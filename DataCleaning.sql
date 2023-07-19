/*

Data Cleaning

1. Changing Date format
*/

SELECT *
FROM Nashville.dbo.NashvilleHousing

SELECT SaleDateConverted, CONVERT(Date,Saledate)
FROM Nashville.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET Saledate = CONVERT(Date, Saledate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, Saledate)






-- 2. Populate Property Address data





SELECT *
FROM Nashville.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville.dbo.NashvilleHousing a
JOIN Nashville.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville.dbo.NashvilleHousing a
JOIN Nashville.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL





--3. splitting address into individual columns





SELECT PropertyAddress
FROM Nashville.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address


FROM Nashville.dbo.NashvilleHousing






ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
FROM Nashville.dbo.NashvilleHousing







Select OwnerAddress
FROM Nashville.dbo.NashvilleHousing





SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Nashville.dbo.NashvilleHousing






ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)






Select *
FROM Nashville.dbo.NashvilleHousing







--4. Changing Y and N to Yes and No







Select Distinct(SoldasVacant), COUNT(SoldasVacant)
FROM Nashville.dbo.NashvilleHousing
GROUP BY Soldasvacant
ORDER BY 2

SELECT SoldasVacant,
	CASE When SoldasVacant = 'Y' THEN 'Yes'
		WHEN SoldasVacant = 'N' THEN 'No'
		ELSE SoldasVacant
		END
FROM Nashville.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldasVacant = CASE When SoldasVacant = 'Y' THEN 'Yes'
		WHEN SoldasVacant = 'N' THEN 'No'
		ELSE SoldasVacant
		END







--5. Remove Duplicates










WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num
FROM Nashville.dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
Order by PropertyAddress









--6. Deleting unused columns









SELECT *
FROM Nashville.dbo.NashvilleHousing

ALTER TABLE Nashville.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE Nashville.dbo.NashvilleHousing
DROP COLUMN SaleDate




































































