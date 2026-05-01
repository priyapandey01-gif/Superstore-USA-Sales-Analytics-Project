use project;

-- 1. Total Sales, Profit, Orders and profit margin

select round(sum(sales), 2) as total_sales , 
       round(sum(profit), 2) as total_profit, 
       count(distinct order_id) as total_order,
       concat(round(sum(profit)/sum(sales)*100,2), "%") as profit_margin
from s_order;

-- 2. Sales, Profit & Profit margin by Category

select category, round(sum(sales),2) as total_sales, round(sum(profit), 2) as  total_profit,
                 concat(round(sum(profit)/sum(sales)*100,2), "%") as profit_margin
from s_order
group by category
order by total_sales desc;

-- 3. Sales, Profit  & Profit margin by Sub-Category

SELECT sub_category, round(sum(sales),2) as total_sales, round(sum(profit), 2) as  total_profit,
                 concat(round(sum(profit)/sum(sales)*100,2), "%") as profit_margin
from s_order
group by sub_category
order by total_sales desc;

-- 4. Sales, Profit  & Profit margin by Region 

SELECT Region, round(sum(sales),2) as total_sales, round(sum(profit), 2) as  total_profit,
                 concat(round(sum(profit)/sum(sales)*100,2), "%") as profit_margin
from s_order
group by Region
order by total_sales desc;

-- 5. Sales, Profit  & Profit margin by Segment 

SELECT Segment, round(sum(sales),2) as total_sales, round(sum(profit), 2) as  total_profit,
                 concat(round(sum(profit)/sum(sales)*100,2), "%") as profit_margin
from s_order
group by Segment
order by total_sales desc;

-- 6. Top 10 Products by Sales & profit  

select product_name, round(sum(sales),2) as total_sales, round(sum(profit), 2) as  total_profit
from s_order
GROUP BY product_Name
order by total_sales desc
limit 10;

-- 7. Bottom 10 Products by sales & Profit (Loss makers)

select product_name, round(sum(sales),2) as total_sales, round(sum(profit),2) as total_profit
from s_order
group by product_name
order by total_profit asc
limit 10;

-- 8. Monthly Sales Trend

select year(order_date) as years, monthname(order_date) as monthname, month(order_date) as month_num, round(sum(sales),2) as total_sales
from s_order
group by  years, monthname, month_num
order by years, month_num asc;

-- 9. Year over Year Sales Growth

select  year(order_date) as years, round(sum(sales),2) as total_sales,
       ifnull(
       concat( 
       round(((sum(sales)- lag(sum(sales)) over(order by year(order_date)))/ (lag(sum(Sales)) over(order by year(order_date)))*100),2),
       "%"),
       "NA") AS yoy_growth
from s_order
group by year(order_date);

-- 10. Impact of Discount on Profit

select
case 
    when discount= 0 then "No discount"
    when discount<= 0.2 then "low(0-20%)"
    when discount<= 0.4 then "medium(20%-40%)"
    else "high 40%+)"
end as discount_range,
     count(*) as total_order,
     round(sum(sales),2) as total_sales,
     round(sum(profit),2) as total_profit,
     round(avg(profit),2) as avg_profit
from s_order
group by discount_range
order by avg_profit desc;
    
-- 11. Top 5 Customers by Sales

select customer_name, customer_id, segment, 
	round(sum(sales),2) as total_sales,  
    round(sum(profit),2) as total_profit,
    count(distinct order_id) as total_order 
from s_order
group by customer_name, customer_id, segment
order by total_sales desc
limit 5;

 -- 12. State wise Sales and Profit (Top 10 states by sales)

select state, Region, 
     round(sum(sales),2) as total_sales,  
     round(sum(profit),2) as total_profit
from s_order
group by state, region
order by total_profit desc
limit 10;

-- 13. Loss making States

select state, Region, 
     round(sum(sales),2) as total_sales,  
     round(sum(profit),2) as total_profit
from s_order
group by state, region
order by total_profit asc
limit 10;

-- 14. Shipping Mode Analysis

select ship_mode, 
	    count(distinct order_id) as total_orders,
        round(sum(sales),2) as total_sales,  
		round(sum(profit),2) as total_profit,
        round(avg(datediff(ship_date,order_date)), 1) as Avg_ship_days
	from s_order
    group by ship_mode
    ORDER BY total_orders DESC;

-- 15. Window Function — Sales Rank by Category

select category, Sub_Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
     rank() over( partition by category order by SUM(Sales) desc) as sales_rank
from s_order
group by  category, Sub_Category;

-- 16. Return Rate by Category 

select o.category,
 count(distinct o.order_id) as total_order,
 count(distinct r.order_id) as total_return,
 concat( round( ( count(distinct r.order_id)/ count(distinct o.order_id))*100, 2), "%") as return_rate
 from s_order o
 left join s_return r
 on o.order_id= r.order_id
 group by o.category
 order by return_rate desc;
    
-- 17. Return Rate by Region   

select o.region,
	     count(distinct o.order_id) as total_order,
         count(distinct r.order_id) as total_return,
   concat(round((count(distinct r.order_id)/count(distinct o.order_id))*100, 2),"%")  as return_rate
   from s_order o
   left  join s_return r 
   on o.order_id= r.order_id
   group by o.region;

-- 18. Running Total of Sales by Month

select monthname(order_date) as month, month(order_date) as month_num,
round(sum(Sales), 2) as total_sales
from s_order
group by month, month_num
order by month_num desc; 

-- 19. Customer Segmentation by Purchase Frequency

SELECT 
    Customer_Name,
    Segment,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    CASE
        WHEN COUNT(DISTINCT Order_ID) >= 10 THEN 'High Value'
        WHEN COUNT(DISTINCT Order_ID) >= 5 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Category
FROM S_Order
GROUP BY Customer_Name, Segment
ORDER BY Total_Orders DESC;

-- 20. Most Profitable Category-Region Combination

SELECT 
    Category, Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin,
    RANK() OVER (ORDER BY SUM(Profit) DESC) AS Profit_Rank
FROM S_Order
GROUP BY Category, Region;
















