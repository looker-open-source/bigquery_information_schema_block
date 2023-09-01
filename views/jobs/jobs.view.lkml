
# https://cloud.google.com/bigquery/docs/information-schema-jobs

include: "/views/date.view.lkml"

view: jobs {
  extends: [jobs_base]
  derived_table: {
    sql:
      SELECT *
      FROM `region-@{REGION}`.INFORMATION_SCHEMA.JOBS_BY_@{SCOPE}
      WHERE creation_time >= {% date_start date.date_filter%}
        AND creation_time < {% date_end date.date_filter%}
    ;;
  }
}
view: jobs_in_project {
  extends: [jobs_base]
  derived_table: {
    sql:
      SELECT *
      FROM `region-@{REGION}`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
      WHERE creation_time >= {% date_start date.date_filter%}
        AND creation_time < {% date_end date.date_filter%}
    ;;
  }
  dimension: query_text { sql: ${query_raw} ;;}
}
view: jobs_in_organization{
  extends: [jobs_base]
  derived_table: {
    sql:
      SELECT *
      FROM `region-@{REGION}`.INFORMATION_SCHEMA.JOBS_BY_ORGANIZATION
      WHERE creation_time >= {% date_start date.date_filter%}
        AND creation_time < {% date_end date.date_filter%}
    ;;
  }
  dimension: query_text { sql: "Query text is only available at PROJECT scope " ;;}
}

