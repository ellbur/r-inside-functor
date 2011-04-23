
. = NA
class(.) = 'magic'

`[<-.magic` = function(., name, value) {
	name = substitute(name)
	parent = parent.frame()
	do.call(`<-`, list(name, collect.all(value)), envir=parent)
	.
}

