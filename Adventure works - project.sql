/* 1.Retrieve information about the products with colour values except null, red, silver/black, white and list price between
£75 and £750. Rename the column StandardCost to Price. Also, sort the results in descending order by list price*/

SELECT ProductNumber, Name, Color, ListPrice AS Price
FROM Production.Product
WHERE Color IS NOT NULL
  AND Color NOT IN ('null', 'red', 'silver/black', 'white')
  AND ListPrice BETWEEN 75 AND 750
ORDER BY ListPrice DESC;


/*Question 2 
Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and female employees born between 1972 and 1975 and hire date between 2001 and 2002. */

select he.BusinessEntityID, BirthDate, Gender, hiredate, firstname, lastname from HumanResources.Employee as he
join Person.Person as pp
on he.BusinessEntityID = pp.BusinessEntityID
where (gender = 'm' and BirthDate between '1962' and '1970' and hiredate>'2001') or (gender='f' and birthdate between '1972' and '1975' and HireDate between '2001' and '2002');


/*Question 3 
Create a list of 10 most expensive products that have a product number beginning with ‘BK’. Include only the product ID, Name and colour. 
*/
select top 10 ProductID, Name,Color, ProductNumber from Production.Product
where ProductNumber like 'BK%'
order by ListPrice desc;


/*Question 4 
Create a list of all contact persons, where the first 4 characters of the last name are the same as the first four characters of the email address. Also, for all contacts whose first name and the last name begin with the same characters, create a new column called full name combining first name and the last name only. Also provide the length of the new column full name.*/
 
select firstname, lastname,EmailAddress ,concat_ws (' ', firstname, lastname) as Fullname, len(concat_ws (' ', firstname, lastname))as FullNameLength from person.EmailAddress as pe
join person.Person as pp
on pe.BusinessEntityID=pp.BusinessEntityID
where left(lastname,4)=left(emailaddress,4) or left(lastname,1) = left(FirstName,1);


/*Question 5 Return all product subcategories that take an average of 3 days or longer to manufacture*/

select pp.ProductSubcategoryID,DaysToManufacture,ps.Name from Production.Product as pp
join production.ProductSubcategory as ps
on pp.ProductSubcategoryID = ps.ProductSubcategoryID
group by pp.ProductSubcategoryID, ps.Name, DaysToManufacture
having DaysToManufacture>=3;


/*Question 6 
Create a list of product segmentation by defining criteria that places each item in a predefined segment as follows. If price gets less than £200 then low value. If price is between £201 and £750 then mid value. If between £750 and £1250 then mid to high value else higher value. Filter the results only for black, silver and red color products. */
select*, case when listprice <200 then 'low_value'
when listprice between 201 and 750 then 'mid_value'
when listprice between 751 and 1250 then 'high_value' else 'higher_value' end as ProductSegments 
from Production.Product
where color in ('black','silver','red')
order by ListPrice;


/*Question 7 
How many Distinct Job title is present in the Employee table? 290*/

select distinct count(jobtitle)from HumanResources.Employee;


/*Question 8 
Use employee table and calculate the ages of each employee at the time of hiring. */

select BusinessEntityID, DATEDIFF(year,BirthDate, HireDate) as EmploymentAge 
from HumanResources.Employee;


/*Question 9 
How many employees will be due a long service award in the next 5 years, if long service is 20 years? 74*/

select count(BusinessEntityID) from HumanResources.Employee
where DATEDIFF(year,hiredate,getdate())+5='20';


/*Question 10 
How many more years does each employee have to work before reaching sentiment, if sentiment age is 65?*/

select BusinessEntityID, 65-DATEDIFF(year,BirthDate, HireDate) as EmploymentAge 
from HumanResources.Employee; 


/*Question 11 
Implement new price policy on the product table base on the colour of the item If white increase price by 8%, If yellow reduce price by 7.5%, If black increase price by 17.2%. If multi, silver, silver/black or blue take the square root of the price and double the value. Column should be called Newprice. For each item, also calculate commission as 37.5% of newly computed list price. */

select ListPrice,Color, case when color='white' then listprice*1.08
when color='yellow' then listprice*.925
when color='black' then listprice*1.172
when color in('multi', 'silver','silver/black','blue') then sqrt(listprice)*2
else listprice end as NewPrice,
(case when color='white' then listprice*1.08
when color='yellow' then listprice*.925
when color='black' then listprice*1.172
when color in('multi', 'silver','silver/black','blue') then sqrt(listprice)*2
else listprice end)*.375 as Commission
from Production.Product 
where Color is not null;


