SELECT Members.member_name, Progress.hours_spent
FROM Members
    INNER JOIN Progress ON Members.member_id = Progress.member_id;
-- member name with their total hours

SELECT m.member_name, SUM(p.hours_spent)
FROM Members m
    INNER JOIN Progress p ON m.member_id = p.member_id
GROUP BY
    p.member_id;
-- Calculates the total recorded study hours for each member

SELECT m.member_name, t.topic_name, p.hours_spent, p.status
FROM
    Progress p
    INNER JOIN Members m ON p.member_id = m.member_id
    INNER JOIN Topics t ON p.topic_id = t.topic_id;
-- Show member with their topics information

SELECT b.batch_name, m.member_name, mo.module_name, t.topic_name, p.status, p.hours_spent
FROM
    Progress p
    INNER JOIN Members m ON p.member_id = m.member_id
    INNER JOIN Batches b ON m.batch_id = b.batch_id
    INNER JOIN Topics t ON p.topic_id = t.topic_id
    INNER JOIN Modules mo ON t.module_id = mo.module_id;
-- Combines all related tables to produce a complete training-progress view