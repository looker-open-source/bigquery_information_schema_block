include: "/views/tables.view.lkml"

include: "/views/columns.view.lkml"


explore: tables {
  view_label: "[Tables]"

  join: partition_column {
    view_label: "Partition Column"
    from: columns
    type: left_outer
    relationship: one_to_one
    sql_on:
      ${partition_column.table_name} = ${tables.table_name}
      AND ${partition_column.is_partitioning_column};;
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

}
