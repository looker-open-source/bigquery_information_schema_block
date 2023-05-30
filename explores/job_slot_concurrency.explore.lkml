include: "/views/dynamic_dts/job_slot_concurrency.view.lkml"
include: "/views/date.view.lkml"

explore: job_slot_concurrency {
  hidden: yes
  always_filter: {
    filters: [date.date_filter: "1 day ago for 1 day"]
  }
  join: date_fill {
    sql: ;;
  relationship: one_to_one
  }
  join: date {
    type: cross
    relationship: many_to_one
    sql_table_name: UNNEST([COALESCE(
        job_slots_datepart_summaries.slot_activity_period
        )]);;
    required_joins: []
  }
}
