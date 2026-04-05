# ============================================================
# 01_data_cleaning.py
# UK Government Procurement — Data Cleaning & Preparation
# Author: Pavithra Gunasekaran
# ============================================================

import pandas as pd
import numpy as np

# ── Load ─────────────────────────────────────────────────────
print("Loading data...")
df = pd.read_csv('../data/contracts_finder_raw.csv', low_memory=False)
print(f"Raw shape: {df.shape}")

# ── Rename columns to working names ──────────────────────────
df = df.rename(columns={
    'Organisation Name': 'department_name',
    'Awarded Date': 'award_date',
    'Awarded Value': 'award_value',
    'Supplier [Name|Address|Ref type|Ref Number|Is SME|Is VCSE]': 'supplier_raw'
})

# ── Extract supplier name (text before first |) ───────────────
df['supplier_name'] = df['supplier_raw'].str.split('|').str[0].str.strip().str.lstrip('[')

# ── Parse dates and values ───────────────────────────────────
df['award_date'] = pd.to_datetime(df['award_date'], errors='coerce', dayfirst=True)
df['award_value'] = pd.to_numeric(df['award_value'], errors='coerce')

# ── Remove nulls and negatives ───────────────────────────────
before = len(df)
df.dropna(subset=['award_value', 'award_date', 'supplier_name', 'department_name'], inplace=True)
df = df[df['award_value'] > 0]
print(f"\nRows removed during cleaning: {before - len(df):,}")
print(f"Clean dataset shape: {df.shape}")

# ── Standardise text fields ───────────────────────────────────
df['supplier_name'] = df['supplier_name'].str.strip().str.title()
df['department_name'] = df['department_name'].str.strip().str.title()

# ── Add derived columns ───────────────────────────────────────
df['award_year'] = df['award_date'].dt.year
df['award_month'] = df['award_date'].dt.to_period('M').astype(str)
df['award_quarter'] = df['award_date'].dt.to_period('Q').astype(str)
df['value_band'] = pd.cut(
    df['award_value'],
    bins=[0, 10_000, 100_000, 1_000_000, 10_000_000, np.inf],
    labels=['<£10k', '£10k–£100k', '£100k–£1M', '£1M–£10M', '>£10M']
)

# ── Save clean version ────────────────────────────────────────
df.to_csv('../data/contracts_finder_clean.csv', index=False)
print("\n✓ Clean data saved to data/contracts_finder_clean.csv")

# ── Quick summary ─────────────────────────────────────────────
print("\n── Data Quality Summary ────────────────────────────")
print(df[['award_value', 'award_date', 'supplier_name', 'department_name']].isnull().sum())
print(f"\nDate range: {df['award_date'].min().date()} → {df['award_date'].max().date()}")
print(f"Total spend: £{df['award_value'].sum():,.0f}")
print(f"Unique departments: {df['department_name'].nunique()}")
print(f"Unique suppliers: {df['supplier_name'].nunique()}")