view: jobs_base {
  # This is the main Information Schema table - with one row per job executed

  extension: required

  dimension: job_id {
    primary_key: yes
    label: "[Job ID]"
    type: string
    sql: ${TABLE}.job_id ;;
    link: {
      label: "Job Lookup Dashboard"
      url: "/dashboards-next/bigquery_information_schema::job_lookup_dashboard?Job%20ID={{ value | encode_uri}}&Created={{date.date_in_filter_format | encode_uri}}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
    link: {
      label: "View Query History in BigQuery"
      url: "https://console.cloud.google.com/bigquery?j=bq:@{REGION}:{{ value | uri_encode }}&page=queryresults"
      icon_url: "https://www.gstatic.com/devrel-devsite/prod/vb06d4bce6b32c84cf01c36dffa546f7ea4ff7fc8fcd295737b014c1412e4d118/cloud/images/favicons/onecloud/favicon.ico"
    }
  }

  dimension_group: creation {
    # This is the partition column
    hidden: yes # Prefer to use a field in an abstract date view
    description: "Creation time of this job"
    type: time
    timeframes: [
      raw,
      time,
      second,
      minute,
      minute5,
      minute15,
      minute30,
      hour,
      date,
      week,
      month,
      time_of_day,
      day_of_week,
      hour_of_day
    ]
    sql: ${TABLE}.creation_time ;;
  }


  dimension: project_id {
    label: "Project ID"
    type: string
    sql: ${TABLE}.project_id ;;
  }

  dimension: project_number {
    hidden: yes
    type: string
    sql: ${TABLE}.project_number ;;
  }

  dimension: user_email {
    description: "The email of the BiqQuery user that created the job"
    type: string
    sql: ${TABLE}.user_email ;;
#     link: {
#       label: "User Lookup Dashboard"
#       url: "/dashboards/...?User={{ value | uri_encode }}"
#       icon_url: "http://www.looker.com/favicon.ico"
#     }
  }

  dimension: job_type_raw {
    # The source table uses NULL to communicate a value, which must be explicitly handled to avoid ambiguity in the face of joins
    hidden: yes
    description: "The type of the job. Can be QUERY, LOAD, EXTRACT, COPY, or null. Job type null indicates an internal job, such as script job statement evaluation or materialized view refresh."
    type: string
    sql: ${TABLE}.job_type ;;
  }

  dimension: job_type {
    description: "The type of the job. Can be QUERY, LOAD, EXTRACT, COPY, or INTERNAL. (Internal is inferred from a null value in the original table. Internal examples: script job statement evaluation or materialized view refresh)"
    type: string
    sql: COALESCE( ${job_type_raw}, CASE WHEN ${job_id} IS NOT NULL THEN 'INTERNAL' END) ;;
    suggestions: ["QUERY","LOAD","COPY","INTERNAL"]
  }

  dimension: statement_type {
    description: "The type of query statement, if valid. For example, SELECT, INSERT, UPDATE, DELETE, or SCRIPT..."
    type: string
    sql: ${TABLE}.statement_type ;;
    suggestions: ["QUERY_STATEMENT_TYPE_UNSPECIFIED", "SELECT", "ASSERT", "INSERT", "UPDATE", "DELETE", "MERGE", "CREATE_TABLE", "CREATE_TABLE_AS_SELECT", "CREATE_VIEW", "CREATE_MODEL", "CREATE_MATERIALIZED_VIEW", "CREATE_FUNCTION", "CREATE_PROCEDURE", "CREATE_SCHEMA", "DROP_TABLE", "DROP_EXTERNAL_TABLE", "DROP_VIEW", "DROP_MODEL", "DROP_MATERIALIZED_VIEW", "DROP_FUNCTION", "DROP_PROCEDURE", "DROP_SCHEMA", "ALTER_TABLE", "ALTER_VIEW", "ALTER_MATERIALIZED_VIEW", "ALTER_SCHEMA", "SCRIPT", "TRUNCATE_TABLE", "CREATE_EXTERNAL_TABLE", "EXPORT_DATA", "CALL"]
  }

  dimension: state {
    description: "Running state of the job. Valid states include PENDING, RUNNING, and DONE."
    type: string
    sql: ${TABLE}.state ;;
    suggestions: ["PENDING", "RUNNING", "DONE"]
  }

  dimension: reservation_id {
    hidden: yes # Foreign key
    label: "Reservation ID"
    description: "Name of the primary reservation assigned to this job, if applicable. If your job ran in a project that is assigned to a reservation, it would follow this format: RESERVATION_ADMIN_PROJECT:RESERVATION_LOCATION.RESERVATION_NAME"
    type: string
    sql: ${TABLE}.reservation_id ;;
  }

  dimension: slot_ms {
    hidden: yes # Prefer measure
    type: number
    description: "Overall slot milliseconds used by the job"
    sql: ${TABLE}.total_slot_ms ;;
  }

  # Dimension group: destination table {

  dimension: destination_table {
    group_label: "Destination Table"
    hidden: yes # Record type, prefer accessing sub-fields separately
    description: "Destination table for results, if any. (Record serialized to JSON)"
    type: string
    sql: TO_JSON_STRING(${TABLE}.destination_table) ;;
  }

  dimension: destination_table_full_path {
    group_label: "Destination Table"
    label: "Destination Table Full Path"
    type: string
    sql:  ${destination_table_project_id} || "." || ${destination_table_dataset_id} || "." || ${destination_table_table_id} ;;
  }

  dimension: destination_table_project_id {
    group_label: "Destination Table"
    label: "Destination Table Project"
    type: string
    sql: ${TABLE}.destination_table.project_id ;;
  }

  dimension: destination_table_dataset_id {
    group_label: "Destination Table"
    label: "Destination Table Dataset"
    type: string
    sql:  ${destination_table}.destination_table.dataset_id ;;
  }

  dimension: destination_table_table_id {
    group_label: "Destination Table"
    label: "Destination Table Table"
    type: string
    sql:  ${destination_table}.destination_table.table_id ;;
  }

  # End destination table dimension group }

  dimension: referenced_tables_raw {
    hidden: yes
    sql: ${TABLE}.referenced_tables ;;

  }
  dimension: referenced_tables {
    hidden: yes # Messy nested/record
    type: string
    sql: TO_JSON_STRING(${referenced_tables_raw}) ;;
  }

  dimension: labels {
    type: string
    sql: ARRAY_TO_STRING(${TABLE}.labels, "; ") ;;
  }

  dimension: error_result {
    hidden: no # Messy, but important enough to expose until it can be modeled better
    type: string
    sql: TO_JSON_STRING(${TABLE}.error_result);;
  }

  dimension: timeline {
    hidden: yes  # Messy nested/record
    type: string
    sql: TO_JSON_STRING(${TABLE}.timeline) ;;
  }

  dimension: job_stages_raw {
    hidden: yes
    sql: ${TABLE}.job_stages ;;
  }

  dimension: job_stages {
    hidden: yes  # Messy nested/record
    type: string
    sql: TO_JSON_STRING(${TABLE}.job_stages) ;;
  }

  # Dimension group: Optimization {

  dimension: is_cache_hit {
    group_label: "Optimization"
    label: "Is Cache Hit?"
    description: "Whether the query results of this job were from a cache"
    type: yesno
    sql: ${TABLE}.cache_hit;;
  }

  dimension: spill_to_disk_bytes {
    hidden: yes # Prefer measures
    group_label: "Optimization"
    label: "Spill to Disk Bytes"
    description: "Number of bytes in the job's shuffle operations that spilled to disk, which results in slower performance"
    type: number
    sql: (SELECT SUM(shuffle_output_bytes_spilled) FROM UNNEST(${job_stages_raw}));;
  }

  dimension: has_spill_to_disk {
    group_label: "Optimization"
    label: "Has Spill to Disk?"
    description: "Whether any stages in the job needed to spill shuffle operations to disk, which results in slower performance"
    type: yesno
    sql: ${spill_to_disk_bytes}>0 ;;
  }

    dimension: bi_engine_mode {
      hidden: yes # Hiding because this appears to just be a less detailed version of acceleration_mode
      group_label: "Optimization"
      label: "BI Engine Mode"
      description: "e.g., ACCELERATION_MODE_UNSPECIFIED, DISABLED, PARTIAL, FULL"
      type: string
      sql:  ${TABLE}.bi_engine_statistics.bi_engine_mode ;;
      suggestions: ["ACCELERATION_MODE_UNSPECIFIED", "DISABLED", "PARTIAL", "FULL"]
    }
    dimension: acceleration_mode {
      group_label: "Optimization"
      label: "BI Engine Acceleration Mode"
      description: "e.g., ACCELERATION_MODE_UNSPECIFIED, DISABLED, PARTIAL, FULL"
      type: string
      sql:  ${TABLE}.bi_engine_statistics.acceleration_mode ;;
      suggestions: ["ACCELERATION_MODE_UNSPECIFIED", "DISABLED", "PARTIAL", "FULL"]
    }

    dimension: bi_engine_reasons {
      group_label: "Optimization"
      label: "BI Engine Reasons"
      description: "List of codes identifying the high-level reasons for no/partial acceleration. See https://cloud.google.com/bigquery/docs/reference/rest/v2/Job#Code"
      type: string
      sql: (SELECT STRING_AGG(DISTINCT code,", ") FROM UNNEST(${TABLE}.bi_engine_statistics.bi_engine_reasons)) ;;
      suggestions: ["CODE_UNSPECIFIED","NO_RESERVATION","INSUFFICIENT_RESERVATION",
        "UNSUPPORTED_SQL_TEXT", "INPUT_TOO_LARGE", "OTHER_REASON", "TABLE_EXCLUDED"]
    }

  # }

  dimension_group: start_time {
    group_label: "Start Time"
    description: "The start time of the job. May be after the creation time due to queueing if the query was in state PENDING"
    type: time
    timeframes: [
      raw,
      time,
      second,
      minute,
      hour,
      date,
      week,
      month,
      time_of_day,
      day_of_week,
      hour_of_day
    ]
    sql: ${TABLE}.start_time ;;
  }

  dimension_group: end_time {
    group_label: "End Time"
    description: "The end time of the job"
    type: time
    timeframes: [
      raw,
      time,
      second,
      minute,
      hour,
      date,
      week,
      month,
      time_of_day,
      day_of_week,
      hour_of_day
    ]
    sql: ${TABLE}.end_time ;;
  }

  # Dimension group: Duration {

  dimension: duration_ms {
    group_label: "Duration"
    label: "Duration (ms)"
    description: "Time elapsed from job creation to job end, in milliseconds"
    type: number
    sql: TIMESTAMP_DIFF(${end_time_raw}, ${creation_raw}, MILLISECOND) ;;
  }

  dimension: duration_s {
    group_label: "Duration"
    label: "Duration (s)"
    description: "Time elapsed from job creation to job end, in seconds"
    type: number
    sql: TIMESTAMP_DIFF(${end_time_raw}, ${creation_raw}, MILLISECOND) / 1000 ;;
  }

  dimension: runtime_ms {
    group_label: "Duration"
    label: "Runtime (ms)"
    description: "Time elapsed from job start to job end, in milliseconds"
    type: number
    sql: TIMESTAMP_DIFF(${end_time_raw}, ${start_time_raw}, MILLISECOND) ;;
  }

  dimension: runtime_s {
    group_label: "Duration"
    label: "Runtime (s)"
    description: "Time elapsed from job start to job end, in seconds"
    type: number
    sql: TIMESTAMP_DIFF(${end_time_raw}, ${start_time_raw}, MILLISECOND) / 1000 ;;
  }

  # }

  # Dimension group: Delay to Start {

  dimension: delay_to_start_ms {
    group_label: "Delay to Start"
    label: "Delay to Start (ms)"
    description: "Time elapsed from job creation to job start, in milliseconds"
    type: number
    sql: TIMESTAMP_DIFF(${start_time_raw}, ${creation_raw}, MILLISECOND) ;;
  }

  dimension: delay_to_start_s {
    group_label: "Delay to Start"
    label: "Delay to Start (s)"
    description: "Time elapsed from job creation to job start, in seconds"
    type: number
    sql: ${delay_to_start_ms} / 1000 ;;
  }


  dimension: is_delay_to_start_200ms {
    hidden: yes
    group_label: "Delay to Start"
    label: "Is Delay to Start > 0.2s?"
    description: "Was time elapsed from job creation to job start greater than 200 milliseconds"
    type: yesno
    sql: ${delay_to_start_ms} > 200 ;;
  }


  dimension: is_delay_to_start_1000ms {
    hidden: yes
    group_label: "Delay to Start"
    label: "Is Delay to Start > 1s?"
    description: "Was time elapsed from job creation to job start greater than 1 second"
    type: yesno
    sql: ${delay_to_start_ms} > 1000 ;;
  }


  dimension: is_delay_to_start_5000ms {
    hidden: yes
    group_label: "Delay to Start"
    label: "Is Delay to Start > 5s?"
    description: "Was time elapsed from job creation to job start greater than 5 seconds"
    type: yesno
    sql: ${delay_to_start_ms} > 5000 ;;
  }


  dimension: is_delay_to_start_25000ms {
    hidden: yes
    group_label: "Delay to Start"
    label: "Is Delay to Start >25s?"
    description: "Was time elapsed from job creation to job start greater than 25 seconds"
    type: yesno
    sql: ${delay_to_start_ms} > 25000 ;;
  }

  # }

  # Dimension group: Query Text {

  dimension: query_raw {
    hidden: yes
    sql: ${TABLE}.query ;;
  }

  dimension: query_text {
    group_label: "Query Text"
    description: "SQL query text. Note: Only the PROJECT scope has the query column"
    # The Query Text field is removed from the Jobs by Organization table
    type: string
    sql:{% if "@{SCOPE}" != "PROJECT"%} "Query text is only available at PROJECT scope " {%
      else %} ${query_raw} {% endif %};;
    html:
    <div style="white-space: pre;">{{rendered_value}}
    </div> ;;
  }

  dimension: query_snippet {
    group_label: "Query Text"
    description: "First 2000 characters of the SQL query text. Note: Only the PROJECT scope has the query column"
    # The Query Text field is removed from the Jobs by Organization table
    type: string
    sql:{% if "@{SCOPE}" != "PROJECT"%} "Query text is only available at PROJECT scope " {%
      else %} ${query_raw} {% endif %};;
    html:
    <div style="white-space: pre;">{{rendered_value}}
    </div> ;;
  }

  # }

  # Dimension group: Looker context {

  dimension: looker_history_id {
    group_label: "Looker Context"
    label: "Looker History ID"
    description: "The Looker history ID, extracted from the context comment in the Labels field, if available. Note: Only available at the PROJECT scope"
    # https://docs.looker.com/admin-options/server/usage#sql_comments
    type: string
    # Unnest from Labels Method:
    sql: (SELECT value from UNNEST(${TABLE}.labels) as label where label.key = 'looker-context-history_id') ;;
    # Regex Method:
    # sql:{% if "@{SCOPE}" != "PROJECT"%} "Query text is only available at PROJECT scope " {%
    #   else %} REGEXP_EXTRACT( ${query_raw}, r'"history_id":\s*(\d*)' ) {% endif %};;
  }

  dimension: looker_user_id {
    group_label: "Looker Context"
    label: "Looker User ID"
    description: "The Looker user ID, extracted from the context comment in the Labels field, if available. Note: Only available at the PROJECT scope"
    # https://docs.looker.com/admin-options/server/usage#sql_comments
    type: string
    # Unnest from Labels Method:
    sql: (SELECT value FROM UNNEST(${TABLE}.labels) as label WHERE label.key = 'looker-context-user_id') ;;
    # Regex Method:
    # sql:{% if "@{SCOPE}" != "PROJECT"%} "Query text is only available at PROJECT scope " {%
    #   else %} REGEXP_EXTRACT( ${query_raw}, r'"user_id":\s*(\d*)' ) {% endif %};;
  }

  dimension: looker_instance_slug {
    group_label: "Looker Context"
    label: "Looker Instance Slug"
    description: "The Looker instance slug, which identifies the Looker instance that issues the query, extracted from the context comment in the Labels field, if available. (For clustered Looker deployments, the instance represents the whole cluster, not an individual node.) Note: Only available at the PROJECT scope"
    # https://docs.looker.com/admin-options/server/usage#sql_comments
    type: string
    # Unnest from Labels Method:
    sql: (SELECT value FROM UNNEST(${TABLE}.labels) as label WHERE label.key = 'looker-context-instance_slug') as instance_slug ;;
    # Regex Method:
    # sql:{% if "@{SCOPE}" != "PROJECT"%} "Query text is only available at PROJECT scope " {%
    #   else %} REGEXP_EXTRACT( ${query_raw}, r'"instance_slug":\s*"([^"]*)"' ) {% endif %};;
  }

  dimension: looker_pdt_type {
    group_label: "Looker Context"
    label: "Looker PDT Type"
    description: "Whether the current job represents a production PDT build (Prod), a dev-mode PDT build (Dev), or is not a PDT (No)"
    # https://docs.looker.com/admin-options/server/usage#sql_comments
    type: string
    sql:{% if "@{SCOPE}" != "PROJECT"%} "Query text is only available at PROJECT scope " {%
      else %} CASE
          WHEN ${query_raw} NOT LIKE '-- Building %'
          THEN 'No'
          WHEN ${query_raw} LIKE '% in dev mode on instance %'
          THEN 'Dev'
          WHEN ${query_raw} IS NOT NULL
          THEN 'Prod'
          END {%endif%};;
    suggestions: ["No","Dev","Prod"]
  }

# End of dimension group: query text }

  # Dimension group: Bytes {

  dimension: processed_bytes {
    hidden: yes # Use measures instead
    group_label: "Processed Bytes"
    label: "Processed Bytes"
    type: number
    sql: ${TABLE}.total_bytes_processed ;;
  }

  dimension: total_bytes_billed {
    type: number
    label: "Bytes Billed"
    sql: ${TABLE}.total_bytes_billed ;;
  }

  dimension: processed_gib {
    hidden: yes # Use measures instead
    group_label: "Processed Bytes"
    label: "Processed GiB"
    description: "Bytes processed, in gigibytes (2^30 bytes)"
    type: number
    sql: ${processed_bytes} / (1024*1024*1024)  ;;
    value_format_name: decimal_2
  }

  dimension: estimated_billed_bytes {
    # BigQuery bills for a minimum of 10MiB for each table referenced, or 10MiB overall
    # https://cloud.google.com/bigquery/pricing#:~:text=minimum

    hidden: yes # Use measures instead
    group_label: "Processed Bytes"
    label: "Estimated Billed Bytes"
    description: "Estimates billable bytes from processed bytes - each job is assigned a minimum of 10MiB per table referenced, or minimum 10MiB per job."
    type:  number
    sql: GREATEST(
      10 * 1024 * 1024,
      10 * 1024 * 1024 * ARRAY_LENGTH(${referenced_tables_raw}),
      ${processed_bytes}
      )  ;;
  }

  dimension: estimated_on_demand_cost {
    # Model creation costs more per GB than other statement types
    hidden: yes # Use measures instead
    group_label: "Processed Bytes"
    label: "Estimated On-Demand Cost"
    description: "Extrapolates from estimated billed bytes to cost in USD for on-demand pricing. Most statements are calculated at $5 USD / TiB, and BQML model creation is calculated at $250 USD / TiB"
    type: number
    value_format_name: usd
    sql: ROUND( ${estimated_billed_bytes} / POW(2, 40)  *
          CASE
            WHEN ${statement_type} = 'CREATE_MODEL'
            THEN 250.00
            WHEN ${statement_type} IN ('DELETE','SELECT','CREATE_TABLE_AS_SELECT','INSERT','MERGE')
            THEN  5.00
            WHEN ${statement_type} IS NULL
            THEN 0.00
          END, 2) ;;
  }

  # End dimension group bytes }

  ## Measures

  # Measure Group: Processed Bytes {

  measure: total_processed_bytes {
    hidden: yes # GiB or TiB is more reasonable for totals
    group_label: "Processed Bytes"
    label: "Processed Bytes"
    type: sum
    sql: ${processed_bytes} ;;
    value_format: "#,##0 \" b\""
    drill_fields: [detail*]
  }

  measure: total_processed_gib {
    group_label: "Processed Bytes"
    label: "Processed GiB"
    description: "Processed bytes, but in gigibytes (2^30 bytes)"
    type: number
    sql: ${total_processed_bytes} / (1024*1024*1024)   ;;
    value_format: "#,##0.0 \" GiB\""
    drill_fields: [detail*]
  }

  measure: total_processed_tib {
    group_label: "Processed Bytes"
    label: "Processed TiB"
    description: "Processed bytes, but in tebibytes (2^40 bytes)"
    type: number
    sql: ${total_processed_bytes} / (1024*1024*1024*1024)   ;;
    value_format: "#,##0.00 \" TiB\""
    drill_fields: [detail*]
  }

  measure: average_processed_gib {
    group_label: "Processed Bytes"
    label: "Average Processed GiB"
    description: "Average processed gigibytes (2^30 bytes) per job, defined as total bytes processed / number of jobs"
    type: average
    value_format: "#,##0.0 \" GiB\""
    sql: ${processed_gib} ;;
    drill_fields: [detail*]
  }

  measure: total_estimated_billed_tb {
    hidden: yes # What would the use case for this as a measure be? Either total processed bytes, or total cost estimate fit better for any case I can think of
    group_label: "Processed Bytes"
    label: "Total Estimated Billed TiB"
    type:  sum
    value_format: "#,##0.00 \" TiB\""
    sql: ${estimated_billed_bytes} / (1024*1024*1024*1024) ;;
    drill_fields: [detail*]
  }

  measure: total_estimated_on_demand_cost {
    group_label: "Processed Bytes"
    label: "Total Estimated On-Demand Cost"
    description: "Extrapolates from bytes billed to cost for on-demand pricing. Most statements are calculated at $5 USD / TB, and BQML model creation is calculated at $250 USD / TB"
    type:  sum
    value_format_name: usd_0
    sql: ${estimated_on_demand_cost} ;;
    drill_fields: [detail*]
  }

  measure: total_mbytes_billed {
  type: sum
  label: "Total MBytes Billed"
  sql: ${total_bytes_billed} / (1000000) ;;
  }

  measure: total_gbytes_billed {
    type: sum
    label: "Total GiB Billed"
    sql: ${total_bytes_billed} / (1000000000) ;;
  }

  measure: total_tb_billed {
    type: sum
    label: "Total TB Billed"
    sql: ${total_bytes_billed} / (1000000000000) ;;
  }

  # End measure group processed bytes }

  # Measure group: Counts {

  measure: count {
    group_label: "Count"

    type: count
    filters: [job_id: "-NULL"]
    drill_fields: [detail*]
  }

  measure: query_count {
    group_label: "Count"
    label: "Query Count"
    type: count
    filters: [
      job_type: "QUERY"
    ]
    drill_fields: [detail*]
  }
  # end measure group: counts }

  # Measure group: cache {

  measure: cache_count {
    group_label: "Cache"
    description: "Count of jobs whose results were from a cache"
    type: count
    filters: [is_cache_hit: "yes"]
    drill_fields: [detail*]
  }

  measure: cache_rate {
    group_label: "Cache"
    description: "Percent of jobs whose results were from a cache"
    type: number
    sql: ${cache_count} / NULLIF(${count},0) ;;
    value_format_name: percent_1
    drill_fields: [detail*]
  }

  measure: query_cache_rate {
    group_label: "Cache"
    description: "Percent of queries whose results were from a cache"
    type: number
    sql: ${cache_count} / NULLIF(${query_count},0) ;;
    value_format_name: percent_1
    drill_fields: [detail*]
  }

  # }

  # Measure group: duration {

  measure: average_duration {
    group_label: "Duration"
    label: "Average Duration (s)"
    description: "Average time elapsed from job creation to job end, in seconds"
    type: average
    value_format_name: decimal_1
    sql: ${duration_s} ;;
    drill_fields: [detail*]
  }
  measure: average_runtime {
    group_label: "Duration"
    label: "Average Runtime (s)"
    description: "Average time elapsed from job start to job end, in seconds"
    type: average
    value_format_name: decimal_1
    sql: ${runtime_s} ;;
    drill_fields: [detail*]
  }
  measure: total_duration {
    group_label: "Duration"
    label: "Total Duration (s)"
    description: "Total time elapsed across jobs from job creation to job end, in seconds"
    type: sum
    value_format_name: decimal_0
    sql: ${duration_s} ;;
    drill_fields: [detail*]
  }
  measure: total_runtime {
    group_label: "Duration"
    label: "Total Runtime (s)"
    description: "Total time elapsed across jobs from job start to job end, in seconds"
    type: sum
    value_format_name: decimal_1
    sql: ${runtime_s} ;;
    drill_fields: [detail*]
  }

  # }

  # Measure group: Delay to start {

  measure: average_delay_to_start_time {
    group_label: "Delay to Start"
    label: "Average Delay to Start Time (s)"
    description: "Average time elapsed from job creation to job start, in seconds"
    type: average
    value_format_name: decimal_1
    sql: ${delay_to_start_s} ;;
    drill_fields: [detail*]
  }

  measure: total_delay_to_start_time {
    group_label: "Delay to Start"
    label: "Total Delay to Start Time (s)"
    description: "Total time elapsed across jobs from job creation to job start, in seconds"
    type: sum
    value_format_name: decimal_1
    sql: ${delay_to_start_s} ;;
    drill_fields: [detail*]
  }

  measure: jobs_delayed_200ms {
    group_label: "Delay to Start"
    label: "Jobs Delayed > 0.2s"
    description: "Count of jobs whose delay to start was over 200 milliseconds"
    type: count
    filters: [is_delay_to_start_200ms: "yes"]
    drill_fields: [detail*]
  }

  measure: jobs_delayed_1000ms {
    group_label: "Delay to Start"
    label: "Jobs Delayed > 1s"
    description: "Count of jobs whose delay to start was over 1 second"
    type: count
    filters: [is_delay_to_start_1000ms: "yes"]
    drill_fields: [detail*]
  }

  measure: jobs_delayed_5000ms {
    group_label: "Delay to Start"
    label: "Jobs Delayed > 5s"
    description: "Count of jobs whose delay to start was over 5 seconds"
    type: count
    filters: [is_delay_to_start_5000ms: "yes"]
    drill_fields: [detail*]
  }

  measure: jobs_delayed_25000ms {
    group_label: "Delay to Start"
    label: "Jobs Delayed >25s"
    description: "Count of jobs whose delay to start was over 25 seconds"
    type: count
    filters: [is_delay_to_start_25000ms: "yes"]
    drill_fields: [detail*]
  }

  measure: percent_jobs_delayed_200ms {
    group_label: "Delay to Start"
    label: "Precent Jobs Delayed > 0.2s"
    description: "Percent of jobs whose delay to start was over 200 milliseconds"
    type: number
    value_format_name: percent_1
    sql: ${jobs_delayed_200ms} / NULLIF(${count},0) ;;
    drill_fields: [detail*]
  }

  measure: percent_jobs_delayed_1000ms {
    group_label: "Delay to Start"
    label: "Precent Jobs Delayed > 1s"
    description: "Percent of jobs whose delay to start was over 1 second"
    type: number
    value_format_name: percent_1
    sql: ${jobs_delayed_1000ms} / NULLIF(${count},0) ;;
    drill_fields: [detail*]
  }

  measure: percent_jobs_delayed_5000ms {
    group_label: "Delay to Start"
    label: "Precent Jobs Delayed > 5s"
    description: "Percent of jobs whose delay to start was over 5 seconds"
    type: number
    value_format_name: percent_2
    sql: ${jobs_delayed_5000ms} / NULLIF(${count},0) ;;
    drill_fields: [detail*]
  }

  measure: percent_jobs_delayed_25000ms {
    group_label: "Delay to Start"
    label: "Precent Jobs Delayed >25s"
    description: "Percent of jobs whose delay to start was over 25 seconds"
    type: number
    value_format_name: percent_2
    sql: ${jobs_delayed_25000ms} / NULLIF(${count}),0) ;;
    drill_fields: [detail*]
  }

  # }

  # Measure group: Spill to Disk {

  measure: any_spill_to_disk {
    group_label: "Spill to Disk"
    label: "Any spill to disk?"
    description: "Whether any bytes spilled to disk"
    type: yesno
    sql: BOOL_OR(${has_spill_to_disk}) ;;
    drill_fields: [detail*]
  }

  measure: spill_to_disk_count {
    group_label: "Spill to Disk"
    label: "Spill to Disk Count"
    description: "Count of jobs with spill to disk"
    type: count
    filters: [has_spill_to_disk: "yes"]
    drill_fields: [detail*]
  }

  measure: average_spill_to_disk_mib {
    group_label: "Spill to Disk"
    label: "Average Spill to Disk MiB"
    description: "Average bytes spilled to disk per job, in megibytes (2^10 bytes)"
    type: average
    sql: ${spill_to_disk_bytes} / (1024 * 1024);;
    drill_fields: [detail*]
    value_format_name: decimal_2
  }

  measure: percent_spill_to_disk {
    group_label: "Spill to Disk"
    label: "Percent Spill to Disk"
    description: "Percent of jobs with spill to disk"
    type: number
    value_format_name: percent_1
    sql: ${spill_to_disk_count} / NULLIF(${count},0) ;;
    drill_fields: [detail*]
  }

  measure: total_spill_to_disk_bytes {
    hidden: yes # Larger units are more practical
    group_label: "Spill to Disk"
    label: "Total Spill to Disk Bytes"
    description: "Total bytes spilled to disk"
    type: sum
    sql: ${spill_to_disk_bytes} ;;
    filters: [has_spill_to_disk: "yes"]
    drill_fields: [detail*]
  }

  measure: total_spill_to_disk_gib {
    group_label: "Spill to Disk"
    label: "Total Spill to Disk GiB"
    description: "Total bytes spilled to disk, in gigibytes (2^30 bytes)"
    type: number
    sql: ${total_spill_to_disk_bytes} / (1024 * 1024 * 1024) ;;
    drill_fields: [detail*]
  }

  # End measure group spill to disk bytes }

  # Measure Group: Slot Milliseconds {

  measure: total_slot_ms {
    group_label: "Slot Milliseconds"
    label: "Total Slot ms"
    type: sum
    sql: ${slot_ms} ;;
    value_format_name: decimal_0
    drill_fields: [job_level*]
  }

  measure: total_slot_seconds {
    group_label: "Slot Milliseconds"
    type: number
    sql: ${total_slot_ms} / 1000 ;;
    value_format_name: decimal_2
    drill_fields: [job_level*]
  }

  measure: total_slot_minutes {
    group_label: "Slot Milliseconds"
    type: number
    sql: ${total_slot_ms} / 1000/60 ;;
    value_format_name: decimal_2
    drill_fields: [job_level*]
  }

  measure: total_slot_hours {
    group_label: "Slot Milliseconds"
    type: number
    sql: ${total_slot_ms} / 1000/60/60;;
    value_format_name: decimal_2
    drill_fields: [job_level*]
  }

  measure: average_slot_ms {
    group_label: "Slot Milliseconds"
    label: "Average Slot ms"
    description: "The average slot milliseconds used across jobs"
    type: average
    sql: ${slot_ms} ;;
    value_format_name: decimal_0
    drill_fields: [job_level*]
  }

  measure: max_slot_ms {
    group_label: "Slot Milliseconds"
    label: "Max Slot ms"
    description: "The maximum slot milliseconds used by a single job"
    type: max
    sql: ${slot_ms} ;;
    value_format_name: decimal_0
    drill_fields: [job_level*]
  }

  measure: skew_slot_ms {
    group_label: "Slot Milliseconds"
    label: "Slot ms Skew"
    description: "The ratio of the maximum slot milliseconds used by a single job against the average slot milliseconds used across jobs"
    type: number
    sql: ${max_slot_ms} / NULLIF(${average_slot_ms},0) ;;
    value_format_name: decimal_1
    drill_fields: [job_level*]
  }

  # }

  set: detail {
    fields: [
      creation_time,
      project_id,
      user_email,
      job_id,
      job_type,
      start_time_time,
      end_time_time,
      state,
      gb_processed,
      duration_seconds,
      total_slot_ms,
    ]
  }
}



