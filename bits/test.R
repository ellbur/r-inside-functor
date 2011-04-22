
source('each-list.R')

sin.       = fmap(sin)
replicate. = fmap(replicate)
sum.       = fmap(sum)
each.      = fmap(each)
length.    = fmap(length)
diff.      = fmap(diff)
cumsum.    = fmap(cumsum)
`%+.%`     = fmap(`+`)
`%-.%`     = fmap(`-`)

e = each.
v = collect

x = list(1, 2, 3)
y = v(replicate.(e(x), 2))
z = v(v(
	sin.(e(e(y)))
))
w = v(cumsum.(e(z)))

