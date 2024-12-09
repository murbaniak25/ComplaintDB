USE [ComplaintsDB];
GO

ALTER DATABASE [ComplaintsDB] SET RECOVERY FULL;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- ========================================
-- 1. Tabele
-- ========================================
CREATE TABLE [dbo].[PostalCodes](
    [PostalCodeID] INT NOT NULL,
    [PostalCode] NVARCHAR(10) NOT NULL,
    [City] NVARCHAR(50) NOT NULL,
    CONSTRAINT [PK_PostalCodes] PRIMARY KEY CLUSTERED ([PostalCodeID] ASC)
);
GO

CREATE TABLE [dbo].[Addresses](
    [AddressID] INT NOT NULL,
    [Street] NVARCHAR(50) NOT NULL,
    [HouseNumber] NVARCHAR(10) NOT NULL,
    [PostalCodeID] INT NOT NULL,
    CONSTRAINT [PK_Addresses] PRIMARY KEY CLUSTERED ([AddressID] ASC)
);
GO

CREATE TABLE [dbo].[Suppliers](
    [SupplierID] INT NOT NULL,
    [SupplierName] NVARCHAR(50) NULL,
    [AddressID] INT NOT NULL,
    [PhoneNumber] NVARCHAR(10) NULL,
    CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED ([SupplierID] ASC)
);
GO

CREATE TABLE [dbo].[ResolutionTypes](
    [ResolutionTypeID] INT NOT NULL,
    [ResolutionType] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_ResolutionTypes] PRIMARY KEY CLUSTERED ([ResolutionTypeID] ASC)
);
GO

CREATE TABLE [dbo].[ShippingOptions](
    [ShippingMethodID] INT NOT NULL,
    [ShippingMethodName] NVARCHAR(50) NULL,
    [ShippingMethodDescription] NVARCHAR(255) NULL,
    CONSTRAINT [PK_ShippingOptions] PRIMARY KEY CLUSTERED ([ShippingMethodID] ASC)
);
GO

CREATE TABLE [dbo].[PaymentMethods](
    [PaymentMethodID] INT NOT NULL,
    [PaymentMethodName] NVARCHAR(50) NULL,
    [PaymentMethodDescription] NVARCHAR(255) NULL,
    CONSTRAINT [PK_PaymentMethods] PRIMARY KEY CLUSTERED ([PaymentMethodID] ASC)
);
GO
CREATE TABLE [dbo].[ResolutionTypeOptions](
    [ResolutionTypeID] INT NOT NULL,
    [PaymentMethodID] INT NOT NULL,
    [ShippingMethodID] INT NOT NULL
);
GO

CREATE TABLE [dbo].[Status](
    [StatusID] INT NOT NULL,
    [StatusName] NVARCHAR(50) NOT NULL,
    CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED ([StatusID] ASC)
);
GO

CREATE TABLE [dbo].[Customers](
    [CustomerID] INT NOT NULL,
    [CustomerName] NVARCHAR(50) NOT NULL,
    [Contact] NVARCHAR(50) NOT NULL,
    [AddressID] INT NOT NULL,
    CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerID] ASC)
);
GO

CREATE TABLE [dbo].[Employees](
    [EmployeeID] INT NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [FirstName] NVARCHAR(50) NOT NULL,
    [Email] NVARCHAR(100) NULL,
    [PhoneNumber] NVARCHAR(50) NULL,
    [HireDate] DATE NOT NULL,
    [AddressID] INT NOT NULL,
    [Salary] MONEY NOT NULL,
    CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED ([EmployeeID] ASC)
);
GO

CREATE TABLE [dbo].[Products](
    [ProductID] INT NOT NULL,
    [SupplierID] INT NULL,
    [ProductName] NVARCHAR(50) NULL,
    [Unit] NVARCHAR(50) NULL,
    [Price] MONEY NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductID] ASC)
);
GO

CREATE TABLE [dbo].[Complaints](
    [ComplaintID] INT NOT NULL,
    [StatusID] INT NOT NULL,
    [CustomerID] INT NOT NULL,
    [EmployeeID] INT NOT NULL,
    [ProductID] INT NOT NULL,
    [ResolutionTypeID] INT NOT NULL,
    [ComplaintTypeID] INT NOT NULL,
    CONSTRAINT [PK_Complaints] PRIMARY KEY CLUSTERED ([ComplaintID] ASC)
);
GO

