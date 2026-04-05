# ============================================================
# 02_eda_visualisation.py
# UK Government Procurement — Exploratory Data Analysis
# Author: Pavithra Gunasekaran
# ============================================================

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import seaborn as sns
import warnings
warnings.filterwarnings('ignore')

# ── Style ────────────────────────────────────────────────────
sns.set_theme(style="whitegrid", palette="Blues_d")
plt.rcParams.update({'figure.dpi': 120, 'font.size': 11})

# ── Load clean data ──────────────────────────────────────────
df = pd.read_csv('../data/contracts_finder_clean.csv', low_memory=False)
df['award_date'] = pd.to_datetime(df['award_date'], errors='coerce')
df['award_value'] = pd.to_numeric(df['award_value'], errors='coerce')

print(f"Dataset shape: {df.shape}")
print(f"Date range: {df['award_date'].min().date()} to {df['award_date'].max().date()}")

# ── 1. Spend by Department (Top 10) ─────────────────────────
fig, ax = plt.subplots(figsize=(12, 6))
dept_spend = (df.groupby('department_name')['award_value']
                .sum()
                .sort_values(ascending=False)
                .head(10)
                .reset_index())
sns.barplot(data=dept_spend, x='award_value', y='department_name', ax=ax)
ax.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'£{x/1e6:.0f}M'))
ax.set_title('Top 10 Organisations by Total Procurement Spend', fontsize=13, fontweight='bold')
ax.set_xlabel('Total Spend')
ax.set_ylabel('')
plt.tight_layout()
plt.savefig('../docs/01_spend_by_department.png')
plt.show()
print("✓ Chart 1 saved")

# ── 2. Monthly Spend Trend ───────────────────────────────────
fig, ax = plt.subplots(figsize=(14, 5))
monthly = df.resample('ME', on='award_date')['award_value'].sum().reset_index()
ax.plot(monthly['award_date'], monthly['award_value'] / 1e6, linewidth=2, color='steelblue')
ax.fill_between(monthly['award_date'], monthly['award_value'] / 1e6, alpha=0.15, color='steelblue')
ax.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'£{x:.0f}M'))
ax.set_title('Monthly Procurement Spend Over Time', fontsize=13, fontweight='bold')
ax.set_xlabel('Month')
ax.set_ylabel('Total Spend (£M)')
plt.tight_layout()
plt.savefig('../docs/02_monthly_trend.png')
plt.show()
print("✓ Chart 2 saved")

# ── 3. Contract Value Distribution ──────────────────────────
fig, ax = plt.subplots(figsize=(10, 5))
bins = [0, 10_000, 100_000, 1_000_000, 10_000_000, df['award_value'].max() + 1]
labels = ['<£10k', '£10k–£100k', '£100k–£1M', '£1M–£10M', '>£10M']
df['value_band'] = pd.cut(df['award_value'], bins=bins, labels=labels)
band_counts = df['value_band'].value_counts().sort_index()
band_counts.plot(kind='bar', ax=ax, color=sns.color_palette("Blues_d", len(labels)))
ax.set_title('Contract Volume by Value Band', fontsize=13, fontweight='bold')
ax.set_xlabel('Contract Value Range')
ax.set_ylabel('Number of Contracts')
ax.tick_params(axis='x', rotation=0)
plt.tight_layout()
plt.savefig('../docs/03_value_distribution.png')
plt.show()
print("✓ Chart 3 saved")

# ── 4. Top 15 Suppliers by Spend ────────────────────────────
fig, ax = plt.subplots(figsize=(12, 7))
top_suppliers = (df.groupby('supplier_name')['award_value']
                   .sum()
                   .sort_values(ascending=False)
                   .head(15)
                   .reset_index())
sns.barplot(data=top_suppliers, x='award_value', y='supplier_name', ax=ax, palette='Blues_d')
ax.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'£{x/1e6:.0f}M'))
ax.set_title('Top 15 Suppliers by Total Contract Value', fontsize=13, fontweight='bold')
ax.set_xlabel('Total Contract Value')
ax.set_ylabel('')
plt.tight_layout()
plt.savefig('../docs/04_top_suppliers.png')
plt.show()
print("✓ Chart 4 saved")

# ── 5. Summary Statistics ────────────────────────────────────
print("\n── Summary Statistics ──────────────────────────────")
print(f"Total contracts analysed:  {len(df):,}")
print(f"Total spend:               £{df['award_value'].sum():,.0f}")
print(f"Average contract value:    £{df['award_value'].mean():,.0f}")
print(f"Median contract value:     £{df['award_value'].median():,.0f}")
print(f"Unique suppliers:          {df['supplier_name'].nunique():,}")
print(f"Unique departments:        {df['department_name'].nunique():,}")
print(f"Date range:                {df['award_date'].min().date()} to {df['award_date'].max().date()}")
