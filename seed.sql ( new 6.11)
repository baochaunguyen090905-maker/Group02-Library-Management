-- DE 05 | PART B - SAMPLE DATA AND VALIDATION
-- Run schema.sql first on a FRESH empty database, then run this file once.
-- Extended coursework dataset: synthetic IDs and monetary values; designed to test edge cases.
-- REVISED: corrected five operational circulation overlaps in the original fixture.
-- Dates changed only for loan_id 5, 17 and 28; status, all IDs, references,
-- payment records and fine amounts remain unchanged.
-- Operational overlap checking is OPTIONAL: the assignment explicitly exempts
-- overlapping borrowing intervals. The enhanced check assumes a Completed loan
-- occupies a copy from loan_date through return_date, an Active loan remains open,
-- and Pending/Cancelled requests do not occupy the physical copy.
USE library_mini;

-- Parent tables first
INSERT INTO categories (category_id, name) VALUES
(1,'Literature'),(2,'Science'),(3,'Technology'),(4,'History'),(5,'Business');

INSERT INTO copies (copy_id, title, author, barcode, category_id) VALUES
(1,'The Great Gatsby','F. Scott Fitzgerald','LIB001',1),
(2,'Pride and Prejudice','Jane Austen','LIB002',1),
(3,'A Brief History of Time','Stephen Hawking','LIB003',2),
(4,'Clean Code','Robert C. Martin','LIB004',3),
(5,'Sapiens','Yuval Noah Harari','LIB005',4),
(6,'The Lean Startup','Eric Ries','LIB006',5),
(7,'Good to Great','Jim Collins','LIB007',5);

INSERT INTO readers (reader_id, full_name, dob, phone) VALUES
(1,'Nguyen An','2001-02-10','0901000001'),
(2,'Tran Binh','2002-03-11','0901000002'),
(3,'Le Chi','2003-04-12','0901000003'),
(4,'Pham Dung','2001-05-13','0901000004'),
(5,'Hoang Ha','2002-06-14','0901000005'),
(6,'Do Khanh','2003-07-15','0901000006'),
(7,'Bui Linh','2004-08-16','0901000007'),
(8,'Vu Minh','2002-09-17','0901000008'),
(9,'Ngo Nam','2001-10-18','0901000009'),
(10,'Dang Oanh','2003-11-19','0901000010');

-- One loan per row; copy 7 is only used in 2024 (not in 2025).
-- Reader 1 has four Completed loans in 2025.
INSERT INTO loans (loan_id, reader_id, copy_id, loan_date, status, due_date) VALUES
(1,1,1,'2025-01-05','Completed','2025-01-19'),
(2,1,2,'2025-02-03','Completed','2025-02-17'),
(3,1,3,'2025-03-05','Completed','2025-03-19'),
(4,1,4,'2025-04-02','Completed','2025-04-16'),
(5,2,1,'2025-01-23','Completed','2025-01-24'),
(6,3,2,'2025-01-15','Completed','2025-01-29'),
(7,4,3,'2025-02-10','Completed','2025-02-24'),
(8,5,4,'2025-03-08','Completed','2025-03-22'),
(9,6,5,'2025-04-11','Completed','2025-04-25'),
(10,7,6,'2025-05-04','Completed','2025-05-18'),
(11,8,1,'2025-06-06','Completed','2025-06-20'),
(12,9,2,'2025-07-07','Completed','2025-07-21'),
(13,10,3,'2025-08-08','Completed','2025-08-22'),
(14,2,4,'2025-09-09','Completed','2025-09-23'),
(15,3,5,'2025-12-02','Completed','2025-12-16'),
(16,4,1,'2025-01-20','Pending','2025-02-03'),
(17,5,2,'2026-10-24','Active','2026-11-07'),
(18,6,3,'2025-03-25','Cancelled','2025-04-08'),
(19,7,4,'2025-10-03','Active','2025-10-17'),
(20,8,7,'2024-11-10','Pending','2024-11-24');

-- Exactly one return record for every Completed loan; none for other statuses.
INSERT INTO return_records (return_id, loan_id, return_date, condition_note, fine_amount) VALUES
(1,1,'2025-01-22','Returned late',60.00),
(2,2,'2025-02-20','Returned late',40.00),
(3,3,'2025-03-15','Good condition',0.00),
(4,4,'2025-04-20','Returned late',25.00),
(5,5,'2025-01-25','Returned late',10.00),
(6,6,'2025-01-25','Good condition',0.00),
(7,7,'2025-02-26','Minor damage',15.00),
(8,8,'2025-03-24','Returned late',20.00),
(9,9,'2025-04-29','Damaged cover',50.00),
(10,10,'2025-05-22','Returned late',30.00),
(11,11,'2025-06-25','Returned late',45.00),
(12,12,'2025-07-25','Returned late; not yet paid',35.00),
(13,13,'2025-08-25','Returned late',25.00),
(14,14,'2025-09-20','Good condition',0.00),
(15,15,'2025-12-18','Returned late',10.00);

