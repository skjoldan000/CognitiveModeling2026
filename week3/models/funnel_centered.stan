parameters {
  real y;
  vector[8] x;
}

model {
  y ~ normal(0, 3);
  x ~ normal(0, exp(y / 2));
}
