-- Sample data for library schema
-- Adds at least 4 catalogue records (authors, themes, books, physical books)
-- Adds at least 10 borrows records (respecting 1-to-1 constraints)

PROMPT 'Inserting sample data...';
SET DEFINE OFF; -- prevent & from being treated as substitution variables in SQL*Plus/SQLcl

-- TRUNCATE existing data (safe order: truncate children first, then parents)
PROMPT 'Truncating tables: borrows -> book_authors -> book_themes -> physical_books -> books -> authors -> themes -> users';
TRUNCATE TABLE borrows;
TRUNCATE TABLE book_authors;
TRUNCATE TABLE book_themes;
TRUNCATE TABLE physical_books;
TRUNCATE TABLE books;
TRUNCATE TABLE authors;
TRUNCATE TABLE themes;
TRUNCATE TABLE users;
COMMIT;
PROMPT 'Truncate complete. Proceeding to insert sample data...';

-- AUTHORS (4+)
INSERT INTO authors (name, bio) VALUES ('J. K. Rowling', 'Children fantasy author');
INSERT INTO authors (name, bio) VALUES ('George R. R. Martin', 'Epic fantasy author');
INSERT INTO authors (name, bio) VALUES ('Isaac Asimov', 'Science fiction author');
INSERT INTO authors (name, bio) VALUES ('Agatha Christie', 'Mystery novelist');

-- THEMES (4+)
INSERT INTO themes (name, description) VALUES ('Fantasy', 'Fantasy and magic');
INSERT INTO themes (name, description) VALUES ('Science Fiction', 'Futuristic & sci-fi');
INSERT INTO themes (name, description) VALUES ('Mystery', 'Detective and mystery');
INSERT INTO themes (name, description) VALUES ('Historical', 'Historical fiction');

-- BOOKS (4+)
INSERT INTO books (title, isbn, publisher, publication_year) VALUES ('Harry Potter and the Philosopher''s Stone', '9780747532699', 'Bloomsbury', 1997);
INSERT INTO books (title, isbn, publisher, publication_year) VALUES ('A Game of Thrones', '9780553103540', 'Bantam', 1996);
INSERT INTO books (title, isbn, publisher, publication_year) VALUES ('Foundation', '9780553293357', 'Gnome Press', 1951);
INSERT INTO books (title, isbn, publisher, publication_year) VALUES ('Murder on the Orient Express', '9780007119318', 'Collins', 1934);

-- Link BOOK_AUTHORS (N-to-N)
-- Using subqueries to find created ids
INSERT INTO book_authors (book_id, author_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Harry Potter and the Philosopher''s Stone'),
  (SELECT a.author_id FROM authors a WHERE a.name = 'J. K. Rowling')
);

INSERT INTO book_authors (book_id, author_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'A Game of Thrones'),
  (SELECT a.author_id FROM authors a WHERE a.name = 'George R. R. Martin')
);

INSERT INTO book_authors (book_id, author_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Foundation'),
  (SELECT a.author_id FROM authors a WHERE a.name = 'Isaac Asimov')
);

INSERT INTO book_authors (book_id, author_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Murder on the Orient Express'),
  (SELECT a.author_id FROM authors a WHERE a.name = 'Agatha Christie')
);

-- Link BOOK_THEMES (N-to-N)
INSERT INTO book_themes (book_id, theme_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Harry Potter and the Philosopher''s Stone'),
  (SELECT t.theme_id FROM themes t WHERE t.name = 'Fantasy')
);

INSERT INTO book_themes (book_id, theme_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'A Game of Thrones'),
  (SELECT t.theme_id FROM themes t WHERE t.name = 'Fantasy')
);

INSERT INTO book_themes (book_id, theme_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Foundation'),
  (SELECT t.theme_id FROM themes t WHERE t.name = 'Science Fiction')
);

INSERT INTO book_themes (book_id, theme_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Murder on the Orient Express'),
  (SELECT t.theme_id FROM themes t WHERE t.name = 'Mystery')
);

-- ADDITIONAL AUTHORS & THEMES for extended examples
INSERT INTO authors (name, bio) VALUES ('Neil Gaiman', 'Contemporary fantasy author');
INSERT INTO authors (name, bio) VALUES ('Terry Pratchett', 'Comic fantasy author');

INSERT INTO themes (name, description) VALUES ('Adventure', 'Action and adventure');
INSERT INTO themes (name, description) VALUES ('Philosophy', 'Philosophical fiction');

