<?php

$hostname = "localhost";
$username = "root";
$password = "";
$dbname = "pusl2022_uptime";

$conn = mysqli_connect($hostname, $username, $password, $dbname);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

if (null !== ($_POST["vibrationValue"] ?? null) && null !== ($_POST["tempValue"] ?? null) && null !== ($_POST["fuelLvlValue"] ?? null) && null !== ($_POST["currentValue"] ?? null) && null !== ($_POST["soundValue"] ?? null) && null !== ($_POST["smokeValue"] ?? null)) {

    $t = $_POST["tempValue"];
    $s = $_POST["soundValue"];
    $sm = $_POST["smokeValue"];
    $fl = $_POST["fuelLvlValue"];
    $v = $_POST["vibrationValue"];
    $c = $_POST["currentValue"];

    $sql = "INSERT INTO sensordata (UID, timeofdata, vibration, temperature, fuelLevel, oilPressure, current, sound, gas) VALUES (1, NOW() , '$v', '$t', '$fl', 0, '$c', '$s', '$sm')";
}
