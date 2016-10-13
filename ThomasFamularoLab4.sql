-- Thomas Famularo 9/25/2016 -  Lab 4: SQL Queries - The Subqueries Sequel
-- 1: get cities of agents booking for customer with c006
select city
  from agents
 where aid in (select aid
		 from orders
                where cid = 'c006');

-- 2: id of products where customer in kyoto, sort by pid high to low
select pid
  from products
  where pid in (select pid
                  from orders
                 where cid in (select cid
                                 from customers
                                where city = 'Kyoto')
                )
  order by pid desc; 

-- 3: get id and names of customers who did not order with agent a03
select cid, name
  from customers
  where cid not in (select cid
                      from orders
                     where aid ='a03');

-- 4: get id of customers who ordered both p01 and p07
select cid, name
  from customers
  where cid in (select cid
                  from orders
                 where pid = 'p01'
             intersect
                select cid
                  from orders
                 where pid = 'p07');

-- 5: get ids of products not ordered by any customer who ordered through a08 order by pid high to low
select pid
  from products
 where pid not in (select pid
                    from orders
                   where aid = 'a08')
 order by pid desc;


-- 6: get names, discounts and city for all customers who ordered through agents in dallas or ny

select name, discount, city
  from customers
 where cid in (select cid
                 from orders
                where aid in (select aid
                                from agents
                               where city in ('Dallas', 'New York')
                             )
               );

-- 7: get all customers with same discount as those in dallas or london
select *
  from customers
 where discount in (select discount
                      from customers
                     where city in ('Dallas', 'London')
                    );



-- 8: Check constraints are rules that you implement in SQL to prevent you from inputting certain values.  
-- They let you impose certain rules for a column or table as a whole. These rules keep data uniform and 
-- help keep a high quality of data.  A couple of good use of check constraints are making sure an input
-- is not over the maximum length, checking another table to make sure a customer exists, and making sure
-- a column is not null if it is going to be used for a primary key.  A poor use of check constrains 
-- would be requiring a user to input dashes when entering a phone number, also requiring an email 
-- address to be from a certain domain.  These good uses keep the quality of data high, the first is good
-- for keeping the speed of the system high, if you have a 1 trillion character long password it would
-- take a really long time for that person to log in.  The second is good for not placing an order for
-- a customer that does not exist. In general, you only want to be able to place orders for customers
-- that exist. The third is good for keeping your primary key a super key, it keeps duplicate data out
-- of your primary key which would cause major problems.  The first bad check constraint forces the user
-- to input data in a certain format that does not always make sense to the user.  The second bad check
-- constraint because emails can be associated with any domain not just the one you decide is correct.