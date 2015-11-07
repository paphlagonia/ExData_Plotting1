source("functions.R")
data <- read_data()

png("plot2.png", bg = "transparent", width = 480, height = 480, units = "px")
plot(
    data$Datetime,
    data$Global_active_power,
    type = "l",
    ylab = "Global Active Power (kilowatts)",
    xlab = ""
)
dev.off()
