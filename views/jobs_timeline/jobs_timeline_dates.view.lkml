# A field-only view for cross view fields between jobs_timeline and date_fill

include: "/views/jobs_timeline/jobs_timeline.view.lkml"
include: "/views/dynamic_dts/date_fill.view.lkml"

view: jobs_timeline_dates {

  measure: average_slots {
    type: number
    sql: ${jobs_timeline.total_slot_seconds} / NULLIF(${date_fill.total_interval_duration_s},0) ;;
    description: "Average slot usage, equal to slot milliseconds divided by period/timerange duration. (Note: because this measure relies on a datefill table to calculate the denominator, please make sure any non-date filters include NULL values to successfully calculate this metric)"
    value_format_name: decimal_2
    drill_fields: [jobs_timeline.job_level*]
  }

}