CREATE TABLE [dbo].[ComplaintDetails](
    [ComplaintID] INT NOT NULL,
    [Description] NVARCHAR(500) NULL,
    [ComplaintDate] DATE NOT NULL,
    [ResolutionDate] DATE NULL,
    CONSTRAINT [PK_ComplaintDetails] PRIMARY KEY CLUSTERED ([ComplaintID] ASC)
);
GO

-- ========================================
-- 2. Klucze obce 
-- ========================================

ALTER TABLE [dbo].[Addresses] WITH CHECK ADD CONSTRAINT [FK_Addresses_PostalCodes] FOREIGN KEY([PostalCodeID])
REFERENCES [dbo].[PostalCodes]([PostalCodeID]);
ALTER TABLE [dbo].[Addresses] CHECK CONSTRAINT [FK_Addresses_PostalCodes];

ALTER TABLE [dbo].[ComplaintDetails] WITH CHECK ADD CONSTRAINT [FK_ComplaintDetails_Complaints1] FOREIGN KEY([ComplaintID])
REFERENCES [dbo].[Complaints]([ComplaintID]);
ALTER TABLE [dbo].[ComplaintDetails] CHECK CONSTRAINT [FK_ComplaintDetails_Complaints1];

ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CONSTRAINT [FK_Complaints_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers]([CustomerID]);
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_Customers];

ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CONSTRAINT [FK_Complaints_Employees] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employees]([EmployeeID]);
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_Employees];

ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CONSTRAINT [FK_Complaints_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products]([ProductID]);
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_Products];

ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CONSTRAINT [FK_Complaints_ResolutionTypes] FOREIGN KEY([ResolutionTypeID])
REFERENCES [dbo].[ResolutionTypes]([ResolutionTypeID]);
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_ResolutionTypes];

ALTER TABLE [dbo].[Complaints] WITH CHECK ADD CONSTRAINT [FK_Complaints_Status] FOREIGN KEY([StatusID])
REFERENCES [dbo].[Status]([StatusID]);
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_Status];

ALTER TABLE [dbo].[Customers] WITH CHECK ADD CONSTRAINT [FK_Customers_Addresses] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Addresses]([AddressID]);
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customers_Addresses];

ALTER TABLE [dbo].[Employees] WITH CHECK ADD CONSTRAINT [FK_Employees_Addresses] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Addresses]([AddressID]);
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_Addresses];

ALTER TABLE [dbo].[Products] WITH CHECK ADD CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Suppliers]([SupplierID]);
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Suppliers];

ALTER TABLE [dbo].[ResolutionTypeOptions] WITH CHECK ADD CONSTRAINT [FK_ResolutionTypeOptions_PaymentMethods] FOREIGN KEY([PaymentMethodID])
REFERENCES [dbo].[PaymentMethods]([PaymentMethodID]);
ALTER TABLE [dbo].[ResolutionTypeOptions] CHECK CONSTRAINT [FK_ResolutionTypeOptions_PaymentMethods];

ALTER TABLE [dbo].[ResolutionTypeOptions] WITH CHECK ADD CONSTRAINT [FK_ResolutionTypeOptions_ResolutionTypes] FOREIGN KEY([ResolutionTypeID])
REFERENCES [dbo].[ResolutionTypes]([ResolutionTypeID]);
ALTER TABLE [dbo].[ResolutionTypeOptions] CHECK CONSTRAINT [FK_ResolutionTypeOptions_ResolutionTypes];

ALTER TABLE [dbo].[ResolutionTypeOptions] WITH CHECK ADD CONSTRAINT [FK_ResolutionTypeOptions_ShippingOptions] FOREIGN KEY([ShippingMethodID])
REFERENCES [dbo].[ShippingOptions]([ShippingMethodID]);
ALTER TABLE [dbo].[ResolutionTypeOptions] CHECK CONSTRAINT [FK_ResolutionTypeOptions_ShippingOptions];

ALTER TABLE [dbo].[Suppliers] WITH CHECK ADD CONSTRAINT [FK_Suppliers_Addresses] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Addresses]([AddressID]);
ALTER TABLE [dbo].[Suppliers] CHECK CONSTRAINT [FK_Suppliers_Addresses];

-- ========================================
-- 3. Sekwencje do ID's 
-- ========================================

CREATE SEQUENCE SEQ_Customers AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_Employees AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_Products AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_Status AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_Complaints AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ComplaintDetails AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_PaymentMethods AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ResolutionTypes AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_Suppliers AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_Addresses AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_PostalCodes AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ShippingOptions AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ResolutionTypeOptions AS INT START WITH 1 INCREMENT BY 1;
GO

-- ========================================
-- 4. Triggery
-- ========================================

