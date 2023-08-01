library("tidyverse")
library("DBI")
library("RSQLite")

tripdb <- dbConnect(RSQLite::SQLite(), "tripdata.db")

if (!dir.exists("data")) {
    source("unzip.R")
}
tripdf <- list.files(path = "data", full.names = TRUE) %>%
    lapply(read_csv) %>%
    bind_rows()

dbWriteTable(tripdb, "trips", tripdf, overwrite = TRUE)
dbDisconnect(tripdb)