/*Question 12 
Print the information about all the Sales.Person and their sales quota. For every Sales person you should provide their FirstName, LastName, HireDate, SickLeaveHours and Region where they work.*/

select pp.FirstName,pp.LastName,ss.SalesQuota, HireDate, SickLeaveHours,pc.Name as WorkRegion from HumanResources.Employee as he
join person.Person as pp on he.BusinessEntityID=pp.BusinessEntityID
join Sales.SalesPerson as ss on ss.BusinessEntityID=pp.BusinessEntityID
join sales.SalesTerritory as st on st.TerritoryID=ss.TerritoryID
join person.CountryRegion as pc on st.CountryRegionCode=pc.CountryRegionCode;


Question 13 
/*Using adventure works, write a query to extract the following information. 
Product name 
Product category name 
Product subcategory name 
Sales person 
Revenue 
Month of transaction 
Quarter of transaction 
Region */

select so.SalesOrderID, SalesOrderDetailID, concat_ws(' ',FirstName,LastName) as SalesPerson, ppt.Name as ProductName, ppc.Name as ProductCategory, pps.Name as productSubCategory,LineTotal as Revenue,month(so.orderdate)as MonthofTransaction, case when month(so.orderdate) between 1 and 3 then 'Q1' when month(so.orderdate) between 4 and 6 then 'Q2' when month(so.orderdate) between 7 and 9 then 'Q3' when month(so.orderdate) between 10 and 12 then 'Q4' end as MonthofTransaction from Sales.SalesOrderDetail as ss
left join sales.SalesOrderHeader as so on ss.SalesOrderID=so.SalesOrderID
left join Person.Person as pp on pp.BusinessEntityID=so.SalesPersonID
left join Sales.SalesTerritory as st on st.TerritoryID=so.TerritoryID
left join person.CountryRegion as pc on st.CountryRegionCode= pc.CountryRegionCode
left join Production.Product as ppt on ppt.ProductID=ss.ProductID
left join Production.ProductSubcategory as pps on ppt.ProductSubcategoryID=pps.ProductSubcategoryID
left join Production.ProductCategory as ppc on ppc.ProductCategoryID=pps.ProductCategoryID;


/*Question 14 
Display the information about the details of an order i.e. order number, order date, amount of order, which customer gives the order and which salesman works for that customer and how much commission he gets for an order. */

select SalesOrderNumber,OrderDate,customerID, concat_ws(' ',firstname,lastname) as Salesman, SubTotal as AmountOfOrder,(SubTotal*CommissionPct) as CommissionOnOrder from sales.SalesOrderHeader sh
join Person.Person pp on pp.BusinessEntityID=sh.SalesPersonID
join sales.SalesPerson sp on sp.BusinessEntityID=sh.SalesPersonID;


/*Question 15 
For all the products calculate 
- Commission as 14.790% of standard cost, 
- Margin, if standard cost is increased or decreased as follows: 

Black: +22%, 
Red: -12% 
Silver: +15% 
Multi: +5% 
White: Two times original cost divided by the square root of cost For other colours, standard cost remains the same */

select ProductID, Name, Color, StandardCost, StandardCost*0.1479 as Commission, case when color ='black' then StandardCost*1.22 when color ='red' then StandardCost*0.88 when color ='silver' then StandardCost*1.15 when color = 'multi' then StandardCost*1.05 when color='white' then (StandardCost*2/SQRT(standardcost)) else StandardCost end as PriceAdjustment,(case when color ='black' then StandardCost*1.22 when color ='red' then StandardCost*0.88 when color ='silver' then StandardCost*1.15 when color = 'multi' then StandardCost*1.05 when color='white' then (StandardCost*2/SQRT(standardcost)) else StandardCost end)-StandardCost as Margin from Production.Product
order by StandardCost desc;


/*Question 16 
Create a view to find out the top 5 most expensive products for each colour.*/
With added_row_number as (select ProductID, Name, Color, ListPrice,
    	row_number() over(partition by color order by listprice desc) as Top5products
   	from production.Product)
  	select*from added_row_number
 	where Top5products between 1 and 5;

