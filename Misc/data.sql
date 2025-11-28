CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    comment TEXT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO comments (customer_name, comment, rating) VALUES
('John Doe', 'Great service, fast repair!', 5),
('Anna Smith', 'Polite staff, but took longer than expected.', 3),
('Mark Johnson', 'Affordable prices and good communication.', 4),
('Bobby Bobinson', 'Very fast, very nice, very good!', 5);