CREATE TRIGGER trg_IDUpdate_Customers
ON Customers
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Customers(CustomerID, CustomerName, Contact, AddressID)
    SELECT NEXT VALUE FOR SEQ_Customers, CustomerName, Contact, AddressID
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_Employees
ON Employees
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Employees(EmployeeID, LastName, FirstName, Email, PhoneNumber, HireDate, AddressID, Salary)
    SELECT NEXT VALUE FOR SEQ_Employees, LastName, FirstName, Email, PhoneNumber, HireDate, AddressID, Salary
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_Products
ON Products
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Products(ProductID, SupplierID, ProductName, Unit, Price)
    SELECT NEXT VALUE FOR SEQ_Products, SupplierID, ProductName, Unit, Price
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_Status
ON Status
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Status(StatusID, StatusName)
    SELECT NEXT VALUE FOR SEQ_Status, StatusName
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_Complaints
ON Complaints
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Complaints(ComplaintID, StatusID, CustomerID, EmployeeID, ProductID, ResolutionTypeID, ComplaintTypeID)
    SELECT NEXT VALUE FOR SEQ_Complaints, StatusID, CustomerID, EmployeeID, ProductID, ResolutionTypeID, ComplaintTypeID
    FROM inserted;
END;
GO

CREATE TRIGGER trg_UpdateResolutionDate
ON Complaints
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE cd
    SET ResolutionDate = GETDATE()
    FROM ComplaintDetails cd
    INNER JOIN inserted i ON cd.ComplaintID = i.ComplaintID
    WHERE i.StatusID = 4;
END;
GO

CREATE TRIGGER trg_IDUpdate_ComplaintDetails
ON ComplaintDetails
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO ComplaintDetails(ComplaintID, Description, ComplaintDate, ResolutionDate)
    SELECT NEXT VALUE FOR SEQ_ComplaintDetails, Description, ComplaintDate, ResolutionDate
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_PaymentMethods
ON PaymentMethods
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO PaymentMethods(PaymentMethodID, PaymentMethodName, PaymentMethodDescription)
    SELECT NEXT VALUE FOR SEQ_PaymentMethods, PaymentMethodName, PaymentMethodDescription
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_ResolutionTypes
ON ResolutionTypes
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO ResolutionTypes(ResolutionTypeID, ResolutionType)
    SELECT NEXT VALUE FOR SEQ_ResolutionTypes, ResolutionType
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_Suppliers
ON Suppliers
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Suppliers(SupplierID, SupplierName, AddressID, PhoneNumber)
    SELECT NEXT VALUE FOR SEQ_Suppliers, SupplierName, AddressID, PhoneNumber
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_Addresses
ON Addresses
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Addresses(AddressID, Street, HouseNumber, PostalCodeID)
    SELECT NEXT VALUE FOR SEQ_Addresses, Street, HouseNumber, PostalCodeID
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_PostalCodes
ON PostalCodes
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO PostalCodes(PostalCodeID, PostalCode, City)
    SELECT NEXT VALUE FOR SEQ_PostalCodes, PostalCode, City
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_ShippingOptions
ON ShippingOptions
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO ShippingOptions(ShippingMethodID, ShippingMethodName, ShippingMethodDescription)
    SELECT NEXT VALUE FOR SEQ_ShippingOptions, ShippingMethodName, ShippingMethodDescription
    FROM inserted;
END;
GO

CREATE TRIGGER trg_IDUpdate_ResolutionTypeOptions
ON ResolutionTypeOptions
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO ResolutionTypeOptions(ResolutionTypeID, PaymentMethodID, ShippingMethodID)
    SELECT NEXT VALUE FOR SEQ_ResolutionTypeOptions, PaymentMethodID, ShippingMethodID
    FROM inserted;
END;
GO

-- ========================================
-- 5. Procedury 
-- ========================================

