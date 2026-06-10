--создадим БД
drop database final_work_de;
create database final_work_de;


--создадим нормализованную схему данных (NDS)
create schema nds;

drop table if exists nds.sales;
drop table if exists nds.customer_types;
drop table if exists nds.genders;
drop table if exists nds.product_lines;
drop table if exists nds.payment_types;
drop table if exists nds.locations;
drop table if exists dds.sales_fact;

--справочник городов и филиалов
CREATE TABLE nds.locations (
    location_id SERIAL PRIMARY KEY,
    branch CHAR(1) NOT NULL,
    city VARCHAR(100) NOT NULL,
    UNIQUE(branch, city)
);

--справочник типов клиентов
CREATE TABLE nds.customer_types (
    customer_type_id SERIAL PRIMARY KEY,
    customer_type_name VARCHAR(20) UNIQUE NOT NULL
);

--справочник полов
CREATE TABLE nds.genders (
    gender_id SERIAL PRIMARY KEY,
    gender_name VARCHAR(10) UNIQUE NOT NULL
);

--справочник товарных линий
CREATE TABLE nds.product_lines (
    product_line_id SERIAL PRIMARY KEY,
    product_line_name VARCHAR(50) UNIQUE NOT NULL
);

--справочник типов оплаты
CREATE TABLE nds.payment_types (
    payment_type_id SERIAL PRIMARY KEY,
    payment_method VARCHAR(20) UNIQUE NOT NULL
);

--таблица фактов
CREATE TABLE nds.sales (
    invoice_id VARCHAR(20) PRIMARY KEY,
    location_id INTEGER REFERENCES nds.locations(location_id),
    customer_type_id INTEGER REFERENCES nds.customer_types(customer_type_id),
    gender_id INTEGER REFERENCES nds.genders(gender_id),
    product_line_id INTEGER REFERENCES nds.product_lines(product_line_id),
    payment_type_id INTEGER REFERENCES nds.payment_types(payment_type_id),
    unit_price NUMERIC(10,2) NOT NULL,
    quantity INTEGER NOT NULL,
    tax_5_percent NUMERIC(10,2) NOT NULL,
    total NUMERIC(10,2) NOT NULL,
    cogs NUMERIC(10,2) NOT NULL,
    gross_margin_percent NUMERIC(5,2) NOT NULL,
    gross_income NUMERIC(10,2) NOT NULL,
    rating NUMERIC(3,1),
    sale_date DATE NOT NULL,
    sale_time TIME NOT NULL
);

--создание схемы DDS
CREATE SCHEMA dds;

drop table if exists dds.sales_fact;

-- Таблица фактов (DDS)
CREATE TABLE dds.sales_fact (
    fact_id SERIAL PRIMARY KEY,
    invoice_id VARCHAR(20),
    branch CHAR(1),
    city VARCHAR(50),
    customer_type VARCHAR(20),
    gender VARCHAR(10),
    product_line VARCHAR(50),
    payment_method VARCHAR(20),
    unit_price NUMERIC(10,2),
    quantity INTEGER,
    tax_amount NUMERIC(10,2),
    total_amount NUMERIC(10,2),
    cogs NUMERIC(10,2),
    gross_income NUMERIC(10,2),
    rating NUMERIC(3,1),
    sale_date DATE,
    sale_time TIME,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    day_of_week VARCHAR(10)
);

--dq_result
drop table if exists nds.dq_result;

--table dq_result
CREATE TABLE nds.dq_result (
    id SERIAL PRIMARY KEY,
    check_name VARCHAR(15),
    kind_of_row CHAR(1),
    total_cnt INTEGER,
    err_cnt INTEGER,
    dq NUMERIC(10,2),
    invoice_id VARCHAR(20),
    kv1 text,
    kv2 text,
    kv3 text,
    kv4 text,
    date_check timestamp
);


--создание пользователя для python и предоставление ему доступа
create role python_user with login;
alter role python_user with password 'python_pass';
grant connect on database final_work_de to python_user; 

grant usage on schema nds TO python_user; 
GRANT ALL ON ALL TABLES IN SCHEMA nds TO python_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA nds TO python_user;
grant usage on schema dds TO python_user; 
GRANT ALL ON ALL TABLES IN SCHEMA dds TO python_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA dds TO python_user;


--проверка заполнения таблиц данными
select * from nds.locations;
select * from nds.customer_types;
select * from nds.genders;
select * from nds.product_lines;
select * from nds.payment_types;

select * from nds.sales;

select * from dds.sales_fact;



--удаление данных из таблиц
delete from nds.sales;

delete from nds.locations;
delete from nds.customer_types;
delete from nds.genders;
delete from nds.product_lines;
delete from nds.payment_types;

delete from dds.sales_fact;

    


select * from nds.dq_result;

