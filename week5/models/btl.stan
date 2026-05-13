data {
  int<lower=2> I;                 // number of items
  int<lower=1> P;                 // number of unordered pairs
  array[P] int<lower=1, upper=I> item1;
  array[P] int<lower=1, upper=I> item2;
  array[P] int<lower=0> y;        // item1 chosen over item2
  array[P] int<lower=0> n;        // total comparisons
}

parameters {
  vector[I] eta_raw;
}

transformed parameters {
  vector[I] eta;
  vector[P] pair_z;

  // sum-to-zero identification
  eta = eta_raw - mean(eta_raw);

  for (p in 1:P) {
    pair_z[p] = eta[item1[p]] - eta[item2[p]];
  }
}

model {
  eta_raw ~ normal(0, 1);

  for (p in 1:P) {
    y[p] ~ binomial(n[p], Phi(pair_z[p])); // note ive changed to probit (instead logit) model for familiarity :)
    // y[p] ~ binomial(n[p], inv_logit(pair_z)); // to follow original btl
    // y[p] ~ binomial_logit(n[p], pair_z[p]); even more efficient for inv_logit
  }
}
