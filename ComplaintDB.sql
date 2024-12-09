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
