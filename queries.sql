USE library_mini;
 
-- =====================================================================
-- queries.sql - Phần C: 10 truy vấn độc lập (MySQL 8.0+)
-- =====================================================================
 
-- ---------------------------------------------------------------------
-- 1. Các lượt mượn Completed trong tháng 01/2025,
--    kèm bạn đọc, bản sách và loan_date.
-- ---------------------------------------------------------------------
SELECT l.loan_id,
       l.loan_date,
       r.reader_id,
       r.full_name,
       c.copy_id,
       c.title
FROM loans l
JOIN readers r ON r.reader_id = l.reader_id
JOIN copies  c ON c.copy_id   = l.copy_id
WHERE l.status = 'Completed'
  AND l.loan_date >= '2025-01-01'
  AND l.loan_date <  '2025-02-01'
ORDER BY l.loan_date, l.loan_id;
 
-- ---------------------------------------------------------------------
-- 2. Số lượt mượn (mọi trạng thái) theo thể loại trong quý I/2025,
--    giữ cả thể loại có 0 lượt.
--    Điều kiện ngày đặt trong ON (không đặt trong WHERE) để không mất nhóm 0.
-- ---------------------------------------------------------------------
SELECT cat.category_id,
       cat.name AS category_name,
       COUNT(l.loan_id) AS total_loans
FROM categories cat
LEFT JOIN copies cp ON cp.category_id = cat.category_id
LEFT JOIN loans  l  ON l.copy_id = cp.copy_id
                   AND l.loan_date >= '2025-01-01'
                   AND l.loan_date <  '2025-04-01'
GROUP BY cat.category_id, cat.name
ORDER BY cat.category_id;
 
-- ---------------------------------------------------------------------
-- 3. Bạn đọc có ít nhất một lượt mượn chưa có biên bản trả sách,
--    loại trừ Cancelled. Mỗi người xuất hiện một lần.
-- ---------------------------------------------------------------------
SELECT r.reader_id,
       r.full_name
FROM readers r
WHERE EXISTS (
    SELECT 1
    FROM loans l
    WHERE l.reader_id = r.reader_id
      AND l.status <> 'Cancelled'
      AND NOT EXISTS (
          SELECT 1
          FROM return_records rr
          WHERE rr.loan_id = l.loan_id
      )
)
ORDER BY r.reader_id;
 
-- ---------------------------------------------------------------------
-- 4. Phí phát sinh trung bình trên một giao dịch Completed của từng
--    thể loại (toàn bộ thời gian); chỉ lấy nhóm đã phát sinh chi phí.
-- ---------------------------------------------------------------------
SELECT cat.category_id,
       cat.name AS category_name,
       COUNT(rr.return_id)             AS completed_loans,
       SUM(rr.fine_amount)             AS total_fine,
       ROUND(AVG(rr.fine_amount), 2)   AS avg_fine_per_loan
FROM categories cat
JOIN copies cp         ON cp.category_id = cat.category_id
JOIN loans l           ON l.copy_id = cp.copy_id
                      AND l.status = 'Completed'
JOIN return_records rr ON rr.loan_id = l.loan_id
GROUP BY cat.category_id, cat.name
HAVING SUM(rr.fine_amount) > 0
ORDER BY cat.category_id;
 
-- ---------------------------------------------------------------------
-- 5. Top 3 bản sách có nhiều lượt mượn Completed nhất năm 2025.
--    Bằng nhau thì copy_id tăng dần; chỉ lấy bản có giao dịch.
-- ---------------------------------------------------------------------
SELECT cp.copy_id,
       cp.title,
       COUNT(*) AS completed_loans
FROM copies cp
JOIN loans l ON l.copy_id = cp.copy_id
WHERE l.status = 'Completed'
  AND l.loan_date >= '2025-01-01'
  AND l.loan_date <  '2026-01-01'
GROUP BY cp.copy_id, cp.title
ORDER BY completed_loans DESC, cp.copy_id ASC
LIMIT 3;
 
