include: "/views/jobs/jobs.view.lkml"

view: job_referenced_tables {

  sql_table_name: UNNEST(jobs.referenced_tables) ;;

  dimension: table_full_path {
    group_label: "[Identifiers]"
    label: "Path, as referenced"
    description: "The project, dataset, and table name as a single dot-delimited string. This comes from the jobs.referenced_tables field, regardless of whether the table is found/matched in the tables table."
    sql: ${project_id} || "." || ${dataset_id} || "." || ${table_id};;
  }

  dimension: project_id {
    type: string
    full_suggestions: yes
    hidden: yes
    sql: ${TABLE}.project_id ;;
  }

  dimension: dataset_id {
    type: string
    full_suggestions: yes
    hidden: yes
    sql: ${TABLE}.dataset_id ;;
  }

  dimension: table_id {
    type: string
    full_suggestions: yes
    hidden: yes
    sql: ${TABLE}.table_id ;;
  }
}
