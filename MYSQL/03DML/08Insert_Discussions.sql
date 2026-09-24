-- Top-level doubts / discussion posts (no parent)
INSERT INTO
    Discussions (
        batch_id,
        topic_id,
        member_id,
        parent_id,
        message
    )
VALUES (
        1,
        3,
        1,
        NULL,
        'Difference between CREATE TABLE and ALTER TABLE when adding a NOT NULL column with existing data?'
    ),
    (
        1,
        9,
        2,
        NULL,
        'When should we use WHERE vs HAVING in a query with GROUP BY?'
    ),
    (
        1,
        14,
        3,
        NULL,
        'Does INNER JOIN drop rows if the foreign key value is NULL on either side?'
    ),
    (
        1,
        NULL,
        2,
        NULL,
        'Can someone share good practice questions for JOINs before tomorrow session?'
    ),
    (
        1,
        17,
        1,
        NULL,
        'For Aggregate Functions, is COUNT(*) different from COUNT(column_name) in terms of performance?'
    );

-- Replies to the above (reconciler/admin/peer responses)
INSERT INTO
    Discussions (
        batch_id,
        topic_id,
        member_id,
        parent_id,
        message
    )
VALUES (
        1,
        3,
        4,
        1,
        'ALTER TABLE modifies an existing table; adding NOT NULL without a DEFAULT fails if rows already exist. Use DEFAULT or backfill first.'
    ),
    (
        1,
        9,
        4,
        2,
        'WHERE filters rows before grouping, HAVING filters groups after aggregation — cannot use HAVING for non-aggregated column filters efficiently.'
    ),
    (
        1,
        14,
        5,
        3,
        'Yes, INNER JOIN excludes rows where the join condition does not match on either side, including NULLs.'
    ),
    (
        1,
        NULL,
        3,
        4,
        'I found a few practice sets in the shared drive, will share the link in batch group.'
    ),
    (
        1,
        17,
        4,
        5,
        'COUNT(*) counts all rows including NULLs, COUNT(column_name) skips NULLs in that column — performance difference is usually negligible in MySQL.'
    );

SELECT * FROM Discussions ORDER BY discussion_id;