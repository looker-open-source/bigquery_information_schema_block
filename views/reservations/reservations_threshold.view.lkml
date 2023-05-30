view: reservations_threshold {
  derived_table: {
    # datagroup_trigger:
    sql: SELECT
          reservation_id,
          threshold_sum_stopped,
          threshold_sum_timeout,
          threshold_sum_resources_exceeded,
          threshold_sum_other_errors,
          threshold_avg_duration,
          threshold_median_duration,
          threshold_slot_usage,
          threshold_shuffle_terabytes_spilled,
          CASE WHEN SUM(CASE WHEN daily_sum_stopped>threshold_sum_stopped THEN 1 ELSE 0 END) = 7 THEN 1 ELSE 0 END AS slo_breach_sum_stopped, -- Check metric against threshold and count if all 7 days are in breach
          CASE WHEN SUM(CASE WHEN daily_sum_timeout>threshold_sum_timeout THEN 1 ELSE 0 END) = 7 THEN 1 ELSE 0 END AS slo_breach_sum_timeout,
          CASE WHEN SUM(CASE WHEN daily_sum_resources_exceeded>threshold_sum_resources_exceeded THEN 1 ELSE 0 END) = 7 THEN 1 ELSE 0 END AS slo_breach_sum_resources_exceeded,
          CASE WHEN SUM(CASE WHEN daily_sum_other_errors>threshold_sum_other_errors THEN 1 ELSE 0 END) = 7 THEN 1 ELSE 0 END AS slo_breach_sum_other_errors,
          CASE WHEN SUM(CASE WHEN daily_avg_duration>threshold_avg_duration THEN 1 ELSE 0 END) = 7 THEN 1 ELSE 0 END AS slo_breach_avg_duration,
          CASE WHEN SUM(CASE WHEN daily_median_duration>threshold_median_duration THEN 1 ELSE 0 END) = 7 THEN 1 ELSE 0 END AS slo_breach_median_duration,
          CASE WHEN SUM(CASE WHEN daily_slot_usage>threshold_slot_usage THEN 1 ELSE 0 END) = 7 THEN 1 ELSE 0 END AS slo_breach_slot_usage,
          CASE WHEN SUM(CASE WHEN daily_shuffle_terabytes_spilled>threshold_shuffle_terabytes_spilled THEN 1 ELSE 0 END) = 7 THEN 1 ELSE 0 END AS slo_breach_shuffle_terabytes_spilled
          FROM
          (
            SELECT
            reservation_id,
            day,
            daily_sum_stopped,
            daily_sum_timeout,
            daily_sum_resources_exceeded,
            daily_sum_other_errors,
            daily_avg_duration,
            daily_median_duration,
            daily_slot_usage,
            daily_shuffle_terabytes_spilled,
            ROUND(PERCENTILE_CONT(daily_sum_stopped, 0.9) OVER (PARTITION BY reservation_id)) AS threshold_sum_stopped, -- Calculate 6 months P90 of the different metrics
            ROUND(PERCENTILE_CONT(daily_sum_timeout, 0.9) OVER (PARTITION BY reservation_id)) AS threshold_sum_timeout,
            ROUND(PERCENTILE_CONT(daily_sum_resources_exceeded, 0.9) OVER (PARTITION BY reservation_id)) AS threshold_sum_resources_exceeded,
            ROUND(PERCENTILE_CONT(daily_sum_other_errors, 0.9) OVER (PARTITION BY reservation_id)) AS threshold_sum_other_errors,
            ROUND(PERCENTILE_CONT(daily_avg_duration, 0.9) OVER (PARTITION BY reservation_id)) AS threshold_avg_duration,
            ROUND(PERCENTILE_CONT(daily_median_duration, 0.9) OVER (PARTITION BY reservation_id)) AS threshold_median_duration,
            ROUND(PERCENTILE_CONT(daily_slot_usage, 0.9) OVER (PARTITION BY reservation_id)) AS threshold_slot_usage,
            ROUND(PERCENTILE_CONT(daily_shuffle_terabytes_spilled, 0.9) OVER (PARTITION BY reservation_id)) AS threshold_shuffle_terabytes_spilled
          FROM
          (
            SELECT
            reservation_id,
            EXTRACT(DATE from jbo.creation_time) AS day,
            SUM(CASE WHEN error_result.reason = 'stopped' THEN 1 ELSE 0 END) AS daily_sum_stopped, -- Calculate daily aggregates of all metrics
            SUM(CASE WHEN error_result.reason = 'timeout' THEN 1 ELSE 0 END) AS daily_sum_timeout,
            SUM(CASE WHEN error_result.reason = 'resourcesExceeded' THEN 1 ELSE 0 END) AS daily_sum_resources_exceeded,
            SUM(CASE WHEN error_result.reason NOT IN ('stopped', 'timeout', 'resourcesExceeded') THEN 1 ELSE 0 END) AS daily_sum_other_errors,
            ROUND(AVG(TIMESTAMP_DIFF(end_time, start_time, SECOND))) AS daily_avg_duration,
            APPROX_QUANTILES(TIMESTAMP_DIFF(end_time, start_time, SECOND), 100)[OFFSET(50)] AS daily_median_duration,
            ROUND(SAFE_DIVIDE(SUM(total_slot_ms), (1000 * 60 * 60 * 24))) AS daily_slot_usage,
            ROUND(SUM((SELECT SUM(shuffle_output_bytes_spilled)/(1000*1000*1000*1000) FROM UNNEST(job_stages)))) AS daily_shuffle_terabytes_spilled
            FROM `region-@{REGION}.INFORMATION_SCHEMA.JOBS_BY_ORGANIZATION` jbo
            WHERE jbo.creation_time BETWEEN TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 180 DAY) AND CURRENT_TIMESTAMP() -- Get all 6 months of data
            GROUP BY reservation_id, day
          )
          )
          WHERE day BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) AND DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY) -- 7 days in the past from yesterday
          GROUP BY reservation_id, threshold_sum_stopped, threshold_sum_timeout, threshold_sum_resources_exceeded, threshold_sum_other_errors,
          threshold_avg_duration, threshold_median_duration, threshold_slot_usage, threshold_shuffle_terabytes_spilled ;;
  }

