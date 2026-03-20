-- ============================================================
-- 03_supplier_analysis.sql
-- UK Government Procurement — Supplier Concentration Analysis
-- Author: Pavithra Gunasekaran
-- ============================================================

-- 1. Top 20 suppliers by total contract value
SELECT
    supplier_name,
    COUNT(*)                                AS contracts_won,
    ROUND(SUM(award_value), 2)              AS total_value,
    ROUND(AVG(award_value), 2)              AS avg_contract_value
FROM contracts
WHERE award_value IS NOT NULL
GROUP BY supplier_name
ORDER BY total_value DESC
LIMIT 20;

-- 2. Supplier concentration — what % of spend goes to top 10 suppliers
WITH supplier_spend AS (
    SELECT
        supplier_name,
        SUM(award_value) AS total_spend
    FROM contracts
    WHERE award_value IS NOT NULL
    GROUP BY supplier_name
),
ranked AS (
    SELECT *,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
        SUM(total_spend) OVER ()                AS grand_total
    FROM supplier_spend
)
SELECT
    supplier_name,
    ROUND(total_spend, 2)                   AS supplier_spend,
    spend_rank,
    ROUND(total_spend * 100.0 / grand_total, 2) AS pct_of_total
FROM ranked
WHERE spend_rank <= 10
ORDER BY spend_rank;

-- 3. Suppliers working across multiple departments (potential strategic partners)
SELECT
    supplier_name,
    COUNT(DISTINCT department_name)         AS departments_served,
    COUNT(*)                                AS total_contracts,
    ROUND(SUM(award_value), 2)              AS total_value
FROM contracts
WHERE award_value IS NOT NULL
GROUP BY supplier_name
HAVING COUNT(DISTINCT department_name) > 3
ORDER BY departments_served DESC, total_value DESC
LIMIT 15;

-- 4. Single-supplier dependency by department
-- Flags departments where one supplier holds >50% of their total spend
WITH dept_total AS (
    SELECT department_name, SUM(award_value) AS dept_spend
    FROM contracts
    GROUP BY department_name
),
supplier_dept AS (
    SELECT department_name, supplier_name, SUM(award_value) AS supplier_spend
    FROM contracts
    GROUP BY department_name, supplier_name
)
SELECT
    sd.department_name,
    sd.supplier_name,
    ROUND(sd.supplier_spend, 2)             AS supplier_spend,
    ROUND(dt.dept_spend, 2)                 AS total_dept_spend,
    ROUND(sd.supplier_spend * 100.0 / dt.dept_spend, 1) AS pct_of_dept_spend
FROM supplier_dept sd
JOIN dept_total dt ON sd.department_name = dt.department_name
WHERE sd.supplier_spend * 100.0 / dt.dept_spend > 50
ORDER BY pct_of_dept_spend DESC;
