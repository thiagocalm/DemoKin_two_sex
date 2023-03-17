

# Packages ----------------------------------------------------------------

#Using the developing version
devtools::install_github("IvanWilli/DemoKin")

library(DemoKin)
library(tidyr)
library(dplyr)
library(ggplot2)
library(knitr)

# Scenario 1: we have all data ----------------------------------------------

# data
fra_fert_f <- fra_asfr_sex[,"ff"]
fra_fert_m <- fra_asfr_sex[,"fm"]
fra_surv_f <- fra_surv_sex[,"pf"]
fra_surv_m <- fra_surv_sex[,"pm"]

# estimating relates

kin_sc1 <- kin2sex(
  pf = fra_surv_f,
  pm = fra_surv_m,
  ff = fra_fert_f,
  fm = fra_fert_m,
  time_invariant = TRUE,
  sex_focal = "f",
  birth_female = .5
)

# outputs full data
kin_sc1_out <- kin_sc1$kin_summary |>
  mutate(kin = case_when(kin %in% c("s", "s") ~ "s",
                         kin %in% c("ya", "oa") ~ "a",
                         T ~ kin)) |>
  filter(kin %in% c("d", "m", "gm", "ggm", "s", "a"))

kin_sc1_out |>
  group_by(kin, age_focal, sex_kin) %>%
  summarise(count=sum(count_living)) %>%
  ggplot(aes(age_focal, count, fill=sex_kin))+
  geom_area()+
  theme_bw() +
  facet_wrap(~kin)


# Scenario 2: GKP factors -------------------------------------------------

kin_sc2 <- kin(fra_surv_f,
               fra_fert_f,
               birth_female = .5)

kin_sc2_out <- kin_sc2$kin_summary |>
  mutate(count_living = case_when(kin == "m" ~ count_living * 2,
                                  kin == "gm" ~ count_living * 4,
                                  kin == "ggm" ~ count_living * 8,
                                  kin == "d" ~ count_living * 2,
                                  kin == "gd" ~ count_living * 4,
                                  kin == "ggd" ~ count_living * 4,
                                  kin == "oa" ~ count_living * 4,
                                  kin == "ya" ~ count_living * 4,
                                  kin == "os" ~ count_living * 2,
                                  kin == "ys" ~ count_living * 2,
                                  kin == "coa" ~ count_living * 8,
                                  kin == "cya" ~ count_living * 8,
                                  kin == "nos" ~ count_living * 4,
                                  kin == "nys" ~ count_living * 4))

# Evaluating both (Full data and GKP factors)

bind_rows(
  kin_sc1_out  |>  mutate(type = "Full"),
  kin_sc2_out  |>  mutate(type = "GKP"))  |>
  mutate(kin = case_when(kin %in% c("ys", "os") ~ "s",
                         kin %in% c("ya", "oa") ~ "a",
                         kin %in% c("coa", "cya") ~ "c",
                         kin %in% c("nys", "nos") ~ "n",
                         T ~ kin))  |>
  filter(age_focal %in% c(5, 15, 30, 60, 80))  |>
  group_by(kin, age_focal, type) |>
  summarise(count = sum(count_living))  |>
  ggplot(aes(type, count)) +
  geom_bar(aes(fill=type), stat = "identity") +
  facet_grid(col = vars(kin), row = vars(age_focal), scales = "free") +
  theme_light() +
  theme(
    axis.text.x = element_text(angle = 90),
    legend.position = "bottom")

# Scenario 3: Male survival is available ----------------------------------

kin_sc3 <- kin2sex(
  pf = fra_surv_f,
  pm = fra_surv_m,
  ff = fra_fert_f,
  fm = fra_fert_f,
  time_invariant = TRUE,
  sex_focal = "f",
  birth_female = .5
)

# output

kin_sc3_out <- kin_sc3$kin_summary  |>
  mutate(kin = case_when(kin %in% c("s", "s") ~ "s",
                         kin %in% c("ya", "oa") ~ "a",
                         T ~ kin)) |>
  filter(kin %in% c("d", "m", "gm", "ggm", "s", "a"))


# Comparing estimates -----------------------------------------------------

# Number of kinship along the lifecicle

