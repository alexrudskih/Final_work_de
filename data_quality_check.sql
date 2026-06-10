--dq
--DQ_1
--Отрицательные значения в основных сущностях
INSERT INTO nds.dq_result (
		check_name,kind_of_row,total_cnt,err_cnt,dq,invoice_id,kv1,kv2,kv3,kv4,date_check  
)
with t1 as 
(select *, 
case when unit_price < 0
	or quantity < 0
	or tax_5_percent < 0
	or total < 0 then 1 else 0 end as err_flg
from nds.sales
)
select 
	'DQ_1' as check_name,
	'T' as kind_of_row,
	count(err_flg) as total_cnt,
	sum(err_flg) as err_cnt,
	1.0-sum(err_flg)*1.0/count(err_flg) as dq,
	null as invoice_id,
	null as kv1,
	null as kv2,
	null as kv3,
	null as kv4,
	now() as date_check
from t1
union all
select 
	'DQ_1' as check_name,
	'R' as kind_of_row,
	null as total_cnt,
	null as err_cnt,
	null as dq,
	invoice_id,
	unit_price::text as kv1,
	quantity::text as kv2,
	tax_5_percent::text as kv3,
	total::text as kv4,
	now() as date_check
from t1
where err_flg = 1
;

--DQ_2 
--Проверка выбросов в рейтинге (0-10)
INSERT INTO nds.dq_result (
		check_name,kind_of_row,total_cnt,err_cnt,dq,invoice_id,kv1,kv2,kv3,kv4,date_check  
)
with t1 as 
(select *, 
case when rating < 0 OR rating > 9 then 1 else 0 end as err_flg
from nds.sales
)
select 
	'DQ_2' as check_name,
	'T' as kind_of_row,
	count(err_flg) as total_cnt,
	sum(err_flg) as err_cnt,
	1.0-sum(err_flg)*1.0/count(err_flg) as dq,
	null as invoice_id,
	null as kv1,
	null as kv2,
	null as kv3,
	null as kv4,
	now() as date_check
from t1
union all
select 
	'DQ_2' as check_name,
	'R' as kind_of_row,
	null as total_cnt,
	null as err_cnt,
	null as dq,
	invoice_id,
	rating::text as kv1,
	null as kv2,
	null as kv3,
	null as kv4,
	now() as date_check
from t1
where err_flg = 1
;

--DQ_3
--Проверка бизнес-правила: Total = Unit price * Quantity + Tax 5%
INSERT INTO nds.dq_result (
		check_name,kind_of_row,total_cnt,err_cnt,dq,invoice_id,kv1,kv2,kv3,kv4,date_check 
)		
with t1 as 
(select *, 
case when unit_price * quantity + tax_5_percent != total then 1 else 0 end as err_flg
from nds.sales
)
select 
	'DQ_3' as check_name,
	'T' as kind_of_row,
	count(err_flg) as total_cnt,
	sum(err_flg) as err_cnt,
	1.0-sum(err_flg)*1.0/count(err_flg) as dq,
	null as invoice_id,
	null as kv1,
	null as kv2,
	null as kv3,
	null as kv4,
	now() as date_check
from t1
union all
select 
	'DQ_3' as check_name,
	'R' as kind_of_row,
	null as total_cnt,
	null as err_cnt,
	null as dq,
	invoice_id,
	unit_price::text as kv1,
	quantity::text as kv2,
	tax_5_percent::text as kv3,
	total::text as kv4,
	now() as date_check
from t1
where err_flg = 1
;

--DQ_4 
--Проверка аномалий в датах (будущие даты)
INSERT INTO nds.dq_result (
		check_name,kind_of_row,total_cnt,err_cnt,dq,invoice_id,kv1,kv2,kv3,kv4,date_check 
)
with t1 as 
(select *, 
case when sale_date > CURRENT_DATE then 1 else 0 end as err_flg
from nds.sales
)
select 
	'DQ_4' as check_name,
	'T' as kind_of_row,
	count(err_flg) as total_cnt,
	sum(err_flg) as err_cnt,
	1.0-sum(err_flg)*1.0/count(err_flg) as dq,
	null as invoice_id,
	null as kv1,
	null as kv2,
	null as kv3,
	null as kv4,
	current_date as date_check
from t1
union all
select 
	'DQ_4' as check_name,
	'R' as kind_of_row,
	null as total_cnt,
	null as err_cnt,
	null as dq,
	invoice_id,
	sale_date::text as kv1,
	null as kv2,
	null as kv3,
	null as kv4,
	current_date as date_check
from t1
where err_flg = 1
;