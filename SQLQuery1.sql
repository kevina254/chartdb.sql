
-- 1. Car Table
CREATE TABLE Car (
  CarID INT IDENTITY(1,1) PRIMARY KEY,
  CarModel VARCHAR(100) NOT NULL,
  Manufacturer VARCHAR(100) NOT NULL,
  Year INT CHECK (Year BETWEEN 1980 AND 2100),
  Color VARCHAR(50),
  RentalRate DECIMAL(10,2) NOT NULL CHECK (RentalRate >= 0),
  Availability BIT NOT NULL DEFAULT 1
);

INSERT INTO Car (CarModel, Manufacturer, Year, Color, RentalRate, Availability) VALUES
('Corolla', 'Toyota', 2018, 'White', 45.00, 1),
('Civic', 'Honda', 2019, 'Black', 50.00, 1),
('RAV4', 'Toyota', 2021, 'Red', 70.00, 1),
('Model 3', 'Tesla', 2022, 'Blue', 120.00, 1),
('Safari', 'Land Rover', 2016, 'Green', 90.00, 1);

SELECT * FROM Car;

-- 2. Customer Table
CREATE TABLE Customer (
  CustomerID INT IDENTITY(1,1) PRIMARY KEY,
  FirstName VARCHAR(80) NOT NULL,
  LastName VARCHAR(80) NOT NULL,
  Email VARCHAR(150) UNIQUE,
  PhoneNumber VARCHAR(30),
  Address VARCHAR(255)
);

INSERT INTO Customer (FirstName, LastName, Email, PhoneNumber, Address) VALUES
('Alice', 'Wanjiku', 'alice.w@example.com', '+254700111222', 'Nairobi, Kenya'),
('Brian', 'Kipkoech', 'brian.k@example.com', '+254700333444', 'Nakuru, Kenya'),
('Catherine', 'Njeri', 'catherine.n@example.com', '+254700555666', 'Eldoret, Kenya'),
('David', 'Otieno', 'david.o@example.com', '+254700777888', 'Mombasa, Kenya'),
('Edith', 'kimathi', 'edith.k@example.com', '+254700999000', 'Kisumu, Kenya');

SELECT * FROM Customer;


