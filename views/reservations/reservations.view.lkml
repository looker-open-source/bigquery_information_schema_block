view: reservations {

  sql_table_name: `@{RESERVATION_ADMIN_PROJECT}.region-@{REGION}.INFORMATION_SCHEMA.RESERVATIONS_BY_PROJECT` ;;

  dimension: reservation_name {
    primary_key: yes
    type: string
    label: "[Name]"
    description: "User-provided reservation name"
  }

  # Foreign keys

  dimension: project_id {
    type: string
    description: "String ID of the administration project"

  }
  dimension: project_number {
    type: number
    hidden: yes
    description: "Internal numeric ID of the administration project"
  }


  dimension: ignore_idle_slots {
    type: yesno
    description: "If true, queries using this reservation cannot use idle/unused slots from other capacity commitments."
    label: "Ignore Idle Slots?"
  }
  dimension:slot_capacity {
    type: number
    description: "Slot capacity associated with the reservation."
  }

  measure: count {
    type: count
    filters: [reservation_name: "-NULL"]
  }

  measure: total_slot_capacity {
    type: sum
    sql: ${slot_capacity} ;;
  }
}