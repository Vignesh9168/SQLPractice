CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    Balance DECIMAL(10, 2) NOT NULL,
    LastTransactionDate DATE NOT NULL
);

INSERT INTO Accounts (AccountID, CustomerID, Balance, LastTransactionDate) VALUES
(1, 101, 500.00, '2024-11-20'),
(2, 102, 1500.00, '2024-11-21'),
(3, 103, 200.00, '2024-11-19'),
(4, 104, 2500.00, '2024-11-18'),
(5, 105, 1000.00, '2024-11-22'),
(6, 106, 300.00, '2024-11-17'),
(7, 107, 4000.00, '2024-11-16'),
(8, 108, 750.00, '2022-11-15'),
(9, 109, 1200.00, '2023-11-14'),
(10, 110,650.00,'2022-11-13')


DROP TABLE Accounts

---1.. You have a table Accounts with columns AccountID, CustomerID, Balance, and LastTransactionDate. 
---Write a query to identify accounts that have been inactive for more than 12 months.*------


select * from Accounts WHERE DATEDIFF(day,LastTransactionDate,CURRENT_TIMESTAMP) > 365

---2.Given a table Transactions with columns TransactionID, AccountID, Amount, and TransactionDate, 
--find the top 3 accounts with the highest total transaction volume for each month.--


CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    TransactionDate DATE NOT NULL,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

INSERT INTO Transactions (TransactionID, AccountID, Amount, TransactionDate) VALUES
(1, 1, 100.00, '2024-01-10'),
(2, 1, 150.00, '2024-02-15'),
(3, 2, 200.00, '2024-03-20'),
(4, 2, 250.00, '2024-04-25'),
(5, 3, 300.00, '2024-03-30'),
(6, 3, 350.00, '2024-06-05'),
(7, 4, 400.00, '2024-03-10'),
(8, 4, 450.00, '2024-08-15'),
(9, 5, 500.00, '2024-05-20'),
(10, 5, 550.00, '2024-05-25');


with RankedTransats as (
      SELECT AccountID, 
       SUM(Amount) as TotalAmount, 
       MONTH(TransactionDate) as Month,
       DENSE_RANK() OVER (PARTITION BY MONTH(TransactionDate) ORDER BY SUM(Amount) DESC) as Rank
FROM Transactions
GROUP BY AccountID, MONTH(TransactionDate)
)

select AccountID, TotalAmount, Month ,Rank
from RankedTransats
WHERE  Rank <=3 
order by Month, Rank

--3.A table LoanApplications contains columns ApplicationID, CustomerID, LoanAmount, ApprovalStatus, and ApplicationDate.
---Write a query to calculate the average loan amount for approved applications submitted in the last six months

CREATE TABLE LoanApplications (
    ApplicationID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    LoanAmount DECIMAL(10, 2) NOT NULL,
    ApprovalStatus VARCHAR(20) NOT NULL,
    ApplicationDate DATE NOT NULL
);

INSERT INTO LoanApplications (ApplicationID, CustomerID, LoanAmount, ApprovalStatus, ApplicationDate) VALUES
(1, 101, 10000.00, 'Approved', '2024-05-20'),
(2, 102, 15000.00, 'Rejected', '2024-06-25'),
(3, 103, 12000.00, 'Approved', '2024-07-15'),
(4, 104, 20000.00, 'Approved', '2024-08-10'),
(5, 105, 17000.00, 'Pending', '2024-09-05'),
(6, 106, 13000.00, 'Approved', '2024-10-01'),
(7, 107, 14000.00, 'Rejected', '2024-10-20'),
(8, 108, 25000.00, 'Approved', '2024-11-11'),
(9, 109, 30000.00, 'Approved', '2024-11-12'),
(10, 110, 22000.00, 'Pending', '2024-11-14');

--q. Write a query to calculate the average loan amount for approved applications submitted in the last six months

select avg(LoanAmount) as Average_loan_amount from LoanApplications where (ApprovalStatus Like  'Approved') and  
DATEDIFF(month, ApplicationDate, CURRENT_TIMESTAMP) <= 6
