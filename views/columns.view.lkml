view: columns {
  sql_table_name: `region-@{REGION}.INFORMATION_SCHEMA.COLUMNS` ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: table_catalog {
    hidden: yes # Foreign key
    type: string
    sql: ${TABLE}.table_catalog ;;
  }

  dimension: table_schema {
    hidden: yes # Foreign key
    type: string
    sql: ${TABLE}.table_schema ;;
  }

  dimension: table_name {
    hidden: yes # Foreign key
    type: string
    sql: ${TABLE}.table_name ;;
  }

  dimension: column_name {
    label: "[Name]"
    type: string
    sql: ${TABLE}.column_name ;;
  }

  dimension: ordinal_position {
    type: number
    sql: ${TABLE}.ordinal_position ;;
  }

  dimension: is_nullable {
    type: string
    sql: ${TABLE}.is_nullable ;;
    suggestions: ["YES","NO"]
  }

  dimension: data_type {
    type: string
    sql: ${TABLE}.data_type ;;
  }

  dimension: is_generated {
    type: string
    sql: ${TABLE}.is_generated ;;
    suggestions: ["YES","NO"]
  }

  dimension: generation_expression {
    type: string
    sql: ${TABLE}.generation_expression ;;
  }

  dimension: is_stored {
    type: string
    sql: ${TABLE}.is_stored ;;
    suggestions: ["YES","NO"]
  }

  dimension: is_hidden {
    type: string
    sql: ${TABLE}.is_hidden ;;
    suggestions: ["YES","NO"]
  }

  dimension: is_updatable {
    type: string
    sql: ${TABLE}.is_updatable ;;
    suggestions: ["YES","NO"]
  }

  dimension: is_system_defined {
    type: string
    sql: ${TABLE}.is_system_defined ;;
    suggestions: ["YES","NO"]
  }

  dimension: is_partitioning_column {
    type: string
    sql: ${TABLE}.is_partitioning_column ;;
    suggestions: ["YES","NO"]
  }

  dimension: clustering_ordinal_position {
    type: number
    sql: ${TABLE}.clustering_ordinal_position ;;
    suggestions: ["YES","NO"]
  }

  set: detail {
    fields: [
      table_catalog,
      table_schema,
      table_name,
      column_name,
      ordinal_position,
      is_nullable,
      data_type,
      is_generated,
      generation_expression,
      is_stored,
      is_hidden,
      is_updatable,
      is_system_defined,
      is_partitioning_column,
      clustering_ordinal_position
    ]
  }
}