fields_hidden_by_default: yes

dimension: reservation_id {
  type: string
  label: "Reservation ID"
  hidden: no
}
dimension: threshold_sum_stopped {}
dimension: threshold_sum_timeout {}
dimension: threshold_sum_resources_exceeded {}
dimension: threshold_sum_other_errors {}
dimension: threshold_avg_duration {}
dimension: threshold_median_duration {}
dimension: threshold_slot_usage {}
dimension: threshold_shuffle_terabytes_spilled {}
dimension: slo_breach_sum_stopped {}
dimension: slo_breach_sum_timeout {}
dimension: slo_breach_sum_resources_exceeded {}
dimension: slo_breach_sum_other_errors {}
dimension: slo_breach_avg_duration {}
dimension: slo_breach_median_duration {}
dimension: slo_breach_slot_usage {}
dimension: slo_breach_shuffle_terabytes_spilled {}

measure: total_threshold_sum_stopped {
  label: "Total Stopped"
  hidden: no
  sql: ${threshold_sum_stopped} ;;
  type: sum
}
measure: total_threshold_sum_timeout {
  label: "Total Timeout Errors"
  hidden: no
  sql: ${threshold_sum_timeout} ;;
  type: sum
}
measure: total_threshold_sum_resources_exceeded {
  label: "Total Resource Exceeded Errors"
  hidden: no
  sql: ${threshold_sum_resources_exceeded} ;;
  type: sum
}
measure: total_threshold_sum_other_errors {
  label: "Total Other Errors"
  hidden: no
  sql: ${threshold_sum_other_errors} ;;
  type: sum
}
measure: total_threshold_avg_duration {
  label: "Duration Average"
  hidden: no
  sql: ${threshold_avg_duration} ;;
  type: average
}
measure: total_threshold_median_duration {
  label: "Duration Median"
  hidden: no
  sql: ${threshold_median_duration} ;;
  type: median
}
measure: total_threshold_slot_usage {
  label: "Total Slot Usage"
  hidden: no
  sql: ${threshold_slot_usage} ;;
  type: sum
}
measure: total_threshold_shuffle_terabytes_spilled {
  label: "Total Shuffle Spilled TB"
  hidden: no
  sql: ${threshold_shuffle_terabytes_spilled} ;;
  type: sum
}
measure: total_slo_breach_sum_stopped {
  label: "SLO Breach Total Stopped"
  hidden: no
  sql: ${slo_breach_sum_stopped} ;;
  type: sum
}
measure: total_slo_breach_sum_timeout {
  label: "SLO Breach Timeouts"
  hidden: no
  sql: ${slo_breach_sum_timeout} ;;
  type: sum
}
measure: total_slo_breach_sum_resources_exceeded {
  label: "SLO Breach Resource Exceeded Errors"
  hidden: no
  sql: ${slo_breach_sum_resources_exceeded} ;;
  type: sum
}
measure: total_slo_breach_sum_other_errors {
  label: "SLO Breach Other Errors"
  hidden: no
  sql: ${slo_breach_sum_other_errors} ;;
  type: sum
}
measure: total_slo_breach_avg_duration {
  label: "SLO Breach Duration Average"
  hidden: no
  sql: ${slo_breach_avg_duration} ;;
  type: sum
}
measure: total_slo_breach_median_duration {
  label: "SLO Breach Duration Median"
  hidden: no
  sql: ${slo_breach_median_duration} ;;
  type: sum
}
measure: total_slo_breach_slot_usage {
  label: "SLO Breach Total Slot Usage"
  hidden: no
  sql: ${slo_breach_slot_usage} ;;
  type: sum
}
measure: total_slo_breach_shuffle_terabytes_spilled {
  label: "SLO Breach Shuffle Spilled TB"
  hidden: no
  sql: ${slo_breach_shuffle_terabytes_spilled} ;;
  type: sum
}

}
