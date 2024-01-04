CREATE TABLE  sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct decimal(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date timestamp NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct decimal(11,9),
    gross_income DECIMAL(12, 4),
    rating decimal(2, 1)
);

alter table sales
alter column rating type decimal(10,2) 


select * from sales




