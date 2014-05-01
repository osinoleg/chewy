<?php

// Server Main
// ----------------------------------------------------------------------------------------------------------------------------------

function process_request($request)
{
    $action = isset($request['action']) ? $request['action'] : "";

    switch($action)
    {
        case "login":
            return login($request);
        break;
        case "recieved_message":
            return recieved_message($request);
        break;
        case "get_message_history":
            return get_message_history($request);
        break;
        case "get_registered_devices":
            return get_registered_devices($request);
        break;
        case "add_user":
            return add_user($request);
        break;
        case "send_push":
            return send_push($request);
        break;
        case "register_device":
            return register_device($request);
        break;
        case "get_all_messages":
            return get_all_messages($request);
        break;
    };

    return "";
}

$request = $_SERVER['REQUEST_METHOD'] == 'GET' ? $_GET : $_POST;

$result = process_request($request);
echo $result;

// Server Actions
// ----------------------------------------------------------------------------------------------------------------------------------

function register_device($request)
{
    $device_id = isset($request['device_id']) ? $request['device_id'] : "";

    if ($device_id)
    {
        // If this device dosn't exist in mysql db then write it
        $link = mysql_connect("localhost");
        if (!$link)
            return "Unable to connect to local DB";

        if (!mysql_select_db('chewy', $link))
        {
            mysql_close($link);
            return "Unable to use DB chewy";
        }

        $result = mysql_query("INSERT into devices (device_id) VALUES('$device_id');", $link);

        mysql_close($link);

        return json_encode($result);
    }
}

function login($request)
{
    $user = isset($request['user']) ? $request['user'] : "";
    $password = isset($request['password']) ? $request['password'] : "";

    $result = array('result' => 'false');

    if (!$user || !$password)
        return json_encode($result);

    $password = md5($password);

    $link = mysql_connect("localhost");
    if (!$link)
        return "Unable to connect to local DB";

    if (!mysql_select_db('chewy', $link))
    {
        mysql_close($link);
        return $result;
    }

    $resource = mysql_query("SELECT * FROM users where user = '$user' and password = '$password';", $link);
    $results = array();
    while($row = mysql_fetch_array($resource, MYSQL_ASSOC))
        $results[] = $row;

    if ($results)
        $result['result'] = true;

    mysql_close($link);

    return json_encode($result);
}

function get_all_messages($request)
{
    $link = mysql_connect("localhost");
    if (!$link)
        return "Unable to connect to local DB";

    if (!mysql_select_db('chewy', $link))
    {
        mysql_close($link);
        return "Unable to use DB chewy";
    }

    $resource = mysql_query("SELECT * FROM messages");
    $messages = array();
    while($row = mysql_fetch_array($resource, MYSQL_ASSOC))
        $messages[] = $row;

    $result = array();
    foreach($messages as $message)
    {
        $message_id = $message['id'];
        $message_txt = $message['message'];
    
        $result[$message_id] = array($message_id, $message_txt);
    }

    return json_encode($result);
}

function get_message_history($request)
{
    $link = mysql_connect("localhost");
    if (!$link)
        return "Unable to connect to local DB";

    if (!mysql_select_db('chewy', $link))
    {
        mysql_close($link);
        return "Unable to use DB chewy";
    }

    $resource = mysql_query("SELECT * FROM messages");
    $messages = array();
    while($row = mysql_fetch_array($resource, MYSQL_ASSOC))
        $messages[] = $row;

    $result = array();
    foreach($messages as $message)
    {
        $message_id = $message['id'];

        if (!isset($result[$message_id]))
            $result[$message_id] = array(
                $message['message'], $message['sent_to'], 0);
    }

    // Lookup who all recieved a message and fill in the results
    $resource = mysql_query("SELECT * FROM message_history");
    $message_history = array();
    while($row = mysql_fetch_array($resource, MYSQL_ASSOC))
    {
        $message_id = $row['message_id'];
        $result[$message_id][2] += 1;
    }

    return json_encode($result);
}

function recieved_message($request)
{
    $message_id = isset($request['message_id']) ? $request['message_id'] : "";
    $device_id = isset($request['device_id']) ? $request['device_id'] : "";

    if (!$device_id)
        return "Specify a device id!";

    if (!$message_id)
        return "Specify a message id!";

    $link = mysql_connect("localhost");
    if (!$link)
        return "Unable to connect to local DB";

    if (!mysql_select_db('chewy', $link))
    {
        mysql_close($link);
        return "Unable to use DB chewy";
    }

    $result = mysql_query("INSERT INTO message_history (device_id, message_id) values('$device_id', '$message_id')");
    return json_encode($result);
}

