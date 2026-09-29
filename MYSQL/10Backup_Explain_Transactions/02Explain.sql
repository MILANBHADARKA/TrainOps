DESCRIBE Progress;

SHOW INDEX FROM Progress;

SELECT * FROM PROGRESS 
WHERE Status = 'Completed';

EXPLAIN SELECT * FROM PROGRESS 
WHERE Status = 'Completed';

ALTER TABLE Progress
DROP INDEX idx_progress_status;

EXPLAIN SELECT * FROM PROGRESS 
WHERE Status = 'Completed';

CREATE INDEX idx_progress_status ON Progress (status);



-- EXPLAIN KEYWORD
-- it tells you exactly HOW MySQL plans to execute it.

-- Example 1: A Bad Query (Full Table Scan)
-- Imagine we forgot to put an index on the `status` column, and we run this:
EXPLAIN SELECT * FROM Progress WHERE status = 'Completed';

-- What to look for in the result grid:
-- Look at the `type` column. If it says "ALL", it means MySQL is doing a "Full Table Scan".
-- It had to read every single row in the table to find the 'Completed' ones. 
-- In a database with 1 million rows, this takes a very long time!


-- Example 2: A Good Query (Using Indexes)
-- Because `email` has a UNIQUE constraint, it has a built-in Index.
EXPLAIN SELECT * FROM Members WHERE email = 'milan@example.com';

-- What to look for in the result grid:
-- Look at the `type` column. It will say "const" or "ref".
-- Look at the `possible_keys` and `key` columns. It will show you exactly which 
-- index it used (e.g., `email_UNIQUE`).
-- Look at the `rows` column. It will say "1". MySQL instantly knew exactly where 
-- this row was without scanning the whole table!


-- Example 3: EXPLAIN with JOINs
EXPLAIN 
SELECT m.member_name, p.status 
FROM Members m
JOIN Progress p ON m.member_id = p.member_id;

-- When you use JOINs, EXPLAIN outputs multiple rows (one for each table).
-- It tells you what order it is joining the tables in, and whether the foreign keys 
-- are helping speed up the JOIN!
