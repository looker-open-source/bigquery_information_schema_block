view: job_stage_steps {

  sql_table_name: UNNEST(${job_stages.SQL_TABLE_NAME}.steps) ;;

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${jobs.job_id} || "-" || CAST(${job_stages.stage_id} AS STRING) || "-" || CAST(job_stage_steps_offset AS STRING) ;;
  }

  dimension: kind {}

  dimension: join_type {
    type: string
    sql: CASE WHEN ${kind} = "JOIN" THEN (SELECT STRING_AGG(REGEXP_REPLACE(substep, r" ON .*", ""), "; ") FROM ${TABLE}.substeps AS substep) END;;
  }

  dimension: join_condition {
    type: string
    sql: CASE WHEN ${kind} = "JOIN" THEN (SELECT STRING_AGG(REGEXP_REPLACE(substep, r".*? ON ", ""), "; ") FROM ${TABLE}.substeps AS substep) END;;
  }

}
