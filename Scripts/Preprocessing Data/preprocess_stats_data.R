# In this script, I want to preprocess the data a bit. After a first look at the data
# I don't think my initial idea of joining player data will work, since in the data
# files the player names all have different formats (e.g., "R. Jiménez", "Raúl Alonso 
# Jiménez Rodríguez", "Raul Jiménez"). Therefore, for now, I will start by making nation 
# indices. 

# Packages                        ----------------------------------------------------------------

library(tidyverse)

# Data                            -------------------------------------------------------------------

df_players_all   <- read_csv("Data/wm2026_all_players.csv")
df_players_stats <- read_csv2("Data/player_stats_2026.csv")
df_quali         <- read_csv("Data/wm2026_quali_games.csv") 

# Get countries in Quali          ---------------------------------------------------------------

countries_in_quali <- df_quali |> 
                        select(country = Away, region = Region) |> 
                        rowwise() |> 
                        mutate(region = str_split_1(region,"_")[1]) |> 
                        arrange(country) |> 
                        distinct() %>%
                        add_column("ID" = 1:nrow(.),.before = "country")

# Compute country level variables ---------------------------------------------------------------

# Lets compute country level variables, but only based on the 30 best players (e.g., for 
# Argentina we have 1061 players in the data base).
country_stats <- df_players_stats |> 
                    arrange(nationality_name, desc(overall), desc(value_eur)) |> 
                    group_by(nationality_name) |> 
                    slice_head(n = 30) |> 
                    summarize(n                 = n(),
                              across(
                                c(overall, value_eur, age),
                                list(
                                  mean = \(x) mean(x, na.rm = TRUE),
                                  sd   = \(x) sd(x, na.rm = TRUE),
                                  md   = \(x) median(x, na.rm = TRUE),
                                  min  = \(x) min(x, na.rm = TRUE),
                                  max  = \(x) max(x, na.rm = TRUE)
                                ),
                                .names = "{.fn}_{.col}"
                              )) |> 
                    rename(country = nationality_name)



# Merge                           ---------------------------------------------------------------

# Rename countries to make them match

# df <- full_join(countries_in_quali, country_stats, by="country") 

# Cabo Verde, Canada, China PR, Congo DR, Curacao, Czechia, Côte d'Ivoire, 	
# Korea Republic, Mexico, Russia, Türkiye, United States


country_stats <- country_stats |> 
                    mutate(country = case_when(
                      country == "China PR" ~ "China",
                      country == "Korea Republic" ~ "South Korea",
                      country == "Czechia" ~ "Czech Republic",
                      country == "Côte d'Ivoire" ~ "Ivory Coast",
                      country == "Cabo Verde" ~ "Cape Verde",
                      country == "Congo DR" ~ "DR Congo",
                      country == "Curacao" ~ "Curaçao",
                      country == "Türkiye" ~ "Turkey",
                      TRUE ~ country))

df <- full_join(countries_in_quali, country_stats, by="country") 

# Not matched are the hosting countries (Mexico, Canada and USA), who did not have
# any qualifying games, and Russia which does not participate. Lets remove Russia and 
# then add IDs for the hosting countries.

df <- df |> 
        filter(country != "Russia") |> 
        mutate(region = ifelse(country %in% c("Canada","Mexico","USA"), "CONCACAF", region)) 

df$ID <- 1:nrow(df)


# Save                            ---------------------------------------------------------------

write_csv2(df, file = "Data/country_stats.csv")