CREATE PROCEDURE usp_InsertCustomer
    @CustomerName VARCHAR(50),
    @Contact VARCHAR(20),
    @AddressID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Customers (CustomerName, Contact, AddressID)
        VALUES (@CustomerName, @Contact, @AddressID);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertEmployee
    @LastName VARCHAR(50),
    @FirstName VARCHAR(50),
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(15),
    @HireDate DATE,
    @AddressID INT,
    @Salary MONEY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Employees (LastName, FirstName, Email, PhoneNumber, HireDate, AddressID, Salary)
        VALUES (@LastName, @FirstName, @Email, @PhoneNumber, @HireDate, @AddressID, @Salary);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertProduct
    @SupplierID INT,
    @ProductName VARCHAR(50),
    @Unit VARCHAR(20),
    @Price MONEY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Products (SupplierID, ProductName, Unit, Price)
        VALUES (@SupplierID, @ProductName, @Unit, @Price);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertStatus
    @StatusName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Status (StatusName)
        VALUES (@StatusName);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertComplaint
    @StatusID INT,
    @CustomerID INT,
    @EmployeeID INT,
    @ProductID INT,
    @ResolutionTypeID INT,
    @ComplaintTypeID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Complaints (StatusID, CustomerID, EmployeeID, ProductID, ResolutionTypeID, ComplaintTypeID)
        VALUES (@StatusID, @CustomerID, @EmployeeID, @ProductID, @ResolutionTypeID, @ComplaintTypeID);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertComplaintDetail
    @ComplaintID INT,
    @Description VARCHAR(500),
    @ComplaintDate DATE,
    @ResolutionDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO ComplaintDetails (ComplaintID, Description, ComplaintDate, ResolutionDate)
        VALUES (@ComplaintID, @Description, @ComplaintDate, @ResolutionDate);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_DeleteComplaint
    @ComplaintID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DELETE FROM ComplaintDetails WHERE ComplaintID = @ComplaintID;
        DELETE FROM Complaints WHERE ComplaintID = @ComplaintID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO


CREATE PROCEDURE usp_InsertPaymentMethod
    @PaymentMethodName VARCHAR(50),
    @PaymentMethodDescription VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO PaymentMethods (PaymentMethodName, PaymentMethodDescription)
        VALUES (@PaymentMethodName, @PaymentMethodDescription);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertAddress
    @Street NVARCHAR(50),
    @HouseNumber NVARCHAR(10),
    @PostalCodeID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Addresses (Street, HouseNumber, PostalCodeID)
        VALUES (@Street, @HouseNumber, @PostalCodeID);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertPostalCode
    @PostalCode NVARCHAR(10),
    @City NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO PostalCodes (PostalCode, City)
        VALUES (@PostalCode, @City);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertSupplier
    @SupplierName NVARCHAR(50),
    @AddressID INT,
    @PhoneNumber NVARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Suppliers (SupplierName, AddressID, PhoneNumber)
        VALUES (@SupplierName, @AddressID, @PhoneNumber);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertResolutionType
    @ResolutionType NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO ResolutionTypes (ResolutionType)
        VALUES (@ResolutionType);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertShippingOption
    @ShippingMethodName NVARCHAR(50),
    @ShippingMethodDescription NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO ShippingOptions (ShippingMethodName, ShippingMethodDescription)
        VALUES (@ShippingMethodName, @ShippingMethodDescription);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_InsertResolutionTypeOption
    @ResolutionTypeID INT,
    @PaymentMethodID INT,
    @ShippingMethodID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO ResolutionTypeOptions (ResolutionTypeID, PaymentMethodID, ShippingMethodID)
        VALUES (@ResolutionTypeID, @PaymentMethodID, @ShippingMethodID);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO

CREATE PROCEDURE usp_UpdateComplaintStatus
    @ComplaintID INT,
    @NewStatusID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE Complaints
        SET StatusID = @NewStatusID
        WHERE ComplaintID = @ComplaintID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage,16,1);
    END CATCH
END;
GO
-- ========================================
-- 6. Dane i rekordy 
-- ========================================

EXEC usp_InsertPostalCode @PostalCode='00-001', @City='Warszawa';
EXEC usp_InsertPostalCode @PostalCode='30-001', @City='Kraków';
EXEC usp_InsertPostalCode @PostalCode='80-001', @City='Gdañsk';
EXEC usp_InsertPostalCode @PostalCode='60-001', @City='Poznañ';
EXEC usp_InsertPostalCode @PostalCode='50-001', @City='Wroc³aw';
EXEC usp_InsertPostalCode @PostalCode='90-001', @City='£ódŸ';
EXEC usp_InsertPostalCode @PostalCode='20-001', @City='Lublin';
EXEC usp_InsertPostalCode @PostalCode='40-001', @City='Katowice';
EXEC usp_InsertPostalCode @PostalCode='70-001', @City='Szczecin';
EXEC usp_InsertPostalCode @PostalCode='85-001', @City='Bydgoszcz';
EXEC usp_InsertPostalCode @PostalCode='15-001', @City='Bia³ystok';
EXEC usp_InsertPostalCode @PostalCode='81-001', @City='Gdynia';
EXEC usp_InsertPostalCode @PostalCode='42-200', @City='Czêstochowa';
EXEC usp_InsertPostalCode @PostalCode='26-600', @City='Radom';
EXEC usp_InsertPostalCode @PostalCode='41-200', @City='Sosnowiec';

