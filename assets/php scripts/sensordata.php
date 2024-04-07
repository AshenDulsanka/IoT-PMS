<?php

$hostname = "localhost";
$username = "id21971797_uptimesensordata";
$password = "UpTime@lanka234";
$dbname = "id21971797_pusl2022_uptime";

$conn = mysqli_connect($hostname, $username, $password, $dbname);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

if (isset($_POST["tempValue"]) && isset($_POST["soundValue"]) && isset($_POST["smokeValue"]) && isset($_POST["fuelLvlValue"]) && isset($_POST["vibrationValue"]) && isset($_POST["currentValue"]) && isset($_POST["oilPressureValue"])) {

    $t = $_POST["tempValue"];
    $s = $_POST["soundValue"];
    $sm = $_POST["smokeValue"];
    $fl = $_POST["fuelLvlValue"];
    $v = $_POST["vibrationValue"];
    $c = $_POST["currentValue"];
    $o = $_POST["oilPressureValue"];

    $sql = "INSERT INTO sensordata (UID, timeofdata, vibration, temprature, fuelLevel, oilPressure, current, sound, gas) VALUES (1, NOW() , '$v', '$t', '$fl', '$o', '$c', '$s', '$sm')";
}

?>