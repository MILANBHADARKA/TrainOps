-- TEMP TABLES:

-- 1. Auto-Assign Topics to All Members in a Batch when a Module starts.
-- Use case: Trainer clicks "Assign Module" for a batch -> this procedure runs.
-- It creates a Progress row for every member × every topic in that module.
-- TEMP TABLE is used to stage the combinations before bulk inserting.
DELIMITER $$
CREATE PROCEDURE AssignModuleToMembers(IN p_batch_id INT, IN p_module_id INT)
BEGIN
    -- Step 1: Create a temp staging table for member-topic combinations
    CREATE TEMPORARY TABLE IF NOT EXISTS TempAssignments (
        member_id INT NOT NULL,
        topic_id  INT NOT NULL
    );

    -- Step 2: Clear it in case it has leftover data from a previous call
    TRUNCATE TABLE TempAssignments;

    -- Step 3: Generate all member × topic combinations using CROSS JOIN
    -- CROSS JOIN: every member gets paired with every topic in the module
    INSERT INTO TempAssignments (member_id, topic_id)
    SELECT m.member_id, t.topic_id
    FROM Members m
    CROSS JOIN Topics t
    WHERE m.batch_id  = p_batch_id
      AND t.module_id = p_module_id;

    -- Step 4: Bulk insert into Progress. INSERT IGNORE skips if already assigned.
    INSERT IGNORE INTO Progress (member_id, topic_id, status)
    SELECT member_id, topic_id, 'Not Started'
    FROM TempAssignments;

    -- Step 5: Return how many records were freshly assigned
    SELECT ROW_COUNT() AS topics_assigned;

    -- Step 6: Clean up temp table
    DROP TEMPORARY TABLE IF EXISTS TempAssignments;
END$$
DELIMITER ;

CALL AssignModuleToMembers(1, 1);  -- Assign Module 1 topics to all members in Batch 1




-- 2. Generate a Batch Summary Report using Temp Table
-- Use case: Admin dashboard "Batch Health" card - shows per-member completion % 
-- for a given batch, all calculated in one stored procedure call.
DELIMITER $$
CREATE PROCEDURE GetBatchHealthReport(IN p_batch_id INT)
BEGIN
    -- Step 1: Create temp table to hold intermediate per-member stats
    CREATE TEMPORARY TABLE IF NOT EXISTS TempMemberStats (
        member_id       INT,
        member_name     VARCHAR(100),
        total_topics    INT,
        completed       INT,
        in_progress     INT,
        not_started     INT,
        completion_pct  DECIMAL(5,2)
    );

    TRUNCATE TABLE TempMemberStats;

    -- Step 2: Aggregate progress data per member
    INSERT INTO TempMemberStats
    SELECT 
        m.member_id,
        m.member_name,
        COUNT(p.progress_id)                                          AS total_topics,
        SUM(p.status = 'Completed')                                   AS completed,
        SUM(p.status = 'In Progress')                                 AS in_progress,
        SUM(p.status = 'Not Started')                                 AS not_started,
        ROUND(SUM(p.status = 'Completed') / COUNT(p.progress_id) * 100, 2) AS completion_pct
    FROM Members m
    LEFT JOIN Progress p ON m.member_id = p.member_id
    WHERE m.batch_id = p_batch_id
    GROUP BY m.member_id, m.member_name;

    -- Step 3: Return the final, clean report
    SELECT * FROM TempMemberStats ORDER BY completion_pct DESC;

    DROP TEMPORARY TABLE IF EXISTS TempMemberStats;
END$$
DELIMITER ;

CALL GetBatchHealthReport(1);