-- Jr reconciler's queue: things trainees marked done, awaiting jr approval
SELECT p.progress_id, m.member_name, t.topic_name, p.hours_spent, p.completed_on
FROM
    Progress p
    INNER JOIN Members m ON p.member_id = m.member_id
    INNER JOIN Topics t ON p.topic_id = t.topic_id
WHERE
    p.status = 'Completed'
    AND p.jr_reconcile = 'Pending'
ORDER BY p.completed_on ASC;

-- Sr reconciler's queue: only things jr already approved
SELECT p.progress_id, m.member_name, t.topic_name, p.hours_spent, p.completed_on
FROM
    Progress p
    INNER JOIN Members m ON p.member_id = m.member_id
    INNER JOIN Topics t ON p.topic_id = t.topic_id
WHERE
    p.jr_reconcile = 'Approved'
    AND p.sr_reconcile = 'Pending'
ORDER BY p.completed_on ASC;