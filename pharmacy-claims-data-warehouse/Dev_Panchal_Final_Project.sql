-- ALY 6030 Final Project - Pharmacy Claims Database
-- Student Name: Dev Panchal
-- Date: December 12th, 2025

-- PART 2: DATABASE SETUP AND TABLE CREATION

-- Create and use the database
DROP DATABASE IF EXISTS pharmacy_claims;
CREATE DATABASE pharmacy_claims;
USE pharmacy_claims;

-- CREATE DIMENSION TABLES

-- Create dim_member table
CREATE TABLE dim_member (
    member_id INT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    birth_date DATE,
    age INT,
    gender CHAR(1)
);

-- Create dim_drug table
CREATE TABLE dim_drug (
    ndc INT,
    name VARCHAR(100),
    form_code CHAR(2),
    form_desc VARCHAR(100),
    brand_generic_code INT,
    brand_generic_desc VARCHAR(10)
);

-- Create fact_prescription table
CREATE TABLE fact_prescription (
    prescription_id INT,
    member_id INT,
    drug_ndc INT,
    fill_date DATE,
    copay INT,
    insurance_paid INT
);

-- Loading data from Excel Files (What I did actually)

-- ALTERNATIVE: INSERT DATA DIRECTLY (If you dont want to insert data with the data import wizard feature)

-- INSERT INTO dim_member VALUES
-- (10001, 'David', 'Dennison', '1946-06-14', 72, 'M'),
-- (10002, 'John', 'Smith', '1962-01-02', 56, 'M'),
-- (10003, 'Jane', 'Doe', '1982-05-04', 36, 'F'),
-- (10004, 'Elaine', 'Rogers', '1983-10-12', 34, 'F');

-- INSERT INTO dim_drug VALUES
-- (433530848, 'Risperidone', 'TB', 'Tablet', 1, 'Generic'),
-- (545695193, 'Amoxicillin', 'OS', 'Oral Solution', 1, 'Generic'),
-- (545693828, 'Ambien', 'TB', 'Tablet', 2, 'Brand'),
-- (185085302, 'Diprosone', 'TC', 'Topical Cream', 1, 'Generic');

-- INSERT INTO fact_prescription VALUES
-- (1, 10001, 433530848, '2017-10-31', 15, 50),
-- (2, 10001, 433530848, '2018-02-22', 15, 48),
-- (3, 10001, 433530848, '2018-05-08', 15, 55),
-- (4, 10002, 545695193, '2018-06-14', 50, 130),
-- (5, 10003, 545693828, '2017-12-30', 35, 250),
-- (6, 10003, 545693828, '2018-05-16', 35, 322),
-- (7, 10004, 185085302, '2017-11-09', 15, 600),
-- (8, 10004, 185085302, '2017-12-08', 15, 712),
-- (9, 10001, 545693828, '2018-01-15', 20, 650),
-- (10, 10001, 545693828, '2018-02-14', 20, 648),
-- (11, 10001, 545693828, '2018-03-13', 20, 648);

-- DESIGNATE PRIMARY KEYS

-- Primary Key for dim_member (Natural Key - member_id is a unique identifier from source)
ALTER TABLE dim_member
MODIFY member_id INT NOT NULL,
ADD PRIMARY KEY (member_id);

-- Primary Key for dim_drug (Natural Key - NDC is the unique drug identifier from FDA)
ALTER TABLE dim_drug
MODIFY ndc INT NOT NULL,
ADD PRIMARY KEY (ndc);

-- Primary Key for fact_prescription (Surrogate Key - created to uniquely identify each prescription fill)
ALTER TABLE fact_prescription
MODIFY prescription_id INT NOT NULL AUTO_INCREMENT,
ADD PRIMARY KEY (prescription_id);


-- DESIGNATE FOREIGN KEYS

-- Foreign Key: fact_prescription.member_id references dim_member.member_id
-- ON DELETE RESTRICT: Prevent deletion of a member if they have prescription records
-- ON UPDATE CASCADE: If member_id changes, update all related prescriptions
ALTER TABLE fact_prescription
ADD CONSTRAINT fk_member
FOREIGN KEY (member_id) REFERENCES dim_member(member_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Foreign Key: fact_prescription.drug_ndc references dim_drug.ndc
-- ON DELETE RESTRICT: Prevent deletion of a drug if it has prescription records
-- ON UPDATE CASCADE: If drug NDC changes, update all related prescriptions
ALTER TABLE fact_prescription
ADD CONSTRAINT fk_drug
FOREIGN KEY (drug_ndc) REFERENCES dim_drug(ndc)
ON DELETE RESTRICT
ON UPDATE CASCADE;



-- PART 4: ANALYTICS AND REPORTING QUERIES

-- QUERY 1: Number of prescriptions grouped by drug name

SELECT 
    d.name AS drug_name,
    COUNT(f.prescription_id) AS prescription_count
FROM fact_prescription f
INNER JOIN dim_drug d ON f.drug_ndc = d.ndc
GROUP BY d.name
ORDER BY prescription_count DESC;



-- QUERY 2: Prescription stats by age group (65+ vs <65) using CASE statement

SELECT 
    CASE 
        WHEN m.age >= 65 THEN 'age 65+'
        ELSE '< 65'
    END AS age_group,
    COUNT(f.prescription_id) AS total_prescriptions,
    COUNT(DISTINCT f.member_id) AS unique_members,
    SUM(f.copay) AS total_copay
FROM fact_prescription f
INNER JOIN dim_member m ON f.member_id = m.member_id
GROUP BY 
    CASE 
        WHEN m.age >= 65 THEN 'age 65+'
        ELSE '< 65'
    END
ORDER BY age_group DESC;



-- QUERY 3: Most recent prescription fill with insurance paid using Window Functions

SELECT 
    member_id,
    member_first_name,
    member_last_name,
    drug_name,
    fill_date AS most_recent_fill_date,
    insurance_paid AS most_recent_insurance_paid
FROM (
    SELECT 
        m.member_id,
        m.first_name AS member_first_name,
        m.last_name AS member_last_name,
        d.name AS drug_name,
        f.fill_date,
        f.insurance_paid,
        ROW_NUMBER() OVER (PARTITION BY m.member_id ORDER BY f.fill_date DESC) AS rn
    FROM fact_prescription f
    INNER JOIN dim_member m ON f.member_id = m.member_id
    INNER JOIN dim_drug d ON f.drug_ndc = d.ndc
) ranked
WHERE rn = 1
ORDER BY member_id;

