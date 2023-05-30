
# This is a multi-fact explore to support qureies that include, e.g. both reservations and jobs metrics codimensioned by project


include: "/views/reservations/capacity_commitments.view.lkml"
include: "/views/reservations/reservations.view.lkml"
include: "/views/jobs/jobs.view.lkml"
include: "/views/jobs_timeline/jobs_timeline.view.lkml"
include: "/views/tables.view.lkml"

include: "/views/dynamic_dts/date_fill.view.lkml"
include: "/views/date.view.lkml"
include: "/views/jobs/jobs_dates.view.lkml"
include: "/views/jobs_timeline/jobs_timeline_dates.view.lkml"

view: none {
  derived_table: {
    sql: SELECT 0 FROM UNNEST([])  ;; # Zero-row table
  }
}

explore: all {
  from: none
  hidden: yes
  description: "This explore combines a number of tables together for more convenient analysis along co-dimensions"

  always_filter: {
    filters: [
      date.date_filter: "last 8 days"
    ]
  }

  join: capacity_commitments {
    relationship: one_to_one
    type: full_outer
    sql_on: FALSE ;;
  }
  join: reservations {
    relationship: one_to_one
    type: full_outer
    sql_on: FALSE ;;
  }
  join: jobs {
    relationship: one_to_one
    type: full_outer
    sql_on: FALSE ;;
  }
  join: jobs_timeline {
    relationship: one_to_one
    type: full_outer
    sql_on: FALSE ;;
  }
  join: tables {
    relationship: one_to_one
    type: full_outer
    sql_on: FALSE ;;
  }

  join: date_fill {
    type: full_outer
    relationship: one_to_one
    sql_on: FALSE ;;
  }

  # Comeasure views

  join: jobs_dates {
    relationship: one_to_one
    view_label: "Jobs"
    sql:  ;;
  }
  join: jobs_timeline_dates {
    relationship: one_to_one
    view_label: "Jobs Timeline"
    sql:  ;;
  }


  # Codimension views

  join: project_id {

    # Note: later, it may be helpful to have multiple project fields, since some views are associated with multiple projects in different ways
    # e.g. assignments have both the admin/billing project ID, and sometimes an assignee project ID
    # Job table scan steps might have both a job project ID and a table project ID

    type: cross
    relationship: one_to_one
    sql_table_name: UNNEST([COALESCE(
      {% if jobs._in_query                  %} jobs.project_id, {% endif %}
      {% if jobs_timeline._in_query         %} jobs_timeline.project_id, {% endif %}
      {% if tables._in_query                %} tables.project_id, {% endif %}
      {% if capacity_commitments._in_query  %} capacity_commitments.project_id, {% endif %}
      {% if reservations._in_query          %} reservations.project_id, {% endif %}
      NULL
      )]) ;;
  }

  join: date {
    type: cross
    relationship: one_to_one
    sql_table_name: UNNEST([COALESCE(
      {% if jobs._in_query          %} jobs.creation_time, {% endif %}
      {% if jobs_timeline._in_query %} jobs_timeline.period_start, {% endif %}
      {% if date_fill._in_query     %} date_fill.d, {% endif %}
      CAST(NULL AS TIMESTAMP)
      )]) ;;
  }

}

view: project_id {
  label: "Project"
  dimension: _info {
    label: "[View Info]"
    sql: NULL ;; #This field is for information/description only
    description: "This view is a codimension view. It does not list projects on its own. Instead it will show the projects associated with any other views in your query (e.g. commitments, jobs, reservations, etc)"
  }

  dimension: project_id {
    label: "Project ID"
    sql: ${TABLE} ;;
  }
}
