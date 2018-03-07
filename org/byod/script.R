library("readxl") ## for reading in directly from excel
library("dplyr")  ## for piping and data manipulation
library("tidyr")  ## for re-shaping from wide to long

wave_1 <- read_excel("GA time 1.xlsx", sheet = 2L) %>%
  filter(!is.na(ID)) %>%
  mutate(new_id = toupper(gsub("[\\., ]", "", ID))) %>%
  select(-ID)

wave_2 <- read_excel("GA time 2.xlsx", sheet = 2L) %>%
  filter(!is.na(ID)) %>%
  mutate(new_id = toupper(gsub("[\\., ]", "", ID))) %>%
  select(-ID)

## which respondents completed both waves?
semi_join(wave_1, wave_2, "new_id") %>% 
  `[[`("new_id") %>% sort()

## which respondents completed wave 1 but not wave 2?
anti_join(wave_1, wave_2, "new_id") %>%
  `[[`("new_id") %>% sort()

## which respondents completed wave 2 but not wave 1?
anti_join(wave_2, wave_1, "new_id") %>%
  `[[`("new_id") %>% sort()

long_1 <- gather(wave_1, question, response, -new_id) %>%
    mutate(Wave = 1L) %>%
    arrange(new_id)

long_2 <- gather(wave_2, question, response, -new_id) %>%
    mutate(Wave = 2L) %>%
    arrange(new_id)

all_data <- bind_rows(long_1, long_2)
