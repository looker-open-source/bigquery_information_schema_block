# Views based on the following tables: https://cloud.google.com/bigquery/docs/information-schema-jobs-timeline
# The tables are different in scope, but all contain 1 row per job x time period. Essentially, a row for every second that a job was running
# This is similar to the timeline array nested within the jobs table, but flattened
# For slot usage analysis, this is more expensive to query at the job level, but is more accurate for fine time granularities

include: "/views/date.view.lkml"

view: jobs_timeline {
  extends: [jobs_timeline_base]
  derived_table: {
    sql:
      SELECT *
      FROM `region-@{REGION}.INFORMATION_SCHEMA.JOBS_TIMELINE_BY_@{SCOPE}`
      WHERE job_creation_time >= TIMESTAMP_SUB({% date_start date.date_filter %}, INTERVAL @{MAX_JOB_LOOKBACK})
      AND job_creation_time <= {% date_end date.date_filter %}
     ;;
  }
}
view: jobs_timeline_in_project {
  extends: [jobs_timeline_base]
  derived_table: {
    sql:
      SELECT *
      FROM `region-@{REGION}.INFORMATION_SCHEMA.JOBS_TIMELINE_BY_PROJECT`
      WHERE job_creation_time >= TIMESTAMP_SUB({% date_start date.date_filter %}, INTERVAL @{MAX_JOB_LOOKBACK})
      AND job_creation_time <= {% date_end date.date_filter %}
     ;;
  }
}
view: jobs_timeline_in_organization{
  extends: [jobs_timeline_base]
  derived_table: {
    sql:
      SELECT *
      FROM `region-@{REGION}.INFORMATION_SCHEMA.JOBS_TIMELINE_BY_ORGANIZATION`
      WHERE job_creation_time >= TIMESTAMP_SUB({% date_start date.date_filter %}, INTERVAL @{MAX_JOB_LOOKBACK})
      AND job_creation_time <= {% date_end date.date_filter %}
     ;;
  }
}

