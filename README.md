# 🛍️ Customer Shopping Behavior — End-to-End Data Analysis Project

> **Turning Customer Data into Actionable Business Insights to Drive Sales, Loyalty & Growth**

---

## 📌 Project Overview

A full end-to-end data analysis project built on a retail customer shopping behavior dataset containing **3,900 customer records**. The project covers the complete analytics pipeline — from raw data ingestion and Python-based preprocessing, through SQL-driven business analysis, to an interactive Power BI dashboard and documented business recommendations.

**Core Business Question:**
> *"How can the company leverage consumer shopping data to identify trends, improve customer engagement, and optimize marketing and product strategies?"*

---

## 🗂️ Project Structure

```
customer-shopping-behavior/
│
├── data/
│   ├── customer_shopping_behavior.csv           # Raw dataset (18 columns)
│   └── clean_customer_shopping_behavior.csv     # Cleaned & engineered dataset (19 columns)
│
├── notebooks/
│   └── data_preprocessing_and_exploration.ipynb # Python cleaning & EDA
│
├── sql/
│   └── Customer_Shopping_Behavior_Analytics.sql # 10 T-SQL business queries
│
├── dashboard/
│   └── customer_behavior_dashboard.pbix         # Power BI interactive dashboard
│
├── docs/
│   ├── Business_Problem_Document.pdf            # Business problem definition
│   ├── customer_shopping_analysis.docx          # Full SQL analysis documentation
│   └── customer_shopping_analysis.pptx          # Stakeholder presentation
│
└── README.md
```

---

## 🔄 Project Workflow

```
1. Business Problem  →  2. Data Collection  →  3. Data Preprocessing  →  4. SQL Analysis  →  5. Visualization  →  6. Insights & Actions
```

| Phase | Tool | Output |
|---|---|---|
| Business Problem | Document | Defined objectives & KPIs |
| Data Collection | Raw CSV | 3,900 records, 18 columns |
| Data Preprocessing | Python / Pandas | Clean CSV, 19 columns, zero nulls |
| SQL Analysis | T-SQL / SQL Server | 10 business questions answered |
| Visualization | Power BI | Interactive dashboard |
| Documentation | Word + PowerPoint | Report & stakeholder slides |

---

## 🐍 Phase 1 — Data Preprocessing (Python)

**File:** `notebooks/data_preprocessing_and_exploration.ipynb`

### Steps Performed

| Step | Action | Detail |
|---|---|---|
| NULL Handling | `fillna` with category-level median | `review_rating` imputed per `category` group |
| Column Renaming | lowercase + underscore format | SQL/Python-ready naming |
| Feature Engineering | `age_group` via `pd.cut` | Bins: 18-30 / 30-45 / 45-60 / 60+ |
| Feature Engineering | `purchase_frequency_days` via mapping | Weekly=7, Fortnightly=14, Monthly=30 ... |
| Duplicate Drop | Removed `promo_code_used` | 100% identical to `discount_applied` |

### Dataset Schema (Clean)

| Column | Type | Description |
|---|---|---|
| `customer_id` | int | Unique customer identifier |
| `age` | int | Customer age |
| `gender` | str | Male / Female |
| `item_purchased` | str | Product name |
| `category` | str | Clothing / Accessories / Footwear / Outerwear |
| `purchase_amount_(USD)` | int | Latest transaction amount |
| `location` | str | US state |
| `size` | str | S / M / L / XL |
| `color` | str | Product color |
| `season` | str | Spring / Summer / Fall / Winter |
| `review_rating` | float | 1.0 – 5.0 |
| `subscription_status` | str | Yes / No |
| `shipping_type` | str | Standard / Express / Free / etc. |
| `discount_applied` | str | Yes / No |
| `previous_purchases` | int | Count of historical transactions |
| `payment_method` | str | Credit Card / Cash / Venmo / etc. |
| `frequency_of_purchases` | str | Weekly / Monthly / Annually / etc. |
| `age_group` ⭐ | str | Engineered — Young / Adult / Middle-aged / Senior |
| `purchase_frequency_days` ⭐ | int | Engineered — Numeric purchase frequency |

> ⭐ = Engineered column added during preprocessing

---

## 🗄️ Phase 2 — SQL Analysis (T-SQL)

**File:** `sql/Customer_Shopping_Behavior_Analytics.sql`

**Database:** SQL Server — `dbo.customer_shopping_behavior`

### Business Questions & Key Findings

