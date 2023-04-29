SELECT *
FROM HousingDb.dbo.NashvilleHousing

------------------------------------------------------------

--Standardize Date
SELECT SaleDate, CONVERT(Date,SaleDate)
FROM HousingDb.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

------------------------------------------------------------

-- Populate PropertyAddress

SELECT *
FROM HousingDb.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM HousingDb.dbo.NashvilleHousing a
JOIN HousingDb.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM HousingDb.dbo.NashvilleHousing a
JOIN HousingDb.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

------------------------------------------------------------

-- Reformatting Address

SELECT PropertyAddress
FROM HousingDb.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS Address
FROM HousingDb.dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)



ALTER TABLE dbo.NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


SELECT OwnerAddress
FROM HousingDb.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.') ,3),
PARSENAME(REPLACE(OwnerAddress,',','.') ,2),
PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
FROM HousingDb.dbo.NashvilleHousing



ALTER TABLE dbo.NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

ALTER TABLE dbo.NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

ALTER TABLE dbo.NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)



UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)


UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)


UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)


SELECT *
FROM HousingDb.dbo.NashvilleHousing


------------------------------------------------------------

-- Changing Y to Yes and N to No

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM HousingDb.dbo.NashvilleHousing
GROUP BY SoldAsVacant
Order by 2

SELECT SoldAsVacant,
CASE    when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
    END
FROM HousingDb.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE    when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
    END


------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY ParcelID,
                    PropertyAddress,
                    SalePrice,
                    SaleDate,
                    LegalReference
                    ORDER BY
                    UniqueID
    ) row_num
FROM HousingDb.dbo.NashvilleHousing
    )
-- DELETE
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


------------------------------------------------------------

-- Remove Unwanted Columns
CREATE VIEW house_view AS
SELECT UniqueID, ParcelID, LandUse,PropertySplitAddress AS PropertyAddress, PropertySplitCity AS PropertCity,
SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName,OwnerSplitAddress AS OwnerAddress,OwnerSplitCity AS OwnerCity,
OwnerSplitState AS OwnerState,Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath
FROM HousingDb.dbo.NashvilleHousing

SELECT *
FROM house_view


