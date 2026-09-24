-- Junction table connecting members with the topics they are working on
CREATE TABLE Progress (
    progress_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    topic_id INT NOT NULL,
    hours_spent INT DEFAULT 0,
    status ENUM(
        'Not Started',
        'In Progress',
        'Completed'
    ) DEFAULT 'Not Started',
    completed_on DATE,
    jr_reconcile ENUM('Pending', 'Approved') DEFAULT 'Pending',
    sr_reconcile ENUM('Pending', 'Approved') DEFAULT 'Pending',
    CONSTRAINT fk_progress_member FOREIGN KEY (member_id) REFERENCES Members (member_id),
    CONSTRAINT fk_progress_topic FOREIGN KEY (topic_id) REFERENCES Topics (topic_id)
);

-- Allows only one progress record for each member-topic combination
ALTER TABLE Progress
ADD CONSTRAINT uq_progress_member_topic UNIQUE (member_id, topic_id);

-- Automatically records timestemp when progress is created and updated
ALTER TABLE Progress
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Add columns for junior and senior reconciler IDs and their approval timestamps
ALTER TABLE Progress
ADD COLUMN jr_reconciler_id INT NULL,
ADD COLUMN jr_approved_on TIMESTAMP NULL,
ADD COLUMN sr_reconciler_id INT NULL,
ADD COLUMN sr_approved_on TIMESTAMP NULL,
ADD CONSTRAINT fk_jr_reconciler FOREIGN KEY (jr_reconciler_id) REFERENCES Members (member_id),
ADD CONSTRAINT fk_sr_reconciler FOREIGN KEY (sr_reconciler_id) REFERENCES Members (member_id);

-- Add a check constraint to ensure that if the senior reconciler approves, the junior reconciler must have approved first
ALTER TABLE Progress
ADD CONSTRAINT check_reconcile_order CHECK (
    (sr_reconcile = 'Pending')
    OR (
        sr_reconcile = 'Approved'
        AND jr_reconcile = 'Approved'
    )
);

-- Modify the jr_reconcile and sr_reconcile columns to include a "Rejected" option
ALTER TABLE progress
MODIFY COLUMN jr_reconcile ENUM(
    'Pending',
    'Approved',
    "Rejected"
) DEFAULT 'Pending',
MODIFY COLUMN sr_reconcile ENUM(
    'Pending',
    'Approved',
    "Rejected"
) DEFAULT 'Pending';

-- Update the check constraint to account for the "Rejected" option
ALTER TABLE Progress DROP CONSTRAINT check_reconcile_order;

ALTER TABLE Progress
ADD CONSTRAINT check_reconcile_order CHECK (
    sr_reconcile <> 'Approved'
    OR jr_reconcile = 'Approved'
);

-- Add a check constraint to ensure that if the status is "Completed", the junior reconciler must have approved
ALTER TABLE progress
ADD CONSTRAINT check_trainee_completion CHECK (
    jr_reconcile = 'Pending'
    OR status = 'Completed'
);

-- Change data type of hours_spent
ALTER TABLE progress
MODIFY COLUMN hours_spent DECIMAL(5, 2) DEFAULT 0.00;

DESCRIBE progress;