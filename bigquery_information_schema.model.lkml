############## BigQuery Performance Monitoring Model #########################

############## Add the BigQuery Connection that you would like to monitor ######################
connection: "@{CONNECTION}"

include: "/**/*.dashboard"

# Multi-purpose "outer join on false" explore
include: "/explores/all.explore.lkml"

# Core explores
include: "/explores/jobs.explore.lkml"
include: "/explores/jobs_timeline.explore.lkml"
include: "/explores/tables.explore.lkml"

# Niche/hidden explores
include: "/explores/assignments.explore.lkml"
include: "/explores/capacity_commitments.explore.lkml"
include: "/explores/job_slot_concurrency.explore.lkml"

week_start_day: sunday #This is helpful so our WTD measures always have at least some data when viewed on a Monday
