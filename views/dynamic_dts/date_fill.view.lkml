include: "/views/date.view.lkml"

# This view implements a datefill table, when needed, but still depends on separate "date" view for field references,
# so the two views should be combined with a bare join in an explore if date-fill functionality is required

view: date_fill {
  derived_table: {
    sql:
    SELECT
      d,
      {% if date.__millisecond100._is_selected %} 0.1 {%
      elsif date.__second._is_selected         %} 1.0 {%
      elsif date.__minute._is_selected         %} 1.0*60 {%
      elsif date.__minute5._is_selected        %} 1.0*60*5 {%
      elsif date.__minute15._is_selected       %} 1.0*60*15 {%
      elsif date.__hour._is_selected
         or date._parts_of_hour_of_day          %} 1.0*60*60 {%
      elsif date.__date._is_selected
         or date._parts_of_day_of_week          %} 1.0*60*60*24 {%
      elsif date.__week._is_selected            %} 1.0*60*60*24*7 {%
      elsif date.date_filter._is_selected       %}
        TIMESTAMP_DIFF(
          {% date_start date.date_filter %},
          {% date_end date.date_filter %},
          SECOND
        ) {%
      else                                 %} NULL {%
      endif %} as duration_s

    FROM UNNEST(GENERATE_TIMESTAMP_ARRAY(
      {% date_start date.date_filter %},
      {% date_end date.date_filter %},
      {% if date.__millisecond100._is_selected %} INTERVAL 100 MILLISECOND {%
      elsif date.__second._is_selected         %} INTERVAL 1 SECOND {%
      elsif date.__minute._is_selected         %} INTERVAL 1 MINUTE {%
      elsif date.__minute5._is_selected        %} INTERVAL 5 MINUTE {%
      elsif date.__minute15._is_selected       %} INTERVAL 15 MINUTE {%
      elsif date.__hour._is_selected
         or date._parts_of_hour_of_day          %} INTERVAL 1 HOUR {%
      elsif date.__date._is_selected
         or date._parts_of_day_of_week          %} INTERVAL 1 DAY {%
      elsif date.__week._is_selected            %} INTERVAL 7 DAY {%
      else                                 %} INTERVAL 10000 DAY {%
      endif %}
      )) AS d
    ;;
  }
  dimension: duration_s {
    hidden: yes
    type: number
    description: "Total seconds in the date period(s)"
  }

  measure: total_interval_duration_s {
    # To be used as the denominator for all averages "over time"
    hidden: yes
    type: sum
    sql: ${date_fill.duration_s} ;;
  }
}
