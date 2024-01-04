--1.Add the time_of_day column?
alter table sales
add column time_of_day varchar(20) 
update sales 
set time_of_day= (case when time between '00:01:00' and '12:00:00' then 'morning'
                   when time between '12:01:00' and '16:00:00' then 'afternoon'
				   when time between '16:01:00' and '19:00:00' then 'evening'
				   else 'night' end)

--2.Add day_name column?
alter table sales
add column day_name varchar(10)

 update sales
 set day_name=TO_CHAR(date, 'day')
 
--3.Add month_name column?
alter table sales
add column month_name varchar(10)

 update sales
 set month_name=TO_CHAR(date, 'Month') 


--4.What is the most selling product line?
select count(product_line) as pop,product_line  from sales 
group by product_line
limit 1
                       or
select * from(select rank()over( order by count ),pop from (select count(product_line),product_line as pop from sales
												   group by product_line ))
where rank =1


--5.What is the total revenue by month?

select sum(total), month_name from sales
group by month_name
 
 
 
-- 6.What month had the largest COGS?
select sum(COGS), month_name from sales
group by month_name
order by sum desc limit 1   
                or
select * from(select rank()over( order by sum desc ),month_name,sum from (select sum(COGS), month_name from sales
                                                             group by month_name))
where rank =1


---7.What product line had the largest revenue?
select sum(total),product_line from sales
group by product_line
order by sum desc
limit 1
                or
select * from(select rank()over( order by sum desc ),product_line,sum from (select sum(total),product_line from sales
                                                  group by product_line))
where rank =1



/*8.Fetch each product line and add a column to those product 
      line showing "Good", "Bad". Good if its greater than average sales*/
select (case when quantity>avgs then 'good'
  else 'bad' end) as cmp, product_line, avgs from (select round(avg(quantity)over(partition by product_line ) )as avgs,*from sales) 

--***9.Which branch sold more products than average product sold?
select branch from sales
group by branch
having sum(quantity) >(select avg(quantity) from sales)







--10.What is the most common product line by gender?
select* from (select count(product_line) ,product_line, gender ,row_number()over(partition by gender) as row from sales
group by product_line ,gender
order by gender,count desc)
where row =6

--11.What is the average rating of each product line?

select round(avg(rating),2),product_line from sales
group by product_line

--12.What is the most common customer type?
select count(customer_type),customer_type from sales
group by customer_type
order by count desc limit 1

--13.What is the gender distribution per branch?
select cume_dist()over(partition by branch order by gender), gender,branch from sales
group by branch,gender

--14.Which time of the day do customers give most ratings?
select count(*),time_of_day from (select rank ()over(partition by time_of_day order by rating desc),rating,time_of_day,round(avg(rating)over(),2) as avgs,* from sales)
group by time_of_day
having rating>avgs

--15.Which day of the week has the best avg ratings?
select round(avg(rating)over(partition by day_name),3) as avgs,day_name from sales
order by avgs desc
limit 1


--16.Number of sales made in each time of the day per weekday?
select sum(quantity),day_name,time_of_day from sales
group by time_of_day,day_name
order by time_of_day,day_name


--17.Which city has the largest tax/VAT percent?
select city ,tax_pct from sales 
where tax_pct=(select max(tax_pct) from sales)


/*18.Retrieve the invoice details (invoice_id, customer_type, and total) for transactions
made by customers of the same gender in the same city.*/
select a.invoice_id, a.customer_type,a.total from sales as a join sales as b on a.invoice_id=b.invoice_id
where a.gender=b.gender and a.city=b.city 

/*19.Use a CTE to find the total gross income for each branch, considering the 
gross income as the sum of the total for each transaction.*/
with cte as(select sum(gross_income) as total_gross_income ,branch from sales group by branch)
select *from cte


/*20.Create a stored procedure that takes a branch name as input and returns the 
average quantity of products sold in transactions for that branch.*/
create or replace procedure get_avgs( in p_branch varchar(20),inout avgs float )
language plpgsql
as $$
declare
begin
   select avg(quantity)  into avgs from sales
   group by branch
   having branch=p_branch;
end;$$
 
 call get_avgs('A',0)


--21.Rank the transactions based on the total amount in descending order. Include the invoice_id, total, and the rank of each transaction.
select invoice_id, total,rank()over(order by total desc  ) from sales

--22.Calculate the running total of gross income over time. Display the date, total gross income, and the running total.
select gross_income,sum(gross_income)over(order by invoice_id)from sales

