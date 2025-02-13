-- Create the database and switch to it
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Create Tables
DROP TABLE IF EXISTS FinancialFines;
DROP TABLE IF EXISTS Reservations;
DROP TABLE IF EXISTS MemberBook;
DROP TABLE IF EXISTS LibraryStaff;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Books;

-- Books: Stores information about books available in the library.
CREATE TABLE Books (
    ID INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(255) NOT NULL,
    Author NVARCHAR(255) NOT NULL,
    Genre NVARCHAR(255) NOT NULL,
    PublicationYear INT NOT NULL,
    AvailabilityStatus VARCHAR(50) NOT NULL
);

-- Members: Contains details of library members.
CREATE TABLE Members (
    ID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(50) NOT NULL,
    MembershipType VARCHAR(50) NOT NULL,
    RegistrationDate DATE NOT NULL,
    Email VARCHAR(255)
);

-- MemberBook: Junction table tracking the borrowing of books.
CREATE TABLE MemberBook (
    ID INT PRIMARY KEY IDENTITY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    BorrowingDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(ID),
    FOREIGN KEY (BookID) REFERENCES Books(ID)
);

-- LibraryStaff: Stores details about library staff.
CREATE TABLE LibraryStaff (
    ID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(50) NOT NULL,
    AssignedSection NVARCHAR(255) NOT NULL,
    EmploymentDate DATE NOT NULL
);

-- Categories: Groups books into different categories.
CREATE TABLE Categories (
    ID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(255) NOT NULL,
    Description NVARCHAR(255) NOT NULL
);

-- Reservations: Allows members to reserve books.
CREATE TABLE Reservations (
    ID INT PRIMARY KEY IDENTITY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    ReservationDate DATE NOT NULL,
    Status VARCHAR(50) NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(ID),
    FOREIGN KEY (BookID) REFERENCES Books(ID)
);

-- FinancialFines: Tracks fines issued to members for late returns.
CREATE TABLE FinancialFines (
    ID INT PRIMARY KEY IDENTITY,
    MemberID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(50) NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(ID)
);

