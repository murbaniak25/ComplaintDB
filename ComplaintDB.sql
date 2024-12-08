USE [ComplaintsDB]
GO
/****** Object:  User [ADMIN]    Script Date: 08.12.2024 23:55:45 ******/
CREATE USER [ADMIN] FOR LOGIN [admin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [WORKER]    Script Date: 08.12.2024 23:55:45 ******/
CREATE USER [WORKER] FOR LOGIN [WORKER] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [EMPLOYEE]    Script Date: 08.12.2024 23:55:45 ******/
CREATE ROLE [EMPLOYEE]
GO
/****** Object:  DatabaseRole [ROOT]    Script Date: 08.12.2024 23:55:45 ******/
CREATE ROLE [ROOT]
GO
ALTER ROLE [ROOT] ADD MEMBER [ADMIN]
GO
ALTER ROLE [EMPLOYEE] ADD MEMBER [WORKER]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[PhoneNumber] [nvarchar](50) NOT NULL,
	[HireDate] [date] NOT NULL,
	[AddressID] [int] NOT NULL,
	[Salary] [money] NOT NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Complaints]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Complaints](
	[ComplaintID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[ResolutionTypeID] [int] NOT NULL,
	[ComplaintTypeID] [int] NOT NULL,
 CONSTRAINT [PK_Complaints] PRIMARY KEY CLUSTERED 
(
	[ComplaintID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_ReklamacjePracownicy]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ReklamacjePracownicy] AS
SELECT
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    COUNT(c.ComplaintID) AS LiczbaReklamacji
FROM
    Complaints c
    INNER JOIN Employees e ON c.EmployeeID = e.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName;
GO
/****** Object:  Table [dbo].[Status]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status](
	[StatusID] [int] NOT NULL,
	[StatusName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_ComplaintsByStatus]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ComplaintsByStatus] AS
SELECT 
    s.StatusName, 
    COUNT(c.ComplaintID) AS ComplaintCount
FROM 
    Status s
LEFT JOIN 
    Complaints c ON s.StatusID = c.StatusID
GROUP BY 
    s.StatusName;
GO
/****** Object:  Table [dbo].[ComplaintDetails]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComplaintDetails](
	[ComplaintID] [int] NOT NULL,
	[Description] [nvarchar](500) NULL,
	[ComplaintDate] [date] NOT NULL,
	[ResolutionDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[Unit] [nvarchar](50) NOT NULL,
	[Price] [money] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerID] [int] NOT NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[Contact] [nvarchar](50) NOT NULL,
	[AddressID] [int] NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_ComplaintResolutionTime]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ComplaintResolutionTime] AS
SELECT 
    cd.ComplaintID,
    cu.CustomerName,
    p.ProductName,
    DATEDIFF(DAY, cd.ComplaintDate, cd.ResolutionDate) AS ResolutionTimeDays
FROM 
    ComplaintDetails cd
JOIN 
    Complaints c ON cd.ComplaintID = c.ComplaintID
JOIN 
    Customers cu ON c.CustomerID = cu.CustomerID
JOIN 
    Products p ON c.ProductID = p.ProductID;
GO
/****** Object:  Table [dbo].[Addresses]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Addresses](
	[AddressID] [int] NOT NULL,
	[Street] [nvarchar](50) NOT NULL,
	[HouseNumber] [nvarchar](10) NOT NULL,
	[PostalCodeID] [int] NOT NULL,
 CONSTRAINT [PK_Addresses] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentMethods]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentMethods](
	[PaymentMethodID] [int] NOT NULL,
	[PaymentMethodName] [nvarchar](50) NOT NULL,
	[PaymentMethodDescription] [nvarchar](255) NOT NULL,
	[ResolutionTypeID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PostalCodes]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostalCodes](
	[PostalCodeID] [int] NOT NULL,
	[PostalCode] [nvarchar](10) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PostalCodes] PRIMARY KEY CLUSTERED 
(
	[PostalCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResolutionTypes]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResolutionTypes](
	[ResolutionTypeID] [int] NOT NULL,
	[ResolutionType] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_ResolutionTypes] PRIMARY KEY CLUSTERED 
(
	[ResolutionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingMethods]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingMethods](
	[ShippingMethodID] [int] NOT NULL,
	[ShippingMethodName] [nvarchar](50) NOT NULL,
	[ShippingCost] [money] NOT NULL,
	[ResolutionTypeID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Suppliers]    Script Date: 08.12.2024 23:55:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Suppliers](
	[SupplierID] [int] NOT NULL,
	[SupplierName] [nvarchar](50) NOT NULL,
	[AddressID] [int] NOT NULL,
	[PhoneNumber] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED 
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Addresses]  WITH CHECK ADD  CONSTRAINT [FK_Addresses_PostalCodes] FOREIGN KEY([PostalCodeID])
REFERENCES [dbo].[PostalCodes] ([PostalCodeID])
GO
ALTER TABLE [dbo].[Addresses] CHECK CONSTRAINT [FK_Addresses_PostalCodes]
GO
ALTER TABLE [dbo].[ComplaintDetails]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintDetails_Complaints1] FOREIGN KEY([ComplaintID])
REFERENCES [dbo].[Complaints] ([ComplaintID])
GO
ALTER TABLE [dbo].[ComplaintDetails] CHECK CONSTRAINT [FK_ComplaintDetails_Complaints1]
GO
ALTER TABLE [dbo].[Complaints]  WITH CHECK ADD  CONSTRAINT [FK_Complaints_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_Customers]
GO
ALTER TABLE [dbo].[Complaints]  WITH CHECK ADD  CONSTRAINT [FK_Complaints_Employees] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_Employees]
GO
ALTER TABLE [dbo].[Complaints]  WITH CHECK ADD  CONSTRAINT [FK_Complaints_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_Products]
GO
ALTER TABLE [dbo].[Complaints]  WITH CHECK ADD  CONSTRAINT [FK_Complaints_ResolutionTypes] FOREIGN KEY([ResolutionTypeID])
REFERENCES [dbo].[ResolutionTypes] ([ResolutionTypeID])
GO
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_ResolutionTypes]
GO
ALTER TABLE [dbo].[Complaints]  WITH CHECK ADD  CONSTRAINT [FK_Complaints_Status] FOREIGN KEY([StatusID])
REFERENCES [dbo].[Status] ([StatusID])
GO
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_Status]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_Addresses] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Addresses] ([AddressID])
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customers_Addresses]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Addresses] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Addresses] ([AddressID])
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_Addresses]
GO
ALTER TABLE [dbo].[PaymentMethods]  WITH CHECK ADD  CONSTRAINT [FK_PaymentMethods_ResolutionTypes] FOREIGN KEY([ResolutionTypeID])
REFERENCES [dbo].[ResolutionTypes] ([ResolutionTypeID])
GO
ALTER TABLE [dbo].[PaymentMethods] CHECK CONSTRAINT [FK_PaymentMethods_ResolutionTypes]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Suppliers] ([SupplierID])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Suppliers]
GO
ALTER TABLE [dbo].[ShippingMethods]  WITH CHECK ADD  CONSTRAINT [FK_ShippingMethods_ResolutionTypes] FOREIGN KEY([ResolutionTypeID])
REFERENCES [dbo].[ResolutionTypes] ([ResolutionTypeID])
GO
ALTER TABLE [dbo].[ShippingMethods] CHECK CONSTRAINT [FK_ShippingMethods_ResolutionTypes]
GO
ALTER TABLE [dbo].[Suppliers]  WITH CHECK ADD  CONSTRAINT [FK_Suppliers_Addresses] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Addresses] ([AddressID])
GO
ALTER TABLE [dbo].[Suppliers] CHECK CONSTRAINT [FK_Suppliers_Addresses]
GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteComplaint]    Script Date: 08.12.2024 23:55:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DeleteComplaint]
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
/****** Object:  StoredProcedure [dbo].[usp_InsertComplaint]    Script Date: 08.12.2024 23:55:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_InsertComplaint]
    @StatusID INT,
    @CustomerID INT,
    @EmployeeID INT,
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Complaints (StatusID, CustomerID, EmployeeID, ProductID)
        VALUES (@StatusID, @CustomerID, @EmployeeID, @ProductID);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertComplaintDetail]    Script Date: 08.12.2024 23:55:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_InsertComplaintDetail]
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
/****** Object:  StoredProcedure [dbo].[usp_InsertCustomer]    Script Date: 08.12.2024 23:55:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ========================================
-- 5. Procedury
-- ========================================

CREATE PROCEDURE [dbo].[usp_InsertCustomer]
    @CustomerName VARCHAR(50),
    @Contact VARCHAR(20),
    @Address VARCHAR(100),
    @City VARCHAR(100),
    @PostalCode VARCHAR(10),
    @Country VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Customers (CustomerName, Contact, Address, City, PostalCode, Country)
        VALUES (@CustomerName, @Contact, @Address, @City, @PostalCode, @Country);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertEmployee]    Script Date: 08.12.2024 23:55:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_InsertEmployee]
    @LastName VARCHAR(50),
    @FirstName VARCHAR(50),
    @Email VARCHAR(100),
    @PhoneNumber VARCHAR(15),
    @HireDate DATE,
    @Salary MONEY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Employees (LastName, FirstName, Email, PhoneNumber, HireDate, Salary)
        VALUES (@LastName, @FirstName, @Email, @PhoneNumber, @HireDate, @Salary);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertProduct]    Script Date: 08.12.2024 23:55:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_InsertProduct]
    @ProductName VARCHAR(50),
    @Unit VARCHAR(20),
    @Price MONEY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Products (ProductName, Unit, Price)
        VALUES (@ProductName, @Unit, @Price);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertStatus]    Script Date: 08.12.2024 23:55:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_InsertStatus]
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
