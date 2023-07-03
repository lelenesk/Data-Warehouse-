USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[Stg_vw_Erp_Reseller]
as
SELECT distinct 
       [StoreID],
	   S.[Name] AS [ResellerName],
	   S.BusinessEntityID
FROM [erp].[Customer] AS C
left join [erp].[Store]  AS S
on C.StoreId = S.BusinessEntityId
where PersonID is null
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create View [dbo].[Stg_vw_Erp_Product]
as

SELECT
p.[ProductNumber],
p.[Name],
p.[StandardCost],
p.[Color],
p.[Size],
p.[Name] [EnglishDescription],
sc.[Name]  as [ProductSubcategoryCode],
c.[Name]   as  [ProductCategory]
FROM [erp].[Product] p
left join [erp].[ProductSubCategory] sc
on p.ProductSubcategoryID = sc.ProductSubcategoryID
left join [erp].[ProductCategory] c
on sc.ProductCategoryID = c.ProductCategoryID
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[Stg_vw_Erp_Fact_ResellerSales]
as
SELECT h.[SalesOrderID],
row_number() over(partition by h.[SalesOrderID] order by h.modifieddate) as saleLineNumber,
p.ProductNumber,
cast(h.[OrderDate] as date) [OrderDate] ,
cast(h.[DueDate] as Date) [DueDate],
cast(h.[ShipDate] as date) [ShipDate],
c.[StoreID] AS ResellerID,
h.[TerritoryID],
e.NationalIDNumber,
N'USD' Currency,  
[OrderQty],
[UnitPrice],
[UnitPriceDiscount],
[LineTotal],
0 [TaxAmt]
FROM [erp].[SalesHeader] h
left join [erp].[SalesOrderDetail]  o
on h.SalesOrderID = o.SalesOrderID
left join [erp].[Product] p 
on o.[ProductID] = p.ProductID
left join [erp].[Customer] c
on h.[CustomerID] = c.[CustomerID]
left join [hr].[Employee] e
on e.[BusinessEntityID] = h.SalesPersonID
WHERE OnlineOrderFlag = 0
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE or alter view [dbo].[Stg_vw_Erp_Fact_InternetSales]
as
SELECT h.[SalesOrderID],
row_number() over(partition by h.[SalesOrderID] order by h.modifieddate) as saleLineNumber,
p.ProductNumber,
cast(h.[OrderDate] as date) [OrderDate] ,
cast(h.[DueDate] as Date) [DueDate],
cast(h.[ShipDate] as date) [ShipDate],
[CustomerID],
[TerritoryID],
N'USD' Currency,  
[OrderQty],
[UnitPrice],
[UnitPriceDiscount],
[LineTotal],
0 [TaxAmt]
FROM [erp].[SalesHeader] h
left join [erp].[SalesOrderDetail]  o
on h.SalesOrderID = o.SalesOrderID
left join [erp].[Product] p 
on o.[ProductID] = p.ProductID
WHERE OnlineOrderFlag =1 
GO


USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create view [dbo].[Stg_vw_Erp_Fact_EmployeePayHistory]
as

SELECT
b.NationalIDNumber,
dt.MonthStart as SalaryMonth,
eh.Rate,
eh.PayFrequency
FROM [AW_STG].[hr].[EmployeePayHistory] eh
inner join ( 
			SELECT 
			[BusinessEntityID],
			max([RateChangeDate]) AS CurrentRateDate
			FROM [AW_STG].[hr].[EmployeePayHistory]
			GROUP BY [BusinessEntityID]) AS Mxdt
on eh.BusinessEntityID = Mxdt.BusinessEntityID
and eh.RateChangeDate = Mxdt.CurrentRateDate
Left Join [hr].[Employee] b
on b.BusinessEntityID = eh.BusinessEntityID
cross Join (
			SELECT
			CalendarYear,
			EnglishMonthName,
			min(fullDateAlternateKey) as MonthStart,
			Max(FullDateAlterNateKey)  AS MonthEnd
			FROM [AW_DW].[dbo].[DimDate]
			WHERE CalendarYear=2022
			GROUP BY CalendarYear,EnglishMonthName) AS dt
GO

USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[Stg_vw_Erp_Employee]
as

select  
NationalIDNumber 
[FirstName],
[LastName],
[MiddleName],
null [NameStyle],
[Title],
[HireDate],
[BirthDate],
LoginID [EmailAddress],
[MaritalStatus],
[StartDate],
[EndDate],
[NationalIDNumber]
FROM [hr].[Employee] AS e
left join [erp].[Person] AS p
on e.BusinessEntityID = p.BusinessEntityID
left join [hr].[EmployeeDepartmentHistory] AS d
on e.BusinessEntityID = d.BusinessEntityID
GO


USE [AW_STG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Stg_vw_Erp_Customer]
as

SELECT
c.CustomerID,
p.[Title],
p.[FirstName],
p.[MiddleName],
p.[LastName],
p.[NameStyle],
p.[EmailAddress],
pa.[AddressLine1],
pa.City
FROM [erp].[Customer] c
inner join [erp].[Person] p
on c.PersonID = p.BusinessEntityID
left join [erp].[PersonAddress] pa
on p.BusinessEntityID = pa.BusinessEntityID
GO























