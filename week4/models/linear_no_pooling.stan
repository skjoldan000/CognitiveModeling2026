data {
  int<lower=0> n;
  int<lower=1> k;
  array[n] int<lower=1, upper=k> id;
  vector[n] y;
  vector[n] x;
}

parameters {
  vector[k] beta0;
  vector[k] beta1;
  vector<lower=0>[k] sigma;
}

model {
  beta0 ~ normal(0, 5);
  beta1 ~ normal(0, 5);
  sigma ~ normal(0, 5);
  
  // likelihood
  y ~ normal(beta0[id] + beta1[id] .* x, sigma[id]); // .* we want element-wise multiplication, not dot product
}
