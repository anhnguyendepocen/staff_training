## don't forget to set your working directory to moodle_data
library("dplyr") # to get access to pipes and data processing functions
library("tidyr") # because we'll need to reshape the data
library("ggplot2") # for visualization

users <- read.csv("users.csv", stringsAsFactors = FALSE,
   colClasses = rep("character", 3))

hwk <- read.csv("homework.csv", stringsAsFactors = FALSE,
                colClasses = c("character", "integer",
                               "character", "integer"))

## extract each student's "top 7" scores
top_7 <- hwk %>%
    group_by(SID) %>%
    arrange(desc(points)) %>%
    slice(1:7) %>% ungroup()

hwk_grades <- top_7 %>% 
    group_by(SID) %>% 
    summarize(mpoints = mean(points))

mscale <- read.csv("scale.csv", stringsAsFactors = FALSE)

hwk_grades2 <- hwk_grades %>%
    mutate(points = as.integer(round(mpoints)))  
## note: round() uses "go to the even number" rule for
## dealing with .5 values

hwk_marks <- inner_join(hwk_grades2, mscale, "points")

write.csv(hwk_marks, "homework_mark.csv", row.names = FALSE)

hwk_wide <- hwk %>% select(-mark) %>%
    spread(HWID, points)

exam <- read.csv("exam.csv", stringsAsFactors = FALSE,
          colClasses = c("character", "character", "integer"))

grades <- inner_join(hwk_marks, exam, "SID") %>%
    select(SID, Homework = points.x, Exam = points.y) %>%
    mutate(Final = as.integer(round(.6 * Exam + .4 * Homework))) %>%
    inner_join(mscale, c(Final = "points"))

ggplot(grades, aes(Final)) + geom_bar() +
    scale_x_discrete(limits = 1:22)

anti_join(hwk_marks, exam, "SID")

filter(users, ID.number == "4243474")
