dat <- read.csv("../sm_data.csv", skip = 1, stringsAsFactors = FALSE)

glimpse(dat)

rscores

qformats

scored <- qdat %>%
    inner_join(qformats, "Question") %>%
    inner_join(rscores, c("Format", "Response"))

head(AQ_scores)

head(part_AQ, 10)
