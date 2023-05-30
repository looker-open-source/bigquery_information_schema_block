include: "/views/jobs/jobs.view.lkml"

# Nested fields
include: "/views/jobs/job_referenced_tables.view.lkml"
include: "/views/jobs/job_timeline_entries.view.lkml"
include: "/views/jobs/job_stages.view.lkml"
include: "/views/jobs/job_stage_steps.view.lkml"

# Joins
include: "/views/tables.view.lkml"
include: "/views/columns.view.lkml"
include: "/views/reservations/reservations.view.lkml"
include: "/views/dynamic_dts/date_fill.view.lkml"
include: "/views/reservations/reservations_threshold.view"


# Field-only views
include: "/views/date.view.lkml"
include: "/views/jobs/jobs_dates.view.lkml"

# Aggregate tables

explore: jobs {
  extends: [jobs_base]
  description: "Explore jobs, such as queries. (Scope: @{SCOPE})"
  hidden: no

#   aggregate_table: week__project_id {
#     query: {
#       dimensions: [date.__week, project_id]
#       measures: [total_slot_ms, total_processed_tib]
#       filters: [jobs.state: "DONE"]
#       timezone: "..."
#     }
#     materialization: {sql_trigger_value: SELECT DATE_TRUNC(CURRENT_DATE( {timezone} ), WEEK(SUNDAY)) ;;}
#   }
}

explore: jobs_in_project {
  extends: [jobs_base]
  from: jobs_in_project
  description: "Explore jobs, such as queries. (Scope: PROJECT)"
}

explore: jobs_in_organization {
  extends: [jobs_base]
  from: jobs_in_organization
  description: "Explore jobs, such as queries. (Scope: ORGANIZATION)"

  join: reservations_threshold {
    view_label: "Reservation Threshold"
    type: left_outer
    relationship: many_to_one
    sql_on: ${jobs.reservation_id} = ${reservations_threshold.reservation_id} ;;
  }
}


view: job_join_paths {dimension: _alias { hidden: yes sql:${TABLE};;}}

explore: jobs_base {
  view_label: "[Jobs]"
  extension: required
  hidden: yes
  from: jobs
  view_name: jobs


  always_filter: {
    filters: [
      date.date_filter: "last 8 days" #Partition column
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
      {% if jobs._in_query      %} jobs.creation_time, {% endif %}
      {% if date_fill._in_query %} date_fill.d, {% endif %}
      CAST(NULL AS TIMESTAMP)
      )]) ;;
  }

  join: jobs_dates {
    view_label: "[Jobs]"
    relationship: one_to_one
    sql:  ;;
  }


  join: job_join_paths {
    relationship: one_to_many # In case we need measures from jobs and want to use sym aggs rather than dim/msr-splitting the fields
    type: left_outer
    sql_table_name: UNNEST([1,2]) ;;
    sql_on: 0=1
    {% if job_referenced_tables._in_query %} OR ${job_join_paths._alias} = 1 {%endif%}
    {% if job_stages._in_query            %} OR ${job_join_paths._alias} = 2 {%endif%}
    ;;
  }

  join: job_referenced_tables {
    view_label: "Job > Tables"
    relationship: one_to_one
    type: left_outer
    sql_on: ${job_join_paths._alias} = 1 ;;
  }

  join: tables {
    view_label: "Job > Tables"
    type: left_outer
    relationship: one_to_one
    sql_on: ${tables.table_catalog} = ${job_referenced_tables.project_id}
        AND ${tables.table_schema} = ${job_referenced_tables.dataset_id}
        AND ${tables.table_name} = ${job_referenced_tables.table_id} ;;
  }

  join: partition_column {
    view_label: "Job > Tables > Partition"
    from: columns
    type: left_outer
    relationship: one_to_one
    sql_on:
      ${partition_column.table_name} = ${tables.table_name}
      AND ${partition_column.is_partitioning_column} = "YES";;
  }

  join: cluster_1_column {
    view_label: "Job > Tables > Cluster(1)"
    from: columns
    type: left_outer
    relationship: one_to_one
    sql_on:
      ${cluster_1_column.table_name} = ${tables.table_name}
      AND ${cluster_1_column.clustering_ordinal_position} = 1;;
  }

  join: job_stages {
    view_label: "Job > Stages"
    relationship: one_to_one
    type: left_outer
    sql_on: ${job_join_paths._alias} = 2 ;;
  }

  join: job_stage_steps {
    view_label: "Job > Stages > Steps"
    relationship: one_to_many
    type: left_outer
    sql: LEFT JOIN UNNEST(job_stages.steps) AS job_stage_steps WITH OFFSET job_stage_steps_offset ;;
    required_joins: [job_stages]
  }

#   join: job_stage_step_substeps {
#     view_label: "Job > Stages > Steps > Substeps"
#     relationship: one_to_many
#     type: left_outer
#     sql: LEFT JOIN UNNEST(job_stage_steps.substeps) AS job_stage_step_substeps WITH OFFSET job_stage_step_substeps_offset ;;
#   }

  join: reservation {
    from: reservations
    relationship: many_to_one
    sql_on: ${reservation.reservation_name} = ${jobs.reservation_id};;
  }

#   join: jobs_by_project_raw__job_stages__input_stages {
#     view_label: "Jobs by Organization: Job Stages"
#     sql: LEFT JOIN UNNEST(${jobs_by_project_raw__job_stages.input_stages}) as jobs_by_project_raw__job_stages__input_stages ;;
#     relationship: one_to_many
#   }
#
#   join: jobs_by_project_raw__job_stages__steps {
#     view_label: "Jobs by Organization: Job Stages"
#     sql: LEFT JOIN UNNEST(${jobs_by_project_raw__job_stages.steps}) as jobs_by_project_raw__job_stages__steps ;;
#     relationship: one_to_many
#   }
#
#   join: jobs_by_project_raw__job_stages__steps__substeps {
#     view_label: "Jobs by Organization: Job Stages"
#     sql: LEFT JOIN UNNEST(${jobs_by_project_raw__job_stages__steps.substeps}) as jobs_by_project_raw__job_stages__steps__substeps ;;
#     relationship: one_to_many
#   }
#
#   join: referenced_datasets_ndt {
#     view_label: "Jobs by Organization: Referenced Tables"
#     relationship: many_to_one
#     type: left_outer
#     sql_on: ${jobs_by_project_raw__referenced_tables.referenced_dataset_id} = ${referenced_datasets_ndt.referenced_dataset} ;;
#   }

  # The nested timeline should be easy to add under the join paths, but the regular job timeline table is probably more convenient
#   join: job_timeline_entries {
#     view_label: "Job > Timeline"
#     relationship: one_to_one
#     type: left_outer
#     sql_on: ${job_join_paths._alias} = ... ;;
#   }


}