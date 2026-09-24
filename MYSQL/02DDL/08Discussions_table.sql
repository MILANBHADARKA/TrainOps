CREATE TABLE Discussions (
    discussion_id INT AUTO_INCREMENT PRIMARY KEY,
    batch_id INT NOT NULL,
    topic_id INT NULL,
    member_id INT NOT NULL,
    parent_id INT NULL, -- self-reference for replies/threads
    message VARCHAR(1000) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_discussion_batch FOREIGN KEY (batch_id) REFERENCES Batches (batch_id),
    CONSTRAINT fk_discussion_topic FOREIGN KEY (topic_id) REFERENCES Topics (topic_id),
    CONSTRAINT fk_discussion_member FOREIGN KEY (member_id) REFERENCES Members (member_id),
    CONSTRAINT fk_discussion_parent FOREIGN KEY (parent_id) REFERENCES Discussions (discussion_id)
);

SELECT * FROM Discussions;

-- Change the message column to TEXT type to allow for longer messages
ALTER TABLE discussions MODIFY COLUMN message TEXT NOT NULL;

DESCRIBE discussions;