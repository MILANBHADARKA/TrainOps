-- CURSOR:

-- 1. Auto-populate Discussion reminder for each member who has "Not Started" topics.
-- Use case: Trainer clicks "Send Reminder" for a batch -> a reminder discussion 
-- message is inserted for every member who still hasn't started their assigned topics.
-- CURSOR is used because we need to process each member individually.
DELIMITER $$
CREATE PROCEDURE SendTopicReminders(IN p_batch_id INT)
BEGIN
    -- Variables to hold values fetched by the cursor
    DECLARE v_member_id   INT;
    DECLARE v_topic_id    INT;
    DECLARE v_topic_name  VARCHAR(100);
    DECLARE done          INT DEFAULT 0;
    DECLARE v_message     VARCHAR(1000);

    -- Cursor: Find all member-topic pairs that are 'Not Started' in this batch
    DECLARE reminder_cursor CURSOR FOR
        SELECT p.member_id, p.topic_id, t.topic_name
        FROM Progress p
        JOIN Members m ON p.member_id = m.member_id
        JOIN Topics  t ON p.topic_id  = t.topic_id
        WHERE m.batch_id = p_batch_id
          AND p.status   = 'Not Started';

    -- Handler: When cursor has no more rows, set done = 1 to exit loop
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN reminder_cursor;

    reminder_loop: LOOP
        -- Fetch one row at a time into variables
        FETCH reminder_cursor INTO v_member_id, v_topic_id, v_topic_name;

        -- If no more rows, exit the loop
        IF done = 1 THEN
            LEAVE reminder_loop;
        END IF;

        -- Build a personalized reminder message
        SET v_message = CONCAT('Reminder: You have not started the topic "', v_topic_name, '" yet. Please begin as soon as possible.');

        -- Insert a discussion/notification message for this member
        INSERT INTO Discussions (batch_id, topic_id, member_id, message)
        VALUES (p_batch_id, v_topic_id, v_member_id, v_message);

    END LOOP;

    CLOSE reminder_cursor;

    SELECT 'Reminders sent successfully for all pending members.' AS result;
END$$
DELIMITER ;

CALL SendTopicReminders(1);


-- 2. Auto-Reject overdue "In Progress" topics after a deadline.
-- Use case: A scheduled/admin job runs this -> any topic stuck in "In Progress" 
-- for more than 30 days is automatically flagged/reset so the batch can move forward.
-- CURSOR lets us loop through each overdue record and handle it individually.
DELIMITER $$
CREATE PROCEDURE FlagOverdueTopics(IN p_batch_id INT)
BEGIN
    DECLARE v_progress_id INT;
    DECLARE v_member_id   INT;
    DECLARE v_topic_id    INT;
    DECLARE done          INT DEFAULT 0;
    DECLARE flagged_count INT DEFAULT 0;

    -- Cursor: Find all progress records stuck In Progress for over 30 days
    DECLARE overdue_cursor CURSOR FOR
        SELECT p.progress_id, p.member_id, p.topic_id
        FROM Progress p
        JOIN Members m ON p.member_id = m.member_id
        WHERE m.batch_id  = p_batch_id
          AND p.status    = 'In Progress'
          AND p.updated_at < NOW() - INTERVAL 30 DAY;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN overdue_cursor;

    overdue_loop: LOOP
        FETCH overdue_cursor INTO v_progress_id, v_member_id, v_topic_id;

        IF done = 1 THEN LEAVE overdue_loop; END IF;

        -- Insert a warning message for this member in Discussions
        INSERT INTO Discussions (batch_id, topic_id, member_id, message)
        VALUES (
            p_batch_id, 
            v_topic_id, 
            v_member_id, 
            'WARNING: This topic has been In Progress for over 30 days. Please update your progress or contact your trainer.'
        );

        SET flagged_count = flagged_count + 1;
    END LOOP;

    CLOSE overdue_cursor;

    SELECT flagged_count AS total_overdue_topics_flagged;
END$$
DELIMITER ;

CALL FlagOverdueTopics(1);
