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
    mutate(weekday = wday(as.Date(as.POSIXct(ended_at, tz = "UTC")), label = TRUE, abbr = FALSE, locale = "en_US")) %>%
    group_by(member_casual, weekday) %>%
    summarise(trips = n())

bicycles_by_user <- tripdf %>%
    filter(rideable_type != "docked_bike") %>%
    group_by(member_casual, rideable_type) %>%
    summarise(trips = n())


print(statistical_summary)
print(most_used_end_stations)
print(trips_by_month)
print(trips_by_weekday)

dir.create(file.path("result"))
write_csv(most_used_end_stations, "result/most-used-end-stations.csv")
write_csv(trips_by_month, "result/trips-by-month.csv")
write_csv(trips_by_weekday, "result/trips-by-weekday.csv")
write_csv(bicycles_by_user, "result/bicycles-by-user.csv")
dbDisconnect(tripdb)