EXEC usp_InsertAddress @Street='ul. G³ówna', @HouseNumber='1', @PostalCodeID=1;   -- Jan Kowalski
EXEC usp_InsertAddress @Street='ul. Kwiatowa', @HouseNumber='5', @PostalCodeID=2;  -- Maria Nowak
EXEC usp_InsertAddress @Street='ul. Leœna', @HouseNumber='12', @PostalCodeID=3;    -- Piotr Wiœniewski
EXEC usp_InsertAddress @Street='ul. Polna', @HouseNumber='3', @PostalCodeID=4;     -- Anna Zieliñska
EXEC usp_InsertAddress @Street='ul. S³oneczna', @HouseNumber='7', @PostalCodeID=5; -- Krzysztof Wójcik
EXEC usp_InsertAddress @Street='ul. Krótka', @HouseNumber='9', @PostalCodeID=6;     -- Barbara Kowalczyk
EXEC usp_InsertAddress @Street='ul. D³uga', @HouseNumber='15', @PostalCodeID=7;     -- Tomasz Kamiñski
EXEC usp_InsertAddress @Street='ul. Weso³a', @HouseNumber='2', @PostalCodeID=8;     -- Agnieszka Lewandowska
EXEC usp_InsertAddress @Street='ul. Krucza', @HouseNumber='8', @PostalCodeID=9;     -- Micha³ WoŸniak
EXEC usp_InsertAddress @Street='ul. W¹ska', @HouseNumber='4', @PostalCodeID=10;     -- Ewa Szymañska
EXEC usp_InsertAddress @Street='ul. Ró¿ana', @HouseNumber='6', @PostalCodeID=11;    -- Pawe³ D¹browski
EXEC usp_InsertAddress @Street='ul. Lipowa', @HouseNumber='11', @PostalCodeID=12;   -- Magdalena Koz³owska
EXEC usp_InsertAddress @Street='ul. Œwierkowa', @HouseNumber='13', @PostalCodeID=13;-- Adam Jankowski
EXEC usp_InsertAddress @Street='ul. Morska', @HouseNumber='17', @PostalCodeID=14;   -- Joanna Mazur
EXEC usp_InsertAddress @Street='ul. Zamkowa', @HouseNumber='21', @PostalCodeID=15;  -- Grzegorz Krawczyk


EXEC usp_InsertCustomer @CustomerName='Jan Kowalski', @Contact='123-456-001', @AddressID=1;
EXEC usp_InsertCustomer @CustomerName='Maria Nowak', @Contact='123-456-002', @AddressID=2;
EXEC usp_InsertCustomer @CustomerName='Piotr Wiœniewski', @Contact='123-456-003', @AddressID=3;
EXEC usp_InsertCustomer @CustomerName='Anna Zieliñska', @Contact='123-456-004', @AddressID=4;
EXEC usp_InsertCustomer @CustomerName='Krzysztof Wójcik', @Contact='123-456-005', @AddressID=5;
EXEC usp_InsertCustomer @CustomerName='Barbara Kowalczyk', @Contact='123-456-006', @AddressID=6;
EXEC usp_InsertCustomer @CustomerName='Tomasz Kamiñski', @Contact='123-456-007', @AddressID=7;
EXEC usp_InsertCustomer @CustomerName='Agnieszka Lewandowska', @Contact='123-456-008', @AddressID=8;
EXEC usp_InsertCustomer @CustomerName='Micha³ WoŸniak', @Contact='123-456-009', @AddressID=9;
EXEC usp_InsertCustomer @CustomerName='Ewa Szymañska', @Contact='123-456-010', @AddressID=10;
EXEC usp_InsertCustomer @CustomerName='Pawe³ D¹browski', @Contact='123-456-011', @AddressID=11;
EXEC usp_InsertCustomer @CustomerName='Magdalena Koz³owska', @Contact='123-456-012', @AddressID=12;
EXEC usp_InsertCustomer @CustomerName='Adam Jankowski', @Contact='123-456-013', @AddressID=13;
EXEC usp_InsertCustomer @CustomerName='Joanna Mazur', @Contact='123-456-014', @AddressID=14;
EXEC usp_InsertCustomer @CustomerName='Grzegorz Krawczyk', @Contact='123-456-015', @AddressID=15;

EXEC usp_InsertPostalCode @PostalCode='00-999', @City='Warszawa'; -- PC=16

EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='1', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='2', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='3', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='4', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='5', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='6', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='7', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='8', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='9', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='10', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='11', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='12', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='13', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='14', @PostalCodeID=16;
EXEC usp_InsertAddress @Street='ul. Pracownicza', @HouseNumber='15', @PostalCodeID=16;


