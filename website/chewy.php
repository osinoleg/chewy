<?php

// Server Main
// ----------------------------------------------------------------------------------------------------------------------------------

function process_request($request)
{
    $action = isset($request['action']) ? $request['action'] : "";

    switch($action)
    {
        case "get_registered_devices":
            return get_registered_devices($request);
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