-- NEW BOOKS (no borrows yet)
INSERT INTO books (title, isbn, publisher, publication_year) VALUES ('Tales of Two', '9780000000001', 'Collab Press', 2020);
INSERT INTO books (title, isbn, publisher, publication_year) VALUES ('Anthology of Many Minds', '9780000000002', 'Collective Press', 2021);

-- Link BOOK_AUTHORS for new books
-- 'Tales of Two' has two authors
INSERT INTO book_authors (book_id, author_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Tales of Two'),
  (SELECT a.author_id FROM authors a WHERE a.name = 'Neil Gaiman')
);
INSERT INTO book_authors (book_id, author_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Tales of Two'),
  (SELECT a.author_id FROM authors a WHERE a.name = 'Terry Pratchett')
);

-- 'Anthology of Many Minds' has three authors
INSERT INTO book_authors (book_id, author_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Anthology of Many Minds'),
  (SELECT a.author_id FROM authors a WHERE a.name = 'Isaac Asimov')
);
INSERT INTO book_authors (book_id, author_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Anthology of Many Minds'),
  (SELECT a.author_id FROM authors a WHERE a.name = 'Agatha Christie')
);
INSERT INTO book_authors (book_id, author_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Anthology of Many Minds'),
  (SELECT a.author_id FROM authors a WHERE a.name = 'George R. R. Martin')
);

-- Link BOOK_THEMES for new books
INSERT INTO book_themes (book_id, theme_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Tales of Two'),
  (SELECT t.theme_id FROM themes t WHERE t.name = 'Fantasy')
);
INSERT INTO book_themes (book_id, theme_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Tales of Two'),
  (SELECT t.theme_id FROM themes t WHERE t.name = 'Adventure')
);

INSERT INTO book_themes (book_id, theme_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Anthology of Many Minds'),
  (SELECT t.theme_id FROM themes t WHERE t.name = 'Science Fiction')
);
INSERT INTO book_themes (book_id, theme_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Anthology of Many Minds'),
  (SELECT t.theme_id FROM themes t WHERE t.name = 'Historical')
);
INSERT INTO book_themes (book_id, theme_id)
VALUES (
  (SELECT b.book_id FROM books b WHERE b.title = 'Anthology of Many Minds'),
  (SELECT t.theme_id FROM themes t WHERE t.name = 'Philosophy')
);

-- PHYSICAL BOOKS (create 12 physical copies across books so we can create 10 unique borrows)
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'Harry Potter and the Philosopher''s Stone'), 'BC001', 'Good', 'AVAILABLE');
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'Harry Potter and the Philosopher''s Stone'), 'BC002', 'Fair', 'AVAILABLE');
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'A Game of Thrones'), 'BC003', 'Good', 'AVAILABLE');
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'A Game of Thrones'), 'BC004', 'Good', 'AVAILABLE');
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'Foundation'), 'BC005', 'Very Good', 'AVAILABLE');
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'Foundation'), 'BC006', 'Good', 'AVAILABLE');
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'Murder on the Orient Express'), 'BC007', 'Good', 'AVAILABLE');
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'Murder on the Orient Express'), 'BC008', 'Poor', 'AVAILABLE');

-- Extra physical copies to reach 12
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'Harry Potter and the Philosopher''s Stone'), 'BC009', 'Good', 'AVAILABLE');
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'A Game of Thrones'), 'BC010', 'Good', 'AVAILABLE');
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'Foundation'), 'BC011', 'Very Good', 'AVAILABLE');
INSERT INTO physical_books (book_id, barcode, physical_condition, status)
VALUES ((SELECT book_id FROM books WHERE title = 'Murder on the Orient Express'), 'BC012', 'Fair', 'AVAILABLE');

