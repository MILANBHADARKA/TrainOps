INSERT INTO
    Progress (
        member_id,
        topic_id,
        hours_spent,
        status,
        completed_on,
        jr_reconcile,
        sr_reconcile
    )
VALUES (
        1,
        1,
        1,
        'Completed',
        '2026-07-02',
        'Approved',
        'Approved'
    ),
    (
        1,
        2,
        2,
        'Completed',
        '2026-07-03',
        'Approved',
        'Pending'
    ),
    (
        1,
        3,
        3,
        'Completed',
        '2026-07-04',
        'Pending',
        'Pending'
    ),
    (
        2,
        1,
        1,
        'Completed',
        '2026-07-02',
        'Approved',
        'Approved'
    ),
    (
        3,
        2,
        1,
        'In Progress',
        NULL,
        'Pending',
        'Pending'
    );

SELECT * FROM progress;