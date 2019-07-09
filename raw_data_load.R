## Running the data_queries in SQL

#property_event<-dbGetQuery(con,"select* from PROPERTY.PD_PROPERTY_EVENT")

brightline_nw<-dbGetQuery(con,"
select DISTINCT
b.TITLE_NO,
d.title_SK,
b.title_type,
CASE WHEN e.building_name = 'Not applicable' THEN '' ELSE e.building_name end as building_name,
TRIM(e.address||' '||e.suburb||' '||e.town) as Address,
e.town as city,
a.seller_ird_number as ird_number, /*IRD Numbers on tax statement*/
c.PERIOD_START AS PURCHASE_DATE, /*Date that seller aquired property*/
/*c.IR_ENTITY_TYPES AS SALES_ENTITY,*/
/*c.NOTIONAL_TRANSFER_IND AS OWNER_NOTIONAL, /*This flag indicates that seller originally aquired property through notional transfer*/
a.seller_instr_nbr AS inst_no ,
a.seller_settlement_date AS SALE_DATE, 
a.seller_dwelling_on_land AS dwelling_on_land,
a.seller_non_resident_flag AS non_resident_flag,
f.land_use_desc,
f.category_desc as home_category,
f.property_type as property_type,
a.seller_country_code AS country_code,
a.seller_exemption_code AS exemption_code

/*LINZ Tax Statement data*/
FROM property.pd_tax_stmt_owner a

/*--Identify the date the seller aquired the property so we can limit to only transactions that would meet brightline criteria if not for Home Exemption*/
JOIN PROPERTY.PD_TITLE_OWNERSHIP_PERIOD c
ON a.seller_instr_id = c.next_instr_id

/*Identify the entity that actually sold (could have 3 owners that bought the property but only 1 sells their share but is liable under brightline*/
JOIN PROPERTY.PD_TOP_OWNER aa
ON c.top_sk = aa.TOP_SK
AND aa.owner_sk = a.owner_sk

/*--Identifying if sale was a notional transfer*/
LEFT JOIN PROPERTY.PD_TITLE_OWNERSHIP_PERIOD d
ON c.next_instr_id = d.instr_id

/*--Identifying Title Number of property sold*/
LEFT JOIN property.pd_title b
ON d.title_sk= b.title_sk

/*Property Address*/
LEFT JOIN PROPERTY.PD_PROPERTY_ADDRESS e
ON d.TITLE_SK = e.title_sk

/*Identify land use code so we can limit to residential land only*/
LEFT JOIN PROPERTY.PD_PROPERTY_HISTORY f
ON b.qpid = f.qpid
AND f.CURRENT_FLAG = 'Y'



WHERE
a.seller_settlement_date  BETWEEN TO_DATE('29/03/2018','dd/mm/yy') AND TO_DATE('31/05/2019','dd/mm/yy')
/*a.seller_settlement_date  > TO_DATE('01/10/2016','dd/mm/yy') AND  c.PERIOD_START > TO_DATE('01/10/2016','dd/mm/yy')*/
AND a.SELLER_EXEMPTION_CODE IS NULL
AND (a.seller_settlement_date-c.PERIOD_START) < 730
AND c.NOTIONAL_TRANSFER_IND = 'N' 
AND d.NOTIONAL_TRANSFER_IND = 'N'
AND c.event_type_sk = 3 /*transfer only(purchase)*/
AND d.event_type_sk = 3 /*transfer only(sale)*/
AND
(f.property_type = 'Residential' 
OR f.land_use_desc LIKE '%Residential'
OR f.land_use_desc LIKE '%Lifestyle')
")

property_all<-dbGetQuery(con,"select DISTINCT
b.TITLE_NO,
d.title_SK,
b.title_type,
CASE WHEN e.building_name = 'Not applicable' THEN '' ELSE e.building_name end as building_name,
TRIM(e.address||' '||e.suburb||' '||e.town) as Address,
e.town as city,
a.seller_ird_number as ird_number, /*IRD Numbers on tax statement*/
c.PERIOD_START AS PURCHASE_DATE, /*Date that seller aquired property*/
/*c.IR_ENTITY_TYPES AS SALES_ENTITY,*/
/*c.NOTIONAL_TRANSFER_IND AS OWNER_NOTIONAL, /*This flag indicates that seller originally aquired property through notional transfer*/
a.seller_instr_nbr AS inst_no ,
a.seller_settlement_date AS SALE_DATE, 
a.seller_dwelling_on_land AS dwelling_on_land,
a.seller_non_resident_flag AS non_resident_flag,
f.land_use_desc,
f.category_desc as home_category,
f.property_type as property_type,
a.seller_country_code AS country_code,
a.seller_exemption_code AS exemption_code

/*LINZ Tax Statement data*/
FROM property.pd_tax_stmt_owner a

/*--Identify the date the seller aquired the property so we can limit to only transactions that would meet brightline criteria if not for Home Exemption*/
JOIN PROPERTY.PD_TITLE_OWNERSHIP_PERIOD c
ON a.seller_instr_id = c.next_instr_id

/*Identify the entity that actually sold (could have 3 owners that bought the property but only 1 sells their share but is liable under brightline*/
JOIN PROPERTY.PD_TOP_OWNER aa
ON c.top_sk = aa.TOP_SK
AND aa.owner_sk = a.owner_sk

/*--Identifying if sale was a notional transfer*/
LEFT JOIN PROPERTY.PD_TITLE_OWNERSHIP_PERIOD d
ON c.next_instr_id = d.instr_id

/*--Identifying Title Number of property sold*/
LEFT JOIN property.pd_title b
ON d.title_sk= b.title_sk

/*Property Address*/
LEFT JOIN PROPERTY.PD_PROPERTY_ADDRESS e
ON d.TITLE_SK = e.title_sk

/*Identify land use code so we can limit to residential land only*/
LEFT JOIN PROPERTY.PD_PROPERTY_HISTORY f
ON b.qpid = f.qpid
AND f.CURRENT_FLAG = 'Y'
WHERE
a.seller_settlement_date  BETWEEN TO_DATE('29/03/2018','dd/mm/yy') AND TO_DATE('31/05/2019','dd/mm/yy')
/*a.seller_settlement_date  > TO_DATE('01/10/2016','dd/mm/yy') AND  c.PERIOD_START > TO_DATE('01/10/2016','dd/mm/yy')
AND a.SELLER_EXEMPTION_CODE IS NULL
AND (a.seller_settlement_date-c.PERIOD_START) < 730
AND c.NOTIONAL_TRANSFER_IND = 'N' 
AND d.NOTIONAL_TRANSFER_IND = 'N'
AND c.event_type_sk = 3 
AND d.event_type_sk = 3 
AND
(f.property_type = 'Residential' 
OR f.land_use_desc LIKE '%Residential'
OR f.land_use_desc LIKE '%Lifestyle')*/
")

dbDisconnect(con)


