-- ============================================================
-- 01_data_exploration.sql
-- UK Government Procurement — Initial Data Exploration
-- Author: Pavithra Gunasekaran
-- ============================================================

-- 1. Preview the dataset
SELECT * FROM contracts LIMIT 10;

-- 2. Count total records
SELECT COUNT(*) AS total_contracts FROM contracts;

-- 3. Check date range of the data
SELECT 
    MIN(award_date) AS earliest_contract,
    MAX(award_date) AS latest_contract
FROM contracts;

-- 4. List all unique government departments
SELECT DISTINCT 
    department_name,
    COUNT(*) AS contract_count
FROM contracts
GROUP BY department_name
ORDER BY contract_count DESC;

-- 5. Check for nulls in key columns
SELECT
    SUM(CASE WHEN award_value IS NULL THEN 1 ELSE 0 END)     AS null_values,
    SUM(CASE WHEN department_name IS NULL THEN 1 ELSE 0 END)  AS null_departments,
    SUM(CASE WHEN supplier_name IS NULL THEN 1 ELSE 0 END)    AS null_suppliers,
    SUM(CASE WHEN award_date IS NULL THEN 1 ELSE 0 END)       AS null_dates
FROM contracts;

-- 6. Distribution of contract values
SELECT
    CASE
        WHEN award_value < 10000          THEN 'Under £10k'
        WHEN award_value < 100000         THEN '£10k – £100k'
        WHEN award_value < 1000000        THEN '£100k – £1M'
        WHEN award_value < 10000000       THEN '£1M – £10M'
        ELSE 'Over £10M'
    END AS value_band,
    COUNT(*)                              AS contract_count,
    ROUND(SUM(award_value), 2)            AS total_spend
FROM contracts
WHERE award_value IS NOT NULL
GROUP BY value_band
ORDER BY total_spend DESC;
