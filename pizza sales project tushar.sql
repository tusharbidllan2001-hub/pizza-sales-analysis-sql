use pizza_sales;

# 1. what is the number of total orders places?

select count(order_id) as total_orders_placed from orders;

# 2. Calculate the total revenue generated from the overall pizza sales

select round(sum(p.price * od.quantity),0) as total_revenue
from pizzas p join order_details od
on p.pizza_id = od.pizza_id;

# 3. Identify the highest priced pizza
# name | price

select pt.name, p.price as price
from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
order by price desc limit 1;

# 4. Identify the most common pizza size ordered
# size | order_count

 select p.size, count(od.order_id) as order_count
 from pizzas p join order_details od
 on od.pizza_id = p.pizza_id
 group by p.size order by order_count desc;
 
 # 5. List the top 5 most ordered pizza names along with their quantity
 # name | quantity
 
 select pizza_types.name, sum(order_details.quantity) as total_quantity
 from pizza_types join pizzas 
 on pizza_types.pizza_type_id  = pizzas.pizza_type_id
 join order_details
 on order_details.pizza_id = pizzas.pizza_id
 group by pizza_types.name order by total_quantity desc limit 5;
 
 
 # 6. Determine the distribution of orders by hour of the day
 # hour | order_count
 
 select hour(time) as hour, count(order_id) as order_count from orders group by hour order by hour;
 
 # 7. Determine the top 3 most ordered pizza names based on total revenue
 # name | revenue
 
 select pt.name, round(sum(od.quantity * p.price),0) as total_revenue
 from pizza_types pt join pizzas p
 on pt.pizza_type_id = p.pizza_type_id
 join order_details od on od.pizza_id = p.pizza_id
 group by pt.name order by total_revenue desc limit 3;
 
 # 8.  Calculate the percentage contribution of each pizza category to total revenue
 # category | category_revenue | percentage_contribution
 
 # METHOD 1
 with total_revenue as
 (select pt.category, round(sum(od.quantity * p.price),0) as category_revenue
 from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od on od.pizza_id = p.pizza_id
group by pt.category)
select category, category_revenue, concat(round(category_revenue*100 / sum(category_revenue) over() , 2), "%") as percentage_contribution
from total_revenue order by percentage_contribution desc;

# METHOD 2
with total_revenue as
 (select pt.category, round(sum(od.quantity * p.price),0) as category_revenue
 from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od on od.pizza_id = p.pizza_id
group by pt.category)
select category, category_revenue, concat(round((category_revenue / (select sum(category_revenue) from total_revenue))*100,2), "%") as percentage_contribution
from total_revenue group by category order by percentage_contribution desc;


# 9. Find the total quantity of each pizza category ordered

select pt.category, count(od.quantity) as order_count
from pizza_types pt join pizzas p 
on pt.pizza_type_id =p.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
group by pt.category order by order_count desc; 


# 10. Find out how many pizzas are there in each category

select category, count(name) as pizza_count from pizza_types group by category order by pizza_count desc;


# 11. Find out total revenue month wise

select monthname(orders.date) as months, round(sum(order_details.quantity * pizzas.price),2) as total_revenue
from orders join order_details
on orders.order_id = order_details.order_id
join pizzas on order_details.pizza_id = pizzas.pizza_id
group by months;
