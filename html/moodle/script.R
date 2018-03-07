library("dplyr")
library("ggplot2")
library("lubridate")  # for processing dates/times

scores <- read.csv("marks.csv", stringsAsFactors = FALSE,
                   colClasses = c("character", "integer"))

users <- read.csv("users.csv", stringsAsFactors = FALSE,
                  colClasses = "character")

slides <- read.csv("slides.csv", stringsAsFactors = FALSE)

slides_n <- count(slides, User.full.name)

users2 <- mutate(users, 
                 User.full.name = paste(First.name, Surname, sep = " ")) %>%
   rename(SID = ID.number) %>%
   inner_join(scores, "SID")

slide_pts <- left_join(users2, slides_n, "User.full.name") %>% 
   select(User.full.name, points, slide_access = n)

ggplot(slide_pts, aes(slide_access, points)) + geom_point() + geom_smooth()

bbb <- read.csv("bbb.csv", stringsAsFactors = FALSE)

bbb_n <- count(bbb, User.full.name) %>%
   rename(bbb_access = n)

by_week <- bbb %>%
    mutate(date = dmy_hm(Time), # parse the text date
           week = week(date)) %>% # calculate week of year (1-52)
    select(User.full.name, date, week)

by_week_d <- by_week %>%
    select(User.full.name, week) %>%
    distinct() %>%
    filter(week %in% c(39, 40, 41, 43, 45:49))

by_week_d2 <- by_week_d %>%
  semi_join(users2, "User.full.name")

bbb_attend <- count(by_week_d2, User.full.name) %>%
   rename(att = n)

bbb_att_pts <- left_join(users2, bbb_attend, "User.full.name") %>%
    mutate(att = ifelse(is.na(att), 0, att))

ggplot(bbb_att_pts, aes(att, points)) + geom_jitter(alpha = .5) +
    geom_smooth(method = "lm")

lm(points ~ att, bbb_att_pts) %>% summary()
