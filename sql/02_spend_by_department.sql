-- ============================================================
-- 02_spend_by_department.sql
-- UK Government Procurement — Spend Analysis by Department
-- Author: Pavithra Gunasekaran
-- ============================================================

-- 1. Total spend and contract count by department
SELECT
    department_name,
    COUNT(*)                                AS total_contracts,
    ROUND(SUM(award_value), 2)              AS total_spend,
    ROUND(AVG(award_value), 2)              AS avg_contract_value,
    ROUND(MAX(award_value), 2)              AS largest_contract
FROM contracts
WHERE award_value IS NOT NULL
GROUP BY department_name
ORDER BY total_spend DESC
LIMIT 20;

-- 2. Department spend as % of total government spend
SELECT
    department_name,
    ROUND(SUM(award_value), 2)              AS dept_spend,
    ROUND(
        SUM(award_value) * 100.0 / SUM(SUM(award_value)) OVER (), 2
    )                                        AS pct_of_total_spend
FROM contracts
WHERE award_value IS NOT NULL
GROUP BY department_name
ORDER BY dept_spend DESC
LIMIT 15;

-- 3. Year-on-year spend by department (top 5 departments)
SELECT
    department_name,
    STRFTIME('%Y', award_date)              AS award_year,
    COUNT(*)                                AS contracts_awarded,
    ROUND(SUM(award_value), 2)              AS annual_spend
FROM contracts
WHERE award_value IS NOT NULL
  AND department_name IN (
    SELECT department_name
    FROM contracts
    GROUP BY department_name
    ORDER BY SUM(award_value) DESC
    LIMIT 5
  )
GROUP BY department_name, award_year
ORDER BY department_name, award_year;

-- 4. Departments with highest average contract value (min 10 contracts)
SELECT
    department_name,
    COUNT(*)                                AS total_contracts,
    ROUND(AVG(award_value), 2)              AS avg_contract_value
FROM contracts
WHERE award_value IS NOT NULL
GROUP BY department_name
HAVING COUNT(*) >= 10
ORDER BY avg_contract_value DESC
LIMIT 10;
