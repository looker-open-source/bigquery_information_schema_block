view: tables {

  # https://cloud.google.com/bigquery/docs/information-schema-tables

  sql_table_name: `region-@{REGION}.INFORMATION_SCHEMA.TABLES` ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # Dimension group: identifiers {

  dimension: table_full_path {
    primary_key: yes
    group_label: "[Identifiers]"
    label: "  [Path]"
    description: "The project, dataset, and table name as a single dot-delimited string"
    sql: ${table_catalog} || "." || ${table_schema} || "." || ${table_name};;
  }

  dimension: table_catalog {
    group_label: "[Identifiers]"
    label: "  Project"
    description: "The project ID of the project that contains the dataset. a.k.a table catalog"
    type: string
    sql: ${TABLE}.table_catalog ;;
  }

  dimension: table_schema {
    group_label: "[Identifiers]"
    label: " Dataset"
    description: "The name of the dataset that contains the table. a.k.a. datasetId, or table schema"
    type: string
    sql: ${TABLE}.table_schema ;;
  }

  dimension: table_name {
    group_label: "[Identifiers]"
    label: "Name"
    description: "The name of the table or view. a.k.a tableId"
    type: string
    sql: ${TABLE}.table_name ;;
  }

  # }

  dimension: table_type {
    description: "The type of table. E.g., BASE TABLE, VIEW, MATERIALIZED VIEW, EXTERNAL, or SNAPSHOT"
    type: string
    sql: ${TABLE}.table_type ;;
    suggestions: ["BASE TABLE", "VIEW", "MATERIALIZED VIEW", "EXTERNAL", "SNAPSHOT"]
  }

  dimension: is_insertable_into {
    label: "Is Insertable Into?"
    type: string
    sql: ${TABLE}.is_insertable_into ;;
    suggestions: ["YES","NO"]
  }

  dimension: is_typed {
    hidden: yes # Per current BQ docs, the value is always no
    type: string
    sql: ${TABLE}.is_typed ;;
  }

  dimension_group: creation_time {
    type: time
    sql: ${TABLE}.creation_time ;;
    timeframes: [raw,minute,date,month,year]
  }

  set: detail {
    fields: [
      table_full_path,
      table_type,
      is_insertable_into
    ]
  }
}