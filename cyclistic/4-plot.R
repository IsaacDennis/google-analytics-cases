library("ggplot2")
trips_by_month <- read_csv("result/trips-by-month.csv")
trips_by_weekday <- read_csv("result/trips-by-weekday.csv")

trips_by_month_plot <- ggplot(
    trips_by_month,
    mapping = aes(fill = member_casual, x = ended_at, y = trips)) +
    geom_bar(position = "dodge", stat = "identity")

trips_by_weekday_plot <- ggplot(
    trips_by_weekday,
    mapping = aes(fill = member_casual, x = weekday, y = trips)
) +
    geom_bar(position = "dodge", stat = "identity")
