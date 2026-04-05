# Findings Summary

**Project:** UK Government Procurement — SQL Business Intelligence Analysis  
**Author:** Pavithra Gunasekaran  
**Last Updated:** April 2026  
**Data Source:** UK Contracts Finder (data.gov.uk)

---

## Executive Summary

This analysis examined 962 awarded contracts from the UK Government Contracts Finder database, covering November 2018 to March 2026. Total procurement spend across the dataset stands at £3.74 billion. The data reveals significant concentration at both the organisation and supplier level, with a small number of entities accounting for the large majority of total spend.

---

## Key Findings

### 1. Departmental Spend
- Total spend analysed: £3.74 billion across 302 organisations
- Top spending organisation: Wandle Housing Association Limited (£2.09B, 55.8% of total)
- Transport for London ranked second at £454M (12.1%)
- Crown Commercial Service ranked third at £245M (6.6%)
- Top 5 organisations account for approximately 79% of total spend

### 2. Supplier Concentration
- Top 10 suppliers account for 81.5% of total contract value, indicating high concentration
- Largest single supplier: Architectural Decorators Limited (£2.08B), linked to Wandle Housing Association's maintenance framework
- Second largest: Otis Limited (£430M)
- KPMG LLP ranked third at £216M, reflecting significant consultancy spend
- 764 unique suppliers across 962 contracts

### 3. Contract Value Distribution
- Majority of contracts by volume fall in the £10k–£100k band (433 contracts, 45%)
- £100k–£1M band accounts for 337 contracts (35%)
- Only 27 contracts exceed £10M, but these drive a disproportionate share of total spend
- 80 contracts are under £10k (8% of volume)

### 4. Procurement Trends
- Spend was low and stable from 2019 through to mid-2024
- A significant spike occurs in late 2025, driven by the Wandle Housing Association framework contract
- Activity remains elevated into early 2026
- The spike represents an outlier that skews the overall time series

---

## Methodology Notes

- Data sourced from UK Contracts Finder (data.gov.uk), downloaded March 2026
- 38 rows removed during cleaning (null award value, date, supplier, or department)
- Negative and zero-value contracts excluded
- Supplier names standardised using title case normalisation
- Value bands defined as: <£10k, £10k–£100k, £100k–£1M, £1M–£10M, >£10M

---

## Limitations

- Dataset contains 1,000 records (export limit); full Contracts Finder database is significantly larger
- Supplier name variations may result in undercounting of some supplier totals
- Wandle Housing Association's dominance likely reflects a large framework contract rather than typical departmental procurement
- Category classification is inconsistent across organisations

---

## Visualisations

| File | Description |
|------|-------------|
| 01_spend_by_department.png | Top 10 organisations by total spend |
| 02_monthly_trend.png | Monthly spend over time (2018–2026) |
| 03_value_distribution.png | Contract volume by value band |
| 04_top_suppliers.png | Top 15 suppliers by total contract value |

---

## Next Steps

- [ ] Power BI dashboard with interactive department and supplier filters
- [ ] Expand dataset beyond 1,000 record export limit
- [ ] Cross-reference with departmental budget data
- [ ] Investigate Wandle Housing Association framework contract in detail
