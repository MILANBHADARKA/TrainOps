-- Active: 1789414549090@@127.0.0.1@3306@trainingtracker
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    member_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    batch_id INT NOT NULL,
    role_id INT NOT NULL,
    CONSTRAINT fk_member_batch FOREIGN KEY (batch_id) REFERENCES Batches (batch_id),
    CONSTRAINT fk_member_role FOREIGN KEY (role_id) REFERENCES Roles (role_id)
);

DESCRIBE members;

-- Automatically records timestemp when member is created and updated
ALTER TABLE Members
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Add a column to indicate whether the member is active or not (Soft Delete)
ALTER TABLE members ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

-- Chnage batch_id constraint from NOT NULL to NULLABLE
ALTER TABLE Members MODIFY batch_id INT NULL;

-- Example query of rename table
RENAME TABLE members TO members_training;

RENAME TABLE members_training TO members;

-- Example query of altering table to add a new column and constraint
ALTER TABLE members
ADD COLUMN age INT, -- Adds age information to the member record
ADD CONSTRAINT chk_age CHECK (
    age >= 18
    AND age < 59
);
-- Restricts the allowed age range
ALTER TABLE members DROP COLUMN age;