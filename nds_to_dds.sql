INSERT INTO dds.sales_fact (
    invoice_id, branch, city, customer_type, gender, product_line, payment_method,
    unit_price, quantity, tax_amount, total_amount, cogs, gross_income, rating,
    sale_date, sale_time, year, month, quarter, day_of_week
)
SELECT 
    s.invoice_id,
    l.branch,
    l.city,
    ct.customer_type_name AS customer_type,
    g.gender_name AS gender,
    pl.product_line_name AS product_line,
    pt.payment_method,
    s.unit_price,
    s.quantity,
    s.tax_5_percent AS tax_amount,
    s.total AS total_amount,
    s.cogs,
    s.gross_income,
    s.rating,
    s.sale_date,
    s.sale_time,
    EXTRACT(YEAR FROM s.sale_date)::INTEGER AS year,
    EXTRACT(MONTH FROM s.sale_date)::INTEGER AS month,
    EXTRACT(QUARTER FROM s.sale_date)::INTEGER AS quarter,
    TO_CHAR(s.sale_date, 'Day') AS day_of_week
FROM nds.sales s
JOIN nds.locations l ON s.location_id = l.location_id
JOIN nds.customer_types ct ON s.customer_type_id = ct.customer_type_id
JOIN nds.genders g ON s.gender_id = g.gender_id
JOIN nds.product_lines pl ON s.product_line_id = pl.product_line_id
JOIN nds.payment_types pt ON s.payment_type_id = pt.payment_type_id
;