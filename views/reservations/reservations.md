# Reservations

The views in this folder relate to [BigQuery Reservations](https://cloud.google.com/bigquery/docs/reservations-intro), which power flat-rate pricing. To learn about the reservation model, [this tutorial](https://cloud.google.com/blog/topics/developers-practitioners/bigquery-admin-reference-guide-jobs-reservation-model) may help.

To use these views, the BiqQuery connection must have the following permissions:
[https://cloud.google.com/bigquery/docs/information-schema-reservations#required_permissions](https://cloud.google.com/bigquery/docs/information-schema-reservations#required_permissions)

BigQuery Reference Docs for reservation-related tables: [https://cloud.google.com/bigquery/docs/information-schema-reservations#schemas](https://cloud.google.com/bigquery/docs/information-schema-reservations#schemas)

These views are primarily exposed in the [Assignments explore](/explore/bigquery_information_schema/assignments) and the [Capacity Commitments explore](/explore/bigquery_information_schema/capacity_commitments).

Reservation data is also available via the ["All" explore](/explore/bigquery_information_schema/all) for more convenient co-dimensioning with other datasets.
