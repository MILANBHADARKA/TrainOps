-- STORED PROCEDURES:

-- 1. IN Parameter: Get all members in a specific batch
-- Use case: Admin opens a batch page -> API calls this SP -> gets the member list.
DELIMITER $$
CREATE PROCEDURE GetMembersByBatch(IN p_batch_id INT)
BEGIN
    SELECT 
        m.member_id,
        m.member_name,
        m.email,
        m.phone_no,
        r.role_name
    FROM Members m
    JOIN Roles r ON m.role_id = r.role_id
    WHERE m.batch_id = p_batch_id;
END$$
DELIMITER ;

CALL GetMembersByBatch(1);


-- 2. IN Parameter: Get the full progress report for a specific member
-- Use case: Trainee logs in -> Dashboard loads their topic-wise progress.
DELIMITER $$
CREATE PROCEDURE GetMemberProgressReport(IN p_member_id INT)
BEGIN
    SELECT 
        mo.module_name,
        t.topic_name,
        t.target_hours,
        p.hours_spent,
        p.status,
        p.completed_on,
        p.jr_reconcile,
        p.sr_reconcile
    FROM Progress p
    JOIN Topics t     ON p.topic_id  = t.topic_id
    JOIN Modules mo   ON t.module_id = mo.module_id
    WHERE p.member_id = p_member_id
    ORDER BY mo.module_name, t.topic_name;
END$$
DELIMITER ;

CALL GetMemberProgressReport(2);


-- 3. IN + OUT Parameter: Get the overall completion percentage for a member.
-- Use case: Profile page shows "Milan has completed 65% of their training."
DELIMITER $$
CREATE PROCEDURE GetCompletionPercentage(
    IN  p_member_id INT,
    OUT p_percentage DECIMAL(5,2)
)
BEGIN
    DECLARE total_topics   INT;
    DECLARE done_topics    INT;

    SELECT COUNT(*) INTO total_topics
    FROM Progress WHERE member_id = p_member_id;

    SELECT COUNT(*) INTO done_topics
    FROM Progress WHERE member_id = p_member_id AND status = 'Completed';

    IF total_topics = 0 THEN
        SET p_percentage = 0.00;
    ELSE
        SET p_percentage = (done_topics / total_topics) * 100;
    END IF;
END$$
DELIMITER ;

-- How to use OUT parameter:
CALL GetCompletionPercentage(2, @pct);
SELECT @pct AS completion_percentage;


-- 4. Register a new member (INSERT procedure with validation)
-- Use case: Admin creates a new member account from the admin panel.
-- The procedure checks if the email already exists before inserting.
DELIMITER $$
CREATE PROCEDURE RegisterMember(
    IN p_name     VARCHAR(100),
    IN p_email    VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_role_id  INT,
    IN p_batch_id INT
)
BEGIN
    -- Check for duplicate email
    IF EXISTS (SELECT 1 FROM Members WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email already exists. Please use a different email.';
    ELSE
        INSERT INTO Members (member_name, email, password, role_id, batch_id)
        VALUES (p_name, p_email, p_password, p_role_id, p_batch_id);

        -- Return the newly created member_id
        SELECT LAST_INSERT_ID() AS new_member_id;
    END IF;
END$$
DELIMITER ;

CALL RegisterMember('Ravi Shah', 'ravi@example.com', 'hashed_pw_here', 2, 1);

SELECT * 
FROM members;
