--cleaning data
select * 
from [nashville housing]

--standadize date format
select salesDateconverted, convert(date, saleDate)
from [nashville housing]

update portfoilioproject..[nashville housing]
set saleDate = convert(date, saleDate)

alter table [nashville housing]
add salesdateconverted date

update [nashville housing]
set salesDateconverted = convert(date, saleDate)

-- populating property address
select *
from [nashville housing]
--where propertyaddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
---isnull(a.PropertyAddress, b.PropertyAddress)
from [nashville housing]  a
join [Nashville Housing]  b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from [nashville housing]  a
join [Nashville Housing]  b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

--breaking out address into individual (address, city, states)
select *--PropertyAddress
from [nashville housing]
--where propertyaddress is null
order by ParcelID

--we will use the substring and a character index

SELECT 
    SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) - 1) AS street_address,
    SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 2, LEN(propertyaddress)) AS city
FROM 
    [nashville housing];
-- the second substring has plus +2 because we start extracting the characters two places after the comma.
alter table [nashville housing]
add propertysplitaddress nvarchar(255)

update [Nashville Housing]
set propertysplitaddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 


alter table [nashville housing]
add propertysplitcity nvarchar(255)

update [Nashville Housing]
set propertysplitcity = SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress) +2, len(propertyaddress)) 


select *
from [Nashville Housing]

--separating the onweraddress like with did with the propertyaddress but this we will use the parse function

select *
from [Nashville Housing]

select 
PARSENAME(replace(owneraddress, ',', '.'), 3),
PARSENAME(replace(owneraddress, ',', '.'), 2), 
PARSENAME(replace(owneraddress, ',', '.'), 1) 
from [Nashville Housing]

alter table [Nashville Housing]
add owneraddresssplitaddress nvarchar(255)

update [Nashville Housing]
set OwnerAddresssplitaddress = PARSENAME(replace(owneraddress, ',', '.'), 3)

alter table [Nashville Housing]
add owneraddresssplitcity nvarchar(255)

update [Nashville Housing]
set OwnerAddresssplitcity = PARSENAME(replace(owneraddress, ',', '.'), 2)

alter table [Nashville Housing]
add owneraddresssplitstate nvarchar(255)

update [Nashville Housing]
set OwnerAddresssplitstate = PARSENAME(replace(owneraddress, ',', '.'), 1)

select distinct(SoldAsVacant),  count(soldasvacant)
from [Nashville Housing]
group by soldasvacant
order by 2

--same as the same above

SELECT SoldAsVacant, COUNT(*) AS Count
FROM [Nashville Housing]
GROUP BY SoldAsVacant
order by 2

select SoldAsVacant,
case 
  when SoldAsVacant = 'y' then 'yes'
  when SoldAsVacant = 'n' then 'no'
  else SoldAsVacant
  end
FROM [Nashville Housing]

update [Nashville Housing]
set SoldAsVacant =case 
  when SoldAsVacant = 'y' then 'yes'
  when SoldAsVacant = 'n' then 'no'
  else SoldAsVacant
  end


--remove duplicates using CTE
with rownumcte as(
select *,
row_number() over (partition by parcelid, propertyaddress, saledate, 
legalreference
order by uniqueid) row_num
from portfoilioproject..[Nashville Housing]
--order by ParcelID
)

select* from rownumcte
where row_num > 1
order by PropertyAddress

--delete unused coloumns

select *
from portfoilioproject..[Nashville Housing]

alter table portfoilioproject..[nashville housing]
drop column owneraddress, propertyaddress, taxdistrict


alter table portfoilioproject..[nashville housing]
drop column saledate