library("DBI")
library("RSQLite")
library("tidyverse")
tripdb <- dbConnect(RSQLite::SQLite(), "tripdata.db")
tripdf <- dbReadTable(tripdb, "trips_cleaned") %>% as_tibble()
# Median of trip duration
statistical_summary <- tripdf %>%
  group_by(member_casual) %>%
  summarise(
    duration_median = round(median(duration) / 60),
    duration_mean = round(mean(duration) / 60)
  )

most_used_end_stations <- tripdf %>%
  drop_na(end_station_name) %>%
  count(member_casual, end_station_name, sort = TRUE) %>%
  group_by(member_casual) %>%
  slice(1:5)

trips_by_month <- tripdf %>%
  select(-started_at) %>%
  mutate(
    ended_at = format(as.Date(as.POSIXct(ended_at, tz = "UTC")), "%Y-%m")
  ) %>%
  group_by(member_casual, ended_at) %>%
  summarise(trips = n())

trips_by_weekday <- tripdf %>%
  group_by(member_casual, weekday) %>%
  summarise(trips = n())

trip_duration_by_weekday <- tripdf %>%
  group_by(member_casual, weekday) %>%
  summarise(duration = round(median(duration) / 60, 1))

bicycles_by_user <- tripdf %>%
  filter(rideable_type != "docked_bike") %>%
  group_by(member_casual, rideable_type) %>%
  summarise(trips = n())

dir.create(file.path("result"))
write_csv(statistical_summary, "result/statistical-summary.csv")
write_csv(most_used_end_stations, "result/most-used-end-stations.csv")
write_csv(trips_by_month, "result/trips-by-month.csv")
write_csv(trips_by_weekday, "result/trips-by-weekday.csv")
write_csv(trip_duration_by_weekday, "result/trip-duration-by-weekday.csv")
write_csv(bicycles_by_user, "result/bicycles-by-user.csv")
dbDisconnect(tripdb)
