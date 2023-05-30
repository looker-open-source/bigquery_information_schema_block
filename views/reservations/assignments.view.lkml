view: assignments {
 # An assignement represents the assignment of previously committed and possibly reserved resources to a target project

  sql_table_name: `@{BILLING_PROJECT_ID}.region-@{REGION}.INFORMATION_SCHEMA.ASSIGNMENTS_BY_PROJECT` ;;

  dimension: assignment_id {
    label: "[ID]"
    primary_key: yes
    description: "ID that uniquely identifies the assignment"
    type: string
    sql: ${TABLE}.assignment_id ;;
  }

  dimension: admin_project_id {
    label: "Admin Project ID"
    description: "String ID/name of the administrative project"
    hidden: yes # Because foreign key. Show in its own view.
    sql: ${TABLE}.project_id ;;
    type: string
  }
  dimension: admin_project_number {
    description: "Internal numeric ID of the administrative project"
    hidden: yes # Because foreign key. Show in its own view.
    sql: ${TABLE}.project_number ;;
    type: number
  }
  dimension: reservation_name {
    description: "Name of the reservation that the assignment uses."
    hidden: yes # Because foreign key. Show in its own view.
    type: string
  }
  dimension: assignee_type {
    description: "Type of assignee resource. Can be organization, folder or project."
    # Per https://cloud.google.com/bigquery/docs/reservations-intro
    # > To use the slots that you purchase, you will assign projects, folders, or organizations to reservations.
    # > Each level in the resource hierarchy inherits the assignment from the level above it, unless you override.
    # > In other words, a project inherits the assignment of its parent folder, and a folder inherits the assignment of its organization.
    #
    # Since a projects or folders table is not available in information schema, it seems there is no way to know which projects might inherit any
    # folder-level assignments
  }
  dimension: assignee_id {
    type: string
    description: "String ID that uniquely identifies the assignee resource"
    hidden: no # Although a foreign key, it can refer to multiple tables, so useful to expose here even though sometimes redundant
  }
  dimension: assignee_number {
    type: number
    description: "Internal numeric ID that uniquely identifies the assignee resource"
    hidden: no # Although a foreign key, it can refer to multiple tables, so useful to expose here even though sometimes redundant

  }

  dimension: job_type {
    description: "The type of job that can use the reservation. Can be PIPELINE or QUERY."
    suggestions: ["PIPELINE","QUERY"]
  }

}