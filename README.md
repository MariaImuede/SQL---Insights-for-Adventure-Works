
# Database Queries and Insights for Adventure Works
 

![Database Queries and Insights for Adventure Works](https://github.com/MariaImuede/Power-Bi/assets/159175444/ba118000-b55d-4133-9af5-f4cdee5a038d)


## Problem Statement

An analysis of a Microsoft SQL database is conducted to extract meaningful insights related to customer data, sales, and product information. The objectives include identifying patterns, trends, and key metrics to inform decision-making processes and address specific business inquiries.
Dataset provided by: https://www.linkedin.com/company/quantum-analytics-ng/



### Steps followed 

- Step 1 : Initially, the database is explored to understand its structure and identify potential data quality issues such as missing values or inconsistencies.

- Step 2 : Data cleaning tasks are performed to address the identified issues, including handling missing values and standardizing formats.

- Step 3 : The database is queried to answer specific questions related to customer data, sales, and product information.


- Step 4 : Queries are designed to extract relevant insights, such as the number of customers without a middle name and the count of email addresses not ending in a specific domain.

           
- Step 5 : Queries were generated to answer the specific questions 

-- 1. How many people in the DB do not have a middle name? Show the query.
SELECT COUNT(*)
FROM person.Person
WHERE MiddleName IS NULL OR MiddleName = ''; 

![queston1](https://github.com/MariaImuede/Power-Bi/assets/159175444/ba26f88c-cb21-4331-bef3-55ffcf6720b9)


-- 2. How many email addresses do not end in adventure-works.com? Show the query.
SELECT COUNT(*)
FROM person.EmailAddress
WHERE NOT EmailAddress LIKE '%adventure-works.com';

![queston2](https://github.com/MariaImuede/Power-Bi/assets/159175444/d411baab-3a26-413b-b18b-e4d8fa710a08)

/* 3. A ticket is escalated and asks what customers got the email promotion. Please provide the 
information*/
SELECT BusinessEntityID, FirstName, MiddleName, LastName, EmailAddress
FROM Sales.vIndividualCustomer
WHERE EmailPromotion = 1;

![queston3](https://github.com/MariaImuede/Power-Bi/assets/159175444/42a56c19-afa9-475b-9487-91cf1e010251)

/* 5. Retrieve a list of all contacts which are 'Purchasing Manager' and their names*/
SELECT *
FROM Sales.vStoreWithContacts
WHERE ContactType = 'Purchasing Manager'

![queston5](https://github.com/MariaImuede/Power-Bi/assets/159175444/8ab450b8-5a14-4b22-9287-250d03fac7e1)

/* 6. A "Single Item Order" is a customer order where only one item is ordered. Show the 
SalesOrderID and the UnitPrice for every Single Item Order*/
SELECT SalesOrderID, UnitPrice FROM Sales.SalesOrderDetail

![queston6](https://github.com/MariaImuede/Power-Bi/assets/159175444/b863675c-e335-4061-b640-e368f78eb490)

-- 7. Create a view to find out the top 5 most expensive products for each colour.
With added_row_number as (select ProductID, Name, Color, ListPrice,
    	row_number() over(partition by color order by listprice desc) as Top5products
   	from production.Product)
  	select*from added_row_number
 	where Top5products between 1 and 5;

![queston7](https://github.com/MariaImuede/Power-Bi/assets/159175444/cc7ce8a9-02a2-46d5-9747-abd0322a77ae)

	/* 8 
For all the products calculate 
- Commission as 14.790% of standard cost, 
- Margin, if standard cost is increased or decreased as follows: 

Black: +22%, 
Red: -12% 
Silver: +15% 
Multi: +5% 
White: Two times original cost divided by the square root of cost For other colours, standard cost remains the same */

select ProductID, Name, Color, StandardCost, StandardCost*0.1479 as Commission, 
case when color ='black' then StandardCost*1.22 when color ='red' then 
StandardCost*0.88 when color ='silver' then StandardCost*1.15 when color = 'multi' then 
StandardCost*1.05 when color='white' then (StandardCost*2/SQRT(standardcost)) else 
StandardCost end as PriceAdjustment,(case when color ='black' then StandardCost*1.22 when 
color ='red' then StandardCost*0.88 when color ='silver' then StandardCost*1.15 when 
color = 'multi' then StandardCost*1.05 when color='white' then (StandardCost*2/SQRT(standardcost)) else 
StandardCost end)-StandardCost as Margin from Production.Product
order by StandardCost desc;

![queston8](https://github.com/MariaImuede/Power-Bi/assets/159175444/be45f8e6-fb16-4108-a6ea-f42dfdd18b20)

/* 9. Find all the male employees born between 1962 to 1970 and with hire date greater 
than 2001 and female employees born between 1972 and 1975 and hire date between 2001 and 2002. */

select he.BusinessEntityID, BirthDate, Gender, hiredate, firstname, lastname from HumanResources.Employee as he
join Person.Person as pp
on he.BusinessEntityID = pp.BusinessEntityID
where (gender = 'm' and BirthDate between '1962' and '1970' and hiredate>'2001') or 
(gender='f' and birthdate between '1972' and '1975' and HireDate between '2001' and '2002');

![queston9](https://github.com/MariaImuede/Power-Bi/assets/159175444/4080b2a3-756a-41ea-b97d-b304a7707317)

/*10. Create a list of 10 most expensive products that have a product number beginning with ‘BK’. 
Include only the product ID, Name and colour. 
*/
select top 10 ProductID, Name,Color, ProductNumber from Production.Product
where ProductNumber like 'BK%'
order by ListPrice desc;

![queston10](https://github.com/MariaImuede/Power-Bi/assets/159175444/6f9433ff-f3e5-44b4-b75c-22b8be114c9a)
 
 

# Insights

The queries provide valuable insights into various aspects of the database, including customer data, sales, product information, and employee demographics.
Insights include identifying missing middle names, email address patterns, customer responses to email promotions, purchasing manager contacts, single-item order trends, expensive products by color, product margins, and workforce demographics.

# Recommendations:
1. Implement measures to ensure completeness and accuracy of data, particularly regarding middle names and email addresses.Consider investigating the reasons behind the missing middle names, such as data entry conventions or cultural factors, to ensure data completeness and accuracy.

2. Evaluate the effectiveness of email promotions and consider refining targeting strategies based on customer responses. Review email domain patterns to ensure data consistency and consider verifying email addresses for accuracy to improve communication effectiveness.

3. Tailor marketing efforts towards purchasing managers to enhance engagement and increase sales opportunities. Analyze the effectiveness of email promotions by tracking customer responses and conversion rates to optimize future marketing campaigns.

4. Analyze single-item order trends to optimize inventory management and identify popular products.

5. Review pricing strategies for high-cost products and adjust prices based on demand and competition.

6. Conduct workforce diversity and inclusion initiatives based on insights into employee demographics.

