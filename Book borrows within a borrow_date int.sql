-- Book borrows within a borrow_date interval, showing "first" author & theme
SELECT
    b.title                                 AS book_title,
    -- "First" author = the author with the smallest author_id for the book
    (SELECT a.name
       FROM book_authors ba
       JOIN authors a ON a.author_id = ba.author_id
      WHERE ba.book_id = b.book_id
      ORDER BY ba.author_id
      FETCH FIRST 1 ROW ONLY)              AS first_author,
    -- "First" theme = the theme with the smallest theme_id for the book
    (SELECT t.name
       FROM book_themes bt
       JOIN themes t ON t.theme_id = bt.theme_id
      WHERE bt.book_id = b.book_id
      ORDER BY bt.theme_id
      FETCH FIRST 1 ROW ONLY)              AS first_theme,
    u.full_name                             AS borrower_name,
    pb.physical_id                          AS physical_copy_id,
    bo.borrow_date,
    bo.return_date,
    bo.due_date,
    -- Optional: computed interval pieces
    -- If returned, show elapsed days; if not returned, show days since borrow
    CASE
      WHEN bo.return_date IS NOT NULL
        THEN ROUND(bo.return_date - bo.borrow_date)
      ELSE ROUND(SYSDATE - bo.borrow_date)
    END                                     AS elapsed_days
FROM borrows bo
JOIN physical_books pb ON pb.physical_id = bo.physical_id
JOIN books b          ON b.book_id = pb.book_id
JOIN users u          ON u.user_id = bo.user_id
WHERE bo.borrow_date >=  '2026-01-12' --to_date('2026-01-12', 'YYYY-MM-DD')
  AND bo.borrow_date <   to_date('2026-01-22', 'YYYY-MM-DD')
ORDER BY bo.borrow_date DESC, b.title;

--ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

-- virtual -- no existe 
-- vista -- tabla virtual creada con una consulta SQL, se puede consultar como una tabla normal pero no almacena datos físicamente, se genera al momento de la consulta.  lo contrario de una vista es una tabla materializada que si almacena datos físicamente y se actualiza periódicamente. es como una foto de los datos en un momento dado. se utiliza para mejorar el rendimiento de consultas complejas o para tener datos históricos. el modelo de datos para el que se usan las tablas materializadas se llama data warehouse, el cual está asociado al término de business intelligence, que es el proceso de analizar datos para tomar decisiones informadas en una empresa. el data warehouse es un sistema de almacenamiento de datos diseñado para facilitar el análisis y la generación de informes, y las tablas materializadas son una herramienta clave en este contexto para optimizar el rendimiento de las consultas.