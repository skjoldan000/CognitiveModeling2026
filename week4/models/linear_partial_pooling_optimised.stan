data {
  int<lower=0> n;
  int<lower=1> k;
  array[n] int<lower=1, upper=k> id;
  vector[n] y;
  vector[n] x;
}

parameters {
  // intercept
  real beta0_mu;
  real<lower=0> beta0_sigma;
  vector[k] beta0_raw;
  
  // slope
  real beta1_mu;
  real<lower=0> beta1_sigma;
  vector[k] beta1_raw;
  
  // sigma
  real log_sigma_mu;
  real<lower=0> log_sigma_sigma;
  vector[k] log_sigma_raw;
}

transformed parameters {
  // non-centred parameterisation
  vector[k] beta0 = beta0_mu + beta0_sigma * beta0_raw;
  vector[k] beta1 = beta1_mu + beta1_sigma * beta1_raw;
  
  vector[k] log_sigma = log_sigma_mu + log_sigma_sigma*log_sigma_raw;
  vector<lower=0>[k] sigma = exp(log_sigma);
}

model {
  // hyperpriors/group-level priors
  beta0_mu ~ normal(0, 5);
  beta0_sigma ~ normal(0, 1);
  beta1_mu ~ normal(0, 5);
  beta1_sigma ~ normal(0, 1);
  
  // priors/individual-level priors, non-centred
  beta0_raw ~ normal(0, 1);
  beta1_raw ~ normal(0, 1);
  
  log_sigma_mu ~ normal(0, 1);
  log_sigma_sigma ~ normal(0, 1);
  log_sigma_raw ~ normal(0, 1);
  
  // likelihood
  y ~ normal(beta0[id] + beta1[id] .* x, sigma[id]);
}
