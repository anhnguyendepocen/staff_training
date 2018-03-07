wave_1 <- read_excel("GA time 1.xlsx", sheet = 2L)
glimpse(wave_1)

wave_1 <- read_excel("GA time 1.xlsx", sheet = 2L) %>%
  filter(!is.na(ID))

wave_1$ID

wave_1$new_id

head(long_1, 5)
