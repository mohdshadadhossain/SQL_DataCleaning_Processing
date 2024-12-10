-- Select all data
SELECT * 
FROM NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format 
ALTER TABLE NashvilleHousing
CHANGE COLUMN saleDate saleDate DATE;

-- Just checking
SELECT SaleDate
FROM NashvilleHousing;

SELECT * 
FROM NashvilleHousing LIMIT 5;

--------------------------------------------------------------------------------------------------------------------------

-- Ensure that all columns contain the expected data types
SELECT *
FROM NashvilleHousing
WHERE NOT SalePrice REGEXP '^[0-9]+(\.[0-9]+)?$' OR SaleDate IS NULL;

--------------------------------------------------------------------------------------------------------------------------

-- Checking for Null Values
SELECT 
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN PropertyAddress IS NULL THEN 1 ELSE 0 END) AS MissingPropertyAddress,
    SUM(CASE WHEN SalePrice IS NULL THEN 1 ELSE 0 END) AS MissingSalePrice
FROM NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data (houses with the same ParcelID have the same PropertyAddress)
SELECT v1.ParcelID, v1.PropertyAddress, v2.ParcelID, v2.PropertyAddress,
       COALESCE(v1.PropertyAddress, v2.PropertyAddress) AS toPopulate
FROM NashvilleHousing v1
JOIN NashvilleHousing v2
ON v1.ParcelID = v2.ParcelID
   AND v1.UniqueID <> v2.UniqueID -- Ensure they are not the same row
WHERE v1.PropertyAddress IS NULL;

-- Updating the table
UPDATE NashvilleHousing AS v1
JOIN NashvilleHousing AS v2
ON v1.ParcelID = v2.ParcelID
   AND v1.UniqueID <> v2.UniqueID
SET v1.PropertyAddress = COALESCE(v1.PropertyAddress, v2.PropertyAddress)
WHERE v1.PropertyAddress IS NULL;

-- Just checking
SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL;

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out PropertyAddress into Individual Columns using SUBSTRING
SELECT PropertyAddress
FROM NashvilleHousing;

SELECT
    SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address,
    SUBSTRING_INDEX(PropertyAddress, ',', -1) AS City
FROM NashvilleHousing;

-- Updating the table
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress VARCHAR(255);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity VARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING_INDEX(PropertyAddress, ',', -1);

-- Just checking
SELECT * 
FROM NashvilleHousing LIMIT 5;

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out OwnerAddress into Individual Columns
SELECT OwnerAddress
FROM NashvilleHousing;

SELECT
    SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Address,
    SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) AS City,
    SUBSTRING_INDEX(OwnerAddress, ',', -1) AS State
FROM NashvilleHousing;

-- Updating the table
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress VARCHAR(255);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity VARCHAR(255);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState VARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

UPDATE NashvilleHousing
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1);

UPDATE NashvilleHousing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', -1);

-- Just checking
SELECT * 
FROM NashvilleHousing LIMIT 5;

--------------------------------------------------------------------------------------------------------------------------

-- Change 'Y' and 'N' to 'Yes' and 'No' in "Sold as Vacant" field
SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

-- Find and replace
SELECT DISTINCT(SoldAsVacant),
       CASE 
           WHEN SoldAsVacant = 'Y' THEN 'Yes'
           WHEN SoldAsVacant = 'N' THEN 'No'
           ELSE SoldAsVacant
       END AS NewValue
FROM NashvilleHousing;

-- Updating the table
UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
                       WHEN SoldAsVacant = 'Y' THEN 'Yes'
                       WHEN SoldAsVacant = 'N' THEN 'No'
                       ELSE SoldAsVacant
                   END;

-- Just checking
SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

--------------------------------------------------------------------------------------------------------------------------

-- Remove duplicates
-- If a row has the same ParcelID, PropertyAddress, SalePrice, SaleDate, and LegalReference, it is a duplicate
WITH RowNumCTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1;

-- Now let's remove them
SELECT COUNT(*) AS beforeRemovingDuplicates
FROM NashvilleHousing;

WITH RowNumCTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM NashvilleHousing
)
DELETE 
FROM NashvilleHousing
WHERE UniqueID IN (
    SELECT UniqueID
    FROM RowNumCTE
    WHERE row_num > 1
);

-- Just checking
SELECT COUNT(*) AS afterRemovingDuplicates
FROM NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

-- A little Exploratory Data Analysis

-- Average SalePrice per YearBuilt
SELECT YearBuilt, 
       AVG(SalePrice) AS avg_saleprice,
       COUNT(SalePrice) AS num_ofHouses
FROM NashvilleHousing 
GROUP BY YearBuilt
ORDER BY YearBuilt DESC;

-- Average SalePrice per City
SELECT PropertySplitCity, 
       AVG(SalePrice) AS avg_saleprice,
       COUNT(SalePrice) AS num_ofHouses
FROM NashvilleHousing
GROUP BY PropertySplitCity
ORDER BY avg_saleprice DESC;

-- Number of houses by LandUse
SELECT LandUse, COUNT(*) AS countHouses
FROM NashvilleHousing
GROUP BY LandUse
ORDER BY countHouses DESC;
