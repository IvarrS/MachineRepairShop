<?php
// config.php - shared database connection

$DB_HOST = 'YOUR_DB_HOST_HERE';
$DB_NAME = 'car_garage';
$DB_USER = 'YOUR_DB_USERNAME_HERE';
$DB_PASS = 'YOUR_DB_PASSWORD_HERE';

try {
    $pdo = new PDO(
        "mysql:host=$DB_HOST;dbname=$DB_NAME;charset=utf8mb4",
        $DB_USER,
        $DB_PASS,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]
    );
} catch (PDOException $e) {
    http_response_code(500);
    echo 'Database connection failed.';
    exit;
}

