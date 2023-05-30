################ Constants ################

constant: CONNECTION {
  # Enter the name of the Looker connection to use
  value: "looker_app_2"
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
  value: "PROJECT"
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
