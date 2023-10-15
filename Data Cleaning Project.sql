


#cleaning data in mysql queries

SELECT SaleDate
FROM data_cleaning.`nashville housing data for data cleaning`;


/*update  data_cleaning.`nashville housing data for data cleaning`
set    saledate=convert(saleDate,date);*/
#***************************************************************************************************************************************************
#populate Property Address data


select  *
from data_cleaning.`nashville housing data for data cleaning`
#where PropertyAddress is null;
order by ParcelID;


select  a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ifnull(a.PropertyAddress,b.PropertyAddress)
from data_cleaning.`nashville housing data for data cleaning` a
join data_cleaning.`nashville housing data for data cleaning` b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null;

update data_cleaning.`nashville housing data for data cleaning` a
JOIN data_cleaning.`nashville housing data for data cleaning` b on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress) 
WHERE a.PropertyAddress IS NULL;

#*********************************************************************************************************************
# breaking out address into individual columns(Address,city,state)

select  PropertyAddress
from data_cleaning.`nashville housing data for data cleaning`;

select substring(propertyAddress,1,locate(',',propertyAddress)-1),
 substring(propertyAddress,locate(',',propertyAddress)+1,length(propertyAddress))
from data_cleaning.`nashville housing data for data cleaning`;

alter table data_cleaning.`nashville housing data for data cleaning`
add  propertysplitaddress varchar(255);


update data_cleaning.`nashville housing data for data cleaning`
set propertysplitaddress=substring(propertyAddress,1,locate(',',propertyAddress)-1);


alter table data_cleaning.`nashville housing data for data cleaning`
add  propertysplitcity varchar(255);


update data_cleaning.`nashville housing data for data cleaning`
set propertysplitcity=substring(propertyAddress,locate(',',propertyAddress)+1,length(propertyAddress));

select *
from data_cleaning.`nashville housing data for data cleaning`;
#*******************************************************************************************************************************
#Chane  y and n to yes and no in "SoldAsVacant" field

select  distinct(SoldAsVacant),count(SoldAsVacant) as number
from data_cleaning.`nashville housing data for data cleaning`
group by SoldAsVacant
order by 2;



select SoldAsVacant,
case
when  SoldAsVacant="Y" then "Yes"
when   SoldAsVacant="N" then "No"
else SoldAsVacant
end as newsolid
from data_cleaning.`nashville housing data for data cleaning`;

update data_cleaning.`nashville housing data for data cleaning`
set SoldAsVacant=case
when  SoldAsVacant="Y" then "Yes"
when   SoldAsVacant="N" then "No"
else SoldAsVacant
end;

#**********************************************************************************************************

#Remove duplicates
with rownum as(
select *,row_number() over(partition by ParcelID,
                                       PropertyAddress,
                                       SalePrice,
                                       SaleDate,
                                       LegalReference
                                       order by UniqueID) as  row_num
from data_cleaning.`nashville housing data for data cleaning`
)
delete from rownum
where row_num>1;
/*order by propertyAddress;*/


#**********************************************************************************

#delete unused columns

select * 
from data_cleaning.`nashville housing data for data cleaning`;


alter table data_cleaning.`nashville housing data for data cleaning`
drop column OwnerAddress;

alter table data_cleaning.`nashville housing data for data cleaning`
drop column TaxDistrict;

