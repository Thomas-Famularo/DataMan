--Thomas , Lab 6, Database Management

-- Question 1: display name and city of customers who live in any city that makes the most different kinds of products
-- (there are two that make the most. Return name and city from either)select name, city of customers who in most product city
select name, city
  from customers c
 where c.city in (select distinct o.city
		    from products o inner join (select city, count(city)
                                                  from products 
                                              group by city) p on o.city = p.city
                                                 where p.count = (select MAX(p.count) as maximum
                                                                    from (select city, count(city)
                                                                            from products 
                                                                        group by city) p));

-- Question 2: Display names of products where priceUSD is below average priceUSD, sort by alphabet desc
select products.name
  from products
 where priceUSD < (select AVG(priceUSD) as average
                     from products)
 order by name desc;


-- Question 3: Display the customer name, pid ordered, and the total for all orders, sorted by total from low to high.
select customers.name, orders.pid, totalUSD
  from customers inner join orders on customers.cid = orders.cid
order by totalUSD asc;


-- Question 4: Display all customer names (in alphabetical order) and their total ordered, and nothing more. Use coalesce to avoid showing NULLs.
  Select customers.name, coalesce(sum(totalUSD), 0) as totalOrdered
    from customers left join orders on customers.cid = orders.cid
group by customers.cid
order by customers.name DESC;

-- Question 5: Display the names of all customers who bought products from agents based in New York
-- along with the names of the products they ordered, and the names of the agents who sold it to them.
select customers.name as customerName, products.name as productName, agents.name as agentName
  from orders inner join customers on customers.cid = orders.cid
              Inner join products on products.pid = orders.pid
              Inner join agents on agents.aid = orders.aid
 where agents.city = 'New York';

-- Question 6: Write a query to check the accuracy of the dollars column in the Orders table. This means calculating Orders.totalUSD from data in other tables
-- and comparing those values to the values in Orders.totalUSD. Display all rows in Orders where Orders.totalUSD is incorrect, if any.
CREATE VIEW calculatedTotalUSD as
     Select ((1.0 - (customers.discount / 100.0)) * (qty * priceUSD)) as totalUSD, ordnum
       From orders inner join customers on customers.cid = orders.cid
                   Inner join products on products.pid = orders.pid

Select *
  From orders Inner Join calculatedTotalUSD on orders.ordnum = calculatedTotalUSD.ordnum
 where orders.totalUSD != calculatedTotalUSD.totalUSD;


-- Question 7: What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give example queries in SQL to demonstrate. (Feel free to use the CAP
-- database to make your points here.)
-- A LEFT OUTER JOIN and a RIGHT OUTER JOIN are 
-- A LEFT OUTER JOIN and a RIGHT OUTER JOIN are essentially a different command that preforms the same function.  The LEFT and RIGHT key words just decide which\
-- table will be completely displayed, the trunk of the tree, the other side is the branch, the side that will not be completely displayed and most likely have some nulls.
-- The Query
-- SELECT *
-- FROM orders LEFT OUTER JOIN agents ON orders.aid = agents.aid
-- Will give you the same result as
-- SELECT *
-- FROM agents RIGHT OUTER JOIN orders On orders.aid = agents.aid
-- If you switch the order of the tables and the key word RIGHT or LEFT, then the query will have the same result.
          
