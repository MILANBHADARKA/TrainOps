-- Find the member(s) who have spent the absolute highest hours across the entire system.
-- To find "Top Learners"
SELECT p1.member_id, m.member_name, p1.hours_spent
FROM Progress p1
    JOIN Members m ON p1.member_id = m.member_id
WHERE
    p1.hours_spent = (
        SELECT MAX(hours_spent)
        FROM Progress
    );

-- Find members who have spent more hours than the average for that specific topic.
-- Use case: Identify trainees who are taking significantly longer than their peers on a specific topic.
SELECT p1.topic_id, t.topic_name, p1.member_id, m.member_name, p1.hours_spent
FROM
    Progress p1
    JOIN Members m ON p1.member_id = m.member_id
    JOIN Topics t ON p1.topic_id = t.topic_id
WHERE
    p1.hours_spent > (
        SELECT AVG(p2.hours_spent)
        FROM Progress p2
        WHERE
            p1.topic_id = p2.topic_id
    );

-- Find modules that currently have NO topics assigned to them.
-- Use case: Admin sanity check to find empty curriculum modules.
SELECT m.module_id, m.module_name
FROM Modules m
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Topics t
        WHERE
            t.module_id = m.module_id
    );

-- Find topics that take more target_hours than the average of all topics.
-- Tagging "Heavy" topics in the UI.
SELECT topic_name, target_hours
FROM Topics
WHERE
    target_hours > (
        SELECT AVG(target_hours)
        FROM Topics
    );