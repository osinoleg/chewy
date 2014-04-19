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

    if (!$user || !$password)
        return json_encode(false);

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
        return json_encode(false);
    }

    mysql_close($link);

    return json_encode(true);
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
    $results = array();
    while($row = mysql_fetch_array($resource, MYSQL_ASSOC))
        $results[] = $row;

    // Send the push!
    $ctx = stream_context_create();
    stream_context_set_option($ctx, 'ssl', 'local_cert', 'final.pem');
    stream_context_set_option($ctx, 'ssl', 'passphrase', '?oleg?');
    $fp = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195', $err,
        $errstr, 60, STREAM_CLIENT_CONNECT | STREAM_CLIENT_PERSISTENT, $ctx);

    if (!$fp)
        return "Failed to connect: $eer $errstr";

    $body = array();
    $body['aps'] = array(
        'alert' => $message
    );

    $payload = json_encode($body);

    $errors = array();
    foreach($results as $device_row)
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
    }

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
