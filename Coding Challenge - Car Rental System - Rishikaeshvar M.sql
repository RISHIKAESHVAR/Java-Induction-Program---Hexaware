use car_rental_system;

/* -------------------------------------------   */

create table vehicle(vechicleID int primary key, make varchar(255), model varchar(255), year int,
Dailyrate decimal, status bit, passengercapacity int, enginecapacity int);

create table customer(customerid  int primary key, firstname varchar(255), lastname varchar(255), 
email varchar(255), phonenumber varchar(255));

create table lease (leaseid int primary key,vehicleID int,customerid int, foreign key (vehicleID) references vehicle(vechicleID), 
foreign key (customerid) references customer(customerid),startdate date, enddate date, leasetype varchar(255));

create table payment(paymentid int primary key, leaseid int, paymentdate date, amount decimal, 
foreign key (leaseid) references lease(leaseid));

/* -------------------------------------------   */

insert into vehicle values 
(1,'Toyato','Camry',2022,50.00,1,4,1450),
(2,'Honda','Civic',2023,45.00,1,7,1500),
(3,'Ford','Focus',2022,48.00,0,4,1400),
(4,'Nissan','Altima',2023,52.00,1,7,1200),
(5,'Chevrolet','Malibu',2022,47.00,1,4,1800),
(6,'Hyundai','Sonata',2023,49.00,0,7,1400),
(7,'BMW','3 Series',2023,60.00,1,7,2499), 
(8,'Mercedes','C-Class',2022,58.00,1,8,2599),
(9,'Audi','A4',2022,55.00,0,4,2500),
(10,'Lexus','ES',2023,54.00,1,4,2500);

insert into customer values
(1,'John','Doe','johndoe@example.com','555-555-5555'),
(2,'Jane','Smith','janesmith@example.com','555-123-4567'),
(3,'Robert','Johnson','robert@example.com','555-789-1234'),
(4,'Sarah','Brown','sarahe@example.com','555-456-7890'),
(5,'David','Lee','david@example.com','555-987-6543'),
(6,'Laura','Hall','laura@example.com','555-234-5678'),
(7,'Michael','Davis','michael@example.com','555-876-5432'),
(8,'Emma','Wilson','emma@example.com','555-432-1098'),
(9,'William','Taylor','william@example.com','555-321-6547'),
(10,'Olivia','Adams','olivia@example.com','555-765-4321');

insert into lease values
(1,1,1,'2023-01-01','2023-01-05','Daily'),
(2,2,2,'2023-02-15','2023-02-28','Monthly'),
(3,3,3,'2023-03-10','2023-03-15','Daily'),
(4,4,4,'2023-04-20','2023-04-30','Monthly'),
(5,5,5,'2023-05-05','2023-05-10','Daily'),
(6,4,3,'2023-06-15','2023-06-30','Monthly'),
(7,7,7,'2023-07-01','2023-07-10','Daily'),
(8,8,8,'2023-08-12','2023-08-15','Monthly'),
(9,3,3,'2023-09-07','2023-09-10','Daily'),
(10,10,10,'2023-10-10','2023-10-31','Monthly');

insert into payment values
(1,1,'2023-01-03',200.00),
(2,2,'2023-02-20',1000.00),
(3,3,'2023-03-12',75.00),
(4,4,'2023-04-25',900.00),
(5,5,'2023-05-07',60.00),
(6,6,'2023-06-18',1200.00),
(7,7,'2023-07-03',40.00),
(8,8,'2023-08-14',1100.00),
(9,9,'2023-09-09',80.00),
(10,10,'2023-10-25',1500.00);

/* -------------------------------------------   */

select * from vehicle;

select * from customer;

select * from lease;

select * from payment;

/* -------------------------------------------   */

/*1. Update the daily rate for a Mercedes car to 68.*/

update vehicle set Dailyrate = 68.00 where make = 'Mercedes';

/*    Query ran in command prompt  
0	35	14:59:03	UPDATE vehicle SET Dailyrate = 68.00 WHERE make = 'Mercedes'	Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column. 
 To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.	0.000 sec
					getting this error in work bench but got ran in command prompt
 */

/*2. Delete a specific customer and all associated leases and payments. */

DELETE FROM Payment
WHERE leaseID IN (SELECT leaseID FROM Lease WHERE customerID = 1);

