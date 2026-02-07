CREATE OR REPLACE VIEW v_book_authors_details AS
SELECT
    b.book_id,
    b.title AS book_title,
    LISTAGG(a.name, ', ') WITHIN GROUP (ORDER BY a.name)
        --ON OVERFLOW TRUNCATE '...(+more)'  -- Optional: keep long rows from erroring
        AS all_author_names
FROM books b
LEFT JOIN book_authors ba ON ba.book_id = b.book_id
LEFT JOIN authors a       ON a.author_id = ba.author_id
GROUP BY b.book_id, b.title;

--SELECT name, value FROM v$parameter WHERE name = 'compatible';

--select * from v_book_authors_details;