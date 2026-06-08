# Predicting the 2026 World Cup: A Bayesian Approach

[![Rendered with Quarto](https://img.shields.io/badge/Rendered_with-Quarto-blue?logo=quarto)](https://quarto.org/)
[![Built with R](https://img.shields.io/badge/Built_with-R-276DC3?logo=r)](https://www.r-project.org/)
[![Bayesian Modeling](https://img.shields.io/badge/Modeling-Stan_&_brms-B31B1B)](https://mc-stan.org/)

Can we use data to forecast the outcomes of the **group stage** of the  FIFA World Cup 2026? 

This project uses a **Bayesian Poisson regression model** built in `Stan` to simulate the upcoming tournament. 

The approach is documented **[here](https://dizyd.github.io/Predicting-the-2026-World-Cup/)**

---

## Data Sources

The model relies on two primary data files located in the `Data/` directory:

1. **`wm2026_quali_games.csv`**
   * **Description:** Contains historical match results from the World Cup qualifying phases across different global regions. 
   * **Purpose:** Used to calculate actual goals scored and conceded, allowing the model to learn the intrinsic offensive and defensive momentum of each national team.

2. **`country_stats.csv`**
   * **Description:** Contains the average overall player ratings (`mean_overall`) and average squad age (`mean_age`) for each country, scraped from EA Sports FC / FIFA video game data.
   * **Purpose:** Acts as a real-time proxy for the current talent level of a team. Since historical match data might be outdated due to aging rosters, these stats ground the model in the *current* strength of the squads. Missing data for smaller nations is imputed with a conservative baseline score.

---

##  Methodology

1. **The Model:** A Bayesian Poisson model where the number of goals scored by Team A against Team B is influenced by a global scoring rate ($\mu$), an intrinsic attacking strength parameter ($\lambda_{0, A}$), and the difference in their average FIFA player scores.
2. **Simulation:** Posterior parameters are extracted using MCMC sampling. Each match in the hypothetical group stage is simulated thousands of times to generate a probability distribution of goals.
3. **Probabilities:** Win, draw, and loss probabilities are calculated directly from the proportion of simulated outcomes.

---

##  Final Predictions (Group Stage Excerpt)

Below is an excerpt of the model's predictions for some of the key matchups in the simulated 2026 Group Stage. 

*Note: `Pred Goals` represents the most likely scoreline (the mode), while the probabilities reflect the full distribution of simulated outcomes.*

| Team A | Team B | Pred Goals A | Pred Goals B | P(Win A) | P(Win B) | P(Tie) |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: |
| Mexico | South Africa | 2 | 0 | 68.4% | 11.2% | 20.4% |
| Germany | Curaçao | 3 | 0 | 88.1% | 2.5% | 9.4% |
| Spain | Uruguay | 1 | 1 | 39.5% | 31.8% | 28.7% |
| Canada | Switzerland | 1 | 2 | 22.4% | 51.3% | 26.3% |
| Brazil | Morocco | 2 | 1 | 61.2% | 18.5% | 20.3% |
| USA | Australia | 1 | 1 | 35.1% | 34.6% | 30.3% |
| England | Croatia | 1 | 1 | 42.0% | 29.5% | 28.5% |

*(For the complete table of all group stage matches and the full simulated 32-team Knockout Bracket, please visit the [GitHub Pages link](https://dizyd.github.io/Predicting-the-2026-World-Cup/)).*
