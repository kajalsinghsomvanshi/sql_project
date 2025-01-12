drop database if exists Library_Management;
create database  Library_Management;
use Library_Management;
##Manages book records.
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    publisher VARCHAR(255),
    year YEAR,
    quantity INT NOT NULL
);
## Stores information about library members.
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT
);
##Tracks book borrowing details.
CREATE TABLE Borrowing (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
## insert data 
INSERT INTO Books (title, author, publisher, year, quantity)
VALUES 
('The Alchemist', 'Paulo Coelho', 'HarperOne', 1988, 5),
('Harry Potter', 'J.K. Rowling', 'Bloomsbury', 1997, 10),
('To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott & Co.', 1960, 7);
INSERT INTO Members (name, email, phone, address)
VALUES 
('Kajal Singh', 'kajal@example.com', '1234567890', 'Delhi, India'),
('Amit Sharma', 'amit@example.com', '9876543210', 'Mumbai, India');
INSERT INTO Borrowing (member_id, book_id, borrow_date, due_date)
VALUES 
(1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY)),
(2, 2, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY));
## view all books
SELECT * FROM Books;

##Search for Books by Title
SELECT * FROM Books WHERE title LIKE '%Harry%';

##List Members with Borrowed Books
SELECT m.name, b.title, br.borrow_date, br.due_date
FROM Borrowing br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id;

##Overdue Books
SELECT m.name, b.title, br.due_date
FROM Borrowing br
JOIN Members m ON br.member_id = m.member_id
JOIN Books b ON br.book_id = b.book_id
WHERE br.due_date < CURDATE() AND br.return_date IS NULL;

##Trigger: Automatically update book quantity on borrow.
DELIMITER $$

CREATE TRIGGER AfterBookBorrow
AFTER INSERT ON Borrowing
FOR EACH ROW
BEGIN
    UPDATE Books 
    SET quantity = quantity - 1 
    WHERE book_id = NEW.book_id;
END$$

DELIMITER ;

##Stored Procedure: Return books.
DELIMITER $$

CREATE PROCEDURE ReturnBook(IN borrowID INT)
BEGIN
    UPDATE Borrowing
    SET return_date = CURDATE()
    WHERE borrow_id = borrowID;

    UPDATE Books
    SET quantity = quantity + 1
    WHERE book_id = (SELECT book_id FROM Borrowing WHERE borrow_id = borrowID);
END$$

DELIMITER ;






