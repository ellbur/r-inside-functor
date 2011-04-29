
library(insidefunctor)

x = c(1, 2, 3)
y = c(4, 5, 6)

`%+.%` = fmap(`+`)
`%/.%` = fmap(`/`)

.[z] = each(x) %+.% each(y)
z

.[w] = each(x) %+.% (y %for% x)
w

`%near%` = function(y, x) {
    UseMethod('%near%')
}

looktable = function(dep, ind) {
    reorder = order(ind)
    dep = dep[reorder]
    ind = ind[reorder]
    
    attr(dep, 'indvar') = ind
    class(dep) = c('looktable', class(dep))
    
    dep
}

`%near%.looktable` = function(y, x) {
    approx(attr(y, 'indvar'), y, x)$y %for% x
}

.[u] = each(1:5) %+.% reeval(runif(1))
u
v = looktable(
    (0:6)**2,
    0:6
)
v

.[w] = v %near% u
w

.[z] = (v %near% u) %/.% each(u)
z

