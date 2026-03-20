-- ============================================================
-- 05_advanced_analysis.sql
-- UK Government Procurement — Advanced & Window Function Queries
-- Author: Pavithra Gunasekaran
-- ============================================================

-- 1. Running cumulative spend over time (useful for budget tracking)
SELECT
    award_date,
    department_name,
    award_value,
    ROUND(
        SUM(award_value) OVER (
            PARTITION BY department_name
            ORDER BY award_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2
    )                                        AS cumulative_dept_spend
FROM contracts
WHERE award_value IS NOT NULL
ORDER BY department_name, award_date;

-- 2. Rank suppliers within each department by spend
SELECT
    department_name,
    supplier_name,
    ROUND(SUM(award_value), 2)              AS supplier_dept_spend,
    RANK() OVER (
        PARTITION BY department_name
        ORDER BY SUM(award_value) DESC
    )                                        AS supplier_rank_in_dept
FROM contracts
WHERE award_value IS NOT NULL
GROUP BY department_name, supplier_name
QUALIFY supplier_rank_in_dept <= 3  -- Top 3 suppliers per department
ORDER BY department_name, supplier_rank_in_dept;

-- 3. Contracts above average value for their department
SELECT
    contract_id,
    department_name,
    supplier_name,
    award_value,
    ROUND(AVG(award_value) OVER (PARTITION BY department_name), 2) AS dept_avg_value,
    ROUND(award_value - AVG(award_value) OVER (PARTITION BY department_name), 2) AS variance_from_avg
FROM contracts
WHERE award_value IS NOT NULL
HAVING award_value > dept_avg_value
ORDER BY variance_from_avg DESC
LIMIT 20;

-- 4. SME vs large supplier spend split
-- Assumes contract value < £100k is indicative of SME-scale awards
SELECT
    CASE 
        WHEN award_value < 100000 THEN 'SME-scale (< £100k)'
        WHEN award_value < 1000000 THEN 'Mid-market (£100k – £1M)'
        ELSE 'Large (> £1M)'
    END                                     AS supplier_tier,
    COUNT(*)                                AS contract_count,
    ROUND(SUM(award_value), 2)              AS total_spend,
    ROUND(AVG(award_value), 2)              AS avg_contract_value,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_contracts
FROM contracts
WHERE award_value IS NOT NULL
GROUP BY supplier_tier
ORDER BY total_spend DESC;

-- 5. Procurement category analysis (if category column exists)
SELECT
    procurement_category,
    COUNT(*)                                AS contracts,
    ROUND(SUM(award_value), 2)              AS total_spend,
    ROUND(AVG(award_value), 2)              AS avg_value,
    COUNT(DISTINCT supplier_name)           AS unique_suppliers
FROM contracts
WHERE award_value IS NOT NULL
  AND procurement_category IS NOT NULL
GROUP BY procurement_category
ORDER BY total_spend DESC
LIMIT 15;
