library("dplyr")   # data processing
library("tidyr")   # data reshaping
library("ggplot2") # plotting

scales <- read.csv("subscales.csv", stringsAsFactors = FALSE)
glimpse(scales)

stars_wide <- read.csv("stars.csv", stringsAsFactors = FALSE)

glimpse(stars_wide)

stars <- stars_wide %>% gather(item_id, score, -student_id, -year)

glimpse(stars)

## map each item to each of the 5 subscales
## I3  --> Ask_For_Help
## I2  --> Interpretation
## I25 --> Self-Concept
## I30 --> Teacher
## I1  --> Test
## I24 --> Worth

stars_sub <- inner_join(scales, stars, "item_id")
glimpse(stars_sub)

## calculate subscale means per student_id and year
stars_means <- stars_sub %>%
   group_by(student_id, year, subscale) %>%
   summarise(mscore = mean(score))

glimpse(stars_means)

ggplot(stars_means, aes(subscale, mscore, color = subscale)) +
    geom_jitter(alpha = .7) +
    geom_violin(aes(fill = subscale), alpha = .2) +
    coord_flip() + 
    facet_wrap(~year) +
    guides(color = FALSE, fill = FALSE)
