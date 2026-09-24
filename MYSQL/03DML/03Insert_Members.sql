INSERT INTO
    Members (
        member_name,
        email,
        password,
        batch_id,
        role_id
    )
VALUES (
        'Milan',
        'milan@gmail.com',
        'abcdefgh',
        1,
        3
    ),
    (
        'test1',
        'test1@gmail.com',
        'abcdefgh',
        1,
        3
    ),
    (
        'test2',
        'test2@gmail.com',
        'abcdefgh',
        1,
        3
    ),
    (
        'test_reconcilor',
        'test3@gmail.com',
        'abcdefgh',
        1,
        2
    ),
    (
        'test_admin',
        'test4@gmail.com',
        'abcdefgh',
        1,
        1
    );

SELECT * FROM members;