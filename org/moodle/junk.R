## unpiped way to do something
dat1 <- filter(dat, a == 1)
dat2 <- select(dat1, a, b, c)
newdat <- arrange(b)

## same, but with nested function calls (UGLY)
newdat <- arrange(select(filter(dat, a == 1), a, b, c), b)

## RECOMMENDED: pipe it all together
newdat <- dat %>%
  filter(a == 1) %>%
  select(a, b, c) %>%
  arrange(b)

list.files("moodle_data")

scores <- read.csv("marks.csv", stringsAsFactors = FALSE)

scores <- read.csv("moodle_data/marks.csv", stringsAsFactors = FALSE)

head(scores)

scores <- read.csv("moodle_data/marks.csv", stringsAsFactors = FALSE,
                   colClasses = c("character", "integer"))

head(scores)

ggplot(scores, aes(points)) + geom_bar()

users <- read.csv("users.csv", stringsAsFactors = FALSE)

users <- read.csv("moodle_data/users.csv", stringsAsFactors = FALSE)

head(users)

users <- read.csv("moodle_data/users.csv", stringsAsFactors = FALSE,
                  colClasses = "character")

head(users)

slides <- read.csv("moodle_data/slides.csv", stringsAsFactors = FALSE)

head(slides)

glimpse(slides)

count(slides, Affected.user)

count(slides, Event.context)

count(slides, Component)

count(slides, Event.name)

ggplot(slides_n, aes(n)) + geom_bar()

head(users)

users2 <- mutate(users, 
                 User.full.name = paste(First.name, Surname, sep = " "))

users2 <- mutate(users, 
                 User.full.name = paste(First.name, Surname, sep = " ")) %>%
   rename(SID = ID.number)

glimpse(users2)

left_join(users2, slides_n, "User.full.name") %>% head()

slide_pts  # print it out

ggplot(slide_pts, aes(slide_access, points)) + geom_point()

bbb <- read.csv("moodle_data/bbb.csv", stringsAsFactors = FALSE)

glimpse(bbb)

ggplot(bbb_n, aes(bbb_access)) + geom_bar()

bbb_pts <- left_join(users2, bbb_n, "User.full.name") %>% 
   select(User.full.name, points, bbb_access)

bbb_pts

bbb_pts <- left_join(users2, bbb_n, "User.full.name") %>% 
   select(User.full.name, points, bbb_access) %>%
   mutate(bbb_access = ifelse(is.na(bbb_access), 0, bbb_access))

ggplot(bbb_pts, aes(bbb_access, points)) + geom_point() + geom_smooth()

head(by_week)

by_week_d <- by_week %>%
    select(User.full.name, week) %>%
    distinct()

ggplot(by_week_d, aes(week)) + geom_bar()

ggplot(bbb_att_pts, aes(att, points)) + geom_point() +
    geom_smooth(method = "lm")