-- 3. Booking Table
CREATE TABLE Booking (
  BookingID INT IDENTITY(1,1) PRIMARY KEY,
  CarID INT NOT NULL,
  CustomerID INT NOT NULL,
  RentalStartDate DATE NOT NULL,
  RentalEndDate DATE NOT NULL,
  TotalAmount DECIMAL(12,2) NOT NULL CHECK (TotalAmount >= 0),
  CONSTRAINT Booking_Car FOREIGN KEY (CarID) REFERENCES Car(CarID),
   CONSTRAINT Booking_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

INSERT INTO Booking (CarID, CustomerID, RentalStartDate, RentalEndDate, TotalAmount) VALUES
(1, 1, '2025-09-20', '2025-09-25', 225.00),
(2, 2, '2025-09-28', '2025-10-02', 250.00),
(3, 3, '2025-10-01', '2025-10-05', 350.00),
(4, 4, '2025-10-10', '2025-10-12', 360.00),
(5, 5, '2025-11-01', '2025-11-07', 630.00);

SELECT * FROM Booking;


-- 4. Payment Table
CREATE TABLE Payment (
  PaymentID INT IDENTITY(1,1) PRIMARY KEY,
  BookingID INT NOT NULL,
  PaymentDate DATE NOT NULL,
  Amount DECIMAL(12,2) NOT NULL CHECK (Amount >= 0),
  PaymentMethod VARCHAR(50) NOT NULL,
  CONSTRAINT Payment_Booking FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Payment (BookingID, PaymentDate, Amount, PaymentMethod) VALUES
(1, '2025-09-19', 100.00, 'Mpesa'),
(1, '2025-09-20', 125.00, 'Card'),
(2, '2025-09-27', 250.00, 'Mpesa'),
(3, '2025-09-30', 350.00, 'Card'),
(4, '2025-10-09', 360.00, 'Bank Transfer');

SELECT * FROM Payment;


-- 5. Insurance Table
CREATE TABLE Insurance (
  InsuranceID INT IDENTITY(1,1) PRIMARY KEY,
  CarID INT NOT NULL,
  InsuranceProvider VARCHAR(150) NOT NULL,
  PolicyNumber VARCHAR(100) NOT NULL UNIQUE,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  CONSTRAINT FK_Insurance_Car FOREIGN KEY (CarID) REFERENCES Car(CarID) ON 
  DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Insurance (CarID, InsuranceProvider, PolicyNumber, StartDate, EndDate) VALUES
(1, 'Jubilee Insurance', 'JUB-1001-2025', '2025-01-01', '2025-12-31'),
(2, 'APA Insurance', 'APA-2002-2025', '2025-03-01', '2026-02-28'),
(3, 'UAP Insurance', 'UAP-3003-2025', '2025-06-01', '2026-05-31'),
(4, 'Britam', 'BRIT-4004-2025', '2025-02-01', '2026-01-31'),
(5, 'Jubilee Insurance', 'JUB-5005-2025', '2025-07-01', '2026-06-30');

SELECT * FROM Insurance;

-- 6. Location Table
CREATE TABLE Location (
  LocationID INT IDENTITY(1,1) PRIMARY KEY,
  CarID INT NOT NULL,
  LocationName VARCHAR(150) NOT NULL,
  Address VARCHAR(255),
  ContactNumber VARCHAR(30),
  RecordedAt DATETIME NOT NULL DEFAULT GETDATE(),
  CONSTRAINT Location_Car FOREIGN KEY (CarID) REFERENCES Car(CarID) 
);

INSERT INTO Location (CarID, LocationName, Address, ContactNumber) VALUES
(1, 'Nairobi Central Depot', 'Kimathi St, Nairobi', '+254700111000'),
(2, 'Nakuru Branch', 'Nakuru Town Rd, Nakuru', '+254700222000'),
(3, 'Eldoret Office', 'Moi Ave, Eldoret', '+254700333000'),
(4, 'Mombasa Outlet', 'Moi Ave, Mombasa', '+254700444000'),
(5, 'Kisumu Station', 'Jomo Kenyatta Rd, Kisumu', '+254700555000');

SELECT * FROM Location;


-- 7. Reservation Table
CREATE TABLE Reservation (
  ReservationID INT IDENTITY(1,1) PRIMARY KEY,
  CarID INT NOT NULL,
  CustomerID INT NOT NULL,
  ReservationDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
  PickupDate DATE NOT NULL,
  ReturnDate DATE NOT NULL,
  CONSTRAINT Reservation_Car FOREIGN KEY (CarID) REFERENCES Car(CarID),
  CONSTRAINT Reservation_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

INSERT INTO Reservation (CarID, CustomerID, ReservationDate, PickupDate, ReturnDate)
VALUES
(1, 2, '2025-09-15', '2025-09-20', '2025-09-25'),
(2, 3, '2025-09-20', '2025-09-28', '2025-10-02'),
(3, 1, '2025-09-25', '2025-10-01', '2025-10-05'),
(4, 5, '2025-09-30', '2025-10-10', '2025-10-12'),
(5, 4, '2025-10-05', '2025-11-01', '2025-11-07');

SELECT * FROM Reservation;


-- 8. Maintenance Table
CREATE TABLE Maintenance (
  MaintenanceID INT IDENTITY(1,1) PRIMARY KEY,
  CarID INT NOT NULL,
  MaintenanceDate DATE NOT NULL,
  Description VARCHAR(500),
  Cost DECIMAL(12,2) CHECK (Cost >= 0),
  CONSTRAINT Maintenance_Car FOREIGN KEY (CarID) REFERENCES Car(CarID)
);

INSERT INTO Maintenance (CarID, MaintenanceDate, Description, Cost) VALUES
(1, '2025-08-10', 'Oil change and filter replacement', 35.00),
(2, '2025-06-15', 'Brake pad replacement', 120.00),
(3, '2025-07-20', 'Tire rotation and balancing', 60.00),
(4, '2025-05-05', 'Battery replacement', 250.00),
(5, '2025-09-01', 'Engine tune-up', 180.00);

SELECT * FROM Maintenance;

-- List all bookings with customer and car details
SELECT b.BookingID, c.FirstName + ' ' + c.LastName AS CustomerName, ca.CarModel, b.RentalStartDate, b.RentalEndDate, b.TotalAmount
FROM Booking b
JOIN Customer c ON b.CustomerID = c.CustomerID
JOIN Car ca ON b.CarID = ca.CarID
ORDER BY b.RentalStartDate DESC;

-- Payment Summary per booking
SELECT b.BookingID, SUM(p.Amount) AS TotalPaid, b.TotalAmount,
CASE WHEN SUM(p.Amount) >= b.TotalAmount THEN 'PAID' ELSE 'PENDING' END AS PaymentStatus
FROM Booking b
LEFT JOIN Payment p ON b.BookingID = p.BookingID
GROUP BY b.BookingID, b.TotalAmount;

-- Cars currently available for rent
SELECT * FROM Car WHERE Availability = 1;

-- Bookings with total above 300
SELECT * FROM Booking WHERE TotalAmount > 300;

-- Mark car unavailable when booked
UPDATE Car SET Availability = 0 WHERE CarID = 1;

-- Increase rental rate for Toyota cars
UPDATE Car SET RentalRate = RentalRate * 1.1 WHERE Manufacturer = 'Toyota';

-- Extend a reservation return date
UPDATE Reservation SET ReturnDate = DATEADD(DAY, 2, ReturnDate) WHERE ReservationID = 2;

-- =========================
-- Example DELETE Queries
-- =========================
-- Delete a cancelled reservation
DELETE FROM Reservation WHERE ReservationID = 5;

-- Delete maintenance record
DELETE FROM Maintenance WHERE MaintenanceID = 3;

-- Safe delete booking (will cascade delete payments)
DELETE FROM Booking WHERE BookingID = 4;

-- Safe delete car (check if it has bookings)
IF NOT EXISTS (SELECT 1 FROM Booking WHERE CarID = 2)
BEGIN
  DELETE FROM Car WHERE CarID = 2;
END
ELSE
BEGIN
  PRINT 'Car has bookings and cannot be deleted directly.';
END

CREATE INDEX IX_Booking_CustomerID ON Booking(CustomerID);
CREATE INDEX IX_Reservation_PickupDate ON Reservation(PickupDate);

-- End of File
