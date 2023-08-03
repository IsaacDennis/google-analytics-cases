library("DBI")
library("RSQLite")
library("tidyverse")
tripdb <- dbConnect(RSQLite::SQLite(), "tripdata.db")
tripdf <- dbReadTable(tripdb, "trips_cleaned") %>% as_tibble()
# Median of trip duration
statistical_summary <- tripdf %>%
    mutate(duration = ended_at - started_at) %>%
    group_by(member_casual) %>%
    summarise(
        duration_median = round(median(duration) / 60),
        duration_mean = round(mean(duration) / 60),
    )

print(statistical_summary)

dbDisconnect(tripdb)
