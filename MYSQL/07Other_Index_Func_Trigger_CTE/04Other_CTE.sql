-- CTE (Common Table Expression): A temporary "named" query used within a larger query.

-- Use case: The admin wants a report showing each batch's total hours spent,
-- but ONLY for batches that have spent more than 100 hours total.
-- CTEs make complex queries much easier to read by breaking them into steps using 'WITH'.

WITH
    BatchTotals AS (
        -- Step 1: Calculate the total hours for every batch
        SELECT b.batch_name, SUM(p.hours_spent) AS total_hours
        FROM
            Progress p
            JOIN Members m ON p.member_id = m.member_id
            JOIN Batches b ON m.batch_id = b.batch_id
        GROUP BY
            m.batch_id
    )
    -- Step 2: Use the temporary 'BatchTotals' table to filter the results
SELECT batch_name, total_hours
FROM BatchTotals
WHERE
    total_hours > 1;

-- Find all members who have spent more than 5 hours in total across all topics.
WITH
    member_hours AS (
        SELECT member_id, SUM(hours_spent) AS total_hours
        FROM Progress
        GROUP BY
            member_id
    )
SELECT *
FROM member_hours
WHERE
    total_hours > 5;