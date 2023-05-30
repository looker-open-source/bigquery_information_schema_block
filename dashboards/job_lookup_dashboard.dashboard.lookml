- dashboard: job_lookup_dashboard
  title: Job Inspection
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Basic Info
    name: Basic Info
    model: bigquery_information_schema
    explore: jobs
    type: looker_single_record
    fields: [jobs.query_text, date.__minute, jobs.error_result, jobs.is_cache_hit,
      jobs.looker_history_id, jobs.looker_user_id, jobs.total_delay_to_start_time,
      jobs.total_runtime, jobs.total_processed_gib, jobs.total_slot_ms]
    filters: {}
    sorts: [date.__minute desc]
    limit: 500
    show_view_names: false
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
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: [jobs.query_text]
    series_types: {}
    listen:
      Job ID: jobs.job_id
      Created: date.date_filter
    row: 0
    col: 0
    width: 5
    height: 9
  - title: Query Text
    name: Query Text
    model: bigquery_information_schema
    explore: jobs
    type: looker_grid
    fields: [jobs.query_text]
    filters: {}
    limit: 500
    show_view_names: false
    show_row_numbers: true
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
    defaults_version: 1
    hidden_fields: []
    series_types: {}
    listen:
      Job ID: jobs.job_id
      Created: date.date_filter
    row: 0
    col: 5
    width: 8
    height: 9
  - title: Referenced Tables
    name: Referenced Tables
    model: bigquery_information_schema
    explore: jobs
    type: looker_grid
    fields: [job_referenced_tables.table_full_path, found, partition_column.column_name,
      cluster_1_column.column_name]
    filters:
      job_referenced_tables.table_full_path: "-NULL"
    sorts: [job_referenced_tables.table_full_path]
    limit: 500
    dynamic_fields: [{dimension: found, label: 'Found?', expression: 'NOT is_null(${tables.table_name})',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: dimension,
        _type_hint: yesno}]
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
    enable_conditional_formatting: false
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
      job_referenced_tables.table_full_path: 579
    truncate_column_names: false
    defaults_version: 1
    series_types: {}
    listen:
      Job ID: jobs.job_id
      Created: date.date_filter
    row: 0
    col: 13
    width: 11
    height: 9
  - title: Stage Metrics
    name: Stage Metrics
    model: bigquery_information_schema
    explore: jobs
    type: looker_single_record
    fields: [job_stages.count, total_max_wait, total_max_read, total_max_compute,
      total_max_write, total_shuffle_output_bytes, total_shuffle_spilled_bytes]
    filters: {}
    limit: 500
    dynamic_fields: [{measure: total_max_wait, based_on: job_stages.wait_ms_max, type: sum,
        label: Total Max Wait, expression: !!null '', value_format: '#.#," s"', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number}, {measure: total_max_read, based_on: job_stages.read_ms_max,
        type: sum, label: Total Max Read, expression: !!null '', value_format: '#.#,"
          s"', value_format_name: !!null '', _kind_hint: measure, _type_hint: number},
      {measure: total_shuffle_spilled_bytes, based_on: job_stages.shuffle_spilled_bytes,
        type: sum, label: Total Shuffle Spilled Bytes, expression: !!null '', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: measure, _type_hint: number}, {
        measure: total_max_compute, based_on: job_stages.compute_ms_max, type: sum,
        label: Total Max Compute, expression: !!null '', value_format: '#.#," s"',
        value_format_name: !!null '', _kind_hint: measure, _type_hint: number}, {
        measure: total_max_write, based_on: job_stages.write_ms_max, type: sum, label: Total
          Max Write, expression: !!null '', value_format: '#.#," s"', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number}, {measure: total_shuffle_output_bytes,
        based_on: job_stages.shuffle_output_bytes, type: sum, label: Total Shuffle
          Output Bytes, expression: !!null '', value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number}]
    show_view_names: false
    x_axis_gridlines: false
    y_axis_gridlines: true
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
    note_state: expanded
    note_display: above
    note_text: '"Total Max" measures sum up across the stages the maximum amount of
      time spent on that type of task among shards in each stage'
    listen:
      Job ID: jobs.job_id
      Created: date.date_filter
    row: 9
    col: 0
    width: 5
    height: 8
  - title: Job Stages
    name: Job Stages
    model: bigquery_information_schema
    explore: jobs
    type: looker_grid
    fields: [job_stages.stage_id, job_stages.steps_collapsed, job_stages.records_read,
      job_stages.records_written, job_stages.slot_ms, job_stages.wait_ms_max, job_stages.read_ms_max,
      job_stages.compute_ms_max, job_stages.write_ms_max, job_stages.shuffle_output_bytes,
      job_stages.shuffle_spilled_bytes, job_stages.slowest_type, job_stages.slowest_skew]
    filters: {}
    sorts: [job_stages.stage_id]
    limit: 500
    column_limit: 50
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
      job_stages.steps_collapsed: 351
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#3EB0D5",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          custom: {id: 66b59856-c2e5-ce1f-7057-39a887c7366a, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#e8da63", offset: 50},
              {color: "#e09260", offset: 100}]}, options: {steps: 5, constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: [job_stages.wait_ms_max, job_stages.read_ms_max,
          job_stages.compute_ms_max, job_stages.write_ms_max]}, {type: not equal to,
        value: 0, background_color: "#B32F37", font_color: "#ffffff", color_application: {
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7, palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688,
          options: {constraints: {min: {type: minimum}, mid: {type: number, value: 0},
              max: {type: maximum}}, mirror: true, reverse: false, stepped: false}},
        bold: true, italic: false, strikethrough: false, fields: [job_stages.shuffle_spilled_bytes]},
      {type: along a scale..., value: !!null '', background_color: "#3EB0D5", font_color: !!null '',
        color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7, custom: {
            id: 243ca4a6-6c21-8dff-ce8a-7b0d9bb5ae72, label: Custom, type: continuous,
            stops: [{color: "#fff", offset: 0}, {color: "#ffed8b", offset: 50}, {
                color: "#ff8e6f", offset: 100}]}, options: {steps: 5, constraints: {
              min: {type: number, value: 1}, mid: {type: number, value: 4}, max: {
                type: number, value: 16}}, mirror: false, reverse: false, stepped: false}},
        bold: false, italic: false, strikethrough: false, fields: [job_stages.slowest_skew]}]
    truncate_column_names: false
    defaults_version: 1
    series_types: {}
    hidden_fields: [job_stages.stage_id]
    note_state: collapsed
    note_display: below
    note_text: Click on the step name to see substep details
    listen:
      Job ID: jobs.job_id
      Created: date.date_filter
    row: 9
    col: 5
    width: 19
    height: 13
  filters:
  - name: Job ID
    title: Job ID
    type: field_filter
    default_value: ''
    allow_multiple_values: false
    required: true
    model: bigquery_information_schema
    explore: jobs
    listens_to_filters: []
    field: jobs.job_id
  - name: Created
    title: Created
    type: date_filter
    default_value: 2021/07/26
    allow_multiple_values: false
    required: false
