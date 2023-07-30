# Extracts cyclistic-tripdata.zip files to data directory
dir.create(file.path("data"))
zipfile <- "cyclistic-tripdata.zip"
unzip(zipfile, exdir = "data")
