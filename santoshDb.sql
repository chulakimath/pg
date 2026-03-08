SET search_path TO students;
-- INSERT INTO students.students
-- (name,age,grade)
-- VALUES('santosh',26,'A');
-- SELECT * FROM students;

-- UPDATE students.students
-- set name='santosh3',age=25 WHERE id = 6
-- RETURNING *;

-- SELECT * FROM students;


-- CREATE SCHEMA flipkart_db;

-- CREATE TABLE flipkart_db.products(
--     product_id SERIAL PRIMARY KEY,
--     name VARCHAR(100) NOT NULL,
--     sku_code CHAR(8) UNIQUE NOT NULL CHECK(CHAR_LENGTH(sku_code)=8),
--     price NUMERIC(10,2) NOT NULL CHECK(price>=0),
--     stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity>=0),
--     is_available BOOLEAN NOT NULL DEFAULT TRUE,
--     category TEXT NOT NULL,
--     added_on DATE NOT NULL DEFAULT CURRENT_DATE,
--     last_updated TIMESTAMP DEFAULT now()
-- )

-- SET search_path TO flipkart_db

-- INSERT INTO
--     flipkart_db.products (name,sku_code,price,stock_quantity,category)
--     VALUES('OPPO k1 Turo','00000001',28000,1020,'handset'),
--     ('IQOO z1 Turbo','00000002',21000,2000,'handset');


-- INSERT INTO flipkart_db.products (name, sku_code, price , stock_quantity, is_available, category)
-- VALUES
-- ('Wireless Mouse', 'WM123456', 699.99, 50, TRUE, 'Electronics'),
-- ('Bluetooth Speaker', 'BS234567', 1499.00, 30, TRUE, 'Electronics'),
-- ('Laptop Stand', 'LS345678', 799.50, 20, TRUE, 'Accessories'),
-- ('USB-C Hub', 'UC456789', 1299.99, 15, TRUE, 'Accessories'),
-- ('Notebook', 'NB567890', 99.99, 100, TRUE, 'Stationery'),
-- ('Pen Set', 'PS678901', 199.00, 200, TRUE, 'Stationery'),
-- ('Coffee Mug', 'CM789012', 299.00, 75, TRUE, 'Home & Kitchen'),
-- ('LED Desk Lamp', 'DL890123', 899.00, 40, TRUE, 'Home & Kitchen'),
-- ('Yoga Mat', 'YM901234', 499.00, 25, TRUE, 'Fitness'),
-- ('Water Bottle', 'WB012345', 349.00, 60, TRUE, 'Fitness');



-- UPDATE
--     flipkart_db.products
--     SET category = 'Electronics'
--     WHERE product_id in(1,2)



-- SELECT * 
--     FROM flipkart_db.products;

-- SELECT last_value FROM flipkart_db.products_product_id_seq;
-- SELECT setval('products_product_id_seq',15)

-- SELECT setval('products_product_id_seq',(SELECT MAX(product_id) FROM flipkart_db.products))

-- DROP TABLE flipkart_db.products

-- SELECT *
--     FROM 
--         flipkart_db.products
--     WHERE 
--         products.stock_quantity <> (
--             SELECT DISTINCT products.stock_quantity 
--                 FROM 
--                     flipkart_db.products
--                 ORDER BY products.stock_quantity DESC
--                 LIMIT 1
--                 OFFSET 1 

--         )
--     ORDER BY sku_code DESC 



-- SELECt * FROM
-- (SELECT *,dense_rank() OVER (ORDER BY products.stock_quantity DESC) AS qty_rank FROM flipkart_db.products) as tab
-- WHERE tab.qty_rank=2

-- SELECT * FROM flipkart_db.products WHERE LOWER(flipkart_db.products.name) like '%st%'
-- SELECT * FROM flipkart_db.products WHERE flipkart_db.products.name Ilike '%st%'

-- SELECT category,price
--     FROM 
--     (SELECT *, dense_rank() OVER (PARTITION BY category ORDER BY price DESC) AS rank FROM flipkart_db.products) AS TTABLE
--     WHERE rank <=2


--  SELECT  name,price
--     FROM flipkart_db.products
--     ORDER BY price ASC
--     LIMIT 1 

-- SELECT 
--     AVG(price) AS avg,
--     SUM(price) AS sm,
--     COUNT(*) AS cnt,
--     SUM(price)/COUNT(*) AS myAVg
--     FROM flipkart_db.products
--     WHERE products.category in('Home & Kitchen','Fitness')


-- SELECT 
--     products.name,
--     products.stock_quantity
--     FROM 
--         flipkart_db.products
--     WHERE products.stock_quantity>50 AND products.price<>299


-- SELECT 
--     TAB.product_id,
--     TAB.price,
--     TAB.name,
--     TAB.category,
--     TAB.price_rank
--     FROM
--         (SELECT *,ROW_NUMBER()
--          OVER (PARTITION  BY category ORDER BY price DESC) AS price_rank
--          FROM flipkart_db.products) AS TAB
--     WHERE TAB.price_rank<=2


-- SELECT 
--     MIN(price),
--     AVG(price),
--     MAX(price),
--     category
--     FROM flipkart_db.products
--     GROUP BY CATEGORY



-- SELECT 
--     UPPER(products.category) AS upp,
--     LOWER(products.category) AS low,
--     LENGTH(products.category)
-- FROM 
--     flipkart_db.products
-- GROUP BY products.category
    

-- SELECT 
--     products.category
-- FROM 
--     flipkart_db.products

-- Use EXPLAIN ANALYZE to diagnose query performance
-- EXPLAIN ANALYZE
-- SELECT 
--     Upper(products.category)
-- FROM 
--     flipkart_db.products;






-- EXPLAIN (ANALYZE,BUFFERS, FORMAT JSON)
-- SELECT 
--     flipkart_db.products.*
-- FROM 
--     flipkart_db.products


-- EXPLAIN (ANALYZE,BUFFERS, FORMAT JSON)
-- SELECT 
--     CAST(cast_len AS INT)
--     FROM (

--         SELECT 
--             length(len) AS cast_len
--         FROM (
--             SELECT 
--                 CAST((LENGTH(flipkart_db.products.name))AS VARCHAR) AS len,
--                 flipkart_db.products.name
--             FROM 
--                 flipkart_db.products
--             )
--     )


-- SELECT 
--     SUBSTR(products.sku_code,LENGTH(sku_code)-3,LENGTH(sku_code))
-- FROM
--     flipkart_db.products


-- SELECT
--     LEFT(products.sku_code,4) as LEFT,
--     SUBSTR(products.sku_code,LENGTH(sku_code)-3,LENGTH(sku_code))
-- FROM
--     flipkart_db.products

-- SELECT 
--     CONCAT(products.sku_code,' - ',products.category,' - ',products.price) as sku_cat,
--     CONCAT_WS(' - ',products.sku_code,products.category,products.price) as comcatWITHSEPERATOR
-- FROM 
--     flipkart_db.products





1234







SELECT 
    TRIM('            Santosh  '),
    ('            Santosh  ')


