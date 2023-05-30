# BigQuery Information Schema Looker Block

This repository contains a Looker block for monitoring and optimizing Google BigQuery usage and performance, built off of the [Information Schema](https://cloud.google.com/bigquery/docs/information-schema-intro) tables provided natively within BigQuery.

## Setup

### Manifest

The [manifest.lkml file](manifest.lkml) contains a number of parameters to be configured. Review the inline comments in the manifest file for more details.

### Required BQ Permissions

Generally, the required permissions (listed below) are available to the BigQuery Resource Admin and BigQuery Admin roles.

This block requires a Service Account with the following BigQuery permissions:

 - **bigquery.jobs.listAll**
   - At the organization or project level, depending on desired scope
   - Note that JOBS_BY_ORGANIZATION is only available to users with defined Google Cloud organizations. More information on permissions and access control in BigQuery can be found [here](https://cloud.google.com/bigquery/docs/access-control).
 - **bigquery.reservations.list** - To [access BigQuery Reservations data](https://cloud.google.com/bigquery/docs/information-schema-reservations#required_permissions)
 - **bigquery.capacityCommitments.list** - To [access BigQuery Reservations data](https://cloud.google.com/bigquery/docs/information-schema-reservations#required_permissions)
 - **bigquery.reservationAssignments.list** - To [access BigQuery Reservations data](https://cloud.google.com/bigquery/docs/information-schema-reservations#required_permissions)

## Highlighted Datasets / Explores

  * **Jobs**
    * The [Jobs explore](/explore/bigquery_information_schema/jobs) allows users to explore one of the four [JOBS_BY_X tables](https://cloud.google.com/bigquery/docs/information-schema-jobs)
    * The table contains one row for each job, up to a retention limit of 180 days.
    * This is the richest dataset in this block, and can be used to answer questions including: job volume, slot usage, job timing and performance metrics, data volume, and many attributes that explain performance.
    * The explore also exposes nested fields, such as referenced tables, job stages, and job stage steps.
    * The specific table explored depends on the `scope` specified in your [manifest.lkml file](manifest.lkml).
    * Depending on the scope, the SQL text of jobs may or may not be available. If it is, dimensions are also provided that extract Looker contextual information, such as history ID or user ID, from the SQL text
    * If you want to explore a JOBS_BY_X other than the one specified in your `scope`, two hidden explores exist that explicitly override the scope: [jobs_in_project](/explore/bigquery_information_schema/jobs_in_project) and [jobs_in_organization](/explore/bigquery_information_schema/jobs_in_organization)
  * **Jobs Timeline**
    * The [Jobs Timeline explore](/explore/bigquery_information_schema/jobs_timeline) allows users to explore one of the four [JOBS_TIMELINE_BY_X tables](https://cloud.google.com/bigquery/docs/information-schema-jobs-timeline)
    * The table contains one row for each second that each job was active.
    * Although this explore exposes fewer fields & nested detail than the jobs explore, it can be more convenient for aggregating certain metrics based on when queries were running, rather than based on when queries were created.
    * The specific table explored depends on the `scope` specified in your [manifest.lkml file](manifest.lkml).
    * If you want to explore a JOBS_TIMELINE_BY_X other than the one specified in your `scope`, two hidden explores exist that explicitly override the scope:  [jobs_timeline_in_project](/explore/bigquery_information_schema/jobs_timeline_in_project) and [jobs_timeline_in_organization](/explore/bigquery_information_schema/jobs_timeline_in_organization)
  * **Reservations data**
    * For customers using BigQuery's [Flat-rate pricing model](https://cloud.google.com/bigquery/pricing#flat-rate_pricing), these datasets can provide reporting on the current state of reservations. See the [reservations.md file](views/reservations/reservations.md) for more details
  * **Cross-table explore**
    * Although it exposes fewer details than the dedicated Jobs explore, the ["All" explore](/explore/bigquery_information_schema/all) joins together multiple fact tables in a way that can facilitate certain analyses, such as measuring slots usage and slot capacity co-dimensioned at the project leve.l

## Highlighted Dashboards

<div style="text-align: center;">
<img src="/api/internal/core/3.1/vector_thumbnail/dashboard/bigquery_information_schema::pulse" alt="Pulse dashboard thumbnail preview" />
</div>

  * **Pulse** - The Pulse dashboard is a self-contained top-level dashboard that you can use to understand current consumption, performance and efficiency, with the use of Week-to-date and week-over-week metrics throughout.
  * **Time Window Investigation** - The Time Window Investigation dashboard focuses on a specific timerange, removing any comparisons to prior periods, and providing tiles that can help you pick out problematic patterns or outliers to drill into.
  * **Job Lookup** - Primarily intended to be accessed from the ellipsis menu from any Job ID as a "drill across", the Job Lookup dashboard is a deep-dive into a single job, letting you see both job metrics as well as step-by-step query plans, and information about referenced tables.

## Concepts

### Slots and Capacity

A key concept for understanding BigQuery usage is slots. BigQuery uses [Slots](https://cloud.google.com/bigquery/docs/slots) (virtual CPUs) to execute queries in a heavily-distributed parallel architecture. Customers on the flat-rate pricing model explicitly choose how many slots to reserve, also known as [Slot Commitments](https://cloud.google.com/bigquery/docs/reservations-intro#commitments), which can be purchased at the Annual, Monthly, or Flex (60-second) level. Queries run within that capacity, and you pay for that capacity continuously every second it's deployed. For example, if you purchase 2,000 BigQuery slots, your queries in aggregate are limited to using 2,000 virtual CPUs at any given time. You will have this capacity until you delete it, and you will pay for 2,000 slots until you delete them.

### Bytes Shuffled to Disk
The percentage of [data written to shuffle and spilled to disk](https://cloud.google.com/bigquery/query-plan-explanation) can be a good indicator of queries that are overwhelming slot resources and could be further optimized, for example, queries with heavy [data skews](https://cloud.google.com/bigquery/docs/best-practices-performance-patterns#data_skew). Use the Job Lookup Dashboard to drill into individual queries that are spilling heavy volumes of data to disk, viewing their individual stages and identifying opportunities for optimization.

### % of Cached Queries
A higher percentage of [Cached queries](https://cloud.google.com/bigquery/docs/cached-results) will result in lower on-demand costs and lower resource utilization. In addition to reducing costs, queries that use cached results are significantly faster because BigQuery does not need to compute the result set.


### BigQuery Information Schema Data Structure

More information on the Information Schema can be found in [Google Cloud documentation](https://cloud.google.com/bigquery/docs/information-schema-intro).
