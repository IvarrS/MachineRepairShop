CREATE TABLE symptom_issues (
    id INT AUTO_INCREMENT PRIMARY KEY,
    symptom_code VARCHAR(50) NOT NULL,
    issue_text TEXT NOT NULL
);

INSERT INTO symptom_issues (symptom_code, issue_text) VALUES
('engine_knock', 'Possible engine detonation • Low-quality fuel • Worn bearings'),
('warning_light', 'ECU error • Sensor failure • Battery/alternator issue'),
('hard_start', 'Weak battery • Starter motor • Fuel pump problems'),
('vibrations', 'Wheel balance • Suspension wear • Engine mounts'),
('overheating', 'Coolant leak • Bad radiator fan • Thermostat malfunction'),
('brake_noise', 'Worn brake pads • Damaged rotors • Low brake fluid');

CREATE TABLE repair_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    plate VARCHAR(20),
    phone VARCHAR(30),
    pickup TINYINT(1) DEFAULT 0,
    selected_area VARCHAR(50),
    description TEXT
);

CREATE TABLE repair_request_symptoms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    repair_request_id INT NOT NULL,
    symptom_code VARCHAR(50) NOT NULL,
    FOREIGN KEY (repair_request_id) REFERENCES repair_requests(id) ON DELETE CASCADE
);
