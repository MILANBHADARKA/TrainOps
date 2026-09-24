CREATE TABLE Modules (
    module_id INT AUTO_INCREMENT PRIMARY KEY,
    module_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

-- Automatically records timestemp when module is created and updated
ALTER TABLE Modules
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Examle query of renaming a column in the Modules table
ALTER TABLE Modules RENAME COLUMN module_name TO mname;

ALTER TABLE modules RENAME COLUMN mname TO module_name;

DESCRIBE modules;