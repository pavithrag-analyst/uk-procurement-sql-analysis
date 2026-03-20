# 🏛️ UK Government Procurement — SQL Business Intelligence Analysis

**Author:** Pavithra Gunasekaran  
**Domain:** Public Sector Procurement | Enterprise Data & Insights  
**Tools:** SQL · Python (pandas) · Power BI · Excel  
**Data Source:** [UK Government Contracts Finder — data.gov.uk](https://www.contractsfinder.service.gov.uk/Search)

---

## 📌 Project Overview

This project applies SQL-based business intelligence analysis to real UK Government procurement data, sourced from the official Contracts Finder database. It demonstrates end-to-end data analysis skills, from raw data ingestion and SQL querying through to Python-based EDA and visual reporting.

The analysis focuses on identifying procurement patterns, supplier concentration, spend distribution, and contract award trends across government departments, directly mirroring the kind of enterprise data work performed in ERP and procurement consulting environments.

---

## 🎯 Business Questions Answered

| # | Business Question |
|---|-------------------|
| 1 | Which government departments have the highest procurement spend? |
| 2 | What is the distribution of contract values (SME vs large suppliers)? |
| 3 | Which suppliers are most frequently awarded contracts? |
| 4 | How has procurement volume trended over time? |
| 5 | What proportion of contracts are awarded to UK-based vs international suppliers? |
| 6 | Which procurement categories attract the highest average contract value? |
| 7 | Are there departments with unusually high single-supplier dependency? |

---

## 📁 Repository Structure

```
uk-procurement-sql-analysis/
│
├── data/                   # Raw and cleaned datasets (not tracked in git)
│   └── README.md           # Instructions to download source data
│
├── sql/                    # SQL analysis scripts
│   ├── 01_data_exploration.sql
│   ├── 02_spend_by_department.sql
│   ├── 03_supplier_analysis.sql
│   ├── 04_contract_trends.sql
│   └── 05_advanced_analysis.sql
│
├── python/                 # Python EDA scripts
│   ├── 01_data_cleaning.py
│   └── 02_eda_visualisation.py
│
├── powerbi/                # Power BI dashboard file
│   └── procurement_dashboard.pbix
│
├── docs/                   # Supporting documentation
│   └── findings_summary.md
│
├── requirements.txt
└── README.md
```

---

## 🗃️ Data Source & Setup

### Download the Data

1. Visit [UK Contracts Finder Open Data](https://www.contractsfinder.service.gov.uk/Search)
2. Select **"Download data"** → choose CSV export
3. Alternatively, download from [data.gov.uk procurement datasets](https://data.gov.uk/search?q=procurement)
4. Save the file as `contracts_finder_raw.csv` inside the `/data` folder

### Load into SQL (SQLite or PostgreSQL)

```sql
-- SQLite example
.mode csv
.import data/contracts_finder_raw.csv contracts
```

```bash
# PostgreSQL example
psql -U your_user -d your_db -c "\COPY contracts FROM 'data/contracts_finder_raw.csv' CSV HEADER;"
```

### Python Setup

```bash
pip install -r requirements.txt
```

---

## 🔍 Key Findings

> *(To be updated as analysis progresses)*

- **Top spending departments:** TBC
- **Supplier concentration:** TBC  
- **Contract value trends:** TBC  
- **SME participation rate:** TBC

---

## 📊 Dashboard Preview

> Power BI dashboard file available in `/powerbi/` folder.  
> Screenshots to be added following initial analysis run.

---

## 🛠️ Tools & Technologies

| Tool | Usage |
|------|-------|
| SQL (SQLite / PostgreSQL) | Core data querying and aggregation |
| Python — pandas, matplotlib, seaborn | EDA and visualisation |
| Power BI | Interactive dashboard reporting |
| Excel | Data validation and pivot analysis |
| GitHub | Version control and portfolio visibility |

---

## 👩‍💼 About This Project

This project is part of an active data analytics portfolio built alongside an MRes in Digital Management (University of Hertfordshire). It reflects real-world analytical work in enterprise procurement and ERP environments, translated into a structured, reproducible analysis using modern data tools.

📎 [LinkedIn](https://www.linkedin.com/in/pavithragunasekaran) | 📧 pavithra.gunasekaran@gmail.com