| # | Business Question | Key Finding | SQL Technique |
|---|---|---|---|
| Q1 | Gender purchasing behavior & revenue | Males: 68% of base, $157K revenue. Female AOV slightly higher ($60.2 vs $59.5) | `GROUP BY` + Aggregations |
| Q2 | Discount users spending above average | 839 customers used a discount AND exceeded avg spend | `DECLARE` Variable + Subquery |
| Q3 | Top & bottom 5 products by review rating | Gloves lead (3.9★). Shirt lowest (3.6★). Narrow 3.6–3.9 band across all products | `TOP(N)` + `ORDER BY` |
| Q4 | Standard vs Express shipping impact | Express AOV: $60.5 vs Standard: $58.5 — near-equal order volumes | `WHERE IN` + `GROUP BY` |
| Q5 | Subscribers vs non-subscribers | No meaningful difference: Sub AOV $59.5 vs Non-sub $59.9 — program underperforms | `GROUP BY` + `ORDER BY` |
| Q6 | Products with highest discount rates | Hat: 50.0%, Sneakers: 49.7% — systemic over-discounting, margin risk | `CASE WHEN` + Aggregation |
| Q7 | Customer segmentation (New/Returning/Loyal) | Returning: 40.2%, Loyal: 39.7%, New: 20.1% — mature, retention-driven base | Nested Subquery + `CASE` |
| Q8 | Top 3 products per category by revenue | Clothing leads: Blouse ($10,410) top product overall | CTE + `ROW_NUMBER() OVER (PARTITION BY)` |
| Q9 | Repeat buyers & subscription likelihood | 72.4% of repeat buyers (6+ purchases) are NOT subscribed — major conversion gap | CTE + Conditional Aggregation |
| Q10 | Revenue contribution by age group | Middle-aged (45–60): $68K (29.2%) — highest revenue demographic | CTE + `SUM() OVER()` Window Function |

### SQL Techniques Used

- `DECLARE` variables for dynamic filtering
- `CASE WHEN` for conditional aggregation
- Common Table Expressions (`WITH ... AS`)
- Window Functions: `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)`
- Window Aggregation: `SUM() OVER()`
- Subqueries (inline & nested)
- `TOP(N)` with `ORDER BY`

---

## 📊 Phase 3 — Power BI Dashboard

**File:** `dashboard/customer_behavior_dashboard.pbix`

### KPIs

| Metric | Value |
|---|---|
| Total Customers | 3,900 |
| Total Revenue (Last Purchase) | $233K |
| Average Order Value (AOV) | $59.8 |

### Visuals

| Chart | Insight |
|---|---|
| Revenue Share by Gender (Donut) | Male: 67.74% / Female: 32.26% |
| Revenue by Age Demographic (Bar) | Middle-aged (46–60) leads |
| Revenue by Subscription Status (Pie) | Non-subscribers: 73.12% of revenue |
| Customer Base Breakdown (Bar) | Returning > Loyal > New |
| Order Volume by Category (Bar) | Clothing dominates |
| Revenue by Product Category (Bar) | Clothing highest revenue |

### Slicers (Filters)
- Subscription Status (Yes / No)
- Gender (Male / Female)
- Category (Accessories / Clothing / Footwear / Outerwear)
- Shipping Type (Standard / Express / Free / etc.)

---

## 💡 Key Business Insights & Recommendations

### 🔴 Critical Issues

1. **Subscription Program Underperforms**
   - Subscribers and non-subscribers show near-identical AOV ($59.5 vs $59.9)
   - **Action:** Revamp subscription perks — tier-based rewards, early access, exclusive category discounts

2. **Over-Discounting Risk**
   - Top 5 products carry ~47–50% discount rates
   - **Action:** Run elasticity tests — reduce discount frequency on high-volume items (e.g., Pants: 171 orders) to protect margins

3. **Repeat Buyers Not Converting to Subscribers**
   - 72.4% of customers with 6+ purchases have not subscribed
   - **Action:** Trigger subscription offers at the 6th purchase milestone

### 🟡 Growth Opportunities

4. **Female Acquisition Gap**
   - Female AOV ($60.2) is already competitive but females are only 32% of the customer base
   - **Action:** Targeted female acquisition campaigns to grow volume without sacrificing AOV

5. **New Customer Bottleneck**
   - Only 20.1% of customers are "New" — acquisition funnel is narrow
   - **Action:** Top-of-funnel investment to shift this balance

### 🟢 Strengths to Leverage

6. **Mature Customer Base** — 80% are Returning or Loyal customers
7. **Middle-aged segment (45–60)** drives the highest revenue ($68K, 29.2%)
8. **Express shipping** correlates with higher AOV — consider promoting it for high-value product categories

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| Python (Pandas, NumPy) | Data cleaning & feature engineering |
| T-SQL / SQL Server | Business analysis (10 queries) |
| Power BI | Interactive dashboard & visualization |
| Excel | Quick validation & sanity checks |
| PowerPoint | Stakeholder presentation |
| Word | SQL analysis documentation |

---

## 📁 Data Source

- **Dataset:** Consumer Behavior and Shopping Habits Dataset
- **Source:** [Kaggle](https://www.kaggle.com/datasets/zeesolver/consumer-behavior-and-shopping-habits-dataset)
- **Records:** 3,900 customers
- **Grain:** One row = one customer's latest purchase snapshot

---

## 👤 Author

**Zaid Shatat**
Data Science & Artificial Intelligence Student — Yarmouk University

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Zaid%20Shatat-blue?logo=linkedin)](https://linkedin.com/in/zaid-shatat-1a9539396)
[![GitHub](https://img.shields.io/badge/GitHub-zaidshatat-black?logo=github)](https://github.com/zaidshatat)
[![Portfolio](https://img.shields.io/badge/Portfolio-zaid--portfolio.base44.app-green)](https://zaid-portfolio.base44.app)

📧 zaidshatat06@gmail.com | 📞 +962 782 958 173

---

*End-to-End Data Analysis | Python · T-SQL · Power BI · Excel*
