library("DBI")
library("RSQLite")
library("tidyverse")

tripdb <- dbConnect(RSQLite::SQLite(), "tripdata.db")
tripdf <- dbReadTable(tripdb, "trips")

# Create duration, weekday fields
tripdf <- tripdf %>% mutate(
  duration = ended_at - started_at,
  weekday = wday(
    as.Date(as.POSIXct(ended_at, tz = "UTC")),
    label = TRUE,
    abbr = FALSE,
    locale = "en_US"
  )
)

# Delete trips lasting less than 1 minute (60 seconds)
tripdf <- tripdf %>% filter(duration >= 60)
# Delete trips lasting more than 1 day (86400 seconds)
tripdf <- tripdf %>% filter(duration <= 86400)
# Delete trips with the same initial and final latitude and logitude
tripdf <- tripdf %>% filter(start_lat != end_lat | start_lng != end_lng)

dbWriteTable(tripdb, "trips_cleaned", tripdf, overwrite = TRUE)
dbDisconnect(tripdb)
