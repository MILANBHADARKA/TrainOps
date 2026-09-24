CREATE TABLE Batches (
    batch_id INT AUTO_INCREMENT PRIMARY KEY,
    batch_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);

-- Automatically records timestemp when batch is created and updated
ALTER TABLE Batches
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAM

-- Add a column to indicate whether the batch is active or not (Soft Delete)
ALTER TABLE batches ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

DESCRIBE Batches;