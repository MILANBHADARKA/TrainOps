-- INDEXES: Used to massively speed up search queries.

-- Members table --
-- Use case: The login API will constantly query the Members table by email. Without an index, MySQL does a "Full Table Scan". With an index, it finds it instantly.
CREATE INDEX idx_member_email ON Members (email);
ALTER TABLE members DROP INDEX idx_member_email;
SHOW INDEX FROM members;

-- Trainee dashboard: "Show me all members in my batch"
CREATE INDEX idx_member_batch ON Members (batch_id);

-- Role-based filtering: "Show only Trainees" or "Show only Admins"
CREATE INDEX idx_member_role ON Members (role_id);





-- Progress table --
-- Most common dashboard query: "Show all Completed topics"
CREATE INDEX idx_progress_status ON Progress (status);

-- Reconciler inbox: "Show me topics waiting for MY junior approval"
CREATE INDEX idx_progress_jr_reconciler ON Progress (jr_reconciler_id);

-- Senior Reconciler inbox: "Show me topics waiting for MY senior approval"
CREATE INDEX idx_progress_sr_reconciler ON Progress (sr_reconciler_id);

-- Reconcile queue filter: "Show all Pending Jr reconciliations"
CREATE INDEX idx_progress_jr_reconcile ON Progress (jr_reconcile);

CREATE INDEX idx_progress_sr_reconcile ON Progress (sr_reconcile);






-- Discussion table --
-- Batch discussion board: "Load all discussions for Batch #3"
CREATE INDEX idx_discussion_batch ON Discussions (batch_id);

-- Topic-level discussion: "Show me all comments on Topic #5"
CREATE INDEX idx_discussion_topic ON Discussions (topic_id);

-- "Show all messages posted by Member #7"
CREATE INDEX idx_discussion_member ON Discussions (member_id);






-- Topics table --
-- Curriculum page: "Show all topics inside MySQL module"
CREATE INDEX idx_topic_module ON Topics (module_id);

-- Composite Index
CREATE INDEX idx_progress_member_topic ON Progress (member_id, topic_id);