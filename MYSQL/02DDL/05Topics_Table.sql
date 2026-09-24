CREATE TABLE Topics (
    topic_id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    topic_name VARCHAR(100) NOT NULL,
    target_hours INT NOT NULL,
    CONSTRAINT fk_topic_module FOREIGN KEY (module_id) REFERENCES Modules (module_id)
);

-- Automatically records timestemp when topic is created and updated
ALTER TABLE Topics
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Prevents duplicate topic names within the same module
ALTER TABLE Topics
ADD CONSTRAINT uq_topic_per_module UNIQUE (module_id, topic_name);

-- Chnage datatype of target_hours
ALTER TABLE topics
MODIFY COLUMN target_hours DECIMAL(5, 2) DEFAULT 0.00;

DESCRIBE topics;