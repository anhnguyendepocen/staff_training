library("dplyr")
library("tidyr")
## NB: dev version of dplyr (0.4.3.9001) breaks tidyr::nest()
##     if you get the error "No variables selected" when using tidyr::nest(),
##     downgrade back to CRAN version of dplyr (0.4.3) using:
##     install.packages("dplyr")
library("purrr")
library("broom")

survey <- readRDS("stars_anon/survey.rds")
scales <- readRDS("stars_anon/subscales.rds")
software <- readRDS("stars_anon/software.rds")
marks <- readRDS("stars_anon/marks.rds")

## read in all the files stored in data/
read_survey_data <- function(x) {
    fname <- paste("data", x, sep = "/")
    asid <- sub("\\.csv$", "", x) 
    read.csv(fname, stringsAsFactors = FALSE) %>%
        mutate(ASID = asid)
}

my_files <- list.files("data")

## first method: a for loop
##   followed by dplyr::bind_rows()
dat <- list()
for (i in seq_along(my_files)) {
    dat[[i]] <- read_survey_data(my_files[i])
}
survey <- bind_rows(dat)

## second method: base::lapply()
##   followed by dplyr::bind_rows()
dat <- lapply(my_files, read_survey_data)
survey <- bind_rows(dat)

## third method: purrr::map()
##   followed by dplyr::bind_rows()
dat <- purrr::map(my_files, read_survey_data)
survey <- dplyr::bind_rows(dat)

## fourth method: plyr::ldply()
survey <- plyr::ldply(my_files, read_survey_data)

## change from long to wide and calculate final score
## 60% exam, 40% homework
fmarks <- marks %>%
    spread(component, mark) %>%
    mutate(Final = .6 * Exam_Pts + .4 * Homework_Pts) %>%
    select(ASID, Final)

fsoft <- fmarks %>%
    inner_join(software, "ASID")

parm_t <- t.test(Final ~ software, data = fsoft)

hist(fsoft$Final)

## 1. randomly re-assign values of 'software' to each row
## 2. calculate means for each software group
## 3. store the result

## build a function
## x <- fsoft
mean_diff <- function(x, permute = TRUE) {
    if (permute) {
        x$software <- sample(x$software)
    }

    x_means <- x %>%
        group_by(software) %>% summarise(m_Final = mean(Final))

    x_means$m_Final[1] - x_means$m_Final[2]
}

orig <- mean_diff(fsoft, FALSE)

px <- c(orig, replicate(9999, mean_diff(fsoft)))

n_ge <- sum(abs(px) >= abs(px[1]))
pval <- n_ge / length(px)

tidy(parm_t)
cat("permutation p-value: ", round(pval, 4), "\n")

ind_ttest <- function(x) {
    t.test(m_score ~ software, data = x)
}

allsub <- survey %>%
    inner_join(scales, "item_id") %>%
    group_by(ASID, subscale) %>%
    summarise(m_score = mean(resp)) %>%
    ungroup()

allsoft <- allsub %>%
    inner_join(software, "ASID")

res <- allsoft %>%
    nest(-subscale) %>%
    mutate(ttest = map(data, ind_ttest),
           stats = map(ttest, tidy))

res %>%
    unnest(stats) %>%
    select(-data, -ttest)

paired_ttest <- function(x) {
    t.test(x$w1, x$w2, paired = TRUE)
}

subscores <- survey %>%
    inner_join(scales, "item_id") %>%
    group_by(ASID, wave, subscale) %>%
    summarise(m_score = mean(resp)) %>%
    ungroup()

## only those students for whom we have data for both waves
both <- subscores %>%
    select(ASID, wave) %>%
    distinct() %>%
    count(ASID) %>%
    filter(n == 2)

subboth <- subscores %>%
    semi_join(both, "ASID") %>%
    spread(wave, m_score) %>%
    nest(-subscale, .key = scores)

## TODO: show some examples of purrr::map()
subboth %>%
    mutate(model = purrr::map(scores, paired_ttest),
           stats = purrr::map(model, broom::tidy)) %>%
    select(subscale, stats) %>%
    unnest(stats)
