
library(insidefunctor)

rv = reeval
.[y] = e(x,l=2) %+.% rv(runif(1))
.[z] = e(x) %+.% e(rv(runif(1)) %along% x)
 