bind_rows(
  kin_sc1_out |> mutate(type = "Full"),
  kin_sc2_out |> mutate(type = "GKP"),
  kin_sc3_out %>% mutate(type = "Alternative"))  |>
  mutate(kin = case_when(kin %in% c("ys", "os") ~ "s",
                         kin %in% c("ya", "oa") ~ "a",
                         kin %in% c("coa", "cya") ~ "c",
                         kin %in% c("nys", "nos") ~ "n",
                         T ~ kin)) |>
  filter(kin %in% c("a", "d", "ggm","gm","m")) |>
  group_by(kin, age_focal, type) |>
  summarise(count = sum(count_living)) |>
  mutate(kin = case_when(
    kin == "d" ~ "Daugther/Son",
    kin == "a" ~ "Aunt/Uncle",
    kin == "ggm" ~ "Great-Grandmother/father",
    kin == "gm" ~ "Grandmother/father",
    kin == "m" ~ "Mother/Father"
  )) |>
  ggplot(aes(x = as.numeric(age_focal), y = count, linetype = type, color = type)) +
  geom_line(linewidth = 1.05) +
  scale_x_continuous(breaks = seq(0,100,10)) +
  theme_light() +
  labs(
    title = "Number of kin by the female age focal. ",
    caption = "Source: DemoKin package data for example.",
    x = "Age focal",
    y = "Number of kin"
  ) +
  scale_color_manual(values = c("#35978f","#4d4d4d", "#993404")) +
  facet_grid(col = vars(kin), scales = "free") +
  theme(
    plot.title = element_text(face = "bold", size = 12, hjust = 0),
    plot.caption = element_text(size = 9),
    legend.title = element_text(face = "bold", size = 9, hjust = 0, vjust = .5),
    legend.text = element_text(size = 8, hjust = 0, vjust = .5),
    legend.position = "bottom",
    axis.title = element_text(face = "bold", size = 10, hjust = 1, vjust = .5),
    axis.text = element_text(face = "bold", size = 8, color = "#636363", hjust = .5, vjust = .5),
    strip.background = element_blank(),
    strip.text = element_text(face = "bold", size = 9, color = "#636363", hjust = .9, vjust = .5),
    panel.grid = element_line(color = "#f0f0f0",linewidth = .01)
  )

# Ratio approximation scenario by "Full data scenario"

bind_rows(
  kin_sc1_out |> mutate(type = "Full"),
  kin_sc2_out |> mutate(type = "GKP"),
  kin_sc3_out %>% mutate(type = "Alternative"))  |>
  mutate(kin = case_when(kin %in% c("ys", "os") ~ "s",
                         kin %in% c("ya", "oa") ~ "a",
                         kin %in% c("coa", "cya") ~ "c",
                         kin %in% c("nys", "nos") ~ "n",
                         T ~ kin)) |>
  filter(kin %in% c("a", "d", "ggm","gm","m")) |>
  group_by(kin, age_focal, type) |>
  summarise(count = sum(count_living)) |>
  pivot_wider(names_from = "type",values_from = "count") |>
  mutate(sc2by1 = GKP/Full,
         sc3by1 = Alternative/Full) |>
  pivot_longer(cols = sc2by1:sc3by1, names_to = "ratio", values_to = "value") |>
  mutate(kin = case_when(
    kin == "d" ~ "Daugther/Son",
    kin == "a" ~ "Aunt/Uncle",
    kin == "ggm" ~ "Great-Grandmother/father",
    kin == "gm" ~ "Grandmother/father",
    kin == "m" ~ "Mother/Father"
  )) |>
  mutate(ratio = case_when(
    ratio == "sc2by1" ~ "GKP/Full",
    TRUE ~ "Alternative/Full"
  )) |>
  ggplot(aes(x = age_focal, y = value, linetype = ratio, color = ratio)) +
  geom_hline(yintercept = 1, color = "black", linewidth = 1.1) +
  geom_line(linewidth = 1.05) +
    theme_light() +
    labs(
      title = "Ratio between (i)'GKP factor'/'Full data' and (ii)'Alternative'/'Full data' \nnumber of kin by the female age focal",
      caption = "Source: DemoKin package data for example.",
      x = "Age focal",
      y = "Ratio between scenarios"
    ) +
    scale_color_manual(values = c("#35978f", "#993404")) +
    facet_grid(col = vars(kin), scales = "free") +
    theme(
      plot.title = element_text(face = "bold", size = 12, hjust = 0),
      plot.caption = element_text(size = 9),
      legend.title = element_text(face = "bold", size = 9, hjust = 0, vjust = .5),
      legend.text = element_text(size = 8, hjust = 0, vjust = .5),
      legend.position = "bottom",
      axis.title = element_text(face = "bold", size = 10, hjust = 1, vjust = .5),
      axis.text = element_text(face = "bold", size = 8, color = "#636363", hjust = .5, vjust = .5),
      strip.background = element_blank(),
      strip.text = element_text(face = "bold", size = 9, color = "#636363", hjust = .9, vjust = .5),
      panel.grid = element_line(color = "#f0f0f0",linewidth = .01)
    )

