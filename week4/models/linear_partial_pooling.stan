data {
  int<lower=0> n;
  int<lower=1> k;
  array[n] int<lower=1, upper=k> id;
  vector[n] y;
  vector[n] x;
}

parameters {
  real beta0_mu;
  real<lower=0> beta0_sigma;
  
  real beta1_mu;
  real<lower=0> beta1_sigma;
  
  real<lower=0> sigma_sigma;
  
  vector[k] beta0;
  vector[k] beta1;
  vector<lower=0>[k] sigma;
}

model {
  // hyperpriors/group-level priors
  beta0_mu ~ normal(0, 1);
  beta0_sigma ~ exponential(1);
  beta1_mu ~ normal(0, 1);
  beta1_sigma ~ exponential(1);
  sigma_sigma ~ exponential(1);
  
  // priors/individual-level priors
  beta0 ~ normal(beta0_mu, beta0_sigma);
  beta1 ~ normal(beta1_mu, beta1_sigma);
  sigma ~ normal(0, sigma_sigma);
  
  // likelihood
  y ~ normal(beta0[id] + beta1[id] .* x, sigma[id]);
}
