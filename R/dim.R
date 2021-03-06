
as.dim = function(seq, id=dim.id) {
    res = seq
    attr(res, 'id') = id
	class(res) = 'dim'
	
	dim.id <<- dim.id + 1
	
	res
}

align = function(dim.seq, dim.axis) {
    n1 = length(seq.dim(dim.seq))
    n2 = length(seq.dim(dim.axis))
    
	if (n1 != n2) {
		stop('Cannot align dims: sequence lengths differ')
	}
    
	id.dim(dim.seq) = id.dim(dim.axis)
	dim.seq
}

along = function(x, dim.axis) {
    as.dim(lapply(dim.axis, function(.) x), id.dim(dim.axis))
}

`%along%` = along

fold.to.null = function(x) {
    if (length(x) == 0) NULL
    else x
}

`[.dim` = function(dim, x, ...) {
    if (missing(x)) {
        fmap(each)(dim)
    }
    else {
        class(dim) = fold.to.null(setdiff(class(dim), 'dim'))
        rest = append(list(dim, x), list(...))
        do.call(`[`, rest)
    }
}

`[.each` = function(functor, ...) {
    fmap(each)(functor)
}

dim.id = 1

id.dim = function(dim) {
    attr(dim, 'id')
}

`id.dim<-` = function(dim, id) {
    attr(dim, 'id') = id
    dim
}

seq.dim = function(dim) {
    dim
}

print.dim = function(dim) {
	attributes(dim) = c()
    print(dim)
}

unpack.dim = function(dim) {
	dim
}

pack.dim = function(dim, items) {
	as.dim(conservative.regroup(items), id.dim(dim))
}

make.axis.dim = function(dim) {
	seq = seq_along(dim)
	attr(seq, 'id') = id.dim(dim)
	seq
}

