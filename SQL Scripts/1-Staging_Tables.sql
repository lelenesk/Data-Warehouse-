USE [master]
GO

CREATE DATABASE [AW_STG]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AW_STG', FILENAME = N'D:\SQL\Microsoft SQL Server\MSSQL16.GEPHAZ\MSSQL\DATA\AW_STG.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AW_STG_log', FILENAME = N'D:\SQL\Microsoft SQL Server\MSSQL16.GEPHAZ\MSSQL\DATA\AW_STG_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AW_STG].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [AW_STG] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [AW_STG] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [AW_STG] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [AW_STG] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [AW_STG] SET ARITHABORT OFF 
GO

ALTER DATABASE [AW_STG] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [AW_STG] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [AW_STG] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [AW_STG] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [AW_STG] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [AW_STG] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [AW_STG] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [AW_STG] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [AW_STG] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [AW_STG] SET  ENABLE_BROKER 
GO

ALTER DATABASE [AW_STG] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [AW_STG] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [AW_STG] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [AW_STG] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [AW_STG] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [AW_STG] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [AW_STG] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [AW_STG] SET RECOVERY FULL 
GO

ALTER DATABASE [AW_STG] SET  MULTI_USER 
GO

ALTER DATABASE [AW_STG] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [AW_STG] SET DB_CHAINING OFF 
GO

ALTER DATABASE [AW_STG] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [AW_STG] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [AW_STG] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [AW_STG] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [AW_STG] SET QUERY_STORE = ON
GO

ALTER DATABASE [AW_STG] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO

ALTER DATABASE [AW_STG] SET  READ_WRITE 
GO

USE [AW_STG]
GO

CREATE SCHEMA [erp]
GO

CREATE SCHEMA [hr]
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [hr].[EmployeePayHistory](
	[BusinessEntityID] [int] NOT NULL,
	[RateChangeDate] [datetime] NOT NULL,
	[Rate] [money] NOT NULL,
	[PayFrequency] [tinyint] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [hr].[EmployeeDepartmentHistory](
	[BusinessEntityID] [int] NULL,
	[DepartmentID] [smallint] NULL,
	[ShiftID] [tinyint] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [hr].[EmployeeDepartmentHistory] ADD  DEFAULT (getdate()) FOR [Created_Dt]
GO



USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [hr].[Employee](
	[BusinessEntityID] [int] NULL,
	[NationalIDNumber] [nvarchar](15) NULL,
	[LoginID] [nvarchar](50) NULL,
	[OrganizationNode] [binary](892) NULL,
	[OrganizationLevel] [smallint] NULL,
	[JobTitle] [nvarchar](50) NULL,
	[BirthDate] [date] NULL,
	[MaritalStatus] [nvarchar](1) NULL,
	[Gender] [nvarchar](1) NULL,
	[HireDate] [date] NULL,
	[SalariedFlag] [bit] NULL,
	[VacationHours] [smallint] NULL,
	[SickLeaveHours] [smallint] NULL,
	[CurrentFlag] [bit] NULL,
	[rowguid] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [hr].[Employee] ADD  DEFAULT (getdate()) FOR [Created_Dt]
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[Store](
	[rowguid] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[Name] [nvarchar](50) NULL,
	[Demographics] [nvarchar](max) NULL,
	[BusinessEntityID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[SalesTerritory](
	[TerritoryID] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[CountryRegionCode] [nvarchar](3) NULL,
	[Group] [nvarchar](50) NULL
) ON [PRIMARY]
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[SalesOrderDetail](
	[SalesOrderID] [int] NULL,
	[SalesOrderDetailID] [int] NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[OrderQty] [smallint] NULL,
	[ProductID] [int] NULL,
	[SpecialOfferID] [int] NULL,
	[UnitPrice] [money] NULL,
	[UnitPriceDiscount] [money] NULL,
	[LineTotal] [numeric](38, 6) NULL,
	[rowguid] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [erp].[SalesOrderDetail] ADD  DEFAULT (getdate()) FOR [Created_Dt]
GO


USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[SalesHeader](
	[SalesOrderID] [int] NULL,
	[rowguid] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[RevisionNumber] [tinyint] NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NULL,
	[OnlineOrderFlag] [bit] NULL,
	[SalesOrderNumber] [nvarchar](25) NULL,
	[PurchaseOrderNumber] [nvarchar](25) NULL,
	[AccountNumber] [nvarchar](15) NULL,
	[CustomerID] [int] NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NULL,
	[ShipToAddressID] [int] NULL,
	[ShipMethodID] [int] NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[SubTotal] [money] NULL,
	[TaxAmt] [money] NULL,
	[Freight] [money] NULL,
	[TotalDue] [money] NULL,
	[SSIS_ID] [bigint] NULL
) ON [PRIMARY]
GO


USE [AW_STG]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[ProductSubCategory](
	[ProductSubcategoryID] [int] NULL,
	[ProductCategoryID] [int] NULL,
	[Name] [nvarchar](50) NULL
) ON [PRIMARY]
GO


USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[ProductCategory](
	[ModifiedDate] [datetime] NULL,
	[ProductCategoryID] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[rowguid] [uniqueidentifier] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [erp].[ProductCategory] ADD  DEFAULT (getdate()) FOR [Created_Dt]
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[Product](
	[ProductID] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[ProductNumber] [nvarchar](25) NULL,
	[MakeFlag] [bit] NULL,
	[FinishedGoodsFlag] [bit] NULL,
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NULL,
	[ReorderPoint] [smallint] NULL,
	[StandardCost] [money] NULL,
	[ListPrice] [money] NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nvarchar](3) NULL,
	[WeightUnitMeasureCode] [nvarchar](3) NULL,
	[Weight] [numeric](8, 2) NULL,
	[DaysToManufacture] [int] NULL,
	[ProductLine] [nvarchar](2) NULL,
	[Class] [nvarchar](2) NULL,
	[Style] [nvarchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] NULL,
	[SellEndDate] [datetime] NULL,
	[rowguid] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [erp].[Product] ADD  DEFAULT (getdate()) FOR [Created_Dt]
GO



USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[PersonAddress](
	[BusinessEntityID] [int] NULL,
	[AddressID] [int] NULL,
	[rowguid] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[AddressLine1] [nvarchar](60) NULL,
	[City] [nvarchar](30) NULL,
	[PostalCode] [nvarchar](15) NULL,
	[StateProvinceID] [int] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [erp].[PersonAddress] ADD  DEFAULT (getdate()) FOR [Created_Dt]
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[Person](
	[BusinessEntityID] [int] NULL,
	[rowguid] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[PersonType] [nvarchar](2) NULL,
	[NameStyle] [bit] NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [erp].[Person] ADD  DEFAULT (getdate()) FOR [Created_Dt]
GO


USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[Customer](
	[CustomerID] [int] NULL,
	[PersonID] [int] NULL,
	[StoreID] [int] NULL,
	[TerritoryID] [int] NULL,
	[AccountNumber] [varchar](10) NULL,
	[rowguid] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]
GO

USE [AW_STG]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[Currency](
	[CurrencyCode] [nvarchar](3) NULL,
	[Name] [nvarchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [erp].[Currency] ADD  DEFAULT (getdate()) FOR [Created_Dt]
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [erp].[Business_Entity](
	[rowguid] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[BusinessEntityID] [int] NULL,
	[Created_Dt] [datetime] NULL,
	[SSISTrackId] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [erp].[Business_Entity] ADD  DEFAULT (getdate()) FOR [Created_Dt]
GO

























