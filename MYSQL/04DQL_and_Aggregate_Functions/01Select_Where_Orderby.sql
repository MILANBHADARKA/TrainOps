SELECT 
    *
FROM
    Members;   -- Retrieves all member information

SELECT 
    member_name
FROM
    Members;   -- Retrieves only the names instead of returning every member column

SELECT 
    member_name, email
FROM
    Members;   -- Retrieves the basic contact information needed for members

SELECT 
    *
FROM
    Members
WHERE
    role_id = 3;  -- show only trainee

SELECT 
    *
FROM
    Members
WHERE
    role_id = 2;   -- show only Reconcilor

SELECT 
    *
FROM
    Progress
WHERE
    status = 'Completed';      -- show completed topics

SELECT 
    *
FROM
    Topics
WHERE
    target_hours > 2;     -- Show topics requiring more than 2 hours

SELECT 
    *
FROM
    Members
ORDER BY member_name;     -- Sort by name

SELECT 
    *
FROM
    Members
ORDER BY member_name DESC;     -- Descending

SELECT 
    *
FROM
    Progress
ORDER BY hours_spent DESC;     -- Highest hours first

SELECT 
    *
FROM
    Progress
WHERE
    status = 'Completed'
ORDER BY hours_spent DESC;     -- Show completed topics sorted by hours