select * from payment;

DELETE FROM Lease
WHERE customerID = 'specific_customer_id';

select * from lease;

DELETE FROM Customer
WHERE customerID = 1;

select * from customer;

/* -------------------------------------------   */

insert into customer values
(1,'John','Doe','johndoe@example.com','555-555-5555');

insert into lease values
(1,1,1,'2023-01-01','2023-01-05','Daily');

insert into payment values
(1,1,'2023-01-03',200.00);

/* ----------------------------------------------- */


/*3. Rename the "paymentDate" column in the Payment table to "transactionDate".*/

alter table Payment rename column paymentDate to transactionDate;

select * from payment;

/*4. Find a specific customer by email.*/

select * from Customer where email = 'johndoe@example.com';

/*5. Get active leases for a specific customer. */

select Lease.*, Vehicle.make, Vehicle.model from Lease join Vehicle on Lease.vehicleID = Vehicle.vehicleID
where Lease.customerID = 3 and Lease.endDate >= CURDATE();


/*6. Find all payments made by a customer with a specific phone number.*/

select Payment.* from Payment join Lease on Payment.leaseID = Lease.leaseID
join Customer on Lease.customerID = Customer.customerID WHERE Customer.phoneNumber = '555-987-6543';

/*7. Calculate the average daily rate of all available cars.*/

select avg(dailyRate) as average_daily_rate from Vehicle where status = 'available';

/*8. Find the car with the highest daily rate.*/

select * from Vehicle order by dailyRate desc limit 1;

/*9. Retrieve all cars leased by a specific customer. */

select vehicle.* from vehicle
join Lease on vehicle.vehicleID = Lease.vehicleID where Lease.customerID = '2';

/*10. Find the details of the most recent lease.*/

SELECT Lease.*, Vehicle.make, Vehicle.model FROM Lease
JOIN Vehicle ON Lease.vehicleID = Vehicle.vehicleID ORDER BY Lease.startDate DESC LIMIT 1;

/*11. List all payments made in the year 2023.*/

select * from Payment where year(transactionDate) = 2023;

/*12. Retrieve customers who have not made any payments. */

select Customer.* from Customer left join Payment on Customer.customerID = Payment.leaseid WHERE Payment.leaseID is null;

/*13. Retrieve Car Details and Their Total Payments.*/

select Vehicle.vehicleID,Vehicle.make,Vehicle.model,SUM(Payment.amount) as total_payments
from Vehicle join Lease on Vehicle.vehicleID = Lease.vehicleID
join Payment on Lease.leaseID = Payment.leaseID
group by Vehicle.vehicleID, Vehicle.make, Vehicle.model;

/*14. Calculate Total Payments for Each Customer.*/

select Customer.customerID,Customer.firstName,Customer.lastName,SUM(Payment.amount) AS total_payments
from Customer
join Lease on Customer.customerID = Lease.customerID
join Payment on Lease.leaseID = Payment.leaseID
group by Customer.customerID;

/*15. List Car Details for Each Lease.*/

select Lease.*, Vehicle.make, Vehicle.model from Lease join Vehicle on Lease.vehicleID = Vehicle.vehicleID;
    
/*16. Retrieve Details of Active Leases with Customer and Car Information.*/

select Lease.*,Customer.firstName,Customer.lastName,Vehicle.make,Vehicle.model
from Lease
join Customer on Lease.customerID = Customer.customerID
join Vehicle on Lease.vehicleID = Vehicle.vehicleID
where Lease.endDate >= curdate();

/*17. Find the Customer Who Has Spent the Most on Leases.*/

select Customer.customerID,Customer.firstName,Customer.lastName,SUM(Payment.amount) AS total_spent
from Customer
join Lease on Customer.customerID = Lease.customerID
join Payment on Lease.leaseID = Payment.leaseID
group by Customer.customerID
order by total_spent desc limit 1;

/*18. List All Cars with Their Current Lease Information.*/

select vehicle.vehicleid,Vehicle.make,vehicle.model,Lease.startDate as leaseStartDate,Lease.endDate 
as leaseEndDate,Lease.customerID as leaseCustomerID from Vehicle
left join Lease on Vehicle.vehicleID = Lease.vehicleID and Lease.endDate >= CURDATE();










