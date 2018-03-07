library("tidyr")
library("dplyr")

anonymous_SID <- function() {
    paste(sample(0:9, 7, TRUE), collapse = "")
}

dat <- read.csv("/home/daleb/dhome/undergrad_R/stars_scores.csv",
                colClasses = rep(c("character", "integer"), c(2, 2)),
                stringsAsFactors = FALSE)

soft <- read.csv("/home/daleb/dhome/undergrad_R/software.csv",
                 colClasses = rep("character", 3),
                 stringsAsFactors = FALSE) %>%
                     select(-id)

marks <- read.csv("/home/daleb/dhome/undergrad_R/final_grades.csv",
                  stringsAsFactors = FALSE,
                  colClasses = rep(c("character", "integer"), c(4, 3)))

all_IDs <- union(dat %>% select(SID) %>% distinct(),
                 soft %>% select(SID) %>% distinct(),
                 marks %>% select(SID) %>% distinct()) %>%
    arrange(SID)

anon_key <- data_frame(ASID = replicate(nrow(all_IDs), anonymous_SID()),
           SID = all_IDs[["SID"]])

stopifnot(length(unique(anon_key[["ASID"]])) ==
              length(unique(anon_key[["SID"]])))

saveRDS(anon_key, "/home/daleb/dhome/undergrad_R/anon_key.rds")

dat %>% inner_join(anon_key, "SID") %>%
    as_data_frame() %>%
    mutate(item_id = as.integer(substr(item_id, 2, nchar(item_id))),
           wave = paste0("w", Wave)) %>%
    select(ASID, item_id, resp, wave) %>%
    saveRDS("stars_anon/survey.rds")

soft %>% inner_join(anon_key, "SID") %>%
    as_data_frame() %>%
    select(ASID, software = Software) %>%
    saveRDS("stars_anon/software.rds")

marks %>% inner_join(anon_key, "SID") %>%
    as_data_frame() %>%
    select(ASID, Homework_Pts, Exam_Pts) %>%
    gather(component, mark, -ASID) %>%
    arrange(ASID, component) %>%
    saveRDS("stars_anon/marks.rds")

library("dplyr")
library("purrr")

survey <- readRDS("stars_anon/survey.rds")

save_it <- function(x) {
    x_dat <- select(x, -ASID)
    write.csv(x_dat, paste0("data/", x$ASID[1], ".csv"), row.names = FALSE)
}

survey %>%
    split(.$ASID) %>%
    walk(save_it)

survey_nest <- survey %>% nest(-ASID)

map(survey_nest$data, nrow)
map_int(survey_nest$data, nrow)

sdat <- survey_nest %>%
    mutate(ni = map_int(data, nrow),
           nm = map_dbl(data, function(x) mean(x$resp)))

map_dbl(survey_nest$data, function(x) mean(x$resp)) %>%
    mean()

boot <- replicate(1000, sample_n(survey_nest, nrow(survey_nest), TRUE),
                  simplify = FALSE)
