library("ggplot2")
library("tidyverse")
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

ggsave("plots/trips-by-month.png", trips_by_month_plot, width = 10, height = 5)
ggsave("plots/trips-by-weekday.png", trips_by_weekday_plot, width = 10, height = 5)
