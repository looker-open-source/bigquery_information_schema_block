##### NDT to filter by top N Projects #####

view: project_rank_by_gb_processed {
  derived_table: {
    explore_source: jobs {
      column: project_id {field: jobs.project_id}
      column: total_gb_processed {field: jobs_by_project_raw_all_queries.total_gb_processed}
      derived_column: rank {sql: RANK() ;;}
      bind_all_filters: yes
      sorts: [total_gb_processed: desc]
      timezone: "query_timezone"
    }
  }

  dimension: project_id {
    hidden: yes
  }

  dimension: rank {
    type: number
  }
}