-- Cash received only after a confirmed fine; multiple partial payments for loans 1 and 9.
-- Loan 12 has a confirmed fee but no payment; loan 1 still owes 10.
INSERT INTO payments (payment_id, loan_id, amount, payment_date, method) VALUES
(1,1,20.00,'2025-01-23 10:00:00','Cash'),
(2,1,30.00,'2025-01-25 14:00:00','BankTransfer'),
(3,2,40.00,'2025-02-21 09:30:00','Card'),
(4,4,25.00,'2025-04-21 11:00:00','Cash'),
(5,5,10.00,'2025-01-26 10:00:00','Cash'),
(6,7,15.00,'2025-02-27 16:00:00','Card'),
(7,8,20.00,'2025-03-25 13:00:00','BankTransfer'),
(8,9,20.00,'2025-04-30 08:30:00','Cash'),
(9,9,20.00,'2025-05-02 17:00:00','BankTransfer'),
(10,10,30.00,'2025-05-23 09:00:00','Card'),
(11,11,45.00,'2025-06-26 15:30:00','Cash'),
(12,13,25.00,'2025-08-26 13:30:00','Card'),
(13,15,10.00,'2025-12-19 10:10:00','BankTransfer');


-- ADVANCED EXTENSION: increase analytical coverage without changing Part A schema.
-- Copy 8 has never been borrowed; copy 7 is borrowed only outside 2025.
INSERT INTO copies (copy_id,title,author,barcode,category_id) VALUES
(8,'Data Science Handbook','Jake VanderPlas','LIB008',3);
-- Reader 11 has no loans; reader 12 has only cancelled/pending history, no payments.
INSERT INTO readers (reader_id,full_name,dob,phone) VALUES
(11,'Mai Phuong','2002-12-20',NULL),
(12,'Phan Quynh','2001-11-09','0901000012');

-- Edge periods: 2024, the first/last days of Q1-2025, and 2026.
-- Active loans 17 and 28 are dated after the most recent returns of their respective copies.
-- Loan 5 begins after loan 1 returns copy 1, while remaining late and paid after return.
-- Category Business (copy 6/7) remains without Q1-2025 transactions.
INSERT INTO loans (loan_id,reader_id,copy_id,loan_date,status,due_date) VALUES
(21,2,7,'2024-12-20','Completed','2025-01-03'),
(22,3,1,'2025-03-31','Completed','2025-04-14'),
(23,4,5,'2025-01-01','Completed','2025-01-15'),
(24,5,6,'2026-01-05','Completed','2026-01-19'),
(25,6,2,'2025-12-31','Completed','2026-01-14'),
(26,12,5,'2025-07-11','Cancelled','2025-07-25'),
(27,12,1,'2026-02-02','Pending','2026-02-16'),
(28,9,6,'2026-10-25','Active','2026-11-08');
-- Only the five newly Completed loans receive return records.
INSERT INTO return_records (return_id,loan_id,return_date,condition_note,fine_amount) VALUES
(16,21,'2025-01-06','Returned late (cross-year loan)',18.00),
(17,22,'2025-04-14','Returned on time (Q1 boundary)',0.00),
(18,23,'2025-01-17','Returned late (year boundary)',12.00),
(19,24,'2026-01-21','Returned late (outside 2025)',28.00),
(20,25,'2026-01-14','Returned on time (cross-year return)',0.00);
-- One additional partial payment on loan 21; loan 23 gets two installments.
-- Loan 24 stays unpaid; these payments all follow the return record.
INSERT INTO payments (payment_id,loan_id,amount,payment_date,method) VALUES
(14,21,10.00,'2025-01-07 10:00:00','Cash'),
(15,23,5.00,'2025-01-18 11:30:00','Card'),
(16,23,7.00,'2025-02-03 14:30:00','BankTransfer');

-- ASSERTION DASHBOARD: PASS means zero violations or an explicitly satisfied scenario.
-- 1: target table counts
SELECT 'categories' AS table_name, COUNT(*) AS row_count, 5 AS required_min FROM categories
UNION ALL SELECT 'copies',COUNT(*),6 FROM copies
UNION ALL SELECT 'readers',COUNT(*),10 FROM readers
UNION ALL SELECT 'loans',COUNT(*),12 FROM loans
UNION ALL SELECT 'return_records',COUNT(*),10 FROM return_records
UNION ALL SELECT 'payments',COUNT(*),10 FROM payments;

