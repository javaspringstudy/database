show databases;
use classicmodels;
show tables;

desc payments;
select * from payments;
select sum(amount), count(checkNumber) from payments;

desc orders;
select * from orders;
select * from orders inner join customers on orders.customerNumber = customers.customerNumber;
select orderNumber, country from orders inner join customers on orders.customerNumber = customers.customerNumber;
select orderNumber, country from orders o inner join customers c on o.customerNumber = c.customerNumber where c.country = "USA";

select FOUND_ROWS();

-- 일별매출액
select orderDate, sum(t.priceEach*t.quantityOrdered)
from orders o inner join orderdetails t 
on o.orderNumber = t.orderNumber
group by o.orderDate 
order by 1;

-- 월별 매출액
select substr(orderDate,1,7) 월별, concat("$",format(sum(t.priceEach*t.quantityOrdered),0)) 매출액
from orders o
inner join orderdetails t on o.orderNumber = t.orderNumber
group by 1;

-- 년도별 매출액
select substr(orderDate,1,4), sum(t.priceEach*t.quantityOrdered)
from orders o
inner join orderdetails t on o.orderNumber = t.orderNumber
group by 1;

-- 일자별 구매자수
select orderDate, count(distinct customerNumber), count(orderNumber)
from orders
group by 1
order by 1;

-- 월별 구매자수
select substr(orderdate,1,7) 월별, count(distinct customerNumber) 구매자수
from orders 
group by 1;


-- 년도별 구매자수
select substr(orderdate,1,4) 년도별, count(distinct customerNumber)
from orders
group by 1
order by 1
;

-- 컬럼에대한 중복확인
select count(orderNumber), count(distinct orderNumber)
from orders;


desc orderdetails;
select * from orderdetails;
select distinct ordernumber from orderdetails order by ordernumber asc;
select * from orderdetails where priceeach >= 30 order by priceeach asc;


desc customers;
select * from customers;
select customername, customernumber, country from customers where country in ("USA","Canada");
select customername, customernumber, country from customers where country not in("USA","Canada");
select addressLine1 from customers where addressLine1 like "%ST%";
select country, city, count(*) as 고객수 from customers group by country, city;
select country, (case when country in ("USA","Canada") then "북미" else "비북미" end) from customers order by country;
select sum(case when country in ("USA","Canada") then 1 else 0 end) as "북미고객수", sum(case when country in ("USA","Canada") then 0 else 1 end) as "비북미고객수" from customers order by country;

select (case when country in ("USA","Canada") then "북미고객" else "비북미고객" end) as 지역, (count(country)) as 고객수
from customers
group by (case when country in ("USA","Canada") then "북미고객" else "비북미고객" end);

select (sum(case
	when country = "USA" then 1
    else 0
end)) as "USA거주자의수", concat(round(sum(case
	when country = "USA" then 1
    else 0
end)/count(*)*100,2),"%") from customers;


--  usa 거주자의 주문번호
select orderNumber from orders where customerNumber in (select customerNumber from customers where country="USA");

desc employees;
select employeeNumber, reportsTo from employees where reportsTo is null;

create view reportTbl as 
(select employeeNumber, reportsTo from employees where reportsTo is null);

select * from reportTbl;


#년도별 인당 매출액
-- 고객이 년도별로 구매한 기록 전체 출력 : 구매년도, 고객명, 매출건수, 매출액  
	-- 관련테이블 : orders, customers, orderdetails

select SUBSTR(orderDate,1,4) as 구매년도, customerName as 고객명, count(distinct orderDate) 구매건수, (priceEach*quantityOrdered) as 매출액
from orders o
inner join customers c on c.customerNumber = o.customerNumber
inner join orderdetails t on o.orderNumber = t.orderNumber 
group by 1, c. customerNumber 
order by 1;


#년도별 총 매출액 : 구매년도, 구매자수, 매출액
select SUBSTR(orderDate, 1, 4) 구매년도,  count(DISTINCT customerNumber) 구매건수, 
sum(quantityOrdered*priceEach) as 매출액,
FLOOR(sum(quantityOrdered*priceEach)/count(DISTINCT customerNumber))  as 인당평균매출액
from orders o
inner join orderdetails t on o.orderNumber = t.orderNumber 
group by 1
order by 1;

#1건의 거래는 평균적으로 얼마의 매출을 발생시키는가?
select SUBSTR(orderDate, 1, 4) 구매년도,  count(DISTINCT customerNumber) 구매건수, 
sum(quantityOrdered*priceEach) as 매출액, 
FLOOR(sum(quantityOrdered*priceEach)/count(DISTINCT customerNumber))  as 인당평균매출액,
FORMAT(sum(quantityOrdered*priceEach)/count(DISTINCT o.orderNumber),0)  as 건당매출액
from orders o
inner join orderdetails t on o.orderNumber = t.orderNumber 
group by 1
order by 1;

#국가별, 도시별 매출액
select country as 국가, city as 도시, (quantityOrdered*priceEach) as 매출액
from orders o
inner join orderdetails t on o.orderNumber = t.orderNumber 
inner join customers c on o.customerNumber = c.customerNumber 
group by 1, 2
order by 1, 3;

#북미(USA, Canada), 비북미 매출액 비교
SELECT 
(CASE when country in ("USA","Canada") then "북미" else "비북미" end) 구분,
sum(quantityOrdered*priceEach) 매출액
from orders o 
inner join orderdetails t on o.orderNumber = t.orderNumber 
inner join customers c on o.customerNumber = c.customerNumber
group by 1;


select sum(case when country IN("USA","Canada") then quantityOrdered*priceEach end) 북미매출,
sum(case when country NOT IN("USA","Canada") then quantityOrdered*priceEach end) 비북미매출
from orders o 
inner join orderdetails t on o.orderNumber = t.orderNumber 
inner join customers c on o.customerNumber = c.customerNumber

;



