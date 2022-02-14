/* Create a new database */	
create database eCommerceDB;
	
/*start using the database */
use eCommerceDB;
	
/*create table  supplier */
create table if not exists Supplier(
	supp_id int primary key, 
	supp_name varchar(50),
	supp_city varchar (10),
	supp_phone varchar(50)
);
	
/*Create table Customer */
create table if not exists Customer(
	cus_id int not null,
	cus_name varchar(20) null default null,
	cus_phone varchar(10),
	cus_city varchar(30),
	cus_gender char, 
	primary key (cus_id)
);
	
/*create table with category */
create table if not exists Category (
	cat_id int not null,
	cat_name varchar(20) null default null, 
	primary key(cat_id)
);
	
/*create table product */
create table if not exists product(
	pro_id int not null,
	pro_name varchar(20) null default null, 
	pro_desc varchar(60) null default null, 
	cat_id int not null, 
	primary key (pro_id),
	foreign key (cat_id) references Category(cat_id)
);

/* create table product details */
create table if not exists product_details (
	prod_id int not null, 
	pro_id int not null, 
	supp_id int not null, 
	prod_price int not null, 
	primary key(prod_id), 
	foreign key(pro_id) references product (pro_id),
	foreign key(supp_id) references supplier(supp_id)
);
	
/* create table orders */
create table if not exists Orders (
	ord_id int not null,
	ord_amount int not null, 
	ord_date date, 
	cus_id int not null, 
	prod_id int not null, 
	primary key(ord_id),
	foreign key(cus_id) references customer(cus_id),
	foreign key(prod_id) references product_details(prod_id)
);
	
/*create table rating */
create table if not exists rating (
	rat_id int not null, 
	cus_id int not null,
	supp_id int null, 
	rat_ratstars int not null,
	primary key(rat_id),
	foreign key (supp_id) references supplier(supp_id),
	foreign key(cus_id) references customer(cus_id)
);

/* Insert values into supplier */
insert into supplier values(1, "Rajesh Retails", "Delhi", '1234567890');
insert into supplier values(2, "Appario Ltd.", "Mumbai", '2589631470');
insert into supplier values(3, "Knome products", "Banglore", '9785462315');
insert into supplier values(4, "Bansal Retails", "Kochi", '8975463285');
insert into supplier values(5, "Mittal Ltd.", "Lucknow", '7898456532');

/* Insert values into customer */
insert into customer values(1, "AAKASH", '9999999999', "DELHI", 'M');
insert into customer values(2, "AMAN", '9785463215', "NOIDA", 'M');
insert into customer values(3, "NEHA", '9999999999', "MUMBAI", 'F');
insert into customer values(4, "MEGHA",'9994562399', "KOLKATA", 'F');
insert into customer values(5, "PULKIT", '7895999999', "LUCKNOW", 'M');

/* Insert values into category */
insert into category values(1, "BOOKS");
insert into category values(2, "GAMES");
insert into category values(3, "GROCERIES");
insert into category values(4, "ELECTRONICS");
insert into category values(5, "CLOTHES");

/* Insert values into product */
insert into product values(1, "GTA V", "DFJDJFDJFDJFDJFJF", 2);
insert into product values(2, "TSHIRT", "DFDFJDFJDKFD", 5);
insert into product values(3, "ROG LAPTOP", "DFNTTNTNTERND", 4);
insert into product values(4, "OATS", "REURENTBTOTH", 3);
insert into product values(5, "HARRY POTTER","NBEMCTHTJTH", 1);

/* Insert values into product details */
insert into product_details values(1, 1, 2, 1500);
insert into product_details values(2, 3, 5, 30000);
insert into product_details values(3, 5, 1, 3000);
insert into product_details values(4, 2, 3, 2500);
insert into product_details values(5, 4, 1, 1000);

/* Insert values into orders */
insert into orders values(20, 1500, "2021-10-12", 3, 5);
insert into orders values(25, 30500, "2021-09-16", 5, 2);
insert into orders values(26, 2000, "2021-10-05", 1, 1);
insert into orders values(30, 3500, "2021-08-16", 4, 3);
insert into orders values(50, 2000, "2021-10-06", 2, 1);

/* Insert values into rating */
insert into rating values(1, 2, 2, 4);
insert into rating values(2, 3, 4, 3);
insert into rating values(3, 5, 1, 5);
insert into rating values(4, 1, 3, 2);
insert into rating values(5, 4, 5, 4);

/* Q3  Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000. */
select count(c.cus_name), c.cus_gender, o.ord_amount
  from customer c, orders o
 where c.cus_id = o.cus_id
   and o.ord_amount > 3000
   group by c.cus_gender;

/*Q4 Display all the orders along with the product name ordered by a customer having Customer_Id=2. */
select o.*,p.pro_name, p.pro_desc
  from customer c, orders o, product p, product_details pd
 where c.cus_id = o.cus_id
   and o.prod_id = pd.prod_id
   and pd.pro_id = p.pro_id
   and c.cus_id = 2;

/* Q5 Display the Supplier details who can supply more than one product. */
select s.supp_name,s.supp_phone,count(pd.pro_id) 'No Of Products'
  from supplier s, product_details pd
 where s.supp_id = pd.supp_id
 group by pd.supp_id
 having count(pd.pro_id) > 1;
 
/* Q6 Find the category of the product whose order amount is minimum.*/
select c.cat_name, p.pro_name, o.ord_amount
  from product p, product_details pd, category c, orders o
   where 1=1
     and p.pro_id = pd.pro_id
     and p.cat_id = c.cat_id
     and pd.prod_id =  o.prod_id
     and o.ord_amount = ( select min(od.ord_amount) from orders od );

/* Q7 Display the Id and Name of the Product ordered after “2021-10-05”.*/
select p.pro_id, p.pro_name, o.ord_date
  from product p, product_details pd, orders o
   where 1=1
     and p.pro_id = pd.pro_id
     and pd.prod_id =  o.prod_id
     and o.ord_date > '2021-10-05';

/* Q8 Display customer name and gender whose names start or end with character 'A'.*/
select cus_name, cus_gender 
  from customer 
 where upper(cus_name) like 'A%' or upper(cus_name) like  '%A';

/* Q9 Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average 
	Supplier” else “Supplier should not be considered”*/

delimiter //
CREATE PROCEDURE ratingVerdict()
	BEGIN
		select r.rat_ratstars, s.supp_name, 
			case when  r.rat_ratstars > 4 then 'Genuine Supplier'
			when r.rat_ratstars > 2 then 'Average Supplier'
			else 'Supplier should not be considered'
			end as verdict
          from rating r, supplier s  
		 where r.supp_id = s.supp_id;
	END // ;
delimiter ;

-- Call the stored procedure
call ratingverdict();