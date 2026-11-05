# Pharmacy Claims Data Warehouse

Four SQL and data-warehousing assignments from Northeastern's ALY6030 Data Warehousing and SQL course (instructor Na, Yu, Fall 2025, CRN 70226), in MySQL. Each assignment takes a flat file and turns it into a proper warehouse design — normalising it, naming its facts and dimensions, building a star schema, and then answering a real question with SQL.

## In plain language

A data warehouse is a database built for questions, not for day-to-day data entry. The raw data arrives as one wide, messy spreadsheet. The work here is to split it into clean tables — facts (the numbers you measure) and dimensions (the things you slice those numbers by) — so the same data can be summed, grouped, and compared without double-counting or contradictions. These four assignments practise that on four very different datasets: startup funding, hospital beds, public housing inspections, and pharmacy claims.

## What is in this repo

### Startup Funding Normalization and a Recipes Database
Folder: `startup-funding-normalization-and-recipes-database/` Files: `Dev_Panchal_Assignment_1.docx`, `Dev_Panchal_Assignment1.pdf`, `Dev_Panchal_Assignment_1.sql`, `recipes.sql` Data: `data/techcrunch.csv` — 523 startup funding events.
What it does: two parts. First, the TechCrunch funding table is checked against the normal forms. `fund_id` (1 to 523, unique, never repeated or NULL) is the right primary key; `company` is not — Facebook alone appears 7 times, for different funding rounds, including three separate Series C rounds. The table satisfies 1NF and 2NF, with the remaining issues explained in the report. Second, a recipes database is built from `recipes.sql` (Chicken Marsala and Absolute Brownies as seed data), and `Dev_Panchal_Assignment_1.sql` adds two new recipes — Masala Chai (Beverage) and Aloo Paratha (Bread) — with their ingredients and recipe-to-ingredient links, then joins all four tables to return everything about just those two new recipes, sorted by category, recipe, and ingredient.

### Hospital Nursing: Which Hospitals Should Host a Pilot Program?
Folder: `hospital-nursing-icu-sicu-beds/` Files: `Dev_Panchal_Assignment_2.sql`, `Dev_Panchal_Assignment_2.docx` Data: `data/bed_fact.csv`, `data/bed_type.csv`, `data/business.csv` Chart: `images/StarSchemaDiagram.png`
What it does: a star schema for a hospital nursing intervention pilot. The fact table is `bed_fact` (license beds, census beds, staffed beds — all additive facts); the dimensions are `business` (hospital) and `bed_type` (ICU, SICU, and others). The queries rank hospitals by ICU (bed_id 4) or SICU (bed_id 15) beds. Top of each list: Phoenix Childrens Hospital leads on license beds with 247, Shands Hospital at the University of Florida leads on census beds with 167, and Vidant Medical Center leads on staffed beds with 203. A drill-down then looks only at hospitals with both ICU and SICU beds. The recommendation, from the report, is two pilot sites: University of Maryland Medical Center (220 license beds, 127 census, 171 staffed, in the both-ICU-and-SICU ranking) and Shands Hospital at the University of Florida (167 on all three measures in that ranking).

### Public Housing Inspections: When Inspection Costs Rise
Folder: `public-housing-inspections-star-schema/` Files: `DevPanchal_Assginment3.sql`, `DevPanchal_Assignment3.docx`, `DevPanchal_Assingment3.xlsx`, `DevPanchal_assingment.csv` (query output) Data: `data/public_housing_inspection_data.csv` — 6,464 inspection rows.
What it does: a star schema design for public housing inspections. Two facts: cost of inspection in dollars (fully additive — it can be summed across any dimension) and inspection score 0–100 (semi-additive — it can be averaged, not summed). Three dimensions: time (inspection date), public housing agency, and development/location. The design recommends two fact tables — a transaction fact table, one row per inspection, and a monthly periodic snapshot for cost summaries — and SCD Type 2 (keep history) for agency names and addresses that change through mergers. The SQL uses `ROW_NUMBER()` and `LEAD()` to compare each agency's most recent inspection cost with its second most recent, reporting the change and percentage change, only where the cost rose. `DevPanchal_assingment.csv` is that query's output (255 rows), not source data.

### Pharmacy Claims Data Warehouse: The Final Project
Folder: `pharmacy-claims-data-warehouse/` Files: `Dev_Panchal_Final_Project.sql`, `Dev_Panchal_Final_Project.docx`, `Dev_Panchal_Final_Project_ERD.pdf` Data: `data/dim_member.csv`, `data/dim_drug.csv`, `data/fact_prescription.csv`
What it does: the final project, and the one this repo is named after. A pharmacy benefit manager's flat file had every patient's full profile repeated on every prescription row, every drug's full record repeated on every fill, and fills stored sideways as `fill_date1, fill_date2, fill_date3` with matching copay and insurance-paid columns — capped at three fills per member-drug pair. It is normalised into a star schema: `dim_member` (4 members), `dim_drug` (4 drugs, keyed by FDA National Drug Code), and `fact_prescription` (11 fills, unpivoted from the original 5-row source). Primary keys are natural keys for the dimensions (member_id, NDC) and a surrogate auto-increment key for the fact table. Foreign keys use ON DELETE RESTRICT and ON UPDATE CASCADE. The analytics queries count prescriptions by drug, compare age groups with a CASE statement (65+ vs under 65), and find each member's most recent fill with `ROW_NUMBER()`.

## How to use it

1. Install MySQL (MySQL Workbench works well).
2. Run `recipes.sql` first for Assignment 1 — it creates and seeds the `recipes` database. Then run `Dev_Panchal_Assignment_1.sql` in it.
3. For the other assignments, load the CSVs in `data/` into the database names the SQL files use (`hospital_nursing`, `public_housing_inspections`, `pharmacy_claims`), then run the matching `.sql` file.
4. Read the matching `.docx` report for the written-up design, tables, and findings.

## Tools

MySQL, SQL (DDL, joins, window functions, CASE), star schema and Kimball warehouse design (facts, dimensions, grain, SCD Type 2, transaction vs periodic snapshot fact tables), normalisation to 3NF, MySQL Workbench.

## What was left out, and why

Only the submitted version of each assignment (code + report, plus the Module 4 workbook for Assignment 3) is included. Near-duplicate files under a "DevPatel" name, class practice SQL files, professor slides and assignment instruction sheets, and the MySQL Workbench model file are not included. `techcrunch.csv` is in `data/` because it sits in the Assignment 1 folder and the report analyses it, even though the recipes SQL reads the `recipes` database, not that CSV — the README says so rather than pretending otherwise.

## Conclusion

Together, the four assignments show the full arc of warehouse work: prove a table is (or is not) normalised, name what is a fact and what is a dimension, draw the star schema, build it in SQL with keys that actually enforce the rules, and then answer the question the business asked — which hospitals to pilot in, which agencies' inspection costs are rising, and how pharmacy claims should be stored so they can be counted honestly. A reader who works through them in order will have seen the same method applied to four datasets that could hardly be more different, and that is the point: the warehouse discipline is the same, whatever the data is about.