EXEC usp_InsertEmployee @LastName='Nowak', @FirstName='Anna', @Email='anna.nowak@example.com',        @PhoneNumber='987-654-001', @HireDate='2023-01-01', @AddressID=16, @Salary=4000.00;
EXEC usp_InsertEmployee @LastName='Kowalski', @FirstName='Piotr', @Email='piotr.kowalski@example.com', @PhoneNumber='987-654-002', @HireDate='2023-02-01', @AddressID=17, @Salary=4200.00;
EXEC usp_InsertEmployee @LastName='Wiœniewski', @FirstName='Marek', @Email='marek.wisniewski@example.com', @PhoneNumber='987-654-003', @HireDate='2023-03-01', @AddressID=18, @Salary=4300.00;
EXEC usp_InsertEmployee @LastName='Wójcik', @FirstName='Tomasz', @Email='tomasz.wojcik@example.com', @PhoneNumber='987-654-004', @HireDate='2023-04-01', @AddressID=19, @Salary=4400.00;
EXEC usp_InsertEmployee @LastName='Kowalczyk', @FirstName='Katarzyna', @Email='katarzyna.kowalczyk@example.com', @PhoneNumber='987-654-005', @HireDate='2023-05-01', @AddressID=20, @Salary=4500.00;
EXEC usp_InsertEmployee @LastName='Kamiñski', @FirstName='Pawe³', @Email='pawel.kaminski@example.com', @PhoneNumber='987-654-006', @HireDate='2023-06-01', @AddressID=21, @Salary=4600.00;
EXEC usp_InsertEmployee @LastName='Lewandowski', @FirstName='Andrzej', @Email='andrzej.lewandowski@example.com', @PhoneNumber='987-654-007', @HireDate='2023-07-01', @AddressID=22, @Salary=4700.00;
EXEC usp_InsertEmployee @LastName='Zieliñski', @FirstName='Jan', @Email='jan.zielinski@example.com', @PhoneNumber='987-654-008', @HireDate='2023-08-01', @AddressID=23, @Salary=4800.00;
EXEC usp_InsertEmployee @LastName='Szymañska', @FirstName='Monika', @Email='monika.szymanska@example.com', @PhoneNumber='987-654-009', @HireDate='2023-09-01', @AddressID=24, @Salary=4900.00;
EXEC usp_InsertEmployee @LastName='WoŸniak', @FirstName='Ewa', @Email='ewa.wozniak@example.com', @PhoneNumber='987-654-010', @HireDate='2023-10-01', @AddressID=25, @Salary=5000.00;
EXEC usp_InsertEmployee @LastName='D¹browski', @FirstName='Micha³', @Email='michal.dabrowski@example.com', @PhoneNumber='987-654-011', @HireDate='2023-11-01', @AddressID=26, @Salary=5100.00;
EXEC usp_InsertEmployee @LastName='Koz³owska', @FirstName='Agnieszka', @Email='agnieszka.kozlowska@example.com', @PhoneNumber='987-654-012', @HireDate='2023-12-01', @AddressID=27, @Salary=5200.00;
EXEC usp_InsertEmployee @LastName='Jankowski', @FirstName='Adam', @Email='adam.jankowski@example.com', @PhoneNumber='987-654-013', @HireDate='2024-01-01', @AddressID=28, @Salary=5300.00;
EXEC usp_InsertEmployee @LastName='Mazur', @FirstName='Joanna', @Email='joanna.mazur@example.com', @PhoneNumber='987-654-014', @HireDate='2024-02-01', @AddressID=29, @Salary=5400.00;
EXEC usp_InsertEmployee @LastName='Krawczyk', @FirstName='Grzegorz', @Email='grzegorz.krawczyk@example.com', @PhoneNumber='987-654-015', @HireDate='2024-03-01', @AddressID=30, @Salary=5500.00;

EXEC usp_InsertPostalCode @PostalCode='00-950', @City='Warszawa'; -- PC=17
EXEC usp_InsertAddress @Street='ul. Dostawców', @HouseNumber='10', @PostalCodeID=17; -- to bêdzie AddressID=31
EXEC usp_InsertSupplier @SupplierName='Dostawca Sp. z o.o.', @AddressID=31, @PhoneNumber='111-222-333';

EXEC usp_InsertPaymentMethod @PaymentMethodName='Karta Kredytowa';
EXEC usp_InsertPaymentMethod @PaymentMethodName='Przelew Bankowy';

