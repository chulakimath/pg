# create new user
```
sudo -u  postgres createuser--intractive
```
name it admin and create database with same name
```
sudo -u postgres createdb root
```

# Start Shell
opean shell
``` 
sudo -i -u postgres 
```
open postgresql prmpt
```
psql
```
```
psql -U santosh -W
```
ask for password enter password 1234 \
this opeans # teminal for commnds to execute

## #list databases
```
\l
```
## #switch database
```
\c postgres
```
## #list schema in dabase
```
\dn
```

# Getting started
### show databases
lists databases filters out template databases due to where
```
SELECT datname FROM pg_database WHERE datistemplate=false;
```
## show Tables
```
SELECT tablename 
FROM pg_catalog.pg_tables 
WHERE schemaname != 'pg_catalog' 
AND schemaname != 'information_schema';
```
# CREATE SCHEMA
```
CREATE SCHEMA students;
```
##### switch schema- same as use database
```
SET search_path TO students;
```

### check last increment id
```
SELECT last_value FROM students.students_id_seq;
```
### Auto increment set to new value
```
SELECT setval(
pg_get_serial_sequence
('students.students', 'id'),
(SELECT COALESCE(MAX(id),1) FROM students.students)
);
```
BASIC
```
SELECT setval(
pg_get_serial_sequence
('students.students', 'id'),2);
```

###### ALTER ADD PRIMARY KEY
```
ALTER TABLE students.students ADD PRIMARY KEY (id)
```

## DATA TYPES
### Numeric 
---
###### INT DOUBLE FLOAT DECIMAL
* SERIAL -> autoincrement (-2b to 2b)
* NUMERIC(8,2) -> 8digits total 6 and 2 after dot
* SMALLINT -> (-32768 to 326767)


### STRING
* VARCHAR() 
* CHAR()
### DATE 
* DATE - DEFAULT now()
* TIME
* TIMESTAMP
* TIMESTAMPTZ (Timestamp with time zone) 
### BOOLEAN
BOOLEAN

# constraints
* PRIMARY KEY
* NOT NULL
* UNIQUE
* DEFAULT
* CHECK  -- age int CHECK(age>18) to insert row age must grater then 18
* FOREIGN KEY -- student_id INTEGER REFERENCES students(student_id) ON DELETE CASCADE

### CREATE TABLE
```
CREATE TABLE flipkart_db.products(
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sku_code CHAR(8) UNIQUE NOT NULL CHECK(CHAR_LENGTH(sku_code)=8),
    price NUMERIC(10,2) NOT NULL CHECK(price>=0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity>=0),
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    category TEXT NOT NULL,
    added_on DATE NOT NULL DEFAULT CURRENT_DATE,
    last_updated TIMESTAMP DEFAULT now()
)

```

## ## AUTO_INCRIMENT CHECK
```
SELECT last_value FROM flipkart_db.products_product_id_seq;
```
## ## UPDATE INCREMENT COUNTER - MANUAL IF U KNOW EXACT VALUE
```
SELECT setval('products_product_id_seq',15)
```

## ## UPDATE INCREMENT COUNTER - AUTO LAST ID
```
SELECT setval('products_product_id_seq',(SELECT MAX(product_id) FROM flipkart_db.products))
```

# 

# #DENSE RANK
Normal query very expensive limit offset - scan performance 
```
SELECT *
    FROM 
        flipkart_db.products
    WHERE 
        products.stock_quantity <> (
            SELECT DISTINCT products.stock_quantity 
                FROM 
                    flipkart_db.products
                ORDER BY products.stock_quantity DESC
                LIMIT 1
                OFFSET 1 

        )
    ORDER BY sku_code DESC 
```
\
SAME WITH dense_rank();
```
SELECT * FROM
(SELECT *,dense_rank() OVER (ORDER BY products.stock_quantity DESC) AS qty_rank FROM flipkart_db.products) as tab
WHERE tab.qty_rank<>2
```

### # Case Insensetive Match
```
SELECT * FROM flipkart_db.products WHERE LOWER(flipkart_db.products.name) like '%st%'
SELECT * FROM flipkart_db.products WHERE flipkart_db.products.name Ilike '%st%'
```

### #dense Rank AND PARTITION 
Get Top two prie from each category 
```
    SELECT category,price
        FROM 
        (SELECT *, dense_rank() OVER (PARTITION BY category ORDER BY price DESC) AS rank FROM flipkart_db.products) AS TTABLE
        WHERE rank <=2
```