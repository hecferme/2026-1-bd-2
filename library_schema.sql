-- Library schema for Oracle
-- Tables: AUTHORS, THEMES, BOOKS, PHYSICAL_BOOKS, USERS, BORROWS
-- N-to-N join tables: BOOK_AUTHORS, BOOK_THEMES
-- 1-to-1 constraints enforced on BORROWS (unique physical_id and user_id)

PROMPT 'Creating library schema...';

-- Drop existing objects if they exist (safe to run in dev/test)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE book_authors CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE book_themes CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE borrows CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE physical_books CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE books CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE authors CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE themes CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE users CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
-- AUTHORS
CREATE TABLE authors (
  author_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR2(200) NOT NULL,
  bio CLOB,
  created_at DATE DEFAULT SYSDATE
);

-- THEMES
CREATE TABLE themes (
  theme_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR2(200) NOT NULL UNIQUE,
  description VARCHAR2(400)
);

-- BOOKS (logical book entity)
CREATE TABLE books (
  book_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title VARCHAR2(400) NOT NULL,
  isbn VARCHAR2(20) UNIQUE,
  publisher VARCHAR2(200),
  publication_year NUMBER(4)
);

-- N to N: BOOK_AUTHORS
CREATE TABLE book_authors (
  book_id NUMBER NOT NULL,
  author_id NUMBER NOT NULL,
  CONSTRAINT pk_book_authors PRIMARY KEY (book_id, author_id),
  CONSTRAINT fk_ba_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
  CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- N to N: BOOK_THEMES
CREATE TABLE book_themes (
  book_id NUMBER NOT NULL,
  theme_id NUMBER NOT NULL,
  CONSTRAINT pk_book_themes PRIMARY KEY (book_id, theme_id),
  CONSTRAINT fk_bt_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
  CONSTRAINT fk_bt_theme FOREIGN KEY (theme_id) REFERENCES themes(theme_id) ON DELETE CASCADE
);

-- PHYSICAL_BOOKS (1 book has N physical copies)
CREATE TABLE physical_books (
  physical_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  book_id NUMBER NOT NULL,
  barcode VARCHAR2(100) NOT NULL UNIQUE,
  physical_condition VARCHAR2(50),
  status VARCHAR2(20) DEFAULT 'AVAILABLE',
  CONSTRAINT chk_physical_status CHECK (status IN ('AVAILABLE','BORROWED','LOST')),
  CONSTRAINT fk_physical_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

-- USERS
CREATE TABLE users (
  user_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  full_name VARCHAR2(200) NOT NULL,
  email VARCHAR2(200) UNIQUE,
  phone VARCHAR2(50),
  district VARCHAR2(200),
  province VARCHAR2(200),
  created_at DATE DEFAULT SYSDATE
);

-- BORROWS
-- Borrows can be many over time. Physical book availability and loss are handled via `status` and triggers.
CREATE TABLE borrows (
  borrow_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  physical_id NUMBER NOT NULL,
  user_id NUMBER NOT NULL,
  borrow_date DATE DEFAULT SYSDATE,
  due_date DATE,
  return_date DATE,
  status VARCHAR2(20) DEFAULT 'BORROWED' NOT NULL,
  CONSTRAINT chk_borrow_status CHECK (status IN ('BORROWED','RETURNED','LOST')),
  CONSTRAINT fk_borrow_physical FOREIGN KEY (physical_id) REFERENCES physical_books(physical_id),
  CONSTRAINT fk_borrow_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Trigger to manage physical_books.status on borrow insert/update
CREATE OR REPLACE TRIGGER trg_borrows_manage_status
AFTER INSERT OR UPDATE ON borrows
FOR EACH ROW
DECLARE
  v_status physical_books.status%TYPE;
BEGIN
  IF (INSERTING) OR (UPDATING AND :NEW.status != :OLD.status) THEN
    IF :NEW.status = 'BORROWED' THEN
      SELECT status INTO v_status FROM physical_books WHERE physical_id = :NEW.physical_id FOR UPDATE;
      IF v_status != 'AVAILABLE' THEN
        raise_application_error(-20001,'Physical book not available for borrowing');
      END IF;
      UPDATE physical_books SET status = 'BORROWED' WHERE physical_id = :NEW.physical_id;
    ELSIF :NEW.status = 'RETURNED' THEN
      UPDATE physical_books SET status = 'AVAILABLE' WHERE physical_id = :NEW.physical_id;
    ELSIF :NEW.status = 'LOST' THEN
      UPDATE physical_books SET status = 'LOST' WHERE physical_id = :NEW.physical_id;
    END IF;
  END IF;
EXCEPTION WHEN NO_DATA_FOUND THEN
  raise_application_error(-20003,'Physical book not found');
END;
/

PROMPT 'Library schema created.';
COMMIT;
