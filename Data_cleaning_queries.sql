-- Data cleaning using SQL queries

select *
from PortfolioProject.dbo.NashvilleHousing


-- 1. Standardize the sales date format
-- The date is in date/time format we need to convert it to date format

select SaleDateConverted
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted = convert(Date, SaleDate);


-- 2. Populate the property address data

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

-- query to see if two addressses having the same parcelId dont populate the porperty address

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject.dbo.NashvilleHousing as a
join PortfolioProject.dbo.NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Query to fill the null values on the property address with the addresses with same parcel ID.
update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as a
join PortfolioProject.dbo.NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- 3. Breaking out the address into individual columns (Address, City, State)

-- Using Substring query to separate the address and city name from the PropertyAddress column
select 
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
 
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

-- Using Parsename query to separate the address, city and state from the owneraddress column
select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

from PortfolioProject.dbo.NashvilleHousing

-- adding further tables for the split owneraddress column

alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

 

 -- 4. Change Y and N to Yes and No on the "Sold as Vacant" field.

 -- Query to see the number of Y and N or Yes and No strings inside the SoldAsVacant column

 select distinct(SoldAsVacant), count(SoldAsVacant)
 from NashvilleHousing
 group by SoldAsVacant
 order by 2
 
 -- Using the case query to replace Y and N with Yes and No on the SoldasVacant column. 
 select SoldAsVacant,
 CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	  WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE
	  SoldAsVacant
	  END
 from PortfolioProject.dbo.NashvilleHousing
    
Update NashvilleHousing
set SoldAsVacant = 
 CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	  WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE
	  SoldAsVacant
	  END


-- 5. Remove the duplicates from the columns of the table.

-- Creating a CTE for the partition of the repeated columns.

With RowNumCTE AS(
select *,
		ROW_NUMBER() OVER (
		Partition by ParcelID,
					 PropertyAddress,
					 SalePrice,
					 LegalReference
					 ORDER BY
						UniqueID
						) row_num

from PortfolioProject.dbo.NashvilleHousing
)

select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

-- 6. Delete Unused columns 

select *
from PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate, OwnerAddress, PropertyAddress, TaxDistrict