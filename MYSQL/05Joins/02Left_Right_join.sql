SELECT m.member_name, p.status
FROM Members m
    LEFT JOIN Progress p ON m.member_id = p.member_id;
-- Keeps every member in the result, even when they have no progress record

SELECT m.member_name
FROM Members m
    LEFT JOIN Progress p ON m.member_id = p.member_id
WHERE
    p.progress_id IS NULL;
-- Finds members who currently have no progress entry

SELECT t.topic_name, p.status
FROM Progress p
    RIGHT JOIN Topics t ON p.topic_id = t.topic_id;
-- Keep every topic in the result, including topics that have no progress recorded yet