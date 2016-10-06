--Thomas - The Joins Three-quel - Lab 5
--Question 1 - Show the cities of agents booking an order for a customer whose id is 'c006'. Use joins this time; no subqueries
  SELECT agents.city
    FROM orders Inner Join agents on orders.aid = agents.aid
   WHERE orders.cid = 'c006'
Order BY agents.city DESC;

--Question 2 - Show the ids of products ordered through any agent who makes at lest one order for a customer in Kyoto, sorted 
--by pid from highest to lowest. Use joins; no subqueries.
select distinct ord.pid 
  from customers inner join orders o   on customers.cid = o.cid and customers.city = 'Kyoto' 
            left outer join orders ord on ord.aid = o.aid 
       order by ord.pid DESC;

--Question 3 - Show the names of customers who have never placed an order. Use a subquery.
  SELECT name
    FROM customers
   WHERE cid NOT in (SELECT distinct cid
                       FROM orders)
Order By Name DESC;

--Question 4 - Show the names of customers who have never placed an order. Use a outer join.
  SELECT customers.name
    FROM orders right outer Join customers on orders.cid = customers.cid
   WHERE orders.ordnum is NULL
Order By customers.name DESC;

--Question 5 - Show the names of customers who placed at least one order through an agent in their own city, along with those agent(s') names.
  SELECT customers.name, agents.name
    FROM orders inner Join customers on orders.cid = customers.cid
                INNER JOIN agents on orders.aid = agents.aid
   WHERE customers.city = agents.city
Order By agents.name DESC;

--Question 6 - Show the names of customers and agents living in the same city, along with the name of the shared city, regardless of whether or not the customer has ever placed an order with that agent.
  SELECT agents.name, customers.name, agents.city
    FROM agents inner Join customers on agents.city = customers.city
   WHERE customers.city = agents.city
Order By agents.name DESC;


--Question 7 - Show the name and city of customers who live in the city that makes the fewest different kinds of products. (Hint: Use count and group by on the Products table.)
  select name, city
    from customers
   where city in  (select city
                     from products
                 group by city
                 order by count(city) asc
                    limit 1)
order by name ASC;

