#  dbt + Snowflake Analytics Project

> A dbt analytics project directly connected to Snowflake as the cloud data warehouse, demonstrating the dbt-snowflake adapter, transformation pipelines, and data modelling best practices.

![dbt](https://img.shields.io/badge/dbt-Core-FF694B) ![Snowflake](https://img.shields.io/badge/Warehouse-Snowflake-29B5E8) ![Status](https://img.shields.io/badge/Status-Active-brightgreen)

---

##  Project Overview

This project establishes a dbt analytics pipeline connected directly to **Snowflake** — one of the most widely adopted cloud data warehouses in modern data stacks. It demonstrates how to configure the `dbt-snowflake` adapter, structure transformation models, and build reliable, tested pipelines that run in Snowflake's compute environment.

The project serves as both a working analytics pipeline and a reference implementation for dbt + Snowflake integration patterns.

---

##  Project Structure

```
dbt_projects/
├── models/               # SQL transformation models
│   ├── staging/          # Source-aligned staging models (views)
│   ├── intermediate/     # Business logic transformations (views)
│   └── marts/            # BI-ready dimensional models (tables)
├── macros/               # Reusable Jinja macros
├── seeds/                # Static CSV reference data loaded into Snowflake
├── snapshots/            # SCD Type 2 historical change tracking
├── tests/                # Custom singular data quality tests
├── analyses/             # Ad-hoc exploratory SQL (not materialised)
└── dbt_project.yml       # Project config — name, paths, materialisations
```

---

##  Materialisation Strategy

| Layer | Materialisation | Rationale |
|-------|----------------|-----------|
| Staging | `view` | Cheap to recompute; always reflects current source data |
| Intermediate | `view` | Reusable logic; not exposed directly to BI tools |
| Marts | `table` | Materialised in Snowflake for fast BI query performance |

---

##  Snowflake Integration

This project uses the `dbt-snowflake` adapter. Configure `~/.dbt/profiles.yml`:

```yaml
dbt_projects:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: YOUR_SNOWFLAKE_ACCOUNT        # e.g. xy12345.eu-west-1
      user: YOUR_USERNAME
      password: YOUR_PASSWORD
      role: TRANSFORMER                      # Role with appropriate warehouse access
      database: ANALYTICS
      warehouse: COMPUTE_WH
      schema: DBT_DEV
      threads: 4
      client_session_keep_alive: False
```

> **Tip:** Use Snowflake's key-pair authentication or SSO for production environments instead of password-based auth.

---

##  Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| dbt Core | 1.x | Transformation framework |
| dbt-snowflake | latest | Snowflake adapter for dbt |
| Snowflake | — | Cloud data warehouse |
| Jinja2 | — | Dynamic SQL templating within dbt models |
| YAML | — | Source definitions, model docs, schema tests |
| Git | — | Version control and team collaboration |

---

##  dbt Best Practices Applied

- ✅ Layered architecture: staging → intermediate → marts
- ✅ One staging model per source table — no skipping layers
- ✅ Sources defined in `_sources.yml` with freshness configuration
- ✅ Models documented in `_models.yml` with column-level descriptions
- ✅ Schema tests (`not_null`, `unique`, `relationships`, `accepted_values`) on key columns
- ✅ Seeds for static reference data loaded directly into Snowflake
- ✅ Snapshots for tracking slowly changing dimensions (SCD Type 2)
- ✅ Custom singular tests in the `tests/` directory

---

##  Getting Started

### 1. Install dbt with the Snowflake adapter

```bash
pip install dbt-snowflake
```

### 2. Configure your Snowflake profile

Create or update `~/.dbt/profiles.yml` with your Snowflake credentials (see above).

### 3. Clone and run the project

```bash
git clone https://github.com/Kelvin1993-prog/dbt_projects.git
cd dbt_projects

dbt debug                       # Verify connection to Snowflake
dbt deps                        # Install any package dependencies
dbt seed                        # Load seed CSV files into Snowflake
dbt run                         # Execute all transformation models
dbt test                        # Run all data quality tests
dbt docs generate               # Generate HTML documentation
dbt docs serve                  # Browse docs at http://localhost:8080
```

### Useful selective run commands

```bash
dbt run --select staging.*      # Run only staging models
dbt run --select +fct_orders    # Run fct_orders and all its upstream dependencies
dbt test --select marts.*       # Test only mart-layer models
dbt build                       # Run + test all models in dependency order
```

---

