
reeval = function(exp, level=1) {
    exp = substitute(exp)
    callback = function() {
        eval(exp)
    }
    make.reeval(callback, level=level)
}

make.reeval = function(
    callback,
    level = 1,
    depth = 1
)
{
    functor = inside.functor(level, depth)
    functor$callback = callback
    
    class(functor) = c('reeval', class(functor))
    
    functor
}

insert.reeval = function(
    inside,
    outside
)
{
    force(outside)
    make.reeval(
        function() outside
    )
}

apply.functor.reeval = function(
    inside,
    func,
    args,
    caller
)
{
    our.level = level(inside)
    
	args.boxed = args
	for (i in seq_along(args.boxed)) {
		arg = args.boxed[[i]]
		
		if (is.inside.functor(arg) && level(arg)>=our.level) {
		}
		else {
			args.boxed[[i]] = insert.reeval(inside, arg)
		}
	} 
    max.depth = max(sapply(args.boxed, depth))
    
    callback = function() {
		piece.args = lapply(args.boxed, function (arg) {
			arg$callback()
		})
		caller(func, piece.args)
    }
    
    make.reeval(
        callback,
        level = our.level,
        depth = max.depth
    )
}

collect.end.reeval = function(inside) {
    inside$callback()
}

