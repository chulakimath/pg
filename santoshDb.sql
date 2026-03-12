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











-- SELECT 
--     TRIM('            Santosh  '),
--     ('            Santosh  ')


-- SELECT 
--     REPLACE(sku_code,LEFT(sku_code,2),'SEE') 
-- FROM
--     flipkart_db.products




-- CREATE TABLE flipkart_db.students (
--     student_id SERIAL PRIMARY KEY,
--     name VARCHAR(255),
--     age INT
-- )

-- SELECT setval(
--     pg_get_serial_sequence('flipkart_db.students','student_id'),8
-- )

INSERT INTO flipkart_db.students (student_name,age,email) VALUES('santu3',26,'santu@mail.com')

SELECT * FROM flipkart_db.students


-- TRUNCATE flipkart_db.students;
-- SELECT setval(
--     pg_get_serial_sequence('flipkart_db.students','student_id'),1,FALSE
-- );

-- ALTER TABLE 
--     flipkart_db.students 
-- ADD COLUMN 
--     email VARCHAR(255) DEFAULT NULL

-- ALTER TABLE
--     flipkart_db.students
-- DROP COLUMN
--     email

-- ALTER TABLE
--     flipkart_db.students
-- RENAME COLUMN
--     name TO student_name 

-- ALTER TABLE
--     flipkart_db.students
-- ALTER COLUMN
--     age TYPE SMALLINT

-- ALTER TABLE
--     flipkart_db.students
-- ALTER COLUMN
--     age SET DEFAULT 18

-- ALTER TABLE 
--     flipkart_db.students
-- ADD CONSTRAINT 
--     age_check CHECK(age>=18)


-- ALTER TABLE 
--     flipkart_db.students
-- ADD CONSTRAINT
--     unique_email UNIQUE(email)

-- ALTER TABLE
--     flipkart_db.students
-- DROP CONSTRAINT 
--     unique_email


-- ALTER TABLE flipkart_db.School_students
-- RENAME TO students
-- ALTER TABLE flipkart_db.products
-- ADD COLUMN price_tag VARCHAR(255)

-- SELECT * FROM flipkart_db.products

-- UPDATE  flipkart_db.products
-- SET price_tag=
-- CASE 
--     WHEN price>1000 THEN 'Expensive'
--     WHEN price BETWEEN 500 AND 1000 THEN 'Moderate'
--     ELSE 'Cheap'
--     END

-- SELECT * FROM
--     (SELECT 
--         products.name,
--         products.category,
--         products.price,
--         CASE 
--             WHEN products.price > 1000 THEN 'Expensive'
--             WHEN products.price BETWEEN 500 AND 1000 THEN 'Moderate'
--             WHEN products.price < 500 THEN 'Cheap'
--             END AS price_tag 
--     FROM flipkart_db.products) AS T1
-- WHERE price_tag='Cheap'
-- ORDER BY price_tag ASC



-- SELECT 
--     products.name,
--     products.stock_quantity,
--     CASE 
--         WHEN stock_quantity>100 THEN 'High Stock'
--         WHEN stock_quantity BETWEEN 30 AND 100 THEN 'Medium Stock'
--         ELSE 'Low Stock'
--         END as label 
-- FROM flipkart_db.products

-- -- UPDATE flipkart_db.students
-- -- SET student_name=CONCAT('santosh','-',student_id)


-- SELECT * FROM flipkart_db.students
-- SELECT * FROM flipkart_db.student_profile

-- -- CREATE TABLE flipkart_db.student_profile
-- -- (
-- --     student_id INT PRIMARY KEY,
-- --     age SMALLINT CHECK (age > 0),
-- --     email VARCHAR(255) UNIQUE NOT NULL,
-- --     phone_num VARCHAR(15) UNIQUE NOT NULL,
-- --         FOREIGN KEY (student_id) 
-- --         REFERENCES flipkart_db.students(student_id)
-- --         ON DELETE CASCADE 
-- -- )

-- -- INSERT INTO 
-- --     flipkart_db.student_profile 
-- --     VALUES 
--     -- (1,25,'santosh1@mail.com','1234567891'),
--     -- (2,25,'santosh2@mail.com','1234567892'),
--     -- (3,25,'santosh3@mail.com','1234567893'),
--     -- (4,25,'santosh4@mail.com','1234567894'),
--     -- (5,25,'santosh5@mail.com','1234567895');

-- -- DELETE FROM flipkart_db.students
-- -- WHERE student_id=3


-- SELECT 
--     flipkart_db.students.student_id,
--     flipkart_db.students.student_name,
--     flipkart_db.student_profile.age,
--     flipkart_db.student_profile.email,
--     flipkart_db.student_profile.phone_num
--     FROM
--         flipkart_db.students
--     JOIN flipkart_db.student_profile
--     ON flipkart_db.students.student_id=flipkart_db.student_profile.student_id


-- CREATE TABLE flipkart_db.student_exam
-- (
--     id BIGSERIAL PRIMARY KEY,
--     student_id INT,
--     subject VARCHAR(255) NOT NULL,
--     marks SMALLINT NOT NULL,
--     FOREIGN KEY (student_id)
--     REFERENCES flipkart_db.students(student_id)
--     ON DELETE CASCADE,
--     UNIQUE(student_id,subject)
-- )





-- CREATE SCHEMA pdb;

-- SET search_path TO pdb;
-- CREATE TABLE products(
--     product_id BIGSERIAL PRIMARY KEY,
--     product_name VARCHAR(100),
--     category TEXT,
--     price NUMERIC(10,2),
--     stock_quantity INT ,
--     is_available BOOLEAN,
--     added_on DATE
-- )

-- CREATE TABLE pdb.orders(
--     order_id BIGSERIAL PRIMARY KEY,
--     product_id INT,
--     quantity INT,
--     order_date DATE,
--     customer_name VARCHAR(100),
--     payment_method VARCHAR(100),
--     CONSTRAINT ref_products
--     FOREIGN KEY (product_id)
--     REFERENCES pdb.products(product_id)
--     ON DELETE CASCADE

-- )


SELECT * FROM pdb.products;
SELECT * FROM pdb.orders ORDER BY product_id;

SELECT 
    products.product_name,
    products.price,
    orders.*
FROM pdb.products
   LEFT JOIN pdb.orders 
    ON pdb.products.product_id = pdb.orders.product_id
ORDER BY
    products.price DESC

SELECT  
    products.product_name,
    products.product_id,
    SUM(orders.quantity) as orders_placed
FROM
    pdb.products
    JOIN pdb.orders 
    ON pdb.orders.product_id=pdb.products.product_id
GROUP BY 
    products.product_id
ORDER BY products.product_id