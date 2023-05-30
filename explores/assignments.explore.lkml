include: "/views/reservations/assignments.view.lkml"
include: "/views/reservations/reservations.view.lkml"

explore: assignments {
  label: "Reservation Assignments"
  hidden: yes # A useful view, but infrequently used. May be accessible from the pulse dashboard
  join: reservations {
    relationship: many_to_one
    sql_on: ${reservations.reservation_name} = ${assignments.reservation_name}
     AND ${reservations.project_number} = ${assignments.admin_project_number};;
  }
}
