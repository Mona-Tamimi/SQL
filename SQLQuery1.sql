Create database Library;

use Library;
Create Table Books(
BookID int Primary Key,
Title varchar(250),
AuthorID int not null unique,
PublishedYear int CHECK (PublishedYear BETWEEN 1000 AND 9999),
CopiesAvailable int, 
BookCategory varchar(20)
);

Create Table Authors(
AuthorID int Primary Key,
FirstName varchar(20),
LastName varchar(20),
BirthYear int CHECK (BirthYear BETWEEN 1000 AND 9999),
);


--1- insert 5 rows in each table (Query to in insert 5 records in each table one by one or in one step)
insert into Books(BookID, Title, AuthorID, PublishedYear, CopiesAvailable, BookCategory)
values 
(1,'Book1',1,2001,200,'math'),
(2,'Book2',2,2002,189,'math'),
(3,'Book3',3,2003,35,'math'),
(4,'Book4',4,2004,89,'math'),
(5,'Book5',5,2005,190,'math');

insert into Authors(AuthorID, FirstName, LastName, BirthYear)
values
(1, 'FirstName', 'LastName', 1991),
(2, 'FirstName', 'LastName', 1992),
(3, 'FirstName', 'LastName', 1993),
(4, 'FirstName', 'LastName', 1994),
(5, 'FirstName', 'LastName', 1995);



--2- Display All Books and Authors: ( Query to retrieve and print details of all books along with their respective authors).
select * from Books,Authors where Books.AuthorID=Authors.AuthorID;

SELECT * 
FROM Books
INNER JOIN Authors ON Books.AuthorID = Authors.AuthorID;



--3-  Book Availability: ( Query to show the book with the highest and lowest number of available copies )
select max(CopiesAvailable)as Max_CopiesAvailable,min(CopiesAvailable) as Min_CopiesAvailable from Books;


--4- Average Publication Year:( Query to calculate and display the average publication year of books in the library )
select AVG(PublishedYear) as avg_PublishedYear from Books;

--5- Total Books Count:( Query to count and print the total number of books in the library )
select sum(CopiesAvailable) as number_of_books  from Books;

--6- Empty Books Table ( i just need make Books Table with out any record )
truncate table Books;

--7- update Authors table ( Query to add Email & Phone_Number as new columns )
alter table Authors
add Email varchar(30), Phone_Number int;

--8- Delete Authors Table
drop table Authors;