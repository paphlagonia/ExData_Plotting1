library(dplyr)

data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data_dir <- "data"
raw_data_path <- sprintf("%s/household_power_consumption.txt", data_dir)
processed_data_path <- sprintf("%s/household_power_consumption.rds", data_dir)

check_file_exists <- function(data_path) {
    data <- tryCatch(
        normalizePath(data_path, mustWork = TRUE),
        error = function(e) e
    )
    if (inherits(data, "simpleError")) return(FALSE)
    data
}

download_data <- function(data_url, data_dir) {
    tmp <- tempfile()
    download.file(data_url, tmp, mode = "wb")
    unzip(tmp, exdir = data_dir)
}

process_data <- function(raw_data_path) {
    read.table(
        raw_data_path,
        header = TRUE,
        sep = ";",
        na.strings = "?",
        stringsAsFactors = FALSE
    ) %>%
    mutate(
        Datetime = paste(Date, Time) %>%
            as.POSIXct(format = "%d/%m/%Y %H:%M:%S"),
        Date = as.Date(Date, format = "%d/%m/%Y")
    ) %>%
    filter(Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))
}

read_data <- function() {
    processed_data <- check_file_exists(processed_data_path)
    if (processed_data == FALSE) {
        if (check_file_exists(data_dir) == FALSE) {
            message("Creating data directory")
            dir.create(data_dir)
        }
        # Download + unzip data file if the file raw_data_path doesn't exist
        raw_data <- check_file_exists(raw_data_path)
        if (raw_data == FALSE) {
            message("Downloading raw data")
            download_data(data_url, data_dir)
            raw_data <- check_file_exists(raw_data_path)
        }
        # Process + save data as RDS if not already processed
        message("Processing data")
        process_data(raw_data) %>% saveRDS(processed_data_path)
        processed_data <- check_file_exists(processed_data_path)
    }
    message("Reading data from file")
    readRDS(processed_data_path)
}
