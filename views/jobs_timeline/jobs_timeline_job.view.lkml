# Several columns on the jobs_timeline tables are just job-level columns that have been denormalized. For proper labelling and symmetric aggregates,
# this field only view contains the field definitions for those columns

include: "/views/jobs_timeline/jobs_timeline.view.lkml"

view: jobs_timeline_job {
  view_label: "Job"


  dimension: job_id {
    type: string
    primary_key: yes
    label: "[Job ID]"
    sql: ${jobs_timeline.sql_table_name}.job_id ;;
    link: {
      label: "Job Lookup Dashboard"
      url: "/dashboards-next/bigquery_information_schema::job_lookup_dashboard?Job%20ID={{ value | encode_uri}}&Created={{date.date_in_filter_format | encode_uri}}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
    link: {
      label: "View Query History in BigQuery"
      url: "https://console.cloud.google.com/bigquery?j=bq:@{REGION}:{{ value }}&page=queryresults"
      icon_url: "http://www.looker.com/favicon.ico"
    }
  }

  dimension: project_id {
    description: "ID of the project for the job"
    label: "Project ID"
    type: string
    sql: ${jobs_timeline.sql_table_name}.project_id ;;
  }

  dimension: user_email {
    type: string
    sql: ${jobs_timeline.sql_table_name}.user_email ;;
  }

  dimension: job_type {
    type: string
    sql: ${jobs_timeline.sql_table_name}.job_type ;;
  }

  dimension: statement_type {
    type: string
    sql: ${jobs_timeline.sql_table_name}.statement_type ;;
  }

  dimension: priority {
    type: string
    sql: ${jobs_timeline.sql_table_name}.priority ;;
  }

  dimension_group: job_start_time {
    type: time
    sql: ${jobs_timeline.sql_table_name}.job_start_time ;;
  }

  dimension_group: job_end_time {
    type: time
    sql: ${jobs_timeline.sql_table_name}.job_end_time ;;
  }

  dimension: reservation_id {
    label: "Reservation ID"
    type: string
    sql: ${jobs_timeline.sql_table_name}.reservation_id ;;
  }

#  This is a struct an needs further modeling. https://cloud.google.com/bigquery/docs/reference/rest/v2/ErrorProto
#   dimension: error_result {
#     type: string
#     sql: ${TABLE}.error_result ;;
#   }

  dimension: cache_hit {
    type: string
    sql: ${jobs_timeline.sql_table_name}.cache_hit ;;
  }


  # Dimension group: Bytes {

  dimension: bytes_processed {
    hidden: yes # Gb version is more reasonable units
    group_label: "Bytes"
    label: "Processed Bytes"
    type: number
    sql: ${jobs_timeline.sql_table_name}.total_bytes_processed ;;
  }

  dimension: gib_processed {
    hidden: yes # Use total measure instead
    group_label: "Bytes"
    label: "Processed GiB"
    type: number
    sql: ${bytes_processed} / (1024*1024*1024)  ;;
    value_format_name: decimal_2
  }


  # }

  # Measure Group: Bytes {


  measure: total_bytes_processed {
    group_label: "Bytes"
    label: "Processed Bytes"
    type: sum
    sql: ${bytes_processed} ;;
    value_format: "#,##0 \" b\""
    drill_fields: [job_level*]
  }

  measure: total_gib_processed {
    group_label: "Bytes"
    label: "Processed GiB"
    description: "Processed bytes, but in gigibytes (2^30 bytes)"
    type: number
    sql: ${total_bytes_processed} / (1024*1024*1024)   ;;
    value_format: "#,##0.0 \" GiB\""
    drill_fields: [job_level*]
  }

  measure: total_tb_processed {
    group_label: "Bytes"
    label: "Processed TiB"
    description: "Processed bytes, but in tebibytes (2^40 bytes)"
    type: number
    sql: ${total_bytes_processed} / (1024*1024*1024*1024)   ;;
    value_format: "#,##0.00 \" TiB\""
    drill_fields: [job_level*]
  }

  # }

  measure: count {
    type: count_distinct
    sql: ${job_id} ;;
  }

  set: job_level {
    fields: [
      job_id,
      jobs_timline.project_id,
      jobs_timline.user_email,
      job_type,
      statement_type,
      total_bytes_processed,
      jobs_timline.count_jobs_timeline
    ]
  }

}