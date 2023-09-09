library("ggplot2")
library("tidyverse")
trips_by_month <- read_csv("result/trips-by-month.csv")
trips_by_weekday <- read_csv("result/trips-by-weekday.csv")
bicycles_by_user <- read_csv("result/bicycles-by-user.csv")

trips_by_weekday <- trips_by_weekday %>%
    mutate(weekday = factor(weekday, levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")))

trips_by_month_plot <- ggplot(
    trips_by_month,
    mapping = aes(fill = member_casual, x = ended_at, y = trips)) +
    geom_bar(position = "dodge", stat = "identity") +
    labs(title = "Number of trips per month by type of customer", x = "Month", y = "Trips")

trips_by_weekday_plot <- ggplot(
    trips_by_weekday,
    mapping = aes(fill = member_casual, x = weekday, y = trips)
) +
    geom_bar(position = "dodge", stat = "identity") +
    labs(title = "Number of trips per weekday by type of customer", x = "Weekday", y = "Trips")

bicycles_by_user_plot <- ggplot(
    bicycles_by_user,
    mapping = aes(fill = rideable_type, x = member_casual, y = trips)
) +
    geom_bar(position = "dodge", stat = "identity") +
    labs(title = "Usage by user and bicycle type", y = "Trips", x = "Customer type")

    
ggsave("plots/trips-by-month.png", trips_by_month_plot, width = 10, height = 5)
ggsave("plots/trips-by-weekday.png", trips_by_weekday_plot, width = 10, height = 5)
ggsave("plots/bicycles-by-user.png", bicycles_by_user_plot, width = 10, height = 5)