-- Insert Data into Books
INSERT INTO Books (Title, Author, Genre, PublicationYear, AvailabilityStatus) VALUES
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 'Available'),
('1984', 'George Orwell', 'Dystopian', 1949, 'Checked Out'),
('Moby Dick', 'Herman Melville', 'Adventure', 1851, 'Available'),
('Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 'Available'),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925, 'Available'),
('Database Fundamentals', 'Author A', 'Educational', 2020, 'Available'),
('SQL for Beginners', 'Author B', 'Educational', 2021, 'Available'),
('C# Programming', 'Author C', 'Educational', 2019, 'Available'),
('Galactic Odyssey', 'Author D', 'Science Fiction', 2018, 'Available');

-- Insert Data into Members
INSERT INTO Members (Name, ContactInfo, MembershipType, RegistrationDate, Email) VALUES
('John Doe', '1234567890', 'Student', '2025-01-01', 'john.doe@example.com'),
('Jane Smith', '2345678901', 'Teacher', '2025-01-02', 'jane.smith@example.com'),
('Alice Johnson', '3456789012', 'Visitor', '2025-01-03', 'alice.johnson@example.com'),
('Bob Brown', '4567890123', 'Student', '2025-01-04', 'bob.brown@example.com'),
('Charlie White', '5678901234', 'Teacher', '2025-01-05', 'charlie.white@example.com');

-- Insert initial Data into MemberBook (base records)
INSERT INTO MemberBook (MemberID, BookID, BorrowingDate, DueDate, ReturnDate) VALUES
(1, 1, '2025-02-01', '2025-02-15', '2025-02-15'),  -- To Kill a Mockingbird borrowed by John Doe
(2, 2, '2025-02-03', '2025-02-17', '2025-02-16'),  -- 1984 borrowed by Jane Smith
(3, 3, '2025-02-05', '2025-02-19', NULL),           -- Moby Dick borrowed by Alice Johnson (not returned)
(4, 4, '2025-02-07', '2025-02-21', '2025-02-20'),    -- Pride and Prejudice borrowed by Bob Brown
(5, 5, '2025-02-09', '2025-02-23', '2025-02-22'),    -- The Great Gatsby borrowed by Charlie White
(1, 2, '2024-01-05', '2024-01-20', '2024-01-18');    -- 1984 borrowed earlier by John Doe

-- Additional Inserts for Query Outputs:

-- Query 6: Members who have borrowed "SQL for Beginners"
-- Book "SQL for Beginners" has BookID = 7.
INSERT INTO MemberBook (MemberID, BookID, BorrowingDate, DueDate, ReturnDate) VALUES
(1, 7, '2025-03-05', '2025-03-20', '2025-03-20');

-- Query 7: Members who have borrowed and returned "C# Programming"
-- Book "C# Programming" has BookID = 8.
INSERT INTO MemberBook (MemberID, BookID, BorrowingDate, DueDate, ReturnDate) VALUES
(2, 8, '2025-03-10', '2025-03-25', '2025-03-24');

-- Query 8: Members with a late return
-- First, insert a new member "Omar" (this will be MemberID = 6).
INSERT INTO Members (Name, ContactInfo, MembershipType, RegistrationDate, Email) 
VALUES ('Omar', '9876543210', 'Student', '2024-06-05', 'Omar@gmail.com');
-- Then, insert a borrowing record with a late return for Omar.
INSERT INTO MemberBook (MemberID, BookID, BorrowingDate, DueDate, ReturnDate) VALUES
(6, 1, '2025-03-01', '2025-03-10', '2025-03-15');  -- Returned 5 days late

-- Query 9: Books borrowed more than 3 times.
-- We'll use "To Kill a Mockingbird" (BookID = 1). One record exists already; add three more.
INSERT INTO MemberBook (MemberID, BookID, BorrowingDate, DueDate, ReturnDate) VALUES
(2, 1, '2025-03-15', '2025-03-30', '2025-03-28'),
(3, 1, '2025-03-20', '2025-04-04', '2025-04-05'),
(4, 1, '2025-03-25', '2025-04-09', '2025-04-09');

-- Query 13: Members who have borrowed a book in the "Science Fiction" category.
-- Book "Galactic Odyssey" (BookID = 9) is in the "Science Fiction" category.
INSERT INTO MemberBook (MemberID, BookID, BorrowingDate, DueDate, ReturnDate) VALUES
(5, 9, '2025-03-30', '2025-04-15', '2025-04-10');

-- Insert Data into LibraryStaff
INSERT INTO LibraryStaff (Name, ContactInfo, AssignedSection, EmploymentDate) VALUES
('Emily Green', '6789012345', 'Fiction', '2020-05-01'),
('Michael Black', '7890123456', 'Non-Fiction', '2019-03-15'),
('Sarah Blue', '8901234567', 'Science Fiction', '2021-07-20'),
('David Gray', '9012345678', 'Reference', '2018-11-30'),
('Linda Red', '0123456789', 'Children', '2022-01-10');

-- Insert Data into Categories
INSERT INTO Categories (Name, Description) VALUES
('Fiction', 'Fictional works.'),
('Dystopian', 'Dystopian novels.'),
('Adventure', 'Adventure and exploration stories.'),
('Romance', 'Romantic stories.'),
('Science Fiction', 'Science fiction works.');

-- Insert Data into Reservations
INSERT INTO Reservations (MemberID, BookID, ReservationDate, Status) VALUES
(1, 2, '2025-02-10', 'Pending'),
(2, 3, '2025-02-11', 'Completed'),
(3, 4, '2025-02-12', 'Cancelled'),
(4, 5, '2025-02-13', 'Pending'),
(5, 6, '2025-02-14', 'Pending');  -- BookID 6 corresponds to "Database Fundamentals"

-- Insert Data into FinancialFines
INSERT INTO FinancialFines (MemberID, Amount, PaymentStatus) VALUES
(1, 5.00, 'Unpaid'),
(2, 3.50, 'Paid'),
(3, 7.25, 'Unpaid'),
(4, 2.00, 'Paid'),
(5, 6.00, 'Unpaid');

-- Queries

-- 1. Select members who registered on 1-1-2025
SELECT * FROM Members WHERE RegistrationDate = '2025-01-01';

-- 2. Select details of a book by title "Database Fundamentals"
SELECT * FROM Books WHERE Title = 'Database Fundamentals';

-- 3. (Optional) If the Email column were missing, you could add it with:
-- ALTER TABLE Members ADD Email VARCHAR(255);

-- 4. Insert a new member record 
-- (Note: "Omar" is already inserted above for Query 8)

-- 5. Select members who have reservations in the system
SELECT DISTINCT Members.*
FROM Members
JOIN Reservations ON Members.ID = Reservations.MemberID;

-- 6. Select members who have borrowed "SQL for Beginners"
SELECT DISTINCT Members.*
FROM Members
JOIN MemberBook ON Members.ID = MemberBook.MemberID
JOIN Books ON MemberBook.BookID = Books.ID
WHERE Books.Title = 'SQL for Beginners';

-- 7. Select members who have borrowed and returned "C# Programming"
SELECT DISTINCT Members.*
FROM Members
JOIN MemberBook ON Members.ID = MemberBook.MemberID
JOIN Books ON MemberBook.BookID = Books.ID
WHERE Books.Title = 'C# Programming' AND MemberBook.ReturnDate IS NOT NULL;

-- 8. Find members who made a late return
SELECT DISTINCT Members.*
FROM Members
JOIN MemberBook ON Members.ID = MemberBook.MemberID
WHERE MemberBook.ReturnDate > MemberBook.DueDate;

-- 9. Select books borrowed more than 3 times
SELECT Books.Title, COUNT(MemberBook.BookID) AS BorrowCount
FROM MemberBook
JOIN Books ON MemberBook.BookID = Books.ID
GROUP BY Books.Title
HAVING COUNT(MemberBook.BookID) > 3;

-- 10. Find members who have borrowed books between January 1, 2024, and January 10, 2024
SELECT DISTINCT Members.*
FROM Members
JOIN MemberBook ON Members.ID = MemberBook.MemberID
WHERE MemberBook.BorrowingDate BETWEEN '2024-01-01' AND '2024-01-10';

-- 11. Count the total number of books in the library
SELECT COUNT(*) AS TotalBooks FROM Books;

-- 12. Find members who have borrowed books but not returned them
SELECT DISTINCT Members.*
FROM Members
JOIN MemberBook ON Members.ID = MemberBook.MemberID
WHERE MemberBook.ReturnDate IS NULL;

-- 13. Find members who have borrowed books in the "Science Fiction" category
SELECT DISTINCT Members.*
FROM Members
JOIN MemberBook ON Members.ID = MemberBook.MemberID
JOIN Books ON MemberBook.BookID = Books.ID
JOIN Categories ON Books.Genre = Categories.Name
WHERE Categories.Name = 'Science Fiction';
