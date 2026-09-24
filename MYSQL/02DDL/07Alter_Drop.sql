DESCRIBE members;

ALTER TABLE members ADD phone_number varchar(13);

ALTER TABLE members RENAME COLUMN phone_number TO phone_no;

CREATE TABLE Dummy ( dummy_data INT PRIMARY KEY NOT NULL );

DESCRIBE Dummy;

DROP TABLE Dummy;