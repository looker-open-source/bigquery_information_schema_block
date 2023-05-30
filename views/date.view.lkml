view: date {
  view_label: "[Date]"

  filter: view_description {
    label: "(info) -➤"
    description: "This is a co-dimension view. These fields combine the primary date dimensions from one or more tables (e.g., the job creation date in the jobs view, or the second-by-second period start in the jobs timeline view)"
    sql: TRUE /*This field is just a description, not useful in a query */;;
  }

  filter: date_filter {
    type: date_time
    datatype: timestamp
    label: "Date Limit"
    #hidden: yes # Hidden for explore-only use with always_filter. Unhidden for ability to select it when linking dsahboard filters to explore filter
    sql: COALESCE({% condition %} ${TABLE} {% endcondition %},TRUE);; # True if null, i.e. applied to a row with no date column
  }

  dimension_group: _ {
    type: time
    datatype: timestamp
    sql: ${TABLE} ;;
    timeframes: [week,date,hour,minute15,minute5,minute,second,millisecond100,raw]
  }

  dimension_group: _parts_of {
    type: time
    datatype: timestamp
    sql: ${TABLE} ;;
    timeframes: [day_of_week, hour_of_day]
  }
  dimension_group: _parts_of_ {
    type: time
    hidden: yes # This is mainly for use in other dimension definitions
    datatype: timestamp
    sql: ${TABLE} ;;
    timeframes: [day_of_week_index]
  }

  dimension: date_in_filter_format {
    hidden: yes # Only for use in LookML
    type: string
    sql: FORMAT_DATE("%Y/%m/%d", ${__date});;
  }

  dimension_group: current {
    type: time
    datatype: timestamp
    sql: CURRENT_TIMESTAMP() ;;
    hidden: yes # This is mainly for use in other dimension definitions
    timeframes: [week,date,hour,minute15,minute5,minute,second,millisecond100,raw,
      day_of_week_index, hour_of_day,]
  }

  dimension: days_ago {
    # Can be helpful in writing custom fields with flexible date logic, since date functions in custom fields are kinda wonky at the moment
    hidden: yes
    type: number
    sql: TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),${__date}, DAY) ;;
  }

  dimension: is_wtd {
    group_label: "Is period-to-date?"
    label: "Is WtD?"
    description: "Is week-to-date? Whether the date in question is earlier within its week than the current date. Useful for filtering to comparable parts of the current period and a past period"
    type: yesno
    sql: ${_parts_of__day_of_week_index} < ${current_day_of_week_index}  ;;
  }

  dimension: is_dth {
    group_label: "Is period-to-date?"
    label: "Is DtH?"
    description: "Is day-to-hour? Whether the hour in question is earlier within its day than the current hour. Useful for filtering to comparable parts of the current period and a past period"
    type: yesno
    sql: ${current_hour_of_day} < ${current_hour_of_day}  ;;
  }
}
