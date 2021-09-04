--select everything from our table

SELECT *
FROM [dbo].[NashVilleHousing] 

--change the salesDate type from datetime to date type

SELECT SaleDate, CONVERT(date, SaleDate) 
as Date 
From [dbo].[NashVilleHousing]

--update the SaleDate with the above querry to change the type 

UPDATE NashVilleHousing 
SET SaleDate = CONVERT(date, SaleDate)

--looks my SaleDate isn't updating..Back to the drawing board now with ALTER method 

ALTER TABLE NashVilleHousing
Add SalesDate date --add a new column named SalesDate

UPDATE NashVilleHousing 
SET SalesDate = CONVERT(date, SaleDate) --set the new added column to date type

SELECT SalesDate, SaleDate, CONVERT(date, SaleDate) 
as Date 
From [dbo].[NashVilleHousing] 

--Show data when where the propertyAddress or parcelID is null

SELECT *
FROM [dbo].[NashVilleHousing]
WHERE PropertyAddress is null 
OR ParcelID is null

--Examine null propertyAddresses but checking if they actually have ParcelID
-- since there is no null parcelID, it is going to be perfect
SELECT ParcelID, PropertyAddress
FROM [dbo].[NashVilleHousing]
ORDER BY 1,2

--use self join to populate null property address based on corresponding ParcelID 
--remember the uniqueID is always unique
SELECT *
FROM [dbo].[NashVilleHousing] x
JOIN [dbo].[NashVilleHousing] y
ON x.ParcelID = y.ParcelID
AND x.[UniqueID ] <> y.[UniqueID ]

--use ISNULL on propertyAddress column x to replace null values by y values

SELECT x.ParcelID, y.ParcelID, x.PropertyAddress, y.PropertyAddress,
ISNULL(x.PropertyAddress, y.PropertyAddress)
FROM [dbo].[NashVilleHousing] x
JOIN [dbo].[NashVilleHousing] y
ON x.ParcelID = y.ParcelID
AND x.[UniqueID ] <> y.[UniqueID ]
WHERE x.PropertyAddress is null

UPDATE x
SET PropertyAddress = ISNULL(x.PropertyAddress, y.PropertyAddress)
FROM [dbo].[NashVilleHousing] x
JOIN [dbo].[NashVilleHousing] y
ON x.ParcelID = y.ParcelID
AND x.[UniqueID ] <> y.[UniqueID ]
WHERE x.PropertyAddress is null 

--checking closely the PropertyAddress, it's comprised by address and the city (a comma is a delimiter) 
--now separate the propertyAddress into address and city

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
FROM [dbo].[NashVilleHousing]
ORDER BY City 

--now it's time to update my table with the above splitted addresses 

--address first 

ALTER TABLE NashVilleHousing
Add PropertySplitAddress nvarchar(255) 

UPDATE NashVilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

--city second

ALTER TABLE NashVilleHousing
Add PropertySplitCity nvarchar(255) 

UPDATE NashVilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM [dbo].[NashVilleHousing] 