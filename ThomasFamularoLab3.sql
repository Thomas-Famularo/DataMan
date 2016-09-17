--Thomas Famularo Lab3--
--List the order number and total dollars of all orders--
Select ordnum,totalUSD
From orders;

--List the name and city of agents named Smith--
Select name,city
From agents
Where name='Smith';

--List the id, name, and priceUSD of products with quantity more than 201,000--
Select pid,name,priceUSD
From products
Where quantity > 201000;

--List the names and cities of customers in Duluth--
Select name,city
From customers
Where city='Duluth';

--List the names of agents not in New York and not in Duluth--
Select name,city
From agents
Where city!='New York'
  and city!='Duluth';

--List all data for products in neither Dallas nor Duluth that cost US$1 or more--
Select *
From products
Where city!='Dallas'
  and city!='Duluth'
  and priceusd >= 1.00;

--List all data for orders in February or March--
Select *
From orders
where mon='feb'
   or mon='mar';

--List all data for orders in February of US$600 or more--
Select *
From orders
where mon='feb'
  and totalUSD >= 600.00;

--List all orders from the customer whose cid is C005--
Select *
From orders
where cid='C005';