# LocalMesh demonstration scenarios

Create each branch from `main`. Open PR A first and wait for it to pass, then open PR B. Close both PRs without merging before starting the next pair.

## Pair 1: duplicate column

### PR A: `demo/01-risk-integer`

`db/migrations/010_accounts_risk_integer.up.sql`
```sql
ALTER TABLE demo_accounts ADD COLUMN risk_score integer NOT NULL DEFAULT 0;
```
`db/migrations/010_accounts_risk_integer.down.sql`
```sql
ALTER TABLE demo_accounts DROP COLUMN risk_score;
```

### PR B: `demo/01-risk-text`

`db/migrations/011_accounts_risk_text.up.sql`
```sql
ALTER TABLE demo_accounts ADD COLUMN risk_score text NOT NULL DEFAULT 'low';
```
`db/migrations/011_accounts_risk_text.down.sql`
```sql
ALTER TABLE demo_accounts DROP COLUMN risk_score;
```
Expected: PostgreSQL `42701`; both orders fail; classification `conflict`.

## Pair 2: order-dependent schema

### PR A: `demo/02-profile-name-40`

`db/migrations/020_profile_name_40.up.sql`
```sql
ALTER TABLE demo_profiles ALTER COLUMN display_name TYPE varchar(40);
```
`db/migrations/020_profile_name_40.down.sql`
```sql
ALTER TABLE demo_profiles ALTER COLUMN display_name TYPE text;
```

### PR B: `demo/02-profile-name-80`

`db/migrations/021_profile_name_80.up.sql`
```sql
ALTER TABLE demo_profiles ALTER COLUMN display_name TYPE varchar(80);
```
`db/migrations/021_profile_name_80.down.sql`
```sql
ALTER TABLE demo_profiles ALTER COLUMN display_name TYPE text;
```
Expected: both SQL orders execute but final schema fingerprints differ; finding `ORDER_SCHEMA_DIVERGENCE`.

## Pair 3: order-dependent data

### PR A: `demo/03-setting-a`

`db/migrations/030_append_setting_a.up.sql`
```sql
UPDATE demo_settings SET value = value || '-A' WHERE id = 1;
```
`db/migrations/030_append_setting_a.down.sql`
```sql
UPDATE demo_settings SET value = regexp_replace(value, '-A$', '') WHERE id = 1;
```

### PR B: `demo/03-setting-b`

`db/migrations/031_append_setting_b.up.sql`
```sql
UPDATE demo_settings SET value = value || '-B' WHERE id = 1;
```
`db/migrations/031_append_setting_b.down.sql`
```sql
UPDATE demo_settings SET value = regexp_replace(value, '-B$', '') WHERE id = 1;
```
Expected: `base-A-B` versus `base-B-A`; finding `ORDER_DATA_DIVERGENCE`.

## Pair 4: one verified safe order

### PR A: `demo/04-rename-customer-key`

`db/migrations/040_rename_customer_key.up.sql`
```sql
ALTER TABLE demo_customers RENAME COLUMN id TO customer_id;
```
`db/migrations/040_rename_customer_key.down.sql`
```sql
ALTER TABLE demo_customers RENAME COLUMN customer_id TO id;
```

### PR B: `demo/04-add-customer-fk`

`db/migrations/041_add_customer_fk.up.sql`
```sql
ALTER TABLE demo_purchases ADD CONSTRAINT demo_purchases_customer_fk FOREIGN KEY (customer_id) REFERENCES demo_customers(id);
```
`db/migrations/041_add_customer_fk.down.sql`
```sql
ALTER TABLE demo_purchases DROP CONSTRAINT demo_purchases_customer_fk;
```
Expected: rename then constraint fails; constraint then rename passes; classification `order_sensitive`.

## Refresh PR A after opening PR B

```bash
git commit --allow-empty -m "chore(repo): refresh compatibility check"
git push
```
