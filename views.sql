-- PART D - LIBRARY BORROWING AND RETURN VIEWS

USE library_mini;

-- D1: One row per loan, including loans without a return record.
-- NULL fine_amount means no confirmed return record; 0 means a confirmed zero fine.
CREATE OR REPLACE VIEW v_detail AS
SELECT
    l.loan_id,
    l.loan_date,
    l.due_date,
    l.status,
    r.reader_id,
    r.full_name AS reader_name,
    c.copy_id,
    c.title AS book_title,
    c.author,
    c.barcode,
    cat.category_id,
    cat.name AS category_name,
    rr.return_date,
    rr.fine_amount
FROM loans AS l
JOIN readers AS r ON r.reader_id = l.reader_id
JOIN copies AS c ON c.copy_id = l.copy_id
JOIN categories AS cat ON cat.category_id = c.category_id
LEFT JOIN return_records AS rr ON rr.loan_id = l.loan_id;

-- D2: One row per category, including categories without any loans.
-- return_records.loan_id is UNIQUE, so this join cannot multiply loan rows.
-- Payments are deliberately not joined here: installments would repeat fines.
CREATE OR REPLACE VIEW v_group_summary AS
SELECT
    cat.category_id,
    cat.name AS category_name,
    COUNT(l.loan_id) AS total_loans,
    SUM(CASE WHEN l.status = 'Completed' THEN 1 ELSE 0 END) AS completed_loans,
    SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_loans,
    COALESCE(SUM(rr.fine_amount), 0) AS total_fine
FROM categories AS cat
LEFT JOIN copies AS c ON c.category_id = cat.category_id
LEFT JOIN loans AS l ON l.copy_id = c.copy_id
LEFT JOIN return_records AS rr ON rr.loan_id = l.loan_id
GROUP BY cat.category_id, cat.name;

-- D3: One row per reader, including readers without loans, fines, or payments.
-- Aggregate fines and actual payments SEPARATELY to one row per reader.
-- Joining these totals preserves each fine once even with multiple payments.
CREATE OR REPLACE VIEW v_debt AS
SELECT
    r.reader_id,
    r.full_name AS reader_name,
    COALESCE(f.total_fine, 0) AS total_fine,
    COALESCE(p.total_paid, 0) AS total_paid,
    COALESCE(f.total_fine, 0) - COALESCE(p.total_paid, 0) AS outstanding_debt
FROM readers AS r
LEFT JOIN (
    SELECT l.reader_id, SUM(rr.fine_amount) AS total_fine
    FROM loans AS l
    JOIN return_records AS rr ON rr.loan_id = l.loan_id
    GROUP BY l.reader_id
) AS f ON f.reader_id = r.reader_id
LEFT JOIN (
    SELECT l.reader_id, SUM(pay.amount) AS total_paid
    FROM loans AS l
    JOIN payments AS pay ON pay.loan_id = l.loan_id
    GROUP BY l.reader_id
) AS p ON p.reader_id = r.reader_id;
