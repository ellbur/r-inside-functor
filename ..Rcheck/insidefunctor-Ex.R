pkgname <- "insidefunctor"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('insidefunctor')

assign(".oldSearch", search(), pos = 'CheckExEnv')
cleanEx()
nameEx("inside.functor")
### * inside.functor

flush(stderr()); flush(stdout())

### Name: inside.functor
### Title: Create the common attributes for an inside...
### Aliases: inside.functor

### ** Examples
# The `each' functor uses `inside.functor' like
make.each = function(
object,
items  = unpack(object, ...),
axis   = make.axis(object, ...),
level  = 1,
depth  = 1,
...
)
{
functor = inside.functor(level, depth)
functor$object    = object
functor$items     = items
functor$axis      = axis
functor$pack.opts = list(...)

class(functor) = c('each', class(functor))

functor
}


cleanEx()
nameEx("insidefunctor-package")
### * insidefunctor-package

flush(stderr()); flush(stdout())

### Name: insidefunctor-package
### Title: insidefunctor-package
### Aliases: insidefunctor-package

### ** Examples
x = c(1, 2, 3)
sin. = fmap(sin)
y = collect(sin.(each(x)))
print(y)

x = c(1, 2, 3)
lists = collect(fmap(replicate)(
each(x),
each(x)
))
print(lists)
lens = collect(fmap(length)(each(lists)))
print(lens)


cleanEx()
nameEx("make.axis")
### * make.axis

flush(stderr()); flush(stdout())

### Name: make.axis
### Title: Creates an axis to loop over.
### Aliases: make.axis

### ** Examples
# make.axis for lists is defined like
make.axis.list = function(object) {
seq_along(object)
}


cleanEx()
nameEx("pack")
### * pack

flush(stderr()); flush(stdout())

### Name: pack
### Title: Collects a sequence back into an object.
### Aliases: pack

### ** Examples
# pack for lists is defined like
pack.list = function(object, items) {
conservative.regroup(items)
}


cleanEx()
nameEx("unpack")
### * unpack

flush(stderr()); flush(stdout())

### Name: unpack
### Title: Extracts a sequence from an object.
### Aliases: unpack

### ** Examples
# The unpack method for lists is defined like
unpack.list = function(object, ...) {
object
}
# Because a list is already a sequence.


### * <FOOTER>
###
cat("Time elapsed: ", proc.time() - get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
