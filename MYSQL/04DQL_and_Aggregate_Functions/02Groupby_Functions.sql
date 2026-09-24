SELECT 
    COUNT(*)
FROM
    Members
WHERE
    role_id = 3;   -- Total Trainees

SELECT 
    COUNT(*)
FROM
    Topics;   -- Total number of topics in the training curriculum

SELECT 
    AVG(hours_spent)
FROM
    Progress;   -- Average number of hours recorded across progress entries

SELECT 
    MAX(hours_spent)
FROM
    Progress;   -- Highest number of hours recorded for any progress entry

SELECT 
    MIN(hours_spent)
FROM  
    Progress;   -- Lowest number of hours recorded for any progress entry

SELECT 
    progress_id, topic_id, IFNULL(completed_on, 'Not Completed')
FROM
    Progress;   -- Replaces NULL completion dates with a readable status

SELECT 
    topic_id, SUM(hours_spent)
FROM
    Progress
GROUP BY topic_id;    -- The total study hours recorded for each topic

SELECT 
    member_id, SUM(hours_spent)
FROM
    Progress
GROUP BY member_id;   -- The total learning hours recorded for each member

SELECT 
    member_id, COUNT(*)
FROM
    Progress
WHERE
    status = 'Completed'
GROUP BY member_id;   -- Counts how many topics each member has completed

SELECT 
    member_id, SUM(hours_spent)
FROM
    Progress
GROUP BY member_id
HAVING SUM(hours_spent) > 4;   -- trainees who studied more than 4 hours

SELECT 
    member_id, COUNT(*)
FROM
    Progress
WHERE
    status = 'Completed'
GROUP BY member_id
HAVING COUNT(*) > 2; -- trainees who completed more than two topics

