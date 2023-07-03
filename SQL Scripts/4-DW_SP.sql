USE [AW_DW]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[Refresh_DimCurrency]
AS
SET NOCOUNT ON

BEGIN
INSERT INTO [dbo].[DimCurrency](
[CurrencyAlternateKey],
[CurrencyName])

SELECT 
[CurrencyCode],
[Name]    
FROM [AW_STG].[erp].[Currency] stg (nolock)
left join [dbo].[DimCurrency] Dim  (nolock)
on stg.CurrencyCode = Dim.CurrencyAlternateKey
where Dim.CurrencyAlternateKey is null

Update Dim
Set [CurrencyName] = Name
from [dbo].[DimCurrency] Dim  (nolock)
inner join [AW_STG].[erp].[Currency] stg  (nolock)
on stg.CurrencyCode = Dim.CurrencyAlternateKey
END

GO


USE [AW_DW]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[Refresh_DimCustomer]
AS
SET NOCOUNT ON

BEGIN
MERGE into [dbo].[DimCustomer] cus
USING [AW_STG].[dbo].[Stg_vw_Erp_Customer] stg
ON cus.[CustomerAlternateKey] = stg.CustomerID

WHEN Matched
and (cus.EmailAddress <> stg.[EmailAddress] 
or cus.[AddressLine1] <> stg.[AddressLine1] 
or cus.City <> stg.City) 
THEN

UPDATE SET 
cus.EmailAddress =stg.[EmailAddress] ,
cus.[AddressLine1] = stg.[AddressLine1] ,
cus.City =  stg.City


WHEN Not Matched by Target 
THEN

INSERT ( 
       [CustomerAlternateKey],
	   [Title], 
	   [FirstName],
	   [MiddleName],
	   [LastName],
       [NameStyle],
	   [EmailAddress],
	   [AddressLine1],
	   [City])
VALUES (
	stg.CustomerID,
    stg.[Title],
	stg.[FirstName],
	stg.[MiddleName],
	stg.[LastName],
	stg.[NameStyle],
	stg.[EmailAddress],
	stg.[AddressLine1],
	stg.City);
END

GO



USE [AW_DW]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[Refresh_DimDate]
AS
SET NOCOUNT ON

BEGIN

DECLARE 
@startdate date = '2005-01-01',
@enddate date = '2024-12-31'

IF @startdate IS NULL
    BEGIN
        SELECT TOP 1 @startdate = FulldateAlternateKey
        From DimDate 
        Order By DateKey ASC 
    END

DECLARE @datelist table (FullDate date)

WHILE @startdate <= @enddate
	BEGIN 
		Insert into @datelist (FullDate)
		Select @startdate
		Set @startdate = dateadd(dd,1,@startdate)
	END 

Insert into dbo.DimDate (
	DateKey, 
    FullDateAlternateKey, 
    DayNumberOfWeek, 
    EnglishDayNameOfWeek, 
    DayNumberOfMonth, 
    DayNumberOfYear, 
    WeekNumberOfYear, 
    EnglishMonthName, 
    MonthNumberOfYear, 
    CalendarQuarter, 
    CalendarYear, 
    CalendarSemester, 
    FiscalQuarter, 
    FiscalYear, 
    FiscalSemester)


select convert(int,convert(varchar, dl.FullDate, 112)) as DateKey,
    dl.FullDate,
    datepart(dw,dl.FullDate) as DayNumberOfWeek,
    datename(weekday,dl.FullDate) as EnglishDayNameOfWeek,
    datepart(d,dl.FullDate) as DayNumberOfMonth,
    datepart(dy,dl.FullDate) as DayNumberOfYear,
    datepart(wk, dl.FUllDate) as WeekNumberOfYear,
    datename(MONTH,dl.FullDate) as EnglishMonthName,
    Month(dl.FullDate) as MonthNumberOfYear,
    datepart(qq, dl.FullDate) as CalendarQuarter,
    year(dl.FullDate) as CalendarYear,
    case datepart(qq, dl.FullDate)
        when 1 then 1
        when 2 then 1
        when 3 then 2
        when 4 then 2
    end as CalendarSemester,
    case datepart(qq, dl.FullDate)
        when 1 then 3
        when 2 then 4
        when 3 then 1
        when 4 then 2
    end as FiscalQuarter,
    case datepart(qq, dl.FullDate)
        when 1 then year(dl.FullDate)
        when 2 then year(dl.FullDate)
        when 3 then year(dl.FullDate) + 1
        when 4 then year(dl.FullDate) + 1
    end as FiscalYear,
    case datepart(qq, dl.FullDate)
        when 1 then 2
        when 2 then 2
        when 3 then 1
        when 4 then 1
    end as FiscalSemester

