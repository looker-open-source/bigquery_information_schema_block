- dashboard: time_window_investigation
  title: Time Window Investigation
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Top
    type: text
    title_text: Top
    row: 14
    col: 0
    width: 24
    height: 2
  - title: Jobs Created by Hour
    name: Jobs Created by Hour
    model: bigquery_information_schema
    explore: jobs
    type: looker_line
    fields: [date.__hour, jobs.count]
    fill_fields: [date.__hour]
    filters:
      jobs.state: DONE
      jobs.job_type: "-NULL"
    sorts: [date.__hour desc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      Date: date.date_filter
    row: 8
    col: 0
    width: 10
    height: 6
  - title: Join Types
    name: Join Types
    model: bigquery_information_schema
    explore: jobs
    type: looker_grid
    fields: [job_stage_steps.join_type, jobs.count, job_stages.count, average_of_records_read,
      average_of_records_written, average_of_slot_ms]
    filters:
      job_stage_steps.join_type: "-NULL"
    sorts: [job_stage_steps.join_type]
    limit: 500
    column_limit: 50
    dynamic_fields: [{measure: average_of_compute_ratio_avg, based_on: job_stages.compute_ratio_avg,
        type: average, label: Average of Compute Ratio Avg, expression: !!null '',
        _kind_hint: measure, _type_hint: number}, {measure: average_of_records_read,
        based_on: job_stages.records_read, type: average, label: Average of Records
          Read, expression: !!null '', value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, _type_hint: number}, {measure: average_of_records_written,
        based_on: job_stages.records_written, type: average, label: Average of Records
          Written, expression: !!null '', value_format: !!null '', value_format_name: decimal_0,
        _kind_hint: measure, _type_hint: number}, {measure: average_of_slot_ms, based_on: job_stages.slot_ms,
        type: average, label: Average of Slot ms, expression: !!null '', value_format: !!null '',
        value_format_name: decimal_0, _kind_hint: measure, _type_hint: number}]
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      tables.table_full_path: Table
      partition_column.column_name: Partition Column
      cluster_1_column.column_name: Cluster Column 1
    series_column_widths:
      tables.table_full_path: 666
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#3EB0D5",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          custom: {id: 66b59856-c2e5-ce1f-7057-39a887c7366a, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#e8da63", offset: 50},
              {color: "#e09260", offset: 100}]}, options: {steps: 5, constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: []}, {type: not equal to, value: 0, background_color: "#B32F37",
        font_color: "#ffffff", color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: true, italic: false,
        strikethrough: false, fields: []}]
    truncate_column_names: false
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    listen:
      Date: date.date_filter
    row: 8
    col: 10
    width: 10
    height: 6
  - title: GiB Spilled to Disk
    name: GiB Spilled to Disk
    model: bigquery_information_schema
    explore: jobs
    type: single_value
    fields: [jobs.total_spill_to_disk_gib, jobs.average_spill_to_disk_mib]
    filters:
      jobs.state: DONE
      jobs.job_type: QUERY
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    comparison_label: Average MiB/query
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    listen:
      Date: date.date_filter
    row: 8
    col: 20
    width: 4
    height: 6
  - title: Top 5 Users
    name: Top 5 Users
    model: bigquery_information_schema
    explore: jobs
    type: looker_grid
    fields: [jobs.count, jobs.total_processed_tib, jobs.average_processed_gib, jobs.average_duration,
      jobs.user_email]
    filters:
      tables.table_name: "-NULL"
    sorts: [jobs.total_processed_tib desc]
    limit: 5
    show_view_names: true
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      jobs.count:
        is_active: true
      jobs.total_processed_tib:
        is_active: true
      jobs.average_processed_gib:
        is_active: true
      jobs.average_duration:
        is_active: true
    defaults_version: 1
    listen:
      Date: date.date_filter
    row: 24
    col: 12
    width: 12
    height: 4
  - title: Top 5 Queries
    name: Top 5 Queries
    model: bigquery_information_schema
    explore: jobs
    type: looker_grid
    fields: [jobs.job_id, jobs.query_text, jobs.total_processed_gib]
    filters:
      jobs.state: DONE
      jobs.job_type: QUERY
    sorts: [jobs.total_processed_gib desc]
    limit: 5
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      jobs.job_id: 335
      jobs.query_text: 726
    series_cell_visualizations:
      jobs.total_processed_gib:
        is_active: false
    defaults_version: 1
    listen:
      Date: date.date_filter
    row: 16
    col: 0
    width: 12
    height: 16
  - title: Top 15 Tables
    name: Top 15 Tables
    model: bigquery_information_schema
    explore: jobs
    type: looker_grid
    fields: [tables.table_catalog, tables.table_schema, tables.table_name, jobs.count,
      jobs.total_processed_tib, jobs.average_processed_gib, jobs.average_duration]
    filters:
      tables.table_name: "-NULL"
    sorts: [jobs.total_processed_tib desc]
    limit: 15
    show_view_names: true
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      jobs.count:
        is_active: true
      jobs.total_processed_tib:
        is_active: true
      jobs.average_processed_gib:
        is_active: true
      jobs.average_duration:
        is_active: true
    defaults_version: 1
    listen:
      Date: date.date_filter
    row: 16
    col: 12
    width: 12
    height: 8
  - title: Top 5 Projects
    name: Top 5 Projects
    model: bigquery_information_schema
    explore: jobs
    type: looker_grid
    fields: [jobs.count, jobs.total_processed_tib, jobs.average_processed_gib, jobs.average_duration,
      jobs.project_id]
    filters:
      tables.table_name: "-NULL"
    sorts: [jobs.total_processed_tib desc]
    limit: 5
    show_view_names: true
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      jobs.count:
        is_active: true
      jobs.total_processed_tib:
        is_active: true
      jobs.average_processed_gib:
        is_active: true
      jobs.average_duration:
        is_active: true
    defaults_version: 1
    listen:
      Date: date.date_filter
    row: 28
    col: 12
    width: 12
    height: 4
  filters:
  - name: Date
    title: Date
    type: date_filter
    default_value: 1 days ago for 1 days
    allow_multiple_values: true
    required: false
