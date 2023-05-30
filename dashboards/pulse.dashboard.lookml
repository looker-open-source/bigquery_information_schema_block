- dashboard: pulse
  title: Pulse
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Capacity
    type: text
    title_text: Capacity
    row: 10
    col: 8
    width: 8
    height: 2
  - name: Latency
    type: text
    title_text: Latency
    row: 10
    col: 0
    width: 8
    height: 2
  - name: Optimization
    type: text
    title_text: Optimization
    row: 10
    col: 16
    width: 8
    height: 2
  - title: Slot ms WTD
    name: Slot ms WTD
    model: bigquery_information_schema
    explore: jobs
    type: single_value
    fields: [date.__week, jobs.total_processed_tib, jobs.total_slot_ms, jobs.average_duration,
      jobs.percent_jobs_delayed_1000ms, jobs.spill_to_disk_count, jobs.query_cache_rate]
    fill_fields: [date.__week]
    filters:
      jobs.state: DONE,NULL
      date.date_filter: 2 weeks
      date.is_wtd: 'Yes'
      jobs.job_type: QUERY,NULL
    sorts: [date.__week desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: processed_wow, label: Processed WoW, expression: "${jobs.total_processed_tib}/offset(${jobs.total_processed_tib},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: slot_ms_wow, label: Slot ms WoW,
        expression: "${jobs.total_slot_ms}/offset(${jobs.total_slot_ms},1) - 1", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, _type_hint: number}, {
        table_calculation: average_duration_wow, label: Average Duration WoW, expression: "${jobs.average_duration}/offset(${jobs.average_duration},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: percent_jobs_delayed_wow, label: Percent
          Jobs Delayed WoW, expression: "${jobs.percent_jobs_delayed_1000ms}/offset(${jobs.percent_jobs_delayed_1000ms},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: spill_to_disk_wow, label: Spill to
          Disk WoW, expression: "${jobs.spill_to_disk_count}/offset(${jobs.spill_to_disk_count},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: query_cache_rate_wow, label: Query
          Cache Rate WoW, expression: "${jobs.query_cache_rate}/offset(${jobs.query_cache_rate},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_format: '#,##0.0,,"M"'
    comparison_label: WoW
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
    series_types: {}
    hidden_fields: [jobs.percent_jobs_delayed_1000ms, jobs.spill_to_disk_count, jobs.query_cache_rate,
      jobs.average_duration, jobs.total_processed_tib, processed_wow]
    listen:
      Project: jobs.project_id
    row: 5
    col: 7
    width: 4
    height: 5
  - title: Bytes Processed WTD
    name: Bytes Processed WTD
    model: bigquery_information_schema
    explore: jobs
    type: single_value
    fields: [date.__week, jobs.total_processed_tib, jobs.total_slot_ms, jobs.average_duration,
      jobs.percent_jobs_delayed_1000ms, jobs.spill_to_disk_count, jobs.query_cache_rate]
    fill_fields: [date.__week]
    filters:
      jobs.state: DONE,NULL
      date.date_filter: 2 weeks
      date.is_wtd: 'Yes'
      jobs.job_type: QUERY,NULL
    sorts: [date.__week desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: processed_wow, label: Processed WoW, expression: "${jobs.total_processed_tib}/offset(${jobs.total_processed_tib},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: slot_ms_wow, label: Slot ms WoW,
        expression: "${jobs.total_slot_ms}/offset(${jobs.total_slot_ms},1) - 1", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, _type_hint: number}, {
        table_calculation: average_duration_wow, label: Average Duration WoW, expression: "${jobs.average_duration}/offset(${jobs.average_duration},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: percent_jobs_delayed_wow, label: Percent
          Jobs Delayed WoW, expression: "${jobs.percent_jobs_delayed_1000ms}/offset(${jobs.percent_jobs_delayed_1000ms},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: spill_to_disk_wow, label: Spill to
          Disk WoW, expression: "${jobs.spill_to_disk_count}/offset(${jobs.spill_to_disk_count},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: query_cache_rate_wow, label: Query
          Cache Rate WoW, expression: "${jobs.query_cache_rate}/offset(${jobs.query_cache_rate},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    series_types: {}
    hidden_fields: [jobs.total_slot_ms, jobs.percent_jobs_delayed_1000ms, jobs.spill_to_disk_count,
      jobs.query_cache_rate, jobs.average_duration]
    listen:
      Project: jobs.project_id
    row: 0
    col: 7
    width: 4
    height: 5
  - title: Jobs Delayed >1s WTD
    name: Jobs Delayed >1s WTD
    model: bigquery_information_schema
    explore: jobs
    type: single_value
    fields: [date.__week, jobs.total_processed_tib, jobs.total_slot_ms, jobs.average_duration,
      jobs.percent_jobs_delayed_1000ms, jobs.spill_to_disk_count, jobs.query_cache_rate]
    fill_fields: [date.__week]
    filters:
      jobs.state: DONE,NULL
      date.date_filter: 2 weeks
      date.is_wtd: 'Yes'
      jobs.job_type: QUERY,NULL
    sorts: [date.__week desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: processed_wow, label: Processed WoW, expression: "${jobs.total_processed_tib}/offset(${jobs.total_processed_tib},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: slot_ms_wow, label: Slot ms WoW,
        expression: "${jobs.total_slot_ms}/offset(${jobs.total_slot_ms},1) - 1", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, _type_hint: number}, {
        table_calculation: average_duration_wow, label: Average Duration WoW, expression: "${jobs.average_duration}/offset(${jobs.average_duration},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: percent_jobs_delayed_wow, label: Percent
          Jobs Delayed WoW, expression: "${jobs.percent_jobs_delayed_1000ms}/offset(${jobs.percent_jobs_delayed_1000ms},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: spill_to_disk_wow, label: Spill to
          Disk WoW, expression: "${jobs.spill_to_disk_count}/offset(${jobs.spill_to_disk_count},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: query_cache_rate_wow, label: Query
          Cache Rate WoW, expression: "${jobs.query_cache_rate}/offset(${jobs.query_cache_rate},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_format: ''
    comparison_label: WoW
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
    series_types: {}
    hidden_fields: [jobs.spill_to_disk_count, jobs.query_cache_rate, jobs.total_processed_tib,
      processed_wow, jobs.total_slot_ms, slot_ms_wow, jobs.average_duration, average_duration_wow]
    listen:
      Project: jobs.project_id
    row: 12
    col: 4
    width: 4
    height: 4
  - title: Current Reservations
    name: Current Reservations
    model: bigquery_information_schema
    explore: all
    type: looker_single_record
    fields: [reservations.total_slot_capacity, capacity_commitments.total_slots, capacity_commitments.total_slots_active]
    filters:
      date.date_filter: 8 days
    sorts: [reservations.total_slot_capacity desc]
    limit: 500
    query_timezone: America/Los_Angeles
    show_view_names: true
    defaults_version: 1
    listen:
      Project: jobs.project_id
    row: 12
    col: 8
    width: 8
    height: 4
  - title: Query Cache Rate WTD
    name: Query Cache Rate WTD
    model: bigquery_information_schema
    explore: jobs
    type: single_value
    fields: [date.__week, jobs.total_processed_tib, jobs.total_slot_ms, jobs.average_duration,
      jobs.percent_jobs_delayed_1000ms, jobs.spill_to_disk_count, jobs.query_cache_rate]
    fill_fields: [date.__week]
    filters:
      jobs.state: DONE,NULL
      date.date_filter: 2 weeks
      date.is_wtd: 'Yes'
      jobs.job_type: QUERY,NULL
    sorts: [date.__week desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: processed_wow, label: Processed WoW, expression: "${jobs.total_processed_tib}/offset(${jobs.total_processed_tib},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: slot_ms_wow, label: Slot ms WoW,
        expression: "${jobs.total_slot_ms}/offset(${jobs.total_slot_ms},1) - 1", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, _type_hint: number}, {
        table_calculation: average_duration_wow, label: Average Duration WoW, expression: "${jobs.average_duration}/offset(${jobs.average_duration},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: percent_jobs_delayed_wow, label: Percent
          Jobs Delayed WoW, expression: "${jobs.percent_jobs_delayed_1000ms}/offset(${jobs.percent_jobs_delayed_1000ms},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: spill_to_disk_wow, label: Spill to
          Disk WoW, expression: "${jobs.spill_to_disk_count}/offset(${jobs.spill_to_disk_count},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: query_cache_rate_wow, label: Query
          Cache Rate WoW, expression: "${jobs.query_cache_rate}/offset(${jobs.query_cache_rate},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_format: ''
    comparison_label: WoW
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
    series_types: {}
    hidden_fields: [jobs.total_processed_tib, processed_wow, jobs.total_slot_ms, slot_ms_wow,
      jobs.average_duration, average_duration_wow, jobs.percent_jobs_delayed_1000ms,
      percent_jobs_delayed_wow, jobs.spill_to_disk_count, spill_to_disk_wow]
    listen:
      Project: jobs.project_id
    row: 12
    col: 16
    width: 4
    height: 4
  - title: Spills-to-Disk WTD
    name: Spills-to-Disk WTD
    model: bigquery_information_schema
    explore: jobs
    type: single_value
    fields: [date.__week, jobs.total_processed_tib, jobs.total_slot_ms, jobs.average_duration,
      jobs.percent_jobs_delayed_1000ms, jobs.spill_to_disk_count, jobs.query_cache_rate]
    fill_fields: [date.__week]
    filters:
      jobs.state: DONE,NULL
      date.date_filter: 2 weeks
      date.is_wtd: 'Yes'
      jobs.job_type: QUERY,NULL
    sorts: [date.__week desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: processed_wow, label: Processed WoW, expression: "${jobs.total_processed_tib}/offset(${jobs.total_processed_tib},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: slot_ms_wow, label: Slot ms WoW,
        expression: "${jobs.total_slot_ms}/offset(${jobs.total_slot_ms},1) - 1", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, _type_hint: number}, {
        table_calculation: average_duration_wow, label: Average Duration WoW, expression: "${jobs.average_duration}/offset(${jobs.average_duration},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: percent_jobs_delayed_wow, label: Percent
          Jobs Delayed WoW, expression: "${jobs.percent_jobs_delayed_1000ms}/offset(${jobs.percent_jobs_delayed_1000ms},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: spill_to_disk_wow, label: Spill to
          Disk WoW, expression: "${jobs.spill_to_disk_count}/offset(${jobs.spill_to_disk_count},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: query_cache_rate_wow, label: Query
          Cache Rate WoW, expression: "${jobs.query_cache_rate}/offset(${jobs.query_cache_rate},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_format: ''
    comparison_label: WoW
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
    series_types: {}
    hidden_fields: [jobs.query_cache_rate, jobs.total_processed_tib, processed_wow,
      jobs.total_slot_ms, slot_ms_wow, jobs.average_duration, average_duration_wow,
      jobs.percent_jobs_delayed_1000ms, percent_jobs_delayed_wow]
    listen:
      Project: jobs.project_id
    row: 12
    col: 20
    width: 4
    height: 4
  - title: Average Job Start Delay
    name: Average Job Start Delay
    model: bigquery_information_schema
    explore: jobs
    type: looker_line
    fields: [date.__hour, jobs.average_delay_to_start_time]
    fill_fields: [date.__hour]
    filters:
      jobs.state: DONE
      jobs.job_type: QUERY
      date.date_filter: 8 days
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
      Project: jobs.project_id
    row: 16
    col: 0
    width: 8
    height: 6
  - title: Slot Usage Skew
    name: Slot Usage Skew
    model: bigquery_information_schema
    explore: jobs
    type: looker_line
    fields: [date.__hour, jobs.skew_slot_ms, jobs.average_slot_ms, jobs.max_slot_ms]
    fill_fields: [date.__hour]
    filters:
      date.date_filter: 2 weeks
    sorts: [date.__hour desc]
    limit: 500
    column_limit: 50
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
    y_axes: [{label: '', orientation: left, series: [{axisId: jobs.skew_slot_ms, id: jobs.skew_slot_ms,
            name: Slot ms Skew}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: log}, {label: !!null '',
        orientation: right, series: [{axisId: jobs.average_slot_ms, id: jobs.average_slot_ms,
            name: Average Slot ms}, {axisId: jobs.max_slot_ms, id: jobs.max_slot_ms,
            name: Max Slot ms}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_colors:
      jobs.skew_slot_ms: "#592EC2"
      jobs.average_slot_ms: "#9ee3a3"
      jobs.max_slot_ms: "#ffd7c1"
    defaults_version: 1
    listen:
      Project: jobs.project_id
    row: 16
    col: 8
    width: 8
    height: 6
  - title: Avg Job Duration WTD
    name: Avg Job Duration WTD
    model: bigquery_information_schema
    explore: jobs
    type: single_value
    fields: [date.__week, jobs.total_processed_tib, jobs.total_slot_ms, jobs.average_duration,
      jobs.percent_jobs_delayed_1000ms, jobs.spill_to_disk_count, jobs.query_cache_rate]
    fill_fields: [date.__week]
    filters:
      jobs.state: DONE,NULL
      date.date_filter: 2 weeks
      date.is_wtd: 'Yes'
      jobs.job_type: QUERY,NULL
    sorts: [date.__week desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: processed_wow, label: Processed WoW, expression: "${jobs.total_processed_tib}/offset(${jobs.total_processed_tib},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: slot_ms_wow, label: Slot ms WoW,
        expression: "${jobs.total_slot_ms}/offset(${jobs.total_slot_ms},1) - 1", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, _type_hint: number}, {
        table_calculation: average_duration_wow, label: Average Duration WoW, expression: "${jobs.average_duration}/offset(${jobs.average_duration},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: percent_jobs_delayed_wow, label: Percent
          Jobs Delayed WoW, expression: "${jobs.percent_jobs_delayed_1000ms}/offset(${jobs.percent_jobs_delayed_1000ms},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: spill_to_disk_wow, label: Spill to
          Disk WoW, expression: "${jobs.spill_to_disk_count}/offset(${jobs.spill_to_disk_count},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: query_cache_rate_wow, label: Query
          Cache Rate WoW, expression: "${jobs.query_cache_rate}/offset(${jobs.query_cache_rate},1)\
          \ - 1", value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_format: '#.0"s"'
    comparison_label: WoW
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
    series_types: {}
    hidden_fields: [jobs.percent_jobs_delayed_1000ms, jobs.spill_to_disk_count, jobs.query_cache_rate,
      jobs.total_processed_tib, processed_wow, jobs.total_slot_ms, slot_ms_wow]
    listen:
      Project: jobs.project_id
    row: 12
    col: 0
    width: 4
    height: 4
  - title: Average Slot Rate by Hour
    name: Average Slot Rate by Hour
    model: bigquery_information_schema
    explore: jobs
    type: looker_line
    fields: [date.__hour, jobs.total_processed_gib, jobs_dates.average_slot_rate,
      is_this_week, date.is_wtd]
    pivots: [is_this_week, date.is_wtd]
    fill_fields: [date.__hour]
    filters:
      jobs.state: DONE,NULL
      date.date_filter: 2 weeks
      date.__hour: before 0 hours ago
    sorts: [date.__hour desc, is_this_week 0, date.is_wtd desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{dimension: is_this_week, label: 'Is this week?', expression: "${date.__week}\
          \ = ${date.current_week}", value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, _type_hint: yesno}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    interpolation: step
    y_axes: [{label: '', orientation: left, series: [{axisId: jobs.total_processed_gib,
            id: jobs.total_processed_gib, name: Processed GiB}], showLabels: false,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    series_colors:
      2021-07-11 - Yes - jobs.total_processed_gib: "#2d919e"
      2021-07-11 - No - jobs.total_processed_gib: "#b7e5e8"
      2021-07-18 - Yes - jobs.total_processed_gib: "#8745de"
      2021-07-18 - No - jobs.total_processed_gib: "#ddcee6"
      No - Yes - jobs.total_processed_gib: "#2d919e"
      No - No - jobs.total_processed_gib: "#b7e5e8"
      Yes - Yes - jobs.total_processed_gib: "#8745de"
      Yes - No - jobs.total_processed_gib: "#ddcee6"
      No - Yes - jobs_dates.average_slot_rate: "#2d919e"
      No - No - jobs_dates.average_slot_rate: "#b7e5e8"
      Yes - Yes - jobs_dates.average_slot_rate: "#8745de"
      Yes - No - jobs_dates.average_slot_rate: "#ddcee6"
    series_labels:
      2021-07-11 - Yes - jobs.total_processed_gib: Last week WTD
      2021-07-11 - No - jobs.total_processed_gib: Last Week Rest
      2021-07-18 - Yes - jobs.total_processed_gib: This Week WTD
      2021-07-18 - No - jobs.total_processed_gib: Today
      No - Yes - jobs.total_processed_gib: Last Week WTD
      No - No - jobs.total_processed_gib: Last Week Rest
      Yes - Yes - jobs.total_processed_gib: This Week WTD
      Yes - No - jobs.total_processed_gib: Today
      No - Yes - jobs_dates.average_slot_rate: Last Week WTD
      No - No - jobs_dates.average_slot_rate: Last Week Rest
      Yes - Yes - jobs_dates.average_slot_rate: This Week WTD
      Yes - No - jobs_dates.average_slot_rate: Today
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: [jobs.total_processed_gib]
    note_state: collapsed
    note_display: hover
    note_text: Average Slot Rate is the total slot milliseconds used by jobs in that
      hour, divided by the milliseconds in that hour. If you were to take an average
      of the slots being used at every point throughout the hour, this would be the
      average number.
    listen:
      Project: jobs.project_id
    row: 5
    col: 11
    width: 13
    height: 5
  - title: Bytes Processed by Hour
    name: Bytes Processed by Hour
    model: bigquery_information_schema
    explore: jobs
    type: looker_line
    fields: [date.__hour, jobs.total_processed_gib, jobs_dates.average_slot_rate,
      is_this_week, date.is_wtd]
    pivots: [is_this_week, date.is_wtd]
    fill_fields: [date.__hour]
    filters:
      jobs.state: DONE,NULL
      date.date_filter: 2 weeks
      date.__hour: before 0 hours ago
    sorts: [date.__hour desc, is_this_week 0, date.is_wtd desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{dimension: is_this_week, label: 'Is this week?', expression: "${date.__week}\
          \ = ${date.current_week}", value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, _type_hint: yesno}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    interpolation: step
    y_axes: [{label: '', orientation: left, series: [{axisId: jobs.total_processed_gib,
            id: jobs.total_processed_gib, name: Processed GiB}], showLabels: false,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    series_colors:
      2021-07-11 - Yes - jobs.total_processed_gib: "#2d919e"
      2021-07-11 - No - jobs.total_processed_gib: "#b7e5e8"
      2021-07-18 - Yes - jobs.total_processed_gib: "#8745de"
      2021-07-18 - No - jobs.total_processed_gib: "#ddcee6"
      No - Yes - jobs.total_processed_gib: "#2d919e"
      No - No - jobs.total_processed_gib: "#b7e5e8"
      Yes - Yes - jobs.total_processed_gib: "#8745de"
      Yes - No - jobs.total_processed_gib: "#ddcee6"
    series_labels:
      2021-07-11 - Yes - jobs.total_processed_gib: Last week WTD
      2021-07-11 - No - jobs.total_processed_gib: Last Week Rest
      2021-07-18 - Yes - jobs.total_processed_gib: This Week WTD
      2021-07-18 - No - jobs.total_processed_gib: Today
      No - Yes - jobs.total_processed_gib: Last Week WTD
      No - No - jobs.total_processed_gib: Last Week Rest
      Yes - Yes - jobs.total_processed_gib: This Week WTD
      Yes - No - jobs.total_processed_gib: Today
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: [jobs_dates.average_slot_rate]
    listen:
      Project: jobs.project_id
    row: 0
    col: 11
    width: 13
    height: 5
  - title: Weekly Slot ms by Project
    name: Weekly Slot ms by Project
    model: bigquery_information_schema
    explore: jobs
    type: looker_area
    fields: [jobs.project_id, jobs.total_slot_ms, date.__week]
    pivots: [jobs.project_id]
    fill_fields: [date.__week]
    filters:
      jobs.state: DONE
      date.date_filter: 24 weeks ago for 24 weeks
    sorts: [jobs.total_slot_ms desc 0, jobs.project_id]
    limit: 500
    column_limit: 25
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: zr-dev-vincegonzalez
              - jobs.total_slot_ms, id: zr-dev-vincegonzalez - jobs.total_slot_ms,
            name: zr-dev-vincegonzalez}], showLabels: false, showValues: true, valueFormat: '#,##0,,"M"',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    label_value_format: ''
    series_types: {}
    value_labels: legend
    label_type: labPer
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: Limited to the top 25 projects
    listen:
      Project: jobs.project_id
    row: 5
    col: 0
    width: 7
    height: 5
  - title: Weekly Bytes Processed by Project
    name: Weekly Bytes Processed by Project
    model: bigquery_information_schema
    explore: jobs
    type: looker_area
    fields: [jobs.project_id, date.__week, jobs.total_processed_tib]
    pivots: [jobs.project_id]
    fill_fields: [date.__week]
    filters:
      jobs.state: DONE
      date.date_filter: 24 weeks ago for 24 weeks
    sorts: [jobs.project_id, date.__week desc]
    limit: 500
    column_limit: 25
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: zr-dev-vincegonzalez
              - jobs.total_processed_tib, id: zr-dev-vincegonzalez - jobs.total_processed_tib,
            name: zr-dev-vincegonzalez}], showLabels: false, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
    value_labels: legend
    label_type: labPer
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: Limited to the top 25 projects
    listen:
      Project: jobs.project_id
    row: 0
    col: 0
    width: 7
    height: 5
  filters:
  - name: Project
    title: Project
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: bigquery_information_schema
    explore: jobs
    listens_to_filters: []
    field: jobs.project_id
