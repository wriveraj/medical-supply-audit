# Medical Supply Chain Audit Simulator
### PostgreSQL · DBeaver · Docker Desktop

A relational database project simulating a regional medical supply chain across six clinical sites in Connecticut. Built to demonstrate real-world inventory auditing, shipment discrepancy detection, PAR-level analysis, and cost exposure reporting using PostgreSQL.

## Background

This project is rooted in 15 years of hands-on operations experience including field inventory management for a medical device company where case readiness was not optional. I built this to translate that operational instinct into a structured analytical system: one that surfaces the kind of problems that hide in plain sight until it is too late.

## Database Structure

7 tables designed to track the full inventory lifecycle:

- products: 15 medical supply items with PAR levels and reorder quantities
- locations: 6 sites — hospitals, clinics, and a central warehouse
- inventory: Current stock levels per product per location
- purchase_orders: Orders placed to restock inventory
- shipments: What actually arrived vs what was ordered
- discrepancies: Flagged mismatches — shortages, overages, stockout risks
- audit_log: Complete history of every inventory movement

## Setup

### Run the database locally
docker run --name medical_supply_db -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=admin123 -e POSTGRES_DB=medical_supply -p 5432:5432 -d postgres:15

### Connect in DBeaver
Host: localhost
Port: 5432
Database: medical_supply
Username: admin
Password: admin123

### Build the schema and load data
Run in order in DBeaver:
1. sql/01_schema.sql
2. sql/02_seed_data.sql

## Analytical Queries

- 01_below_par.sql: Which locations are below PAR level right now?
- 02_shipment_mismatches.sql: Which shipments did not match the purchase order?
- 03_fulfillment_rate.sql: What is the fulfillment rate by location?
- 04_reorder_recommendations.sql: What needs to be ordered and how much will it cost?
- 05_cost_exposure.sql: What is the total reorder cost exposure by location?
- 06_demand_velocity.sql: Which products are moving fastest through the network?

## Key Findings

- 59752 dollars in total reorder cost exposure across three underperforming sites
- Waterbury Urgent Care had the highest gap cost at 7784 dollars — furthest below PAR across 15 products
- Bridgeport Community Clinic had a 33.3% shipment fulfillment rate — only 1 in 3 shipments arrived correctly
- N95 Respirators were the highest-cost reorder item at 3600 dollars per site
- A mislabeled shipment note flagged as an overage was actually a shortage
- Normal Saline moved in large infrequent swings averaging 260 units per adjustment

## Author

William Rivera Jr
Field Inventory Manager to Data Analyst
Portfolio: Coming Soon
LinkedIn: https://linkedin.com/in/william-rivera-966230309
