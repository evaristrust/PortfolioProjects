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

--Show data where the propertyAddress or parcelID is null

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

--Taking at look at the OwnerAddress

--Looks like the ownerAddress is the combination of street address, city, and state 
--Going to separate them into three columns but using a different method..Pretty easy one
--Not substring but ParseName 
--ParseName is highly usable when the delimiter is a period. but I will handle it

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [dbo].[NashVilleHousing]

--owner address first
ALTER TABLE NashVilleHousing
Add OwnerSplitAddress nvarchar(255) 

UPDATE NashVilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

--owner city second
ALTER TABLE NashVilleHousing
Add OwnerSplitCity nvarchar(255) 

UPDATE NashVilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

--owner state third
ALTER TABLE NashVilleHousing
Add OwnerSplitState nvarchar(255) 

UPDATE NashVilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

--realized that soldAsVacant column has N, Y, Yes, and No field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [dbo].[NashVilleHousing]
GROUP BY SoldAsVacant
ORDER BY 2

--gonna change N,Y into No,Yes

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM [dbo].[NashVilleHousing] 

--Then update the SoldAsVacant column

update [dbo].[NashVilleHousing] 
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--check out the duplicate rows using a CTE AND delete them from our table

WITH Duplicates AS(
SELECT *,
		ROW_NUMBER() OVER(
	    PARTITION BY ParcelID,
	                PropertyAddress,
					SalesDate,
					SalePrice,
					LegalReference
					ORDER BY UniqueID
					) RowNumber
FROM [dbo].[NashVilleHousing]
) 

DELETE
FROM Duplicates
WHERE RowNumber > 1
--ORDER BY PropertyAddress

--How about getting rid of unuseful columns 

SELECT *
FROM [dbo].[NashVilleHousing] 

ALTER TABLE [dbo].[NashVilleHousing] 
DROP COLUMN PropertyAddress,
			SaleDate,
			OwnerAddress