EXEC usp_InsertResolutionType @ResolutionType='Zwrot pieniêdzy';
EXEC usp_InsertResolutionType @ResolutionType='Naprawa produktu';

EXEC usp_InsertShippingOption @ShippingMethodName='Kurier', @ShippingMethodDescription='Dostawa kurierem';
EXEC usp_InsertShippingOption @ShippingMethodName='Paczkomat', @ShippingMethodDescription='Dostawa do paczkomatu';


EXEC usp_InsertResolutionTypeOption @ResolutionTypeID=1, @PaymentMethodID=1, @ShippingMethodID=1;

EXEC usp_InsertStatus @StatusName='Nowa';
EXEC usp_InsertStatus @StatusName='Oczekuje na pracownika';
EXEC usp_InsertStatus @StatusName='W trakcie';
EXEC usp_InsertStatus @StatusName='Zakoñczona';

EXEC usp_InsertProduct @SupplierID=1, @ProductName='Smartfon', @Unit='szt.', @Price=2000.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='Laptop', @Unit='szt.', @Price=3500.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='Telewizor', @Unit='szt.', @Price=2500.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='S³uchawki', @Unit='szt.', @Price=150.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='Klawiatura', @Unit='szt.', @Price=100.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='Myszka', @Unit='szt.', @Price=80.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='Monitor', @Unit='szt.', @Price=800.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='Tablet', @Unit='szt.', @Price=1800.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='Kamera', @Unit='szt.', @Price=1200.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='G³oœnik', @Unit='szt.', @Price=300.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='Drukarka', @Unit='szt.', @Price=600.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='Dysk twardy', @Unit='szt.', @Price=250.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='Pendrive', @Unit='szt.', @Price=50.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='Kabel HDMI', @Unit='szt.', @Price=30.00;
EXEC usp_InsertProduct @SupplierID=1, @ProductName='£adowarka', @Unit='szt.', @Price=40.00;

EXEC usp_InsertComplaint @StatusID=1, @CustomerID=1, @EmployeeID=1, @ProductID=1, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=2, @CustomerID=2, @EmployeeID=2, @ProductID=2, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=3, @CustomerID=3, @EmployeeID=3, @ProductID=3, @ResolutionTypeID=2, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=4, @CustomerID=1, @EmployeeID=1, @ProductID=1, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=4, @CustomerID=2, @EmployeeID=2, @ProductID=2, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=4, @CustomerID=3, @EmployeeID=3, @ProductID=3, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=4, @CustomerID=4, @EmployeeID=4, @ProductID=4, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=4, @CustomerID=5, @EmployeeID=5, @ProductID=5, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=4, @CustomerID=6, @EmployeeID=6, @ProductID=6, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=4, @CustomerID=7, @EmployeeID=7, @ProductID=7, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=4, @CustomerID=8, @EmployeeID=8, @ProductID=8, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=1, @CustomerID=9,  @EmployeeID=9,  @ProductID=9,  @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=1, @CustomerID=10, @EmployeeID=10, @ProductID=10, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=1, @CustomerID=11, @EmployeeID=11, @ProductID=11, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=1, @CustomerID=12, @EmployeeID=12, @ProductID=12, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=1, @CustomerID=13, @EmployeeID=13, @ProductID=13, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=1, @CustomerID=14, @EmployeeID=14, @ProductID=14, @ResolutionTypeID=1, @ComplaintTypeID=1;
EXEC usp_InsertComplaint @StatusID=1, @CustomerID=15, @EmployeeID=15, @ProductID=15, @ResolutionTypeID=1, @ComplaintTypeID=1;



EXEC usp_InsertComplaintDetail @ComplaintID=3, @Description='Produkt uszkodzony podczas transportu.', @ComplaintDate='2024-01-15';
EXEC usp_InsertComplaintDetail @ComplaintID=4, @Description='Brak jednego elementu w zestawie.', @ComplaintDate='2024-02-10';
 -- EXEC usp_InsertComplaintDetail @ComplaintID=5, @Description='Produkt uszkodzony podczas transportu.', @ComplaintDate='2024-01-15'; blad 

