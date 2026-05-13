data {
  int<lower=2> I;                 // number of items
  int<lower=1> A;                 // number of aspects
  int<lower=1> P;                 // number of unordered pairs

  array[P] int<lower=1, upper=I> item1;
  array[P] int<lower=1, upper=I> item2;
  array[P] int<lower=0> y;        // item1 chosen over item2
  array[P] int<lower=0> n;        // total comparisons

  array[I, A] int<lower=0, upper=1> X;
}

parameters {
  vector[A] alpha_raw;
}

transformed parameters { 
  vector[A] alpha;
  vector<lower=0>[A] theta;
  vector[P] pair_z;

  // sum-to-zero identification
  alpha = alpha_raw - mean(alpha_raw);
  theta = exp(alpha);

  for (p in 1:P) {
    int i = item1[p];
    int j = item2[p];

    real wi = 0;
    real wj = 0;

    for (a in 1:A) {
      if (X[i, a] == 1 && X[j, a] == 0) {
        wi += theta[a];
      }

      if (X[j, a] == 1 && X[i, a] == 0) {
        wj += theta[a];
      }
    }

    pair_z[p] = log(wi) - log(wj); 
    // note: it is a bit more inefficient to put the loop and pair_z here 
    // in transformed params: it could also be moved to the model 
    // block, where it would not be saved in the output. 
    // but its fine for the small example here :)
  }
}

model {
  alpha_raw ~ normal(0, 1);

  for (p in 1:P) {
    y[p] ~ binomial(n[p], Phi(pair_z[p]));
    // y[p] ~ binomial(n[p], inv_logit(pair_z[p])); // use this for original formulation
    // y[p] ~ binomial_logit(n[p], pair_z[p]); even more efficient for inv_logit
  }
}
