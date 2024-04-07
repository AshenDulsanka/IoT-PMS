<?php

/*
Rui Santos
Complete project details at https://RandomNerdTutorials.com/esp32-esp8266-mysql-database-php/
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files.
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
*/

$servername = "localhost";

// REPLACE with your Database name
$dbname = "id21971797_pusl2022_uptime";

// REPLACE with Database user
$username = "id21971797_uptimesensordata";

// REPLACE with Database user password
$password = "UpTime@lanka234";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT current FROM sensordata WHERE timeofdata >= DATE_SUB(NOW(), INTERVAL 10 DAY) ORDER BY timeofdata DESC";

$data = array();

if ($result = $conn->query($sql)) {
    while ($row = $result->fetch_assoc()) {
        $current = $row["current"];
        $data[] = $current;
    }
    $result->free();
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

echo json_encode($data);

$conn->close();
?>