<?php
// diagnose.php - returns possible issues for selected symptoms as JSON

header('Content-Type: application/json');

$raw = file_get_contents('php://input');
$data = json_decode($raw, true);

if (!isset($data['symptoms']) || !is_array($data['symptoms']) || count($data['symptoms']) === 0) {
    echo json_encode(['issues' => []]);
    exit;
}

require 'config.php';

$symptoms = $data['symptoms'];

// Build placeholders: "?, ?, ?"
$placeholders = implode(',', array_fill(0, count($symptoms), '?'));

$stmt = $pdo->prepare("
    SELECT DISTINCT issue_text
    FROM symptom_issues
    WHERE symptom_code IN ($placeholders)
");
$stmt->execute($symptoms);

$issues = $stmt->fetchAll(PDO::FETCH_COLUMN);

echo json_encode(['issues' => $issues]);

