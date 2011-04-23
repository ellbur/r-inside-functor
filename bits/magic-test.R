
library(insidefunctor)

x = as.dim(c(1, 2, 3, 4, 5, 6))

e = fmap(each)
v = collect

sin.       = fmap(sin)
replicate. = fmap(replicate)
sum.       = fmap(sum)
`%+.%`     = fmap(`+`)

.[y] = replicate.(x[], 1)
.[z] = sin.(y[][])
.[w] = sum.(v(
    sin.(y[][])
))
.[u] = x[] %+.% x[]
 

