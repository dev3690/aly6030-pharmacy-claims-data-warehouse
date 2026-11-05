-- Dev Panchal - Assignment 2: Hospital Nursing Intervention Pilot Program

-- STEP 4a: Analysis for Leadership
-- Identify hospitals with ICU (bed_id = 4) or SICU (bed_id = 15) beds

use hospital_nursing;

select * from bed_fact;
select * from bed_type;
select * from business;

-- Query 1: Top 10 Hospitals by Total ICU or SICU License Beds (Descending)
SELECT b.business_name AS hospital_name, SUM(bf.license_beds) AS total_license_beds FROM bed_fact bf 
INNER JOIN 
    business b ON bf.ims_org_id = b.ims_org_id
INNER JOIN 
    bed_type bt ON bf.bed_id = bt.bed_id
WHERE 
    bf.bed_id IN (4, 15)  -- ICU = 4, SICU = 15
GROUP BY 
    b.business_name
ORDER BY 
    total_license_beds DESC
LIMIT 10;


-- Query 2: Top 10 Hospitals by Total ICU or SICU Census Beds (Descending)
SELECT 
    b.business_name AS hospital_name,
    SUM(bf.census_beds) AS total_census_beds
FROM 
    bed_fact bf
INNER JOIN 
    business b ON bf.ims_org_id = b.ims_org_id
INNER JOIN 
    bed_type bt ON bf.bed_id = bt.bed_id
WHERE 
    bf.bed_id IN (4, 15)  -- ICU = 4, SICU = 15
GROUP BY 
    b.business_name
ORDER BY 
    total_census_beds DESC
LIMIT 10;


-- Query 3: Top 10 Hospitals by Total ICU or SICU Staffed Beds (Descending)
SELECT 
    b.business_name AS hospital_name,
    SUM(bf.staffed_beds) AS total_staffed_beds
FROM 
    bed_fact bf
INNER JOIN 
    business b ON bf.ims_org_id = b.ims_org_id
INNER JOIN 
    bed_type bt ON bf.bed_id = bt.bed_id
WHERE 
    bf.bed_id IN (4, 15)  -- ICU = 4, SICU = 15
GROUP BY 
    b.business_name
ORDER BY 
    total_staffed_beds DESC
LIMIT 10;



-- STEP 5a: Drill Down Investigation
-- Identify hospitals with BOTH ICU and SICU beds (at least 1 of each type)


-- Query 4: Top 10 Hospitals with BOTH ICU and SICU - License Beds (Descending)
SELECT 
    b.business_name AS hospital_name,
    SUM(bf.license_beds) AS total_license_beds
FROM 
    bed_fact bf
INNER JOIN 
    business b ON bf.ims_org_id = b.ims_org_id
WHERE 
    bf.bed_id IN (4, 15)
    AND bf.ims_org_id IN (
        SELECT ims_org_id
        FROM bed_fact
        WHERE bed_id = 4 AND license_beds >= 1
    )
    AND bf.ims_org_id IN (
        SELECT ims_org_id
        FROM bed_fact
        WHERE bed_id = 15 AND license_beds >= 1
    )
GROUP BY 
    b.business_name
ORDER BY 
    total_license_beds DESC
LIMIT 10;



-- Query 5: Top 10 Hospitals with BOTH ICU and SICU - Census Beds (Descending)
SELECT 
    b.business_name AS hospital_name,
    SUM(bf.census_beds) AS total_census_beds
FROM 
    bed_fact bf
INNER JOIN 
    business b ON bf.ims_org_id = b.ims_org_id
WHERE 
    bf.bed_id IN (4, 15)
    AND bf.ims_org_id IN (
        SELECT ims_org_id
        FROM bed_fact
        WHERE bed_id = 4 AND census_beds >= 1
    )
    AND bf.ims_org_id IN (
        SELECT ims_org_id
        FROM bed_fact
        WHERE bed_id = 15 AND census_beds >= 1
    )
GROUP BY 
    b.business_name
ORDER BY 
    total_census_beds DESC
LIMIT 10;


-- Query 6: Top 10 Hospitals with BOTH ICU and SICU - Staffed Beds (Descending)
SELECT 
    b.business_name AS hospital_name,
    SUM(bf.staffed_beds) AS total_staffed_beds
FROM 
    bed_fact bf
INNER JOIN 
    business b ON bf.ims_org_id = b.ims_org_id
WHERE 
    bf.bed_id IN (4, 15)
    AND bf.ims_org_id IN (
        SELECT ims_org_id
        FROM bed_fact
        WHERE bed_id = 4 AND staffed_beds >= 1
    )
    AND bf.ims_org_id IN (
        SELECT ims_org_id
        FROM bed_fact
        WHERE bed_id = 15 AND staffed_beds >= 1
    )
GROUP BY 
    b.business_name
ORDER BY 
    total_staffed_beds DESC
LIMIT 10;


