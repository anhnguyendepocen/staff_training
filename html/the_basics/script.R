## REPL: Read/Evaluate/Print Loop
## R prints results back at you
1 + 1

1 + 1 + 3

## here comes a long expression
## let's break it over multiple lines
1 + 2 + 3 + 4 + 5 + 6 +
    7 + 8 + 9 +
    10

"Good afternoon"

"There is nothing in the world 
that makes people so unhappy as fear.  
The misfortune that befalls us is 
seldom, or never, as bad as that 
which we fear.

- Friedrich Schiller"

## comments: any text from '#' on is ignored until end of line
22 / 7  # approximation to pi

## use the assignment operator '<-'
## R stores the number in the variable
x <- 5

x * 2

## R evaluates the expression and stores the result in the variable
boring_calculation <- 2 + 2

boring_calculation

ls()

rm("x")

rm(list = ls()) # clear out the workspace

## put information into a vector using c(...)
c(1, 2, 3)

c("this", "is", "cool")

## what happens when you mix types?
c(2, "good", 2, "b", "true")

## example IQ scores: mu = 100, sigma = 15
iq <- c(86, 101, 127, 99)

iq - 100

## z-scores
(iq - 100) / 15

iq_z <- (iq - 100) / 15

sort(iq_z)

round(iq_z, 2)

round(sort(iq_z), 2)

install.packages("fortunes")
devtools::install_github("sckott/cowsay")

library("dplyr") # access functionality, including pipes

## replaces:
##   round(sort(iq_z), 2)
iq_z %>% sort() %>% round(2)

## help(topic, package)
help("pnorm") ## help page
?pnorm 

example("pnorm") ## show examples (careful!)

## what percentile (against the standard normal dist)
pnorm(iq_z)

## what percentile, calculated from raw scores
pnorm(iq, mean = 100, sd = 15)

dat <- data.frame(subject = c("DB", "FF", "LQ", "MJ"),
           IQ = iq,
           z_score = iq_z,
           percentile = pnorm(iq_z) * 100)

dat

## all of these methods are equivalent
dat$IQ
dat[["IQ"]]
dat[[2]]

dat[, "IQ"]
dat[, 2]