function send_push($request)
{
    $user = isset($request['user']) ? $request['user'] : "";
    $password = isset($request['password']) ? $request['password'] : "";
    $message = isset($request['message']) ? $request['message'] : "";

    if (!$message)
        return "Specify a message";

    if (!$user || !$password)
        return "Specify a user and password";

    $password = md5($password);

    $link = mysql_connect("localhost");
    if (!$link)
        return "Unable to connect to local DB";

    if (!mysql_select_db('chewy', $link))
    {
        mysql_close($link);
        return "Unable to use DB chewy";
    }

    $resource = mysql_query("SELECT * FROM users where user = '$user' and password = '$password';", $link);
    $results = array();
    while($row = mysql_fetch_array($resource, MYSQL_ASSOC))
        $results[] = $row;

    if (!$results)
    {
        mysql_close($link);
        return "Invalid user password combo";
    }

    // Get devices
    $resource = mysql_query("SELECT * FROM devices;");
    $devices = array();
    while($row = mysql_fetch_array($resource, MYSQL_ASSOC))
        $devices[] = $row;

    // Add Message to message table and get the id
    mysql_query("INSERT into messages (message) VALUES('$message');", $link);
    $resource = mysql_query("SELECT * from messages where message='$message' order by id desc limit 1;", $link);
    $message_result = array();
    while($row = mysql_fetch_array($resource, MYSQL_ASSOC))
        $message_result[] = $row;

    $message_id = $message_result[0]['id'];

    // Send the push!
    $ctx = stream_context_create();
    stream_context_set_option($ctx, 'ssl', 'local_cert', 'final.pem');
    stream_context_set_option($ctx, 'ssl', 'passphrase', '?oleg?');
    $fp = stream_socket_client('ssl://gateway.push.apple.com:2195', $err,
        $errstr, 60, STREAM_CLIENT_CONNECT | STREAM_CLIENT_PERSISTENT, $ctx);

    if (!$fp)
        return "Failed to connect: $eer $errstr";

    $soundfile = "pushnote.wav";
    $body = array();
    $body['aps'] = array(
        'alert' => $message,
        'sound' => $soundfile,
        'message_id' => $message_id,
    );

    $payload = json_encode($body);

    $errors = array();
    $count = 0;
    foreach($devices as $device_row)
    {
        try
        {
            $msg = chr(0) . pack('n', 32) . pack('H*', $device_row['device_id']) . pack('n', strlen($payload)) . $payload;
        }
        catch(Exception $e)
        {
            $errors[] = "Shitty device id: $device_row[device_id]. gana continue on!";
            continue;
        }
        error_log("msg len = ". strlen($payload) . " payload = " . $payload);
        $sent = fwrite($fp, $msg, strlen($msg));
        if (!$sent)
            $errors[] = "Failed to send push to device_id: $device_row[device_id]";
        else
            $count++;
    }

    mysql_query("UPDATE messages set sent_to = '$count' where id = '$message_id'");

    fclose($fp);
    
    mysql_close($link);

    return json_encode($errors);
}

function add_user($request)
{
    $user = isset($request['user']) ? $request['user'] : "";
    $password = isset($request['password']) ? $request['password'] : "";

    if ($user && $password)
    {
        $password = md5($password);

        $link = mysql_connect("localhost");
        if (!$link)
            return "Unable to connect to local DB";

        if (!mysql_select_db('chewy', $link))
        {
            mysql_close($link);
            return "Unable to use DB chewy";
        }

        $result = mysql_query("INSERT into users (user, password) VALUES('$user', '$password');", $link);

        mysql_close($link);

        return json_encode($result);
    }
}

function get_registered_devices($request)
{
    // If this device dosn't exist in mysql db then write it
    $link = mysql_connect("localhost");
    if (!$link)
        return "Unable to connect to local DB";

    if (!mysql_select_db('chewy', $link))
    {
        mysql_close($link);
        return "Unable to use DB chewy";
    }

    $resource = mysql_query("SELECT * FROM devices;", $link);
    if (!$resource)
    {
        mysql_close($link);
        return "Unable to select from devices";
    }

    $results = array();
    while($row = mysql_fetch_array($resource, MYSQL_ASSOC))
        $results[] = $row;

    mysql_close($link);

    return json_encode($results);
}
?>
