select sum(sale_price) as sales , product_id,region from df_orders group by region,product_id order by sales desc limit 5 

with temp as
(select product_id,region,sum(list_price*quantity) as Total from df_orders group by product_id,region ) ,temp1 as(
select * ,row_number() over (partition by region order by Total desc)as rn from temp)
select product_id,region,Total from temp1 where rn<=5


with cte as (
select year(order_date) as order_year,month(order_date) as order_month,
sum(sale_price) as sales
from df_orders
group by year(order_date),month(order_date)
#order by year(order_date),month(order_date)
	)
select order_month
, round(sum(case when order_year=2022 then sales else 0 end)) as sales_2022
, round(sum(case when order_year=2023 then sales else 0 end)) as sales_2023
from cte 
group by order_month
order by order_month


with c as
(select category ,concat(YEAR(order_date),'-',MONTH(order_date)) as MONTH1 ,sum(sale_price) as sales from df_orders group by month1,category),r as(
select * ,row_number() over (partition by  category order by sales desc )as g from c)
select * from r where g=1

with cte as (
select year(order_date) as order_year,sub_category,
sum(sale_price) as sales
from df_orders
group by year(order_date),sub_category
#order by year(order_date),month(order_date)
	),cet2 as(
select sub_category
, round(sum(case when order_year=2022 then sales else 0 end)) as sales_2022
, round(sum(case when order_year=2023 then sales else 0 end)) as sales_2023
from cte 
group by sub_category)
select * ,(sales_2023-sales_2022)*100/sales_2023 as profit_2023_compare from cet2 order by (sales_2023-sales_2022)*100/sales_2023 desc limit 1
