# 🏛️ UK Government Procurement — SQL Business Intelligence Analysis

![SQL](https://img.shields.io/badge/SQL-SQLite%20%2F%20PostgreSQL-blue?style=flat-square&logo=postgresql)
![Status](https://img.shields.io/badge/Status-In%20Progress-yellow?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
![Last Updated](https://img.shields.io/badge/Last%20Updated-March%202026-orange?style=flat-square)
![Data Source](https://img.shields.io/badge/Data-UK%20Contracts%20Finder-lightgrey?style=flat-square)

**Author:** Pavithra Gunasekaran  
**Domain:** Public Sector Procurement | Enterprise Data & Insights  
**Tools:** SQL · Power BI *(coming soon)* · Python EDA *(coming soon)*  
**Data Source:** [UK Government Contracts Finder — data.gov.uk](https://www.contractsfinder.service.gov.uk/Search)

---

## 📌 Project Overview

This project applies SQL-based business intelligence analysis to real UK Government procurement data from the official Contracts Finder database. It demonstrates end-to-end analytical thinking, from raw data exploration and cleaning through to spend analysis, supplier concentration, and time-series trends.

The analysis mirrors the kind of enterprise data work performed in ERP and procurement consulting environments, translating large volumes of transactional data into clear, actionable business insights.

> 💡 This project is part of an active data analytics portfolio built alongside an MRes in Digital Management (University of Hertfordshire), reflecting real-world analytical experience in regulated financial services, ERP, and procurement consulting.

---

## 🎯 Business Questions Answered

| # | Business Question |
|---|-------------------|
| 1 | Which government departments have the highest procurement spend? |
| 2 | What is the distribution of contract values across size bands? |
| 3 | Which suppliers are most frequently awarded contracts? |
| 4 | How has procurement volume and spend trended over time? |
| 5 | Are there departments with high single-supplier dependency? |
| 6 | Which supplier tiers (SME vs large) dominate by volume vs value? |

---

## 📁 Repository Structure
```
uk-procurement-sql-analysis/
│
├── sql/                           # ✅ SQL analysis scripts (complete)
│   ├── 01_data_exploration.sql    #    Initial profiling, null checks, value bands
│   ├── 02_spend_by_department.sql #    Dept spend, % of total, YoY trends
│   ├── 03_supplier_analysis.sql   #    Top suppliers, concentration, dependency flags
│   ├── 04_contract_trends.sql     #    Monthly, quarterly, annual spend trends
│   └── 05_advanced_analysis.sql   #    Window functions, rankings, cumulative spend
│
├── python/                        # 🔜 Coming soon — EDA & visualisation
├── docs/                          # 🔜 Coming soon — Findings & screenshots
│
├── requirements.txt
└── README.md
```

---

## 🗃️ Data Setup

### Download the Data

1. Visit [UK Contracts Finder Open Data](https://www.contractsfinder.service.gov.uk/Search)
2. Click **"Download data"** → choose CSV export
3. Save as `contracts_finder_raw.csv` in the `/data` folder *(not tracked in git)*

### Load into SQL
```sql
-- SQLite
.mode csv
.import data/contracts_finder_raw.csv contracts
```
```bash
# PostgreSQL
psql -U your_user -d your_db -c "\COPY contracts FROM 'data/contracts_finder_raw.csv' CSV HEADER;"
```

### Run the scripts in order
```
01_data_exploration.sql      → understand the dataset
02_spend_by_department.sql   → departmental spend analysis
03_supplier_analysis.sql     → supplier concentration
04_contract_trends.sql       → time-series trends
05_advanced_analysis.sql     → window functions & rankings
```

---

## 🔍 SQL Highlights

### Departmental spend as % of total (window function)
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
FROM ...
WHERE supplier_spend * 100.0 / total_dept_spend > 50;
```

---

## 📊 Findings

> *(To be updated once analysis is run against the full dataset)*

Screenshots and key findings will be added to `/docs` following the initial analysis run.

---

## 🗺️ Roadmap

- [x] SQL analysis scripts (exploration, spend, suppliers, trends, advanced)
- [ ] Python data cleaning script
- [ ] Python EDA & visualisation (pandas + matplotlib)
- [ ] Power BI dashboard
- [ ] Findings summary with screenshots

---

## 🛠️ Tools & Technologies

| Tool | Usage |
|------|-------|
| SQL (SQLite / PostgreSQL) | Core querying, aggregation, window functions |
| Python — pandas, matplotlib | *(coming soon)* EDA and visualisation |
| Power BI | *(coming soon)* Interactive dashboard |
| GitHub | Version control and portfolio visibility |

---

## 👩‍💼 About

Analytically driven professional with 14+ years of experience in regulated financial services, ERP, and enterprise procurement consulting. Currently upskilling in SQL, Python, and Power BI alongside an MRes in Digital Management.

📎 [LinkedIn](https://www.linkedin.com/in/pavithragunasekaran) &nbsp;|&nbsp; 📧 pavithra.gunasekaran@gmail.com &nbsp;|&nbsp; 🐙 [GitHub Portfolio](https://github.com/pavithrag-analyst)
