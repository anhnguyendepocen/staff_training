library("dplyr")   # data processing
library("tidyr")   # data reshaping
library("ggplot2") # plotting

scales <- read.csv("subscales.csv", stringsAsFactors = FALSE)

stars_wide <- read.csv("stars.csv", stringsAsFactors = FALSE)

stars <- stars_wide %>% gather(item_id, score, I01:I51)

stars_sub <- inner_join(scales, stars, "item_id")

## calculate subscale means per student_id and year
stars_means <- stars_sub %>%
   group_by(student_id, year, subscale) %>%
   summarise(mscore = mean(score))

ggplot(stars_means, aes(subscale, mscore, color = subscale)) +
    geom_jitter(alpha = .7) +
    geom_violin(aes(fill = subscale), alpha = .2) +
    stat_summary(fun.y = 'median', geom = "point", size = 5) +
    coord_flip() + 
    facet_wrap(~year) +
    guides(color = FALSE, fill = FALSE)