view: jobs_by_project_raw__labels {

  dimension: labels {
    type: string
    sql: ${TABLE} ;;
  }
}


view: jobs_by_project_raw__job_stages__input_stages {

  dimension: input_stages {
    type: string
    sql: ${TABLE} ;;
  }
}

view: jobs_by_project_raw__job_stages__steps {

  dimension: steps {
    hidden: yes
    type: string
    sql: ${TABLE}.steps ;;
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
  }

  dimension: substeps {
    type: string
    hidden: yes
    sql: ${TABLE}.substeps ;;
  }
}

view: jobs_by_project_raw__job_stages__steps__substeps  {

  dimension: substeps {
    type: string
    sql: ${TABLE} ;;
  }
}

##### NDT to filter Top N Referenced Datasets ######

view: referenced_datasets_ndt {
  derived_table: {
    explore_source: jobs_by_project_raw {
      column: referenced_dataset {field: jobs_by_project_raw__referenced_tables.referenced_dataset_id}
      column: total_jobs {field: jobs_by_project_raw.count_of_jobs}
      derived_column: rank {sql: RANK() OVER (ORDER BY total_jobs DESC) ;;}
      bind_all_filters: yes
      sorts: [total_jobs: desc]
      timezone: "query_timezone"
    }
  }

  dimension: referenced_dataset {
    hidden: yes
  }

  dimension: rank {
    type: number
  }

  dimension: referenced_dataset_ranked_total_jobs {
    sql: ${rank} || ' - ' || ${referenced_dataset} ;;
    order_by_field: rank
    type: string
  }
}
