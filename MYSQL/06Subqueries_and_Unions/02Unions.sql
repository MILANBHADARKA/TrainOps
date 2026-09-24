-- Create an "Activity Feed" or "Audit Log" for the Admin Dashboard.
SELECT
    'Batch Created' AS activity_type,
    batch_name AS entity_name,
    created_at AS activity_date
FROM Batches
UNION ALL
SELECT
    'Member Joined' AS activity_type,
    member_name AS entity_name,
    created_at AS activity_date
FROM Members
ORDER BY activity_date DESC;

-- Find all members involved in a specific topic (EX., 1), either as a trainee or a reconciler.
-- Use case: A topic is being updated, and we need a unique list of emails to notify
SELECT m.email, m.member_name, 'Trainee' AS interaction_type
FROM Progress p
    JOIN Members m ON p.member_id = m.member_id
WHERE
    p.topic_id = 1
UNION
SELECT m.email, m.member_name, 'Junior Reconciler' AS interaction_type
FROM Progress p
    JOIN Members m ON p.jr_reconciler_id = m.member_id
WHERE
    p.topic_id = 1
UNION
SELECT m.email, m.member_name, 'Senior Reconciler' AS interaction_type
FROM Progress p
    JOIN Members m ON p.sr_reconciler_id = m.member_id
WHERE
    p.topic_id = 1;

-- Generate a combined report of all Pending tasks for a specific user (User ID 2).
-- Use case: User logs in, clicks the notification bell, and sees a list of things they need to do.
SELECT 'Action Required: Start Topic' AS task_description, t.topic_name
FROM Progress p
    JOIN Topics t ON p.topic_id = t.topic_id
WHERE
    p.member_id = 2
    AND p.status = 'Not Started'
UNION ALL
SELECT 'Action Required: Jr Reconcile' AS task_description, t.topic_name
FROM Progress p
    JOIN Topics t ON p.topic_id = t.topic_id
WHERE
    p.jr_reconciler_id = 2
    AND p.jr_reconcile = 'Pending'
    AND p.status = 'Completed';




-- NOTES
-- UNION has to determine and remove duplicates.
-- UNION ALL doesn't need to do that.
-- So, if you know your queries will never return duplicates, use UNION ALL for better performance.