view: capacity_commitments {

  sql_table_name: `@{BILLING_PROJECT_ID}.region-@{REGION}.INFORMATION_SCHEMA.CAPACITY_COMMITMENTS_BY_PROJECT` ;;

  dimension: capacity_commitment_id {
    type: string
    primary_key: yes
    description: "ID that uniquely identifies the capacity commitment"
  }

  dimension: commitment_plan {
    type: string
    description: "Commitment plan of the capacity commitment. Can be FLEX, MONTHLY, or ANNUAL."
    suggestions: ["FLEX","MONTHLY","ANNUAL"]
  }

  dimension: project_number {
    type: number
    hidden: yes
    description: "Internal numeric ID of the administrative project"
  }
  dimension: project_id {
    type: string
    description: "String ID of the administrative project"
  }
  dimension: state {
    type: string
    description: "State the capacity commitment is in. Can be PENDING or ACTIVE."
    suggestions: ["PENDING","ACTIVE"]
  }

  dimension: slot_count {
    type: number
    description: "Slot count associated with the capacity commitment"
  }

  measure: count {
    type: count
    filters: [capacity_commitment_id: "-NULL"]
  }
  measure: count_active {
    type: count
    filters: [state: "ACTIVE"]
  }
  measure: total_slots{
    type: sum
    sql: ${slot_count} ;;
  }
  measure: total_slots_active {
    type: sum
    sql: ${slot_count} ;;
    filters: [state: "ACTIVE"]
  }
}