# This view is for the nested array within a job row. For the flattened table, see jobs_timeline.view.lkml

view: job_timeline_entries {

  sql_table_name: UNNEST(jobs.timeline) ;;

  dimension: elapsed_ms {
    type: number
    sql: ${TABLE}.elapsed_ms ;;
  }

  dimension: total_slot_ms {
    type: number
    sql: ${TABLE}.total_slot_ms ;;
  }

  dimension: query_total_slot {
    type: number
    sql: ${total_slot_ms}/${elapsed_ms} ;;
  }

  measure: total_query_slot {
    type: sum
    sql: ${query_total_slot} ;;
  }

  dimension: pending_units {
    hidden: yes
    type: number
    sql: ${TABLE}.pending_units ;;
  }

  dimension: completed_units {
    type: number
    sql: ${TABLE}.completed_units ;;
  }
  dimension: active_units {
    type: number
    sql: ${TABLE}.active_units ;;
  }
}