FROM @datelist AS dl
left join DimDate  AS dd 
on dl.FullDate = dd.FullDateAlternateKey
WHERE dd.FullDateAlternateKey is null 
END

GO

USE [AW_DW]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[Refresh_DimProduct]
AS
SET NOCOUNT ON

BEGIN
INSERT into [dbo].[DimProduct] (
       [ProductAlternateKey],
       [EnglishProductName],
       [StandardCost],
       [Color],
       [Size],
       [EnglishDescription],
       [ProductSubcategoryCode],
       [ProductcategoryCode])

SELECT 
	   stg.[ProductNumber],
       stg.[Name],
       stg.[StandardCost],
       Isnull(stg.[Color],'NA'),
       stg.[Size],
       stg.[EnglishDescription],
	   stg.[ProductSubcategoryCode],
       stg.[ProductCategory]   
FROM [AW_STG].[dbo].[Stg_vw_Erp_Product] as stg with (nolock)
left join [dbo].[DimProduct] as Dim WITH (nolock)
ON Dim.[ProductAlternateKey] = stg.[ProductNumber]
WHERE Dim.[ProductAlternateKey] is null

Update Dim
set Dim.[EnglishDescription]= stg.[EnglishDescription]
FROM [dbo].[DimProduct] AS Dim WITH (nolock)
inner join [AW_STG].[dbo].[Stg_vw_Erp_Product] AS stg WITH (nolock)
on Dim.[ProductAlternateKey] = stg.[ProductNumber]
END

GO

USE [AW_DW]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[Refresh_DimSalesTerritory]
AS
SET NOCOUNT ON

BEGIN
INSERT into [dbo].[DimSalesTerritory] (
[SalesTerritoryAlternateKey],
[SalesTerritoryRegion],
[SalesTerritoryCountry],
[SalesTerritoryGroup])

SELECT  
[TerritoryID],
[Name],
[CountryRegionCode],
[Group]
FROM [AW_STG].[erp].[SalesTerritory] stg (nolock)
left join [dbo].[DimSalesTerritory] Dim  (nolock)
on Dim.[SalesTerritoryAlternateKey] = stg.[TerritoryID]
WHERE Dim.[SalesTerritoryAlternateKey] is null

UPDATE Dim SET
[SalesTerritoryRegion]=[Name],
[SalesTerritoryCountry]=[CountryRegionCode],
[SalesTerritoryGroup]=[Group]
FROM [dbo].[DimSalesTerritory] AS Dim WITH (nolock)
inner join [AW_STG].[erp].[SalesTerritory] AS stg WITH (nolock)
on Dim.[SalesTerritoryAlternateKey] = stg.[TerritoryID]
END

GO

USE [AW_DW]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[Refresh_FactEmployeePay]
AS
SET NOCOUNT ON

BEGIN
INSERT into [AW_DW].[dbo].[FactEmployeePay]
SELECT
e.EmployeeKey,
d.DateKey,
s.PayFrequency,
s.Rate 
FROM [AW_STG].[dbo].[Stg_vw_Erp_Fact_EmployeePayHistory] AS s
left join [AW_DW].[dbo].[DimEmployee] AS e
on e.[EmployeeNationalIDAlternateKey] = s.NationalIDNumber
left join [AW_DW].[dbo].[DimDate] AS d
on s.SalaryMonth = d.FullDateAlternateKey
END

GO


USE [AW_DW]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[Refresh_Reseller]
AS
SET NOCOUNT ON

BEGIN
INSERT into  [dbo].[DimReseller] (
[ResellerAlternateKey],
[ResellerName])

SELECT
Stg.[StoreID],
Stg.[ResellerName]
FROM [AW_STG].[dbo].[Stg_vw_Erp_Reseller] AS stg WITH (nolock)
left join  [dbo].[DimReseller] AS Dim WITH (nolock)
on stg.[StoreID] = Dim.[ResellerAlternateKey]
WHERE Dim.[ResellerAlternateKey] is null

UPDATE Dim Set  
Dim.[ResellerName]=stg.[ResellerName]
from [dbo].[DimReseller] AS Dim WITH (nolock)
inner join  [AW_STG].[dbo].[Stg_vw_Erp_Reseller] AS stg WITH (nolock)
on stg.[StoreID] = Dim.[ResellerAlternateKey]
end

GO
