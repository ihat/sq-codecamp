require("ggplot2")
require("plyr")

data_filename <- "data_file"

df <- read.csv(data_filename, header=FALSE, stringsAsFactors=FALSE)
colnames(df) <- c("num_lines", "time_str", "author")

convert_time <- function(time_str) {
  return(as.POSIXct(strptime(time_str, "%Y-%m-%d %H:%M:%S %z")))
}

df <- transform(df, time=convert_time(time_str))

ggplot(df, aes(x=time, y=num_lines)) + geom_line()

# most number of commits
author_commits <- ddply(df, .(author), nrow)
author_commits[order(author_commits[, 2]), ]