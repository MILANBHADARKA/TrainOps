-- USER-DEFINED FUNCTIONS: Reusable logic that returns a SINGLE value.

-- Use case: A function that takes total decimal hours (e.g., 2.5) and formats it as a readable string for the UI (e.g., "2h 30m").
DELIMITER $$

CREATE FUNCTION FormatHours(decimal_hours DECIMAL(5,2)) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE whole_hours INT;
    DECLARE minutes INT;
    DECLARE result VARCHAR(20);
    
    SET whole_hours = FLOOR(decimal_hours);
    SET minutes = ROUND((decimal_hours - whole_hours) * 60);
    
    SET result = CONCAT(whole_hours, 'h ', minutes, 'm');
    RETURN result;
END$$

DELIMITER ;

-- How to use it in a query:
SELECT
    member_id,
    topic_id,
    FormatHours (hours_spent) AS formatted_time
FROM Progress;

-- show all user-defined functions in the current database:
SHOW FUNCTION STATUS
WHERE Db = 'TrainingTracker';

-- delete the function
DROP FUNCTION FormatHours;