view: jobs_timeline_base {
  extension: required

  dimension: sql_table_name {
    # For use in jobs_timeline_job to reference this table's join alias
    hidden: yes
    sql:${TABLE};;
  }


  #Primary key is (job_id, period_start)
  dimension: job_id {
    hidden: yes # More intuitive to show as the PK in the job view than as a FK in the timeline view
    type: string
    sql: ${TABLE}.job_id ;;
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

  dimension_group: period_start {
    # Unfortunately, this is not the partition column, job_creation_time is
    hidden: yes # Prefer to use a field in an abstract date view
    description: "Start time of this period"
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
      day_of_week_index,
      hour_of_day
    ]
    sql: ${TABLE}.period_start ;;
  }

  dimension_group: job_creation_time {
    # This is the partitioning column
    type: time
    hidden: yes # Fields will make more sense in the field picker under the Job view
    timeframes: [raw, date, time]
    sql: ${TABLE}.job_creation_time ;;
  }

  dimension: project_id {
    # This is one of two clustering columns
    hidden:  yes # It is more logical to display it at the job level
    description: "ID of the project for the job"
    type: string
    sql: ${TABLE}.project_id ;;
  }

  dimension: user_email {
    # This is one of two clustering columns
    hidden:  yes # It is more logical to display it at the job level
    type: string
    sql: ${TABLE}.user_email ;;
  }

  dimension: project_number {
    hidden: yes # Foreign key
    type: number
    sql: ${TABLE}.project_number ;;
  }

  dimension: period_slot_ms {
    description: "Slot milliseconds consumed by a job in the period"
    hidden: yes # To be used almost exclusively as a measure
    type: number
    sql: ${TABLE}.period_slot_ms ;;
  }


  dimension: state {
    description: "Running state of the job at the end of this period. Valid states include PENDING, RUNNING, and DONE"
    type: string
    sql: ${TABLE}.state ;;
  }



  # Measure Group: Job Seconds {


  measure: job_seconds {
    group_label: "Job Seconds"
    label: "Job Seconds"
    description: "Number of jobs running x number of seconds from creation to end. (Max granularity is 1 job second). Useful for understanding job density for non slot-consuming jobs, e.g. pending jobs"
    type: count
    value_format_name: decimal_0
    drill_fields: [detail*]
  }

  measure: job_seconds_running {
    group_label: "Job Seconds"
    label: "Job Seconds Running"
    description: "Number of jobs running x number of seconds that they were running, from creation to start. (Max granularity is 1 job second). Useful for understanding job density for non slot-consuming jobs, e.g. pending jobs"
    type: count
    filters: [
      jobs_timeline.state: "RUNNING"
    ]
    value_format_name: decimal_0
    drill_fields: [detail*]
  }

  measure: job_seconds_pending {
    group_label: "Job Seconds"
    label: "Job Seconds Pending"
    description: "Number of jobs running x number of seconds that they were pending, from creation to start. (Max granularity is 1 job second). Useful for understanding job density for non slot-consuming jobs, e.g. pending jobs"
    type: count
    filters: [
      jobs_timeline.state: "PENDING"
    ]
    value_format_name: decimal_0
    drill_fields: [detail*]
  }

  # Are different units actually helpful? Commenting for now
  #
  # measure: job_minutes {
  #   group_label: "Job Seconds"
  #   label: "Job Minutes"
  #   description: "Job seconds, converted to minutes"
  #   type: number
  #   sql: 1.0 * ${job_seconds} / 60 ;;
  #   value_format_name: decimal_1
  #   drill_fields: [detail*]
  # }

  # measure: job_hours {
  #   group_label: "Job Seconds"
  #   label: "Job Hours"
  #   description: "Job seconds, converted to hours"
  #   type: number
  #   sql: 1.0 * ${job_seconds} / 60 / 60;;
  #   value_format_name: decimal_1
  #   drill_fields: [detail*]
  # }

  # }

  # Measure Group: Count jobs {

  measure: count_jobs {
    group_label: "Count Jobs"
    type: count_distinct
    sql: ${job_id} ;;
    filters: [job_id: "-NULL"]
    drill_fields: [job_level*]
  }

  measure: running_jobs {
    group_label: "Count Jobs"
    type: count_distinct
    sql: ${job_id} ;;
    filters: [state: "RUNNING"]
    drill_fields: [job_level*]
  }
  measure: pending_jobs {
    group_label: "Count Jobs"
    type: count_distinct
    sql: ${job_id} ;;
    filters: [state: "PENDING"]
    drill_fields: [job_level*]
  }

  # }

  # Measure Group: Slot Milliseconds {

  measure: total_slot_ms {
    group_label: "Slot Milliseconds"
    type: sum
    sql: ${period_slot_ms} ;;
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

  # }

  # Measure Group: Time Elapsed {

  measure: min_period_start {
    group_label: "Time Elapsed"
    label: "Earliest timeline entry"
    type: date_time
    datatype: timestamp
    sql: MIN(${period_start_raw}) ;;
  }



  measure: max_period_start {
    hidden: yes
    type: date_time
    datatype: timestamp
    sql: MAX(${period_start_raw}) ;;
  }

  measure: elapsed_seconds  {
    group_label: "Time Elapsed"
    type: number
    sql: 1+TIMESTAMP_DIFF(MAX(${period_start_raw}),MIN(${period_start_raw}), SECOND) ;;
  }

  measure: elapsed_minutes  {
    group_label: "Time Elapsed"
    type: number
    sql: ${elapsed_seconds}/60 ;;
    value_format_name: decimal_1
  }

  measure: elapsed_hours  {
    group_label: "Time Elapsed"
    type: number
    sql: ${elapsed_seconds}/60/60 ;;
    value_format_name: decimal_1
  }

  # }






  set: job_level {
    fields: [
      job_id,
      project_id,
      user_email,
      job_type,
      statement_type,
      total_bytes_processed,
      total_bytes_billed,
      count_jobs_timeline
    ]
  }
  set: detail {
    fields: [
      job_id,
      period_start_time,
      priority,
      state,
      cache_hit,
      reservation_id,
      total_slot_ms,
      total_bytes_processed,
      total_bytes_billed
    ]
  }

}