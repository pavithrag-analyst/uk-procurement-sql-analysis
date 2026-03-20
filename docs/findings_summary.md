# Findings Summary

**Project:** UK Government Procurement — SQL Business Intelligence Analysis  
**Author:** Pavithra Gunasekaran  
**Last Updated:** *(update when analysis is complete)*

---

## Executive Summary

> *(Complete this section after running the analysis)*

This analysis examined UK government procurement data from the Contracts Finder database. Key findings highlight spend concentration across departments, supplier dependency patterns, and procurement trends over time.

---

## Key Findings

### 1. Departmental Spend
- Top spending department: TBC
- Top 5 departments account for approximately TBC% of total spend
- Notable observation: TBC

### 2. Supplier Concentration
- Top 10 suppliers account for TBC% of total contract value
- TBC departments show single-supplier dependency (>50% spend to one supplier)
- Most diversified department: TBC

### 3. Contract Value Distribution
- Majority of contracts (by volume) fall in the TBC value band
- Majority of spend (by value) is concentrated in TBC+ contracts
- SME-scale contracts (<£100k) represent TBC% of contract volume

### 4. Procurement Trends
- Overall spend trend: TBC (increasing / stable / decreasing)
- Peak procurement month/quarter: TBC
- Year-on-year growth: TBC%

---

## Methodology Notes

- Data sourced from UK Contracts Finder (data.gov.uk)
- Null values and negative contract values excluded from analysis
- Supplier names standardised using title case normalisation
- Value bands defined as: <£10k, £10k–£100k, £100k–£1M, £1M–£10M, >£10M

---

## Limitations

- Contract Finder data relies on self-reporting by departments — coverage may be incomplete
- Supplier name variations may result in undercounting of some supplier totals
- Category classification is inconsistent across departments

---

## Next Steps

- [ ] Add Power BI dashboard with interactive filters
- [ ] Expand to multi-year trend analysis
- [ ] Cross-reference with departmental budget data
- [ ] Investigate specific high-value contract outliers
