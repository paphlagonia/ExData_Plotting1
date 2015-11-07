source("functions.R")
data <- read_data()

plotting_var <- c(
    Sub_metering_1 = "black",
    Sub_metering_2 = "red",
    Sub_metering_3 = "blue"
)
var_count <- length(plotting_var)

png("plot3.png", bg = "transparent", width = 480, height = 480, units = "px")
with(data, {
    plot(
        Datetime,
        Sub_metering_1,
        type = "n",
        ylab = "Energy sub metering",
        xlab = ""
    )
    for (var_idx in seq_len(var_count)) {
        var <- plotting_var[var_idx]
        lines(Datetime, get(names(var)), col = var)
    }
    legend("topright", names(plotting_var), col = plotting_var, lwd = 1)
})
dev.off()
