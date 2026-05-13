data {
  int<lower=1> N;
  array[N] int<lower=0, upper=1> y;
  vector[N] agodat;
  vector[N] antadat;
  vector[N] visdat;
}

parameters {
  real baseline;
  real ago;
  real anta;
  real vis;
}

model {
  // priors
  baseline ~ normal(0, 1);
  ago ~ normal(0, 1);
  anta ~ normal(0, 1);
  vis ~ normal(0, 1);

  // likelihood
  vector[N] eta;
  vector[N] p;
  eta= baseline 
      + ago * agodat 
      + anta * antadat 
      + vis * visdat;
  p = Phi(eta);
  y ~ bernoulli(p);
}

generated quantities {
  vector[N] log_lik;
  array[N] int y_rep;
  vector[N] eta;
  vector[N] p;

  for (n in 1:N) {
    eta[n] = baseline
             + ago * agodat[n]
             + anta * antadat[n]
             + vis * visdat[n];

    p[n] = Phi(eta[n]);

    log_lik[n] = bernoulli_lpmf(y[n] | p[n]); // for LOO-CV
    y_rep[n] = bernoulli_rng(p[n]); // for posterior predictive checks
  }
}