-- 2: orphaned foreign keys (all must be 0)
SELECT 'copies -> categories' AS check_name,COUNT(*) AS violations
FROM copies x LEFT JOIN categories c ON x.category_id=c.category_id WHERE c.category_id IS NULL
UNION ALL SELECT 'loans -> readers',COUNT(*) FROM loans x LEFT JOIN readers r ON x.reader_id=r.reader_id WHERE r.reader_id IS NULL
UNION ALL SELECT 'loans -> copies',COUNT(*) FROM loans x LEFT JOIN copies c ON x.copy_id=c.copy_id WHERE c.copy_id IS NULL
UNION ALL SELECT 'returns -> loans',COUNT(*) FROM return_records x LEFT JOIN loans l ON x.loan_id=l.loan_id WHERE l.loan_id IS NULL
UNION ALL SELECT 'payments -> loans',COUNT(*) FROM payments x LEFT JOIN loans l ON x.loan_id=l.loan_id WHERE l.loan_id IS NULL;

-- 3: cardinality/status: Completed exactly one return, all others zero (no rows expected)
SELECT l.loan_id,l.status,COUNT(rr.return_id) AS return_count
FROM loans l LEFT JOIN return_records rr ON rr.loan_id=l.loan_id
GROUP BY l.loan_id,l.status
HAVING (l.status='Completed' AND COUNT(rr.return_id)<>1)
    OR (l.status<>'Completed' AND COUNT(rr.return_id)<>0);

-- 4: temporal integrity: due_date and return_date vs loan_date (no rows expected)
SELECT l.loan_id,l.loan_date,l.due_date,rr.return_date
FROM loans l LEFT JOIN return_records rr ON rr.loan_id=l.loan_id
WHERE l.due_date<l.loan_date OR rr.return_date<l.loan_date;

-- 5: payment validity: no unconfirmed fee, no overpayment, no early payment (no rows expected)
SELECT p.loan_id,MAX(rr.fine_amount) AS confirmed_fine,SUM(p.amount) AS total_paid,
       MIN(p.payment_date) AS first_payment,MAX(rr.return_date) AS return_date
FROM payments p LEFT JOIN return_records rr ON rr.loan_id=p.loan_id
GROUP BY p.loan_id
HAVING COUNT(rr.return_id)=0 OR SUM(p.amount)>COALESCE(MAX(rr.fine_amount),0)
    OR DATE(MIN(p.payment_date))<MAX(rr.return_date);

-- 6: scenario coverage summary: every check must PASS.
SELECT 'all 4 loan statuses' AS scenario,
       IF(COUNT(DISTINCT status)=4,'PASS','FAIL') AS result FROM loans
UNION ALL SELECT 'January 2025 loans',IF(COUNT(*)>0,'PASS','FAIL') FROM loans WHERE loan_date>='2025-01-01' AND loan_date<'2025-02-01'
UNION ALL SELECT 'Feb/Mar 2025 loans',IF(COUNT(*)>0,'PASS','FAIL') FROM loans WHERE loan_date>='2025-02-01' AND loan_date<'2025-04-01'
UNION ALL SELECT 'Outside Q1, inside 2025',IF(COUNT(*)>0,'PASS','FAIL') FROM loans WHERE loan_date>='2025-04-01' AND loan_date<'2026-01-01'
UNION ALL SELECT 'Outside year 2025',IF(COUNT(*)>0,'PASS','FAIL') FROM loans WHERE loan_date<'2025-01-01' OR loan_date>='2026-01-01'
UNION ALL SELECT 'Reader >3 Completed loans in 2025',IF(COUNT(*)>0,'PASS','FAIL') FROM
 (SELECT reader_id FROM loans WHERE status='Completed' AND loan_date>='2025-01-01' AND loan_date<'2026-01-01' GROUP BY reader_id HAVING COUNT(*)>3) q
UNION ALL SELECT 'Multiple payments per loan',IF(COUNT(*)>0,'PASS','FAIL') FROM
 (SELECT loan_id FROM payments GROUP BY loan_id HAVING COUNT(*)>1) q
UNION ALL SELECT 'Confirmed outstanding debt',IF(COUNT(*)>0,'PASS','FAIL') FROM
 (SELECT rr.loan_id FROM return_records rr LEFT JOIN
   (SELECT loan_id,SUM(amount) AS amount_paid FROM payments GROUP BY loan_id) pay ON pay.loan_id=rr.loan_id
  WHERE rr.fine_amount>COALESCE(pay.amount_paid,0)) q
UNION ALL SELECT 'Borrowing history without payment',IF(COUNT(*)>0,'PASS','FAIL') FROM
 (SELECT r.reader_id FROM readers r WHERE EXISTS(SELECT 1 FROM loans l WHERE l.reader_id=r.reader_id)
    AND NOT EXISTS(SELECT 1 FROM loans l JOIN payments p ON p.loan_id=l.loan_id WHERE l.reader_id=r.reader_id)) q
