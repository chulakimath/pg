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
    pg_get_serial_sequence('students.students', 'id'),2
);
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
### # ROW_NUMBER()
ROW_NUMBER() just give count up no ties,even if rows are identical dosent care
```
SELECT name, price,
ROW_NUMBER() OVER (ORDER BY price DESC) AS row_num
FROM products;
```
| name | price | row_num |
| ---- | ----- | ------- |
| A    | 50000 | 1       |
| B    | 50000 | 2       |
| C    | 45000 | 3       |
| D    | 40000 | 4       |
---
### # DENSE_RANK()
DENSE_RANK() Gives Rank , if identical rows means same rank , dont skip any ranks 
```
SELECT name, price,
DENSE_RANK() OVER (ORDER BY price DESC) AS dense_rank
FROM products;
```

| name | price | dense_rank |
| ---- | ----- | ---------- |
| A    | 50000 | 1          |
| B    | 50000 | 1          |
| C    | 45000 | 2          |
| D    | 40000 | 3          |
---
### #RANK()
RANK() Gives same rank to identical rows but skips number of same rank given and starts from next count of rank
```
SELECT name, price,
RANK() OVER (ORDER BY price DESC) AS rank
FROM products;
```
| name | price | rank |
| ---- | ----- | ---- |
| A    | 50000 | 1    |
| B    | 50000 | 1    |
| F    | 50000 | 1    |
| C    | 45000 | 4    |
| D    | 40000 | 5    |

Missed Rank 2 ,3 because 1(1),1(2),1(3) (Count is consdered but skipped rank)



# Performance analyze
Analyze loops and time of execution
```
EXPLAIN (ANALYZE,BUFFERS, FORMAT JSON)
SELECT * FROM flipkart_db.products;

```
OUTPUT
```
[
  {
    "Plan": {
      "Node Type": "Seq Scan",
      "Parallel Aware": false,
      "Async Capable": false,
      "Relation Name": "products",
      "Alias": "products",
      "Startup Cost": 0.00,
      "Total Cost": 1.13,
      "Plan Rows": 13,
      "Plan Width": 58,
      "Actual Startup Time": 0.014,
      "Actual Total Time": 0.017,
      "Actual Rows": 13,
      "Actual Loops": 1,
      "Shared Hit Blocks": 1,
      "Shared Read Blocks": 0,
      "Shared Dirtied Blocks": 0,
      "Shared Written Blocks": 0,
      "Local Hit Blocks": 0,
      "Local Read Blocks": 0,
      "Local Dirtied Blocks": 0,
      "Local Written Blocks": 0,
      "Temp Read Blocks": 0,
      "Temp Written Blocks": 0
    },
    "Planning": {
      "Shared Hit Blocks": 0,
      "Shared Read Blocks": 0,
      "Shared Dirtied Blocks": 0,
      "Shared Written Blocks": 0,
      "Local Hit Blocks": 0,
      "Local Read Blocks": 0,
      "Local Dirtied Blocks": 0,
      "Local Written Blocks": 0,
      "Temp Read Blocks": 0,
      "Temp Written Blocks": 0
    },
    "Planning Time": 0.087,
    "Triggers": [
    ],
    "Execution Time": 0.034
  }
]
```

### # TYPE CASTING
CAST(column_name AS DATATYPE)
:: DATATYPE
```
    SELECT 
        CAST(LENGTH(name) AS VARCHAR) AS casted_length,
        CAST(LENGTH(name) AS TEXT) AS casted_length2,
        LENGTH(name)::VARCHAR AS casted_length3,
        LENGTH(name)::TEXT AS casted_length3
    FROM 
        flipkart_db.products
```





### String Functions
### #UPPER(column);
```
SELECT 
    DISTINCT UPPER(products.category) 
    FROM 
        flipkart_db.products
```
### #LOWER(column);
```
SELECT 
    DISTINCT LOWER(products.category) 
    FROM 
        flipkart_db.products
```
### #LENGTH(column);
```
SELECT 
    LENGTH(products.category)
FROM 
    flipkart_db.products
```

### #SUBSTR(column)
```
SELECT 
    SUBSTR(products.category,1,3),
FROM
    flipkart_db.products
```
\
last 3 digits
```
SELECT 
    SUBSTR(products.sku_code,LENGTH(sku_code)-3,LENGTH(sku_code)) AS last3digits,
    RIGHT(products.sku_code,3) AS last3digitsFROMFUNCTION
FROM
    flipkart_db.products
```
first 3 digits
```
SELECT 

    LEFT(products.sku_code,3) AS first3digitsFROMFUNCTION
FROM
    flipkart_db.products
```
### #CONCAT AND CONCAT_WS
```
SELECT 
    CONCAT(products.sku_code,' - ',products.category,' - ',products.price) as manual_concat,
    CONCAT_WS(' - ',products.sku_code,products.category,products.price) as concat_with_seperator
FROM 
    flipkart_db.products
```

### #TRIM
```
SELECT 
    TRIM('            Santosh  '),
    ('            Santosh  ')
```

