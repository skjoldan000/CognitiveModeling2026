data {
  int N; // antal total obs
  array[N] int y; // outcome, kodet som 0, 1
  vector[N] x; // predictor, e.g. noise eller signal trial, kodet som 0, 1
}

parameters {
  real z; // her center af noise distribution
  real dprime; // afstand fra z til center af signal distribution
}

model {
  // priors
  z ~ normal(0, 1);
  dprime ~ normal(0, 1);
  
  // likelihood
  // bernoulli sætter implicit threshold til 0
  // i uge 1 satte vi noise distribution til centered på 0, 
  // men vi kan nemt regne frem og tilbage mellem de to  
  y ~ bernoulli(Phi(z + dprime * x)); // linear additiv model på den latente skala
}
