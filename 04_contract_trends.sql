-- ============================================================
-- 04_contract_trends.sql
-- UK Government Procurement — Time Series & Trend Analysis
-- Author: Pavithra Gunasekaran
-- ============================================================

-- 1. Monthly contract volume and spend over time
SELECT
    STRFTIME('%Y-%m', award_date)           AS award_month,
    COUNT(*)                                AS contracts_awarded,
    ROUND(SUM(award_value), 2)              AS monthly_spend,
    ROUND(AVG(award_value), 2)              AS avg_contract_value
FROM contracts
WHERE award_value IS NOT NULL
  AND award_date IS NOT NULL
GROUP BY award_month
ORDER BY award_month;

-- 2. Annual procurement summary
SELECT
    STRFTIME('%Y', award_date)              AS award_year,
    COUNT(*)                                AS total_contracts,
    ROUND(SUM(award_value), 2)              AS total_spend,
    ROUND(AVG(award_value), 2)              AS avg_value,
    COUNT(DISTINCT supplier_name)           AS unique_suppliers,
    COUNT(DISTINCT department_name)         AS active_departments
FROM contracts
WHERE award_value IS NOT NULL
GROUP BY award_year
ORDER BY award_year;

-- 3. Year-on-year spend growth
WITH annual AS (
    SELECT
        STRFTIME('%Y', award_date)          AS yr,
        SUM(award_value)                    AS total_spend
    FROM contracts
    WHERE award_date IS NOT NULL
    GROUP BY yr
)
SELECT
    yr,
    ROUND(total_spend, 2)                   AS total_spend,
    ROUND(
        (total_spend - LAG(total_spend) OVER (ORDER BY yr)) 
        * 100.0 / LAG(total_spend) OVER (ORDER BY yr), 1
    )                                        AS yoy_growth_pct
FROM annual
ORDER BY yr;

-- 4. Quarterly spend trend (useful for Power BI)
SELECT
    STRFTIME('%Y', award_date)              AS yr,
    CASE STRFTIME('%m', award_date)
        WHEN '01' THEN 'Q1' WHEN '02' THEN 'Q1' WHEN '03' THEN 'Q1'
        WHEN '04' THEN 'Q2' WHEN '05' THEN 'Q2' WHEN '06' THEN 'Q2'
        WHEN '07' THEN 'Q3' WHEN '08' THEN 'Q3' WHEN '09' THEN 'Q3'
        ELSE 'Q4'
    END                                     AS quarter,
    COUNT(*)                                AS contracts,
    ROUND(SUM(award_value), 2)              AS quarterly_spend
FROM contracts
WHERE award_value IS NOT NULL
GROUP BY yr, quarter
ORDER BY yr, quarter;
