/*

 Cleaning Data in SQL Queries

 */

 SELECT * 
 FROM PortfolioProject..NashvilleHousing
 ---------------------------------------------------------------------

 --Standardize Data Format

 SELECT SaleDateConverted, CONVERT(Date,SaleDate) SaleDate
 FROM PortfolioProject..NashvilleHousing

 UPDATE NashvilleHousing
 SET SaleDate = CONVERT(Date,SaleDate)

 ALTER TABLE NashvilleHousing
 ADD SaleDateConverted Date;

 UPDATE NashvilleHousing
 SET SaleDateConverted = CONVERT(Date,SaleDateConverted)

 ---------------------------------------------------------------------------

 -- Populate Property Address Data

 SELECT *
 FROM PortfolioProject..NashvilleHousing
 --WHERE PropertyAddress IS NULL
 ORDER BY ParcelID

 SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM PortfolioProject..NashvilleHousing a JOIN 
 PortfolioProject..NashvilleHousing b 
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
	WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a JOIN 
 PortfolioProject..NashvilleHousing b 
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]

---------------------------------------------------------------------------

-- Breaking Out Address Into Individual Columns (Address, City, State)

 SELECT PropertyAddress
 FROM PortfolioProject..NashvilleHousing
 --WHERE PropertyAddress IS NULL
 --ORDER BY ParcelID

 SELECT 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress))as Address
 FROM PortfolioProject..NashvilleHousing

 
 ALTER TABLE PortfolioProject..NashvilleHousing
 ADD PropertySplitAddress Nvarchar(255);

 UPDATE PortfolioProject..NashvilleHousing
 SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

 
 ALTER TABLE PortfolioProject..NashvilleHousing
 ADD PropertySplitCity Nvarchar(255);

 UPDATE PortfolioProject..NashvilleHousing
 SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress))

 SELECT * FROM PortfolioProject..NashvilleHousing



SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
, PARSENAME(REPLACE(OwnerAddress,',','.'),2)
, PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
 ADD OwnerSplitAddress Nvarchar(255);

 UPDATE PortfolioProject..NashvilleHousing
 SET OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress,',','.'),3)

 ALTER TABLE PortfolioProject..NashvilleHousing
 ADD OwnerSplitCity Nvarchar(255);

 UPDATE PortfolioProject..NashvilleHousing
 SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress,',','.'),2)

 ALTER TABLE PortfolioProject..NashvilleHousing
 ADD OwnerSplitState Nvarchar(255);

 UPDATE PortfolioProject..NashvilleHousing
 SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress,',','.'),1)

 ---------------------------------------------------------------------------
 -- Change Y to N to Yes and No in "Sold as Vacant" field

 SELECT Distinct SoldAsVacant, Count(SoldAsVacant)
 FROM PortfolioProject..NashvilleHousing
 GROUP BY SoldAsVacant

SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject..NashvilleHousing

UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
 ---------------------------------------------------------------------------
 
 --Remove Duplicates
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
  FROM PortfolioProject..NashvilleHousing
  --ORDER BY ParcelID
  )
  DELETE
  FROM RowNumCTE 
  WHERE row_num > 1

  ---------------------------------------------------------------------------

  --Delete Unused Columns

  SELECT *
  FROM PortfolioProject..NashvilleHousing

  ALTER TABLE PortfolioProject..NashvilleHousing
  DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

   ALTER TABLE PortfolioProject..NashvilleHousing
  DROP COLUMN SaleDate