library("dplyr")
library("tidyr")
library("ggplot2")

## read in the data
dat <- read.csv("sm_data.csv", skip = 1, stringsAsFactors = FALSE)

## pull out participant information
part_info <- dat %>%
    select(Id, Gender, Age, Participate)

qdat <- dat %>%
    select(Id, Q1:Q10) %>%
    gather(Question, Response, Q1:Q10) %>%
    arrange(Id, Question)

## table link format to response score
rscores <- data_frame(Format = rep(1:2, each = 4),
                      Response = rep(c("Definitely Agree", "Slightly Agree",
                          "Slightly Disagree", "Definitely Disagree"),
                          times = 2),
                      Score=c(1, 1, 0, 0,
                          0, 0, 1, 1))

## table linking question to format
qformats <- data_frame(Question = paste0("Q", 1:10),
                       Format = c(1, 2, 2, 2, 2, 2,
                           1, 1, 2, 1))

scored <- qdat %>%
    mutate(Question = as.character(Question)) %>%
    inner_join(qformats, "Question") %>%
    inner_join(rscores, c("Format", "Response"))

stopifnot(nrow(scored) == nrow(qdat))

AQ_scores <- scored %>%
    group_by(Id) %>%
    summarise(AQ = sum(Score)) %>%
    arrange(desc(AQ))

ggplot(AQ_scores, aes(AQ)) + geom_bar() + scale_x_discrete(limits = 0:10)

part_AQ <- inner_join(AQ_scores, part_info, "Id")
