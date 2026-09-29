-- TRANSACTIONS: COMMIT & ROLLBACK

-- It ensures that a group of SQL statements either ALL succeed, or ALL fail.
-- If step 1 succeeds but step 2 fails, you don't want half-inserted data. 

START TRANSACTION;

-- Step 1: Update the role
UPDATE Members 
SET role_id = (SELECT role_id FROM Roles WHERE role_name = 'Reconciler')
WHERE member_id = 5;

-- Step 2: Assign them to pending reconciliations
-- (Let's make a syntax error or a constraint fails here)
UPDATE Progress 
SET jr_reconciler_is = 5 
WHERE status = 'Completed' AND jr_reconcile = 'Pending' AND member_id IN (SELECT member_id FROM Members WHERE batch_id = 1);

COMMIT; 

ROLLBACK;


-- internal working


CREATE database TrainingTracker1;

