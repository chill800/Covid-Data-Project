--Cleaning data in SQL queries

Select *
From PortfolioProject..Sheet1$

--Format the Date column

alter table Sheet1$
ADD PointofSale Date;

Update Sheet1$
SET PointofSale = convert(Date, SaleDate)


--Populate Property Address data

Select *
From PortfolioProject..Sheet1$
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..Sheet1$ a
join PortfolioProject..Sheet1$ b
on	a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..Sheet1$ a
join PortfolioProject..Sheet1$ b
on	a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into individual columns (Address, City, State)

select *
from PortfolioProject..Sheet1$

select SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as [Address],
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as [City]
from PortfolioProject..Sheet1$

---create a new column
alter table PortfolioProject..Sheet1$
ADD PropertyStreet Nvarchar(255);

UPDATE PortfolioProject..Sheet1$
SET PropertyStreet = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProject..Sheet1$
ADD PropertyCity Nvarchar(255);

Update PortfolioProject..Sheet1$
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))


--Split the OwnerAddress

select 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
from PortfolioProject..Sheet1$

alter table PortfolioProject..Sheet1$
ADD OwnerStreet Nvarchar(255);

UPDATE PortfolioProject..Sheet1$
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

-------

alter table PortfolioProject..Sheet1$
ADD OwnerCity Nvarchar(255);

UPDATE PortfolioProject..Sheet1$
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

---------

alter table PortfolioProject..Sheet1$
ADD OwnerState Nvarchar(255);

UPDATE PortfolioProject..Sheet1$
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)

---Change Y and N to Yes and No in Sold in Vacant field

select SoldAsVacant,
CASE
	when SoldAsVacant = 'Y' then 'Yes' 
	when SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
END 
from PortfolioProject..Sheet1$

UPDATE PortfolioProject..Sheet1$
SET SoldAsVacant = CASE
	when SoldAsVacant = 'Y' then 'Yes' 
	when SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
END 

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject..Sheet1$
group by SoldAsVacant

---Removing duplicates using a cte using row number

---Looking for duplicates

select ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference, count(*) as cnt
from PortfolioProject..Sheet1$
group by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
having COUNT(*) > 1


WITH ROWNUMCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
				uniqueID
				) row_num
from PortfolioProject..Sheet1$
)
Select *
from ROWNUMCTE
WHERE row_num > 1
order by PropertyAddress

----delete duplicates

WITH ROWNUMCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
				uniqueID
				) row_num
from PortfolioProject..Sheet1$
)
DELETE
from ROWNUMCTE
WHERE row_num > 1

----Delete Unused Columns

select *
from PortfolioProject..Sheet1$

Alter TABLE PortfolioProject..Sheet1$
DROP COLUMN SaleDate



