-- VIEWS:

-- 1. Create a "Dashboard" View (The most common use case)
-- Use case: The UI needs to display a grid of every member's progress on every topic.
CREATE OR REPLACE VIEW vw_MemberProgressDashboard AS
SELECT 
    m.member_id,
    m.member_name,
    b.batch_name,
    mo.module_name,
    t.topic_name,
    p.status,
    p.hours_spent,
    t.target_hours,
    p.jr_reconcile,
    p.sr_reconcile
FROM Progress p
JOIN Members m  ON p.member_id = m.member_id
JOIN Batches b  ON m.batch_id  = b.batch_id
JOIN Topics t   ON p.topic_id  = t.topic_id
JOIN Modules mo ON t.module_id = mo.module_id;

SELECT * FROM vw_MemberProgressDashboard WHERE member_id = 1;


-- 2. Security/Restricted View
-- Use case: You want to show a list of Users to everyone, but you DO NOT want to expose their passwords or phone numbers.
CREATE OR REPLACE VIEW vw_PublicMemberDirectory AS
SELECT 
    member_id,
    member_name,
    email,
    r.role_name
FROM Members m
JOIN Roles r ON m.role_id = r.role_id;

-- Now, Trainees query this view to see who else is in the system, and it is physically impossible for them to accidentally fetch passwords.
