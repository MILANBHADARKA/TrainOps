-- TRIGGERS: Automatically run code BEFORE or AFTER an Insert/Update/Delete.

-- Use case: When a trainee marks their progress as 'Completed', the system should
-- AUTOMATICALLY log the current date in 'completed_on'.

DELIMITER $$

CREATE TRIGGER trg_progress_completed
BEFORE UPDATE ON Progress
FOR EACH ROW
BEGIN
    -- Check if the status is CHANGING to 'Completed'
    IF NEW.status = 'Completed' AND OLD.status != 'Completed' THEN
        SET NEW.completed_on = CURRENT_DATE();
    ELSEIF NEW.status != 'Completed' THEN
        SET NEW.completed_on = NULL;
    END IF;
    
    -- Automate Jr Reconciler timestamps!
    IF NEW.jr_reconcile = 'Approved' AND OLD.jr_reconcile != 'Approved' THEN
        SET NEW.jr_approved_on = CURRENT_TIMESTAMP();
    END IF;

    -- Automate Sr Reconciler timestamps!
    IF NEW.sr_reconcile = 'Approved' AND OLD.sr_reconcile != 'Approved' THEN
        SET NEW.sr_approved_on = CURRENT_TIMESTAMP();
    END IF;
END$$

DELIMITER;

-- Show all triggers in the current database
SHOW TRIGGERS
FROM TrainingTracker;

-- Delete the trigger
DROP TRIGGER trg_progress_completed;

SELECT * FROM progress;

UPDATE progress SET status = 'Not Started' WHERE progress_id = 8;

UPDATE progress SET status = 'Completed' WHERE progress_id = 8;