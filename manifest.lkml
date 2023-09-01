################ Constants ################

constant: CONNECTION {
  # Enter the name of the Looker connection to use
  value: "looker_private_demo" #value: ""
  export: override_optional
}

constant: REGION {
  # E.g. us
  value: "us"
  export: override_optional
}
constant: SCOPE {
  # The table from which jobs data will be sourced, per the options described at https://cloud.google.com/bigquery/docs/information-schema-jobs
  # This block has been tested with PROJECT or ORGANIZATION. Tables for USER and FOLDER are untested as of 2021-04
  value: "USER" #value: "PROJECT"
  export: override_optional
}
constant: BILLING_PROJECT_ID {
  # This is used to reference Capacity Commitment data (for flat-rate billing) to compare slot usage against
  value: " "
  export: override_optional
}
constant: RESERVATION_ADMIN_PROJECT  {
  # IF Different than Billing Project ID, used when querying RESERVATIONS_BY_<SCOPE> Data
  value: " "
  export: override_optional
}

constant: MAX_JOB_LOOKBACK {
  # The maximum amount of time to look backwards in job data to find jobs that may still be open in a filtered window of slot usage
  # (This is necessary because detailed slot usage data is in job steps or job timelines, but are partitioned by job creation time.
  #  So, a job created at 11:30 that runs for 1 hour should affect slots usage between 12:00-4:00, but for performance reasons we want to limit how far back
  #  we'll scan for these long-running jobs)
  # Here's a query to help set a max based on your longest running jobs: /explore/bigquery_information_schema/jobs?fields=duration_hr,jobs.start_time_date,jobs.job_id,jobs.project_id&f[date.date_filter]=181+days&sorts=duration_hr+desc&limit=25&column_limit=50&vis=%7B%7D&filter_config=%7B%22date.date_filter%22%3A%5B%7B%22type%22%3A%22past%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22181%22%2C%22unit%22%3A%22day%22%7D%2C%7B%7D%5D%2C%22id%22%3A5%2C%22error%22%3Afalse%7D%5D%7D&dynamic_fields=%5B%7B%22dimension%22%3A%22duration_hr%22%2C%22label%22%3A%22Duration+%28hr%29%22%2C%22expression%22%3A%22%24%7Bjobs.duration_s%7D+%2F+3600%22%2C%22value_format%22%3Anull%2C%22value_format_name%22%3A%22decimal_1%22%2C%22_kind_hint%22%3A%22dimension%22%2C%22_type_hint%22%3A%22number%22%7D%5D&origin=share-expanded.
  # The value you provide should be a number and a datepart supported by https://cloud.google.com/bigquery/docs/reference/standard-sql/timestamp_functions#timestamp_sub
  value: "8 HOUR"
  export: override_optional
}

constant: PII_QUERY_TEXT {
  # Whether/how to expose strings/numbers that may be embedded in query text or query plans (which might sometimes contain PII)
  # Valid values are: SHOW, HASH, or HIDE
  # Invalid values will be treated as HIDE
  value: "HIDE"
  export: override_optional
}

constant: PII_HASH_PADDING {
  # If your other PII constant specifies the HASH option, you may specify padding to be added before computing the hash, to make the hash
  # more resistant to pre-computed hash tables
  value: "oQ4IS2cTmXBN"
  export: override_optional
}

#LAMS
#rule: K7{} # Provide one `primary_key`
#rule: F1{} # No cross-view fields
#rule: F2{} # No view-labeled fields
#rule: F3{} # Count fields filtered
#rule: E1{} # Join with subst'n operator
#rule: E7{} # Explore label 25-char max
#rule: T1{} # Triggers use datagroups
#
#rule: mft1 {
# description: "CONNECTION: If you adapted the manifest value for dev purposes, ensure it has the expected value to publish, \"\" (or update rule)"
# match: "$.manifest.constant.CONNECTION.value"
# expr_rule: (=== ::match "") ;;
#}
#rule: mft2 {
# description: "REGION: If you adapted the manifest value for dev purposes, ensure it has the expected value to publish, \"us\" (or update rule)"
# match: "$.manifest.constant.REGION.value"
# expr_rule: (=== ::match "us") ;;
#}
#rule: mft3 {
# description: "SCOPE: If you adapted the manifest value for dev purposes, ensure it has the expected value to publish, \"PROJECT\" (or update rule)"
# match: "$.manifest.constant.SCOPE.value"
# expr_rule: (=== ::match "PROJECT") ;;
#}