EXEC usp_InsertComplaintDetail @ComplaintID=1, @Description='Reklamacja zakoñczona',   @ComplaintDate='2024-06-01', @ResolutionDate='2024-06-05';
EXEC usp_InsertComplaintDetail @ComplaintID=2, @Description='Reklamacja zakoñczona',   @ComplaintDate='2024-06-02', @ResolutionDate='2024-06-06';
EXEC usp_InsertComplaintDetail @ComplaintID=3, @Description='Reklamacja zakoñczona',   @ComplaintDate='2024-06-03', @ResolutionDate='2024-06-07';
EXEC usp_InsertComplaintDetail @ComplaintID=4, @Description='Reklamacja zakoñczona',   @ComplaintDate='2024-06-04', @ResolutionDate='2024-06-08';
EXEC usp_InsertComplaintDetail @ComplaintID=5, @Description='Reklamacja zakoñczona',   @ComplaintDate='2024-06-05', @ResolutionDate='2024-06-09';
EXEC usp_InsertComplaintDetail @ComplaintID=6, @Description='Reklamacja zakoñczona',   @ComplaintDate='2024-06-06', @ResolutionDate='2024-06-10';
EXEC usp_InsertComplaintDetail @ComplaintID=7, @Description='Reklamacja zakoñczona',   @ComplaintDate='2024-06-07', @ResolutionDate='2024-06-11';
EXEC usp_InsertComplaintDetail @ComplaintID=8, @Description='Reklamacja zakoñczona',   @ComplaintDate='2024-06-08', @ResolutionDate='2024-06-12';

EXEC usp_InsertComplaintDetail @ComplaintID=9,  @Description='Reklamacja w toku', @ComplaintDate='2024-06-09';
EXEC usp_InsertComplaintDetail @ComplaintID=10, @Description='Reklamacja w toku', @ComplaintDate='2024-06-10';
EXEC usp_InsertComplaintDetail @ComplaintID=11, @Description='Reklamacja w toku', @ComplaintDate='2024-06-11';
EXEC usp_InsertComplaintDetail @ComplaintID=12, @Description='Reklamacja w toku', @ComplaintDate='2024-06-12';
EXEC usp_InsertComplaintDetail @ComplaintID=13, @Description='Reklamacja w toku', @ComplaintDate='2024-06-13';
EXEC usp_InsertComplaintDetail @ComplaintID=14, @Description='Reklamacja w toku', @ComplaintDate='2024-06-14';
EXEC usp_InsertComplaintDetail @ComplaintID=15, @Description='Reklamacja w toku', @ComplaintDate='2024-06-15';
-- ========================================
-- 7. Loginy, Uzytkownicy, Role, Uprawnienia
-- ========================================
CREATE USER [ADMIN] FOR LOGIN [admin] WITH DEFAULT_SCHEMA=[dbo];
CREATE USER [WORKER] FOR LOGIN [WORKER] WITH DEFAULT_SCHEMA=[dbo];

CREATE ROLE [ROOT];
CREATE ROLE [EMPLOYEE];

ALTER ROLE [ROOT] ADD MEMBER [ADMIN];
ALTER ROLE [EMPLOYEE] ADD MEMBER [WORKER];

-- Uprawnienia
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Customers] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Employees] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Products] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Status] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Complaints] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[ComplaintDetails] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[PaymentMethods] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Addresses] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[PostalCodes] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[ResolutionTypes] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[ShippingOptions] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[ResolutionTypeOptions] TO [ROOT];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Suppliers] TO [ROOT];

-- Procedury
GRANT EXECUTE ON [dbo].[usp_InsertCustomer] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertEmployee] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertProduct] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertStatus] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertComplaint] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertComplaintDetail] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_DeleteComplaint] TO [ROOT];
GRANT EXECUTE ON [dbo].[usp_InsertPaymentMethod] TO [ROOT];

GRANT SELECT ON [dbo].[Customers] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[Employees] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[Products] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[Status] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[Complaints] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[ComplaintDetails] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[PaymentMethods] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[Addresses] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[PostalCodes] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[ResolutionTypes] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[ShippingOptions] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[ResolutionTypeOptions] TO [EMPLOYEE];
GRANT SELECT ON [dbo].[Suppliers] TO [EMPLOYEE];

-- ========================================
-- 8. Backup Bazy Danych
-- ========================================

BACKUP DATABASE [ComplaintDB]
TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\ComplaintDB.bak' 
WITH NOFORMAT,
NOINIT,
NAME = N'ComplaintDB-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO

-- ========================================
-- 9. Przywracanie Bazy Danych z loginem sa
-- ========================================

--RESTORE DATABASE [ComplaintDB]
--FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\ComplaintDB.bak'
--WITH FILE = 1, -- Domyœlnie pierwszy zestaw backupu w pliku
--MOVE N'ComplaintDB_Data' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ComplaintDB.mdf', -- Lokalizacja pliku danych
--MOVE N'ComplaintDB_Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ComplaintDB.ldf', -- Lokalizacja pliku logu
--NOUNLOAD,
--STATS = 10; -- Wyœwietlanie postêpu co 10%
--GO


