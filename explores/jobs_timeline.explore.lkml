include: "/views/jobs_timeline/jobs_timeline.view.lkml"
include: "/views/dynamic_dts/date_fill.view.lkml"

# Field-only views
include: "/views/date.view.lkml"
include: "/views/jobs_timeline/jobs_timeline_dates.view.lkml"
include: "/views/jobs_timeline/jobs_timeline_job.view.lkml"
include: "/views/jobs_timeline/jobs_timeline_job_dates.view.lkml"

explore: jobs_timeline {
  view_label: "[Jobs Timeline]"
  description: "This dataset contains a row for every second (between creation and completion) for every query. (Scope: @{SCOPE})"

  always_filter: {
    filters: [
      date.date_filter: "last 8 days"
      ]
    }

  join: date_fill {
    type: full_outer
    relationship: one_to_one
    sql_on: FALSE ;;
  }

  join: date {
    type: cross
    relationship: one_to_one
    sql_table_name: UNNEST([COALESCE(
      {% if jobs_timeline._in_query %} jobs_timeline.period_start, {% endif %}
      {% if date_fill._in_query     %} date_fill.d, {% endif %}
      CAST(NULL AS TIMESTAMP)
      )]) ;;
  }

  join: jobs_timeline_dates {
    view_label: "[Jobs Timeline]"
    sql:  ;; #Field only view for cross-view fields
    relationship: one_to_one
  }

  join: jobs_timeline_job {
    view_label: "Job"
    sql:  ;; #Field only view for cross-view fields ;;
    relationship: many_to_one
  }

  join: jobs_timeline_job_dates {
    view_label: "Job"
    sql:  ;; #Field only view for cross-view fields
    relationship: one_to_one
  }

}