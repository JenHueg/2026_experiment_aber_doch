# Transparency note: 
# This script was created using the help of ChatGPT model -5.6 Luna, an AI language model developed by OpenAI.

#load packages
library(ordinal)   # clmm
library(ggplot2)   # diagrams
library(dplyr)     # data
library(readr)     # csv
library(flextable) # tables
library(broom.mixed) 

# Prepare data --------------

###set working directory if necessary and show current working directory ------
#setwd()

###load data----
data <- read.table("data_test.csv", header = T, sep = ";")
data

###inspect data ----
str(data)
head(data)
glimpse(data)
#shows how often my dependent variable (rating) is missing and how many participants I have
table(data$rating, useNA = "always")
n_distinct(data$participantID) 

###set factors for model ----
#legend for condition names in table:
# x = structure 1, control, not in analysis
# y = structure 2, control, not in analysis
# a = at-issue, in analysis
# n = not-at-issue, in analysis
# d = particle "doch", in analysis
# b = particle "aber", in analysis
# factor "issueness" and "particle" needed for model 

###add aditional columns with two relavant factors ----
data <- data %>%
  mutate(
    factor_issueness = substr(condition, 2,2),
    factor_particle = substr(condition, 3,3)
  )

data

###set as factors ---
data$factor_issueness <- factor(data$factor_issueness, levels = c("a", "n"), labels = c("at-issue", "not-at-issue"))
data$factor_particle <- factor(data$factor_particle, levels = c("d", "b"), labels = c("doch", "aber"))
data$participantID <- factor(data$participantID)
data$item <- factor(data$item)
data$rating <- factor(data$rating, ordered = TRUE, levels = 1:5)
#check if really factor
class(data$factor_issueness)
class(data$factor_particle)
class(data$participantID)
class(data$item)
class(data$rating)

# CLMM ------------------

### testing parallel odds prerequisite ----
# Standard model
modell_po <- clm(rating ~ condition, data = data)
saveRDS(modell_po, "modell_po.rds")

# not standard model, allows different effects across thresholds 
modell_npo <- clm(rating ~ condition, nominal = ~ condition, data = data)
saveRDS(modell_npo, "modell_npo.rds")

# compare with likelihood ratio test
# output should not show significant result in order to continue with CLMM
anova(modell_po, modell_npo)

###CLMM ----
model <- clmm(rating ~ factor_issueness * factor_particle + (1|participantID) + (1|item), data = data)
summary(model)

###CLMM ---- (test data only works with item as random effects)
model <- clmm(rating ~ factor_issueness * factor_particle + (1|item), data = data)
summary(model)

### Comparisons ---- 
library(emmeans)
#testing for main effect; hypothesis: d > b
emm_particle <- emmeans(model, ~ factor_particle)
contrast_d_b <- contrast(emm_particle, method = "pairwise")
contrast_d_b # would not be one sided! 
test(contrast_d_b, side = ">") # one-sided test for d > b

#looking at interaction effect
comparison_particle_base <- emmeans(model, pairwise ~ factor_issueness | factor_particle)
comparison_issueness_base <- emmeans(model, pairwise ~ factor_particle| factor_issueness)

#plot 
# install.packages("janitor") # needed for functions
#install.packages("knitr") # needed for functions
#install.packages("likert") # needed for functions
#install.packages("RColorBrewer") # needed for functions)
#install.packages("scales") # needed for functions
library(janitor)
library(knitr)
library(likert)
library(RColorBrewer)
library(scales)

# summarize conditions excluding y and x distinction
data2 <- data %>%
  mutate(condition_group = sub("^[xy]", "", condition))
data2

#name grouped conditions
data2 <- data2 %>%
  mutate(
    condition_group = dplyr::recode(
      condition_group, 
      "ab" = "at-issue, aber",
      "ad" = "at-issue, doch",
      "nb" = "not-at-issue, aber",
      "nd" = "not-at-issue, doch"
    )
  )
data2

# calculate percentages of ratings
df_plot <- data2 %>%
  count(condition_group, rating) %>%
  group_by(condition_group) %>%
  mutate(
    percentage = n / sum(n) * 100
  ) %>%
  ungroup()

#determine order of ratings

df_plot$rating <- factor(
  df_plot$rating,
  levels = c(5,4,3,2,1)
)

#determine order of conditions

df_plot$condition_group <- factor(
  df_plot$condition_group,
  levels = c(
    "at-issue, doch",
    "not-at-issue, doch",
    "at-issue, aber",
    "not-at-issue, aber"
  )
)

#select colours manually (keep it accessible)
my_colors <- c(
  "1" = "#D55E00",
  "2" = "#CC79A7",
  "3" = "#E69F00",
  "4" = "#56B4E9",
  "5" = "#009E73"
)

#create plot

p <- ggplot(
  df_plot,
  aes(
    y = condition_group,
    x = percentage,
    fill = rating
  )
) +
  
  geom_col(
    width = 0.7
  ) +
  
  scale_x_continuous(
    labels = function(x) paste0(x, "%"),
    limits = c(0, 100),
    breaks = seq(0, 100, 25),
    expand = c(0, 0)
  ) +
  
  scale_fill_manual(
    values = my_colors,
    labels = c(
      "1" = "1, very bad",
      "2" = "2",
      "3" = "3",
      "4" = "4",
      "5" = "5, very good"
    ),
    name = "rating"
  ) +
  
  labs(
    x = NULL,
    y = "percentage"
  ) +
  
  theme_minimal(base_size = 16) +
  
  theme(
    legend.position = "right",
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  )

p




