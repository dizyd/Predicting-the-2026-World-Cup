
data {
  int<lower=0> N_teams;
  int<lower=0> N_matches;
  int<lower=0> goals_A[N_matches];
  int<lower=0> goals_B[N_matches];
  int<lower=0> team_A[N_matches];
  int<lower=0> team_B[N_matches];
  vector[N_matches] score_A;
  vector[N_matches] score_B;
}


parameters {
  vector[N_teams] lambda0;
  real b1;
  real mu;
}


model {
  // Priors
  b1      ~ normal(0, 1);
  mu      ~ normal(0, 1);
  lambda0 ~ normal(0, 0.5);

  
  for(i in 1:N_matches){
    
    goals_A[i] ~ poisson(exp(mu + lambda0[team_A[i]] + b1*(score_A[i] - score_B[i])));
    goals_B[i] ~ poisson(exp(mu + lambda0[team_B[i]] + b1*(score_B[i] - score_A[i])));
    
  }
  
 

}
