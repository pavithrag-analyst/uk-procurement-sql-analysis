# 🏛️ UK Government Procurement - SQL Business Intelligence Analysis

![SQL](https://img.shields.io/badge/SQL-PostgreSQL%20%2F%20SQLite-blue?style=flat-square&logo=postgresql)
![Python](https://img.shields.io/badge/Python-pandas%20%7C%20matplotlib-blue?style=flat-square&logo=python)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?style=flat-square&logo=powerbi)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat-square)
![Data Source](https://img.shields.io/badge/Data-UK%20Contracts%20Finder-lightgrey?style=flat-square)

**Author:** Pavithra Gunasekaran
**Domain:** Public Sector Procurement | Enterprise Data & Insights
**Tools:** SQL · Python (pandas, matplotlib) · Power BI
**Data Source:** [UK Government Contracts Finder - data.gov.uk](https://www.contractsfinder.service.gov.uk/Search)

---

## 📌 Project Overview

This project applies SQL-based business intelligence analysis to real UK Government procurement data sourced from the official Contracts Finder database. It covers end-to-end analytical work: raw data ingestion and cleaning, SQL querying across five analytical layers, Python EDA and visualisation, and a Power BI dashboard for interactive reporting.

The analysis identifies procurement spend patterns, supplier concentration risk, contract value distribution, and award trends across government departments — the kind of structured, evidence-based insight work relevant to public sector, financial services, and enterprise consulting environments.

**Dataset:** 962 awarded contracts | £3.74 billion total spend | November 2018 to March 2026 | 302 organisations | 764 unique suppliers

---

## 🎯 Business Questions Answered

| # | Business Question |
|---|-------------------|
| 1 | Which government departments have the highest procurement spend? |
| 2 | What is the distribution of contract values across size bands? |
| 3 | Which suppliers are most frequently awarded contracts, and how concentrated is the spend? |
| 4 | How has procurement volume and spend trended over time? |
| 5 | Are there departments with high single-supplier dependency risk? |
| 6 | How does spend split across SME-scale, mid-market, and large contracts? |
| 7 | Which suppliers serve the broadest range of departments? |

---

## 🔍 Key Findings

### Departmental Spend
- Total spend across 302 organisations: **£3.74 billion**
- **Wandle Housing Association** is the top spending organisation at £2.09B (55.8% of total), most likely reflecting a large maintenance framework contract rather than typical departmental procurement
- **Transport for London** ranked second at £454M (12.1%), **Crown Commercial Service** third at £245M (6.6%)
- The top 5 organisations account for approximately **79% of total spend** - significant concentration at the portfolio level

### Supplier Concentration
- **Top 10 suppliers account for 81.5% of total contract value** - a high concentration ratio indicating structural dependency risk
- Largest single supplier: Architectural Decorators Limited (£2.08B), tied to the Wandle framework
- **KPMG LLP** ranks third at £216M, reflecting material consultancy spend across departments
- **Serco's** presence in the top 15 (despite being a major public sector contractor) suggests the 1,000-record export is a sample, not the full Contracts Finder database

### Contract Value Distribution
- The most common contract band by volume is **£10k–£100k** (433 contracts, 45% of total)
- **£100k–£1M** accounts for 337 contracts (35%)
- Only **27 contracts exceed £10M**, but these disproportionately drive total spend
- **80 contracts are under £10k** (8% by volume - SME-scale awards)
- Median contract value: **£93,318** - a better indicator of typical contract size than the mean
- Mean contract value: £3.89M (skewed significantly by large outliers)

### Procurement Trends
- Data spans **November 2018 to March 2026**
- Monthly trend analysis shows spend variability throughout the period, with notable peaks visible in the time series
- Year-on-year analysis highlights periods of elevated procurement activity

---

## 📁 Repository Structure

```
uk-procurement-sql-analysis/
│
├── sql/                          # SQL analysis scripts (complete)
│   ├── 01_data_exploration.sql   # Data profiling, null checks, value band distribution
│   ├── 02_spend_by_department.sql# Departmental spend, % of total, YoY trends
│   ├── 03_supplier_analysis.sql  # Top suppliers, concentration, dependency flags
│   ├── 04_contract_trends.sql    # Monthly, quarterly, annual spend trends
│   └── 05_advanced_analysis.sql  # Window functions, rankings, cumulative spend
│
├── python/                       # Python EDA scripts (complete)
│   ├── 01_data_cleaning.py       # Data ingestion, column standardisation, cleaning
│   └── 02_eda_visualisation.py   # EDA charts and visualisation outputs
│
├── powerbi/                      # Power BI dashboard
│   └── procurement_dashboard.pbix
│
├── docs/                         # Supporting documentation and visuals
│   ├── findings_summary.md       # Full findings write-up
│   ├── 01_spend_by_department.png
│   ├── 02_monthly_trend.png
│   ├── 03_value_distribution.png
│   └── 04_top_suppliers.png
│
├── data/                         # Raw data (not tracked in git)
│   └── README.md                 # Instructions to download source data
│
├── requirements.txt
└── README.md
```

---

## 🛠️ SQL Highlights

### Department spend as % of total (window function)
```sql
SELECT
    department_name,
    ROUND(SUM(award_value), 2) AS dept_spend,
    ROUND(
        SUM(award_value) * 100.0 / SUM(SUM(award_value)) OVER (), 2
    ) AS pct_of_total_spend
FROM contracts
WHERE award_value IS NOT NULL
GROUP BY department_name
ORDER BY dept_spend DESC;
```

### Flagging single-supplier dependency by department
```sql
SELECT department_name, supplier_name,
    ROUND(supplier_spend * 100.0 / total_dept_spend, 1) AS pct_of_dept_spend
FROM supplier_dept sd
JOIN dept_total dt ON sd.department_name = dt.department_name
WHERE sd.supplier_spend * 100.0 / dt.dept_spend > 50
ORDER BY pct_of_dept_spend DESC;
```

### Ranking suppliers within each department (window function)
```sql
SELECT
    department_name,
    supplier_name,
    ROUND(SUM(award_value), 2) AS supplier_dept_spend,
    RANK() OVER (
        PARTITION BY department_name
        ORDER BY SUM(award_value) DESC
    ) AS supplier_rank_in_dept
FROM contracts
GROUP BY department_name, supplier_name
ORDER BY department_name, supplier_rank_in_dept;
```

---

## 🗃️ Data Setup

### Download the Data
1. Visit [UK Contracts Finder Open Data](https://www.contractsfinder.service.gov.uk/Search)
2. Click **Download data** and export as CSV
3. Save as `contracts_finder_raw.csv` in the `/data` folder (not tracked in git)

### Load into SQL
```bash
# SQLite
.mode csv
.import data/contracts_finder_raw.csv contracts

# PostgreSQL
psql -U your_user -d your_db -c "\COPY contracts FROM 'data/contracts_finder_raw.csv' CSV HEADER;"
```

### Python Setup
```bash
pip install -r requirements.txt
python python/01_data_cleaning.py
python python/02_eda_visualisation.py
```

### Run SQL scripts in order
```
01_data_exploration.sql      → profile the dataset
02_spend_by_department.sql   → departmental spend analysis
03_supplier_analysis.sql     → supplier concentration
04_contract_trends.sql       → time-series trends
05_advanced_analysis.sql     → window functions and rankings
```

---

## 🛠️ Tools & Technologies

| Tool | Usage |
|------|-------|
| SQL (SQLite / PostgreSQL / MySQL) | Core querying, aggregation, window functions |
| Python - pandas, matplotlib, seaborn | Data cleaning, EDA, visualisation |
| Power BI | Interactive dashboard with department and supplier filters |
| GitHub | Version control and portfolio visibility |

---

## Key Skills Demonstrated

- Complex SQL: joins, aggregations, CTEs, window functions (RANK, SUM OVER, LAG)
- Exploratory data analysis and data cleaning in Python (pandas)
- Supplier concentration and dependency risk analysis
- Time-series trend analysis across a 7-year dataset
- Translating raw transactional data into structured business insight
- Identifying data quality issues and documenting analytical limitations honestly

---

## Methodology and Limitations

- 962 contracts analysed after removing 38 rows with null values or zero/negative award amounts
- Supplier names standardised via title case normalisation; bracket artefacts from raw CSV export removed
- Dataset represents a 1,000-record export from Contracts Finder — the full database is significantly larger
- Wandle Housing Association's dominance (55.8% of spend) reflects a large framework contract, not typical departmental procurement patterns
- Category classification is inconsistent across organisations in the source data

---

📎 [LinkedIn](https://www.linkedin.com/in/pavithragunasekaran) | 📧 pavithra.gunasekaran@gmail.com | 🐙 [GitHub Portfolio](https://github.com/pavithrag-analyst)
