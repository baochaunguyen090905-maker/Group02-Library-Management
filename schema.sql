CREATE DATABASE IF NOT EXISTS library_mini
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE library_mini;
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE copies (
    copy_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(150) NOT NULL,
    barcode VARCHAR(50) NOT NULL UNIQUE,
    category_id INT NOT NULL,

    CONSTRAINT fk_copies_categories
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);
CREATE TABLE readers (
    reader_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    dob DATE,
    phone VARCHAR(20)
);
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    reader_id INT NOT NULL,
    copy_id INT NOT NULL,
    loan_date DATE NOT NULL,

    status ENUM(
        'Pending',
        'Active',
        'Completed',
        'Cancelled'
    ) NOT NULL DEFAULT 'Pending',

    due_date DATE NOT NULL,

    CONSTRAINT fk_loans_readers
        FOREIGN KEY (reader_id)
        REFERENCES readers(reader_id),

    CONSTRAINT fk_loans_copies
        FOREIGN KEY (copy_id)
        REFERENCES copies(copy_id),

    CONSTRAINT chk_loans_dates
        CHECK (due_date >= loan_date)
);
CREATE TABLE return_records (
    return_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL UNIQUE,
    return_date DATE NOT NULL,
    condition_note VARCHAR(255),
    fine_amount DECIMAL(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT fk_returns_loans
        FOREIGN KEY (loan_id)
        REFERENCES loans(loan_id),

    CONSTRAINT chk_fine_amount
        CHECK (fine_amount >= 0)
);
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATETIME NOT NULL,

    method ENUM(
        'Cash',
        'BankTransfer',
        'Card'
    ) NOT NULL,

    CONSTRAINT fk_payments_loans
        FOREIGN KEY (loan_id)
        REFERENCES loans(loan_id),

    CONSTRAINT chk_payment_amount
        CHECK (amount > 0)
);