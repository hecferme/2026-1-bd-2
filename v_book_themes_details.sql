CREATE OR REPLACE VIEW v_book_themes_details AS
SELECT
    b.book_id,
    b.title AS book_title,
    LISTAGG(t.name, ', ') WITHIN GROUP (ORDER BY t.name) AS all_book_themes
FROM books b
LEFT JOIN book_themes bt ON bt.book_id = b.book_id
LEFT JOIN themes t       ON t.theme_id = bt.theme_id
GROUP BY b.book_id, b.title;