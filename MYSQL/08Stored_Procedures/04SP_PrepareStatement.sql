-- PREPARE STATEMENT: REAL WORLD USE CASES (PROJECT SPECIFIC - TrainingTracker)

-- 1. Dynamic Status Filter for Progress table
-- Use case: The UI has a dropdown "Filter by Status: [All / Not Started / In Progress / Completed]"
-- The backend sends whatever the user selects, and we execute it safely.
-- Prepare Statement prevents SQL Injection by parameterizing the value.
SET @status_val = 'Completed';  -- Simulating a value sent from UI/backend
SET @sql_query = 'SELECT member_id, topic_id, hours_spent, status FROM Progress WHERE status = ?';

PREPARE filter_stmt FROM @sql_query;
EXECUTE filter_stmt USING @status_val;
DEALLOCATE PREPARE filter_stmt;  -- Always free the prepared statement after use!


-- 2. Dynamic Search: Find a member by email (used in Login API)
-- Use case: Login form submits email -> backend calls this dynamically.
-- Using Prepare Statement ensures the email input is safely parameterized 
-- and not directly embedded in SQL (prevents SQL Injection attacks).
SET @login_email = 'milan@example.com';
SET @sql_login = 'SELECT member_id, member_name, password, role_id, batch_id FROM Members WHERE email = ?';

PREPARE login_stmt FROM @sql_login;
EXECUTE login_stmt USING @login_email;
DEALLOCATE PREPARE login_stmt;




-- 3. Dynamic ORDER BY using Prepare Statement
-- Use case: Admin panel has sortable columns — "Sort by: Name / Date / Completion"
-- You cannot use ORDER BY with a normal parameterized placeholder (?),
-- so Prepare Statement with CONCAT is the correct approach here.
SET @sort_column = 'member_name';  -- Value sent from UI (ASC/DESC toggle)
SET @sort_order  = 'ASC';

-- Build the SQL string dynamically (validated/whitelisted by backend before reaching here)
SET @sql_sort = CONCAT(
    'SELECT m.member_name, m.email, r.role_name, b.batch_name ',
    'FROM Members m ',
    'JOIN Roles r ON m.role_id = r.role_id ',
    'JOIN Batches b ON m.batch_id = b.batch_id ',
    'ORDER BY ', @sort_column, ' ', @sort_order
);

PREPARE sort_stmt FROM @sql_sort;
EXECUTE sort_stmt;
DEALLOCATE PREPARE sort_stmt;


-- 4. INSIDE A STORED PROCEDURE: Dynamic table reporting
-- Use case: A generic report generator that accepts the status filter as a parameter
-- and dynamically builds the query string, then executes it safely.
DELIMITER $$
CREATE PROCEDURE GetProgressByStatus(IN p_status VARCHAR(20))
BEGIN
    SET @dynamic_sql = CONCAT(
        'SELECT p.member_id, m.member_name, t.topic_name, p.hours_spent, p.status ',
        'FROM Progress p ',
        'JOIN Members m ON p.member_id = m.member_id ',
        'JOIN Topics  t ON p.topic_id  = t.topic_id ',
        'WHERE p.status = "', p_status, '"'
    );

    PREPARE dynamic_stmt FROM @dynamic_sql;
    EXECUTE dynamic_stmt;
    DEALLOCATE PREPARE dynamic_stmt;
END$$
DELIMITER ;

CALL GetProgressByStatus('In Progress');
CALL GetProgressByStatus('Completed');
