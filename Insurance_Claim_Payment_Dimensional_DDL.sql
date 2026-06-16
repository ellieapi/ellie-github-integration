BEGIN;


CREATE TABLE IF NOT EXISTS "claim_adjuster_dim_scd1" (
  "claim_adjuster_sk" BIGINT NOT NULL,
  PRIMARY KEY ("claim_adjuster_sk"),
  "claim_adjuster_bk" STRING NOT NULL,
  "adjuster_full_name" STRING,
  "office_location" STRING,
  "employment_status" STRING,
  "created_ts" TIMESTAMP NOT NULL,
  "updated_ts" TIMESTAMP,
  "record_source" STRING NOT NULL
);


CREATE TABLE IF NOT EXISTS "claim_payment_fact" (
  "claim_payment_sk" BIGINT NOT NULL,
  PRIMARY KEY ("claim_payment_sk"),
  "claim_payment_bk" STRING,
  "policy_sk" BIGINT NOT NULL,
  "policyholder_sk" BIGINT NOT NULL,
  "claim_adjuster_sk" BIGINT NOT NULL,
  "claim_type_sk" BIGINT NOT NULL,
  "payment_date_sk" INTEGER NOT NULL,
  "paid_total" DECIMAL(18, 2) NOT NULL,
  "payment_transaction_count" INTEGER DEFAULT '1',
  "deductible_quantity" DECIMAL(18, 4) NOT NULL,
  "recovery_ratio" DECIMAL(9, 4),
  "reserve_utilization_percentage" DECIMAL(5, 2),
  "payment_status_code" STRING,
  "claim_source_id" STRING,
  "etl_batch_id" STRING,
  "created_ts" TIMESTAMP NOT NULL,
  "updated_ts" TIMESTAMP,
  "loaded_ts" TIMESTAMP NOT NULL,
  "record_source" STRING NOT NULL
);


CREATE TABLE IF NOT EXISTS "claim_type_dim_scd1" (
  "claim_type_sk" BIGINT NOT NULL,
  PRIMARY KEY ("claim_type_sk"),
  "claim_type_bk" STRING NOT NULL,
  "claim_type_name" STRING,
  "peril_group" STRING,
  "active_status" STRING,
  "created_ts" TIMESTAMP NOT NULL,
  "updated_ts" TIMESTAMP,
  "record_source" STRING NOT NULL
);


CREATE TABLE IF NOT EXISTS "payment_date_dim" (
  "date_sk" INTEGER NOT NULL,
  PRIMARY KEY ("date_sk"),
  "date" DATE NOT NULL,
  "day_number" INTEGER NOT NULL,
  "day_name" STRING NOT NULL,
  "day_name_short" STRING NOT NULL,
  "week_number" INTEGER NOT NULL,
  "month_number" INTEGER NOT NULL,
  "month_name" STRING NOT NULL,
  "month_name_short" STRING NOT NULL,
  "quarter_number" INTEGER NOT NULL,
  "year_number" INTEGER NOT NULL,
  "is_weekend" STRING NOT NULL,
  "is_workday" BOOLEAN NOT NULL,
  "is_holiday" BOOLEAN,
  "holiday_name" STRING,
  "created_ts" TIMESTAMP NOT NULL,
  "record_source" STRING NOT NULL
);


CREATE TABLE IF NOT EXISTS "policy_dim" (
  "policy_sk" BIGINT NOT NULL,
  PRIMARY KEY ("policy_sk"),
  "policy_bk" STRING NOT NULL,
  "coverage_type" STRING,
  "annual_premium_band" STRING,
  "policy_status" STRING,
  "valid_from_ts" TIMESTAMP NOT NULL,
  "valid_to_ts" TIMESTAMP NOT NULL,
  "is_current" BOOLEAN NOT NULL,
  "version_no" INTEGER NOT NULL,
  "change_hash" STRING NOT NULL,
  "created_ts" TIMESTAMP NOT NULL,
  "updated_ts" TIMESTAMP,
  "record_source" STRING NOT NULL
);


CREATE TABLE IF NOT EXISTS "policyholder_dim_scd2" (
  "policyholder_id" BIGINT NOT NULL UNIQUE,
  PRIMARY KEY ("policyholder_id"),
  "policyholder_business_key" STRING NOT NULL,
  "residence_postal_area" STRING,
  "risk_segment" STRING,
  "customer_status" STRING,
  "valid_from_ts" TIMESTAMP NOT NULL,
  "valid_to_ts" TIMESTAMP NOT NULL,
  "is_current" BOOLEAN NOT NULL,
  "version_no" INTEGER NOT NULL,
  "change_hash" STRING NOT NULL,
  "created_ts" TIMESTAMP NOT NULL,
  "updated_ts" TIMESTAMP,
  "record_source" STRING NOT NULL
);


ALTER TABLE "claim_payment_fact"
ADD CONSTRAINT "FK_claim_payment_fact_payment_date_dim" FOREIGN KEY ("payment_date_sk") REFERENCES "payment_date_dim" ("date_sk");


ALTER TABLE "claim_payment_fact"
ADD CONSTRAINT "FK_claim_payment_fact_policy_dim" FOREIGN KEY ("policy_sk") REFERENCES "policy_dim" ("policy_sk");


ALTER TABLE "claim_payment_fact"
ADD CONSTRAINT "FK_claim_payment_fact_policyholder_dim_scd2" FOREIGN KEY ("policyholder_sk") REFERENCES "policyholder_dim_scd2" ("policyholder_id");


ALTER TABLE "claim_payment_fact"
ADD CONSTRAINT "FK_claim_payment_fact_claim_adjuster_dim_scd1" FOREIGN KEY ("claim_adjuster_sk") REFERENCES "claim_adjuster_dim_scd1" ("claim_adjuster_sk");


ALTER TABLE "claim_payment_fact"
ADD CONSTRAINT "FK_claim_payment_fact_claim_type_dim_scd1" FOREIGN KEY ("claim_type_sk") REFERENCES "claim_type_dim_scd1" ("claim_type_sk");


COMMIT;