UNION ALL SELECT 'Category without Q1-2025 loans',IF(COUNT(*)>0,'PASS','FAIL') FROM
 (SELECT c.category_id FROM categories c WHERE NOT EXISTS
    (SELECT 1 FROM copies cp JOIN loans l ON l.copy_id=cp.copy_id WHERE cp.category_id=c.category_id
    AND l.loan_date>='2025-01-01' AND l.loan_date<'2025-04-01')) q
UNION ALL SELECT 'Copy without 2025 loans',IF(COUNT(*)>0,'PASS','FAIL') FROM
 (SELECT cp.copy_id FROM copies cp WHERE NOT EXISTS
    (SELECT 1 FROM loans l WHERE l.copy_id=cp.copy_id AND l.loan_date>='2025-01-01' AND l.loan_date<'2026-01-01')) q;

-- 7: payment ledger and debt reconciliation: fees aggregated per loan BEFORE joining payments.
-- Avoid multiplying the fee when a loan has more than one payment.
SELECT r.reader_id,r.full_name,
       COALESCE(SUM(f.fee),0) AS confirmed_fines,
       COALESCE(SUM(f.paid),0) AS total_paid,
       COALESCE(SUM(f.fee-f.paid),0) AS outstanding_debt
FROM readers r LEFT JOIN
  (SELECT l.reader_id,l.loan_id,rr.fine_amount AS fee,COALESCE(pay.paid,0) AS paid
   FROM loans l JOIN return_records rr ON rr.loan_id=l.loan_id
   LEFT JOIN (SELECT loan_id,SUM(amount) AS paid FROM payments GROUP BY loan_id) pay ON pay.loan_id=l.loan_id) f
  ON f.reader_id=r.reader_id
GROUP BY r.reader_id,r.full_name ORDER BY outstanding_debt DESC,r.reader_id;

-- 8: OPTIONAL physical-copy circulation audit (zero rows expected).
-- This is an extra operational-quality check, NOT a rubric requirement.
-- Only Completed/Active loans are treated as physically holding a copy.
-- Completed loans end on return_date; Active loans have no confirmed end.
-- Inclusive intervals make same-day return/reissue a conservative overlap.
SELECT a.copy_id,
       a.loan_id AS earlier_loan_id, a.status AS earlier_status,
       a.loan_date AS earlier_loan_date, ra.return_date AS earlier_return_date,
       b.loan_id AS later_loan_id, b.status AS later_status,
       b.loan_date AS later_loan_date, rb.return_date AS later_return_date
FROM loans a
JOIN loans b ON b.copy_id = a.copy_id AND a.loan_id < b.loan_id
LEFT JOIN return_records ra ON ra.loan_id = a.loan_id
LEFT JOIN return_records rb ON rb.loan_id = b.loan_id
WHERE a.status IN ('Completed','Active')
  AND b.status IN ('Completed','Active')
  AND a.loan_date <= COALESCE(rb.return_date, '9999-12-31')
  AND b.loan_date <= COALESCE(ra.return_date, '9999-12-31')
ORDER BY a.copy_id, a.loan_id, b.loan_id;

-- 9: optional diagnostic: 2025 transactions by month and status.
SELECT MONTH(loan_date) AS loan_month,status,COUNT(*) AS loans_count
FROM loans WHERE loan_date>='2025-01-01' AND loan_date<'2026-01-01'
GROUP BY MONTH(loan_date),status ORDER BY loan_month,status;

-- 10: summary of fines and payments: these are different event timelines.
SELECT 'Fine confirmations (all years)' AS metric,COALESCE(SUM(fine_amount),0) AS amount FROM return_records
UNION ALL SELECT 'Payments received (all years)',COALESCE(SUM(amount),0) FROM payments;

-- NEGATIVE TESTS: kept commented so seed.sql executes without intentional errors.
-- INSERT INTO copies(title,author,barcode,category_id) VALUES('Duplicate','X','LIB001',1); -- UNIQUE barcode
-- INSERT INTO loans(reader_id,copy_id,loan_date,status,due_date) VALUES(999,1,'2025-01-01','Pending','2025-01-15'); -- invalid FK
-- INSERT INTO loans(reader_id,copy_id,loan_date,status,due_date) VALUES(1,1,'2025-01-20','Pending','2025-01-10'); -- invalid dates CHECK
-- INSERT INTO return_records(loan_id,return_date,fine_amount) VALUES(1,'2025-01-23',5); -- UNIQUE loan_id
-- INSERT INTO return_records(loan_id,return_date,fine_amount) VALUES(16,'2025-02-01',-1); -- negative fee CHECK
-- INSERT INTO payments(loan_id,amount,payment_date,method) VALUES(1,0,'2025-01-23 10:00:00','Cash'); -- amount CHECK
-- NOTE: wrong status/return association and overpayment are cross-table business rules,
--       demonstrated by validation SELECTs rather than enforced by the supplied schema.
