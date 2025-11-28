<?php
// repair_submit.php - saves repair registration to database

header('Content-Type: application/json');

$payload = json_decode(file_get_contents('php://input'), true);

if (!$payload) {
    echo json_encode(['ok' => false, 'error' => 'Bad JSON']);
    exit;
}

$firstName = trim($payload['firstName'] ?? '');
$lastName  = trim($payload['lastName'] ?? '');
$plate     = trim($payload['plate'] ?? '');
$phone     = trim($payload['phone'] ?? '');
$desc      = trim($payload['desc'] ?? '');
$pickup    = !empty($payload['pickup']) ? 1 : 0;
$selectedArea = $payload['selectedArea'] ?? null;
$symptoms  = $payload['symptoms'] ?? [];

if ($firstName === '' || $lastName === '' || $plate === '' || $phone === '') {
    echo json_encode(['ok' => false, 'error' => 'Missing fields']);
    exit;
}

require 'config.php';

try {
    $pdo->beginTransaction();

    // Main repair row
    $stmt = $pdo->prepare("
        INSERT INTO repair_requests
        (first_name, last_name, plate, phone, pickup, selected_area, description)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ");
    $stmt->execute([
        $firstName,
        $lastName,
        $plate,
        $phone,
        $pickup,
        $selectedArea,
        $desc
    ]);

    $repairId = $pdo->lastInsertId();

    // Linked symptoms
    if (is_array($symptoms) && count($symptoms) > 0) {
        $stmtSym = $pdo->prepare("
            INSERT INTO repair_request_symptoms (repair_request_id, symptom_code)
            VALUES (?, ?)
        ");
        foreach ($symptoms as $code) {
            $stmtSym->execute([$repairId, $code]);
        }
    }

    $pdo->commit();

    echo json_encode(['ok' => true, 'id' => $repairId]);
} catch (Exception $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    echo json_encode(['ok' => false, 'error' => 'DB error']);
}