-- ---------------------------------------------------------------------
-- 6. Tổng tiền từng bạn đọc đã thanh toán trong năm 2025 (theo payment_date),
--    giữ cả người chưa trả tiền với tổng bằng 0.
--    Điều kiện payment_date đặt trong ON để không mất người có tổng 0.
-- ---------------------------------------------------------------------
SELECT r.reader_id,
       r.full_name,
       COALESCE(SUM(p.amount), 0) AS total_paid_2025
FROM readers r
LEFT JOIN loans l    ON l.reader_id = r.reader_id
LEFT JOIN payments p ON p.loan_id = l.loan_id
                    AND p.payment_date >= '2025-01-01 00:00:00'
                    AND p.payment_date <  '2026-01-01 00:00:00'
GROUP BY r.reader_id, r.full_name
ORDER BY r.reader_id;
 
-- ---------------------------------------------------------------------
-- 7. Bạn đọc chưa có bất kỳ bản ghi thanh toán nào (toàn bộ dữ liệu),
--    kể cả người chưa có giao dịch.
-- ---------------------------------------------------------------------
SELECT r.reader_id,
       r.full_name
FROM readers r
WHERE NOT EXISTS (
    SELECT 1
    FROM loans l
    JOIN payments p ON p.loan_id = l.loan_id
    WHERE l.reader_id = r.reader_id
)
ORDER BY r.reader_id;
 
-- ---------------------------------------------------------------------
-- 8. Toàn bộ bạn đọc theo tổng phí phát sinh đã xác nhận giảm dần
--    (không phụ thuộc đã thanh toán hay chưa); bằng nhau thì mã tăng dần.
--    Phí lấy từ return_records, không join payments nên không bị cộng lặp.
-- ---------------------------------------------------------------------
SELECT r.reader_id,
       r.full_name,
       COALESCE(SUM(rr.fine_amount), 0) AS total_fine
FROM readers r
LEFT JOIN loans l          ON l.reader_id = r.reader_id
LEFT JOIN return_records rr ON rr.loan_id = l.loan_id
GROUP BY r.reader_id, r.full_name
ORDER BY total_fine DESC, r.reader_id ASC;
 
-- ---------------------------------------------------------------------
-- 9. Tỷ lệ hủy của từng bản sách trong năm 2025:
--    (số lượt Cancelled / tổng số lượt của năm) * 100, làm tròn 2 chữ số;
--    NULL nếu tổng bằng 0. Giữ cả bản sách không có giao dịch 2025.
-- ---------------------------------------------------------------------
SELECT cp.copy_id,
       cp.title,
       COUNT(l.loan_id) AS total_loans_2025,
       COALESCE(SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END), 0) AS cancelled_loans_2025,
       ROUND(
           SUM(CASE WHEN l.status = 'Cancelled' THEN 1 ELSE 0 END)
           / NULLIF(COUNT(l.loan_id), 0) * 100
       , 2) AS cancel_rate_pct
FROM copies cp
LEFT JOIN loans l ON l.copy_id = cp.copy_id
                 AND l.loan_date >= '2025-01-01'
                 AND l.loan_date <  '2026-01-01'
GROUP BY cp.copy_id, cp.title
ORDER BY cp.copy_id;
 
-- ---------------------------------------------------------------------
-- 10. Bạn đọc có hơn 3 lượt mượn Completed trong năm 2025, kèm số lần,
--     sắp số lần giảm dần.
-- ---------------------------------------------------------------------
SELECT r.reader_id,
       r.full_name,
       COUNT(*) AS completed_loans_2025
FROM readers r
JOIN loans l ON l.reader_id = r.reader_id
WHERE l.status = 'Completed'
  AND l.loan_date >= '2025-01-01'
  AND l.loan_date <  '2026-01-01'
GROUP BY r.reader_id, r.full_name
HAVING COUNT(*) > 3
ORDER BY completed_loans_2025 DESC, r.reader_id ASC;
