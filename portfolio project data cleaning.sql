


Select *
From [housing project].dbo.nashvilleproject

--standardise sale date
Select SaleDateConverted, CONVERT(Date,SaleDate)
From [housing project].dbo.nashvilleproject



update nashvilleproject
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE nashvilleproject
Add SaleDateConverted Date;

Update nashvilleproject
SET SaleDateConverted = CONVERT(Date,SaleDate)

--populate property  address data


Select *
From [housing project].dbo.nashvilleproject
--Where propertyaddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [housing project].dbo.nashvilleproject a
JOIN [housing project].dbo.nashvilleproject b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null


Update a
SET propertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [housing project].dbo.nashvilleproject a
JOIN [housing project].dbo.nashvilleproject b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null


--breaking out address into individual columns address,city,state



Select PropertyAddress
From [housing project].dbo.nashvilleproject
--order by ParcelID
--Where a.PropertyAddress is null



SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress))as Address

From [housing project].dbo.nashvilleproject

ALTER TABLE nashvilleproject
Add PropertySplitAddress nvarchar(255);

Update nashvilleproject
SET PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )


ALTER TABLE nashvilleproject
Add PropertySplitCity nvarchar(255);

Update nashvilleproject
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From [housing project].dbo.nashvilleproject


Select OwnerAddress
From [housing project].dbo.nashvilleproject

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From [housing project].dbo.nashvilleproject

ALTER TABLE nashvilleproject
Add OwnerSplitAddress nvarchar(255);

Update nashvilleproject
SET OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE nashvilleproject
Add OwnerSplitCity nvarchar(255);

Update nashvilleproject
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


ALTER TABLE nashvilleproject
Add OwnerSplitState nvarchar(255);

Update nashvilleproject
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


Select *
From [housing project].dbo.nashvilleproject

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [housing project].dbo.nashvilleproject
group by SoldAsVacant
order by 2


Select SoldAsvacant
,CASE when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant
		END
From [housing project].dbo.nashvilleproject

Update nashvilleproject
Set SoldAsvacant = CASE when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant
		END

	--remove duplicates
WITH RowNumCTE AS(	
Select*,
ROW_NUMBER()OVER (
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY 
				UniqueID
				) row_num


From [housing project].dbo.nashvilleproject
--order by ParcelID
)
sELECT*
from RowNumCTE
where row_num > 1
--order by PropertyAddress


--DELETE UNUSED COLUMNS


Select*
From [housing project].dbo.nashvilleproject


ALTER TABLE [housing project].dbo.nashvilleproject
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [housing project].dbo.nashvilleproject
DROP COLUMN SaleDate