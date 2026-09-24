UPDATE Progress
SET
    status = NULL,
    hours_spent = 3,
    completed_on = NULL
WHERE
    progress_id = 10;
-- update progress raw

SELECT * FROM Progress WHERE progress_id = 10;

SELECT * FROM topics;

INSERT INTO
    topics (
        module_id,
        topic_name,
        target_hours
    )
VALUES (1, "Dummay", 4);
-- add dummy data

SET SQL_SAFE_UPDATES = 0;

DELETE FROM Topics WHERE topic_name = 'Dummay';
-- delete raw
SET SQL_SAFE_UPDATES = 1;