-- USERS (create 12 users so each borrow can be unique per user)
INSERT INTO users (full_name, email, phone, district, province) VALUES ('Alice Smith', 'alice@example.com', '555-0001', 'Central', 'ProvinceA');
INSERT INTO users (full_name, email, phone, district, province) VALUES ('Bob Johnson', 'bob@example.com', '555-0002', 'North', 'ProvinceA');
INSERT INTO users (full_name, email, phone, district, province) VALUES ('Carol Lee', 'carol@example.com', '555-0003', 'East', 'ProvinceB');
INSERT INTO users (full_name, email, phone, district, province) VALUES ('David Brown', 'david@example.com', '555-0004', 'West', 'ProvinceB');
INSERT INTO users (full_name, email, phone, district, province) VALUES ('Eve Davis', 'eve@example.com', '555-0005', 'Central', 'ProvinceC');
INSERT INTO users (full_name, email, phone, district, province) VALUES ('Frank Miller', 'frank@example.com', '555-0006', 'North', 'ProvinceC');
INSERT INTO users (full_name, email, phone, district, province) VALUES ('Grace Wilson', 'grace@example.com', '555-0007', 'South', 'ProvinceA');
INSERT INTO users (full_name, email, phone, district, province) VALUES ('Hank Moore', 'hank@example.com', '555-0008', 'South', 'ProvinceB');
INSERT INTO users (full_name, email, phone, district, province) VALUES ('Ivy Taylor', 'ivy@example.com', '555-0009', 'East', 'ProvinceC');
INSERT INTO users (full_name, email, phone, district, province) VALUES ('Jack Anderson', 'jack@example.com', '555-0010', 'Central', 'ProvinceA');
INSERT INTO users (full_name, email, phone, district, province) VALUES ('Kim Walker', 'kim@example.com', '555-0011', 'West', 'ProvinceB');
INSERT INTO users (full_name, email, phone, district, province) VALUES ('Leo Harris', 'leo@example.com', '555-0012', 'North', 'ProvinceA');

COMMIT;

-- BORROWS (10 records; includes some RETURNED and one LOST example)
INSERT INTO borrows (physical_id, user_id, borrow_date, due_date)
VALUES ((SELECT physical_id FROM physical_books WHERE barcode='BC001'), (SELECT user_id FROM users WHERE email='alice@example.com'), DATE '2026-01-05', DATE '2026-01-20');

INSERT INTO borrows (physical_id, user_id, borrow_date, due_date)
VALUES ((SELECT physical_id FROM physical_books WHERE barcode='BC002'), (SELECT user_id FROM users WHERE email='bob@example.com'), DATE '2026-01-06', DATE '2026-01-21');

-- Carol borrowed and returned
INSERT INTO borrows (physical_id, user_id, borrow_date, due_date, return_date, status)
VALUES ((SELECT physical_id FROM physical_books WHERE barcode='BC003'), (SELECT user_id FROM users WHERE email='carol@example.com'), DATE '2026-01-07', DATE '2026-01-22', DATE '2026-01-18', 'RETURNED');

INSERT INTO borrows (physical_id, user_id, borrow_date, due_date)
VALUES ((SELECT physical_id FROM physical_books WHERE barcode='BC004'), (SELECT user_id FROM users WHERE email='david@example.com'), DATE '2026-01-08', DATE '2026-01-23');

-- Eve borrowed and returned
INSERT INTO borrows (physical_id, user_id, borrow_date, due_date, return_date, status)
VALUES ((SELECT physical_id FROM physical_books WHERE barcode='BC005'), (SELECT user_id FROM users WHERE email='eve@example.com'), DATE '2026-01-09', DATE '2026-01-24', DATE '2026-01-20', 'RETURNED');

INSERT INTO borrows (physical_id, user_id, borrow_date, due_date)
VALUES ((SELECT physical_id FROM physical_books WHERE barcode='BC006'), (SELECT user_id FROM users WHERE email='frank@example.com'), DATE '2026-01-10', DATE '2026-01-25');

INSERT INTO borrows (physical_id, user_id, borrow_date, due_date)
VALUES ((SELECT physical_id FROM physical_books WHERE barcode='BC007'), (SELECT user_id FROM users WHERE email='grace@example.com'), DATE '2026-01-11', DATE '2026-01-26');

-- Hank lost the book
INSERT INTO borrows (physical_id, user_id, borrow_date, due_date, status)
VALUES ((SELECT physical_id FROM physical_books WHERE barcode='BC008'), (SELECT user_id FROM users WHERE email='hank@example.com'), DATE '2026-01-12', DATE '2026-01-27', 'LOST');

INSERT INTO borrows (physical_id, user_id, borrow_date, due_date)
VALUES ((SELECT physical_id FROM physical_books WHERE barcode='BC009'), (SELECT user_id FROM users WHERE email='ivy@example.com'), DATE '2026-01-13', DATE '2026-01-28');

INSERT INTO borrows (physical_id, user_id, borrow_date, due_date)
VALUES ((SELECT physical_id FROM physical_books WHERE barcode='BC010'), (SELECT user_id FROM users WHERE email='jack@example.com'), DATE '2026-01-14', DATE '2026-01-29');

COMMIT;

PROMPT 'Sample data inserted.';

-- Quick verification queries (useful for manual checks)
-- SELECT * FROM books;
-- SELECT * FROM authors;
-- SELECT * FROM book_authors;
-- SELECT * FROM physical_books;
-- SELECT * FROM borrows;
