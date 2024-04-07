<!DOCTYPE html>
<html>
    
<head>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
    </style>
</head>

<body>
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

    $sql = "SELECT logID, UID, timeofdata, vibration, temprature, fuelLevel, oilPressure, current, sound, gas FROM sensordata ORDER BY logID DESC";

    echo '<table cellspacing="5" cellpadding="5">
      <tr> 
        <td>Log ID</td> 
        <td>User ID</td>
        <td>Time of Data</td> 
        <td>Vibration</td> 
        <td>Temperature</td> 
        <td>Fuel Level</td>
        <td>Oil Pressure</td> 
        <td>Current</td>
        <td>Sound</td> 
        <td>Gas</td> 
      </tr>';

    if ($result = $conn->query($sql)) {
        while ($row = $result->fetch_assoc()) {
            $row_logID = $row["logID"];
            $row_UID = $row["UID"];
            $row_timeofdata = $row["timeofdata"];
            $row_vibration = $row["vibration"];
            $row_temperature = $row["temprature"];
            $row_fuelLevel = $row["fuelLevel"];
            $row_oilPressure = $row["oilPressure"];
            $row_current = $row["current"];
            $row_sound = $row["sound"];
            $row_gas = $row["gas"];

            echo '<tr> 
                <td>' . $row_logID . '</td> 
                <td>' . $row_UID . '</td>
                <td>' . $row_timeofdata . '</td> 
                <td>' . $row_vibration . '</td> 
                <td>' . $row_temperature . '</td> 
                <td>' . $row_fuelLevel . '</td>
                <td>' . $row_oilPressure . '</td> 
                <td>' . $row_current . '</td>
                <td>' . $row_sound . '</td> 
                <td>' . $row_gas . '</td> 
              </tr>';
        }
        $result->free();
    }

    $conn->close();
    ?>
    </table>
</body>

</html>