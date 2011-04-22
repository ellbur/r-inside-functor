
inside.functor = function(level, depth) {
    functor = list(
		level = level,
		depth = depth
	)
	class(functor) = 'inside.functor'
	functor
}

is.inside.functor = function(x) {
	'inside.functor' %in% class(x)
}

level = function(functor) {
	UseMethod('level')
}

level.inside.functor = function(functor) {
	functor$level
}

depth = function(...) {
	UseMethod('depth')
}

depth.default = function(...) {
	0
}

depth.inside.functor = function(functor) {
	functor$depth
}

apply = function(functor, func, args, caller) {
	UseMethod('apply')
}

collect = function(functor) {
	UseMethod('collect')
}

collect.inside.functor = function(functor) {
	if (!is.inside.functor(functor)) {
		functor
	}
	else {
		if (functor$depth == 1) {
			collect.end(functor)
		}
		else {
			apply(functor, collect, list(functor), do.call)
		}
	}
}

collect.end = function(functor) {
	UseMethod('collect.end')
}

apply.check.functor = function(func, args) {
	if (len(args) == 0) {
		return(func())
	}
	
	functor.levels = sapply(args, λ(x) %=% {
		if (is.inside.functor(x)) {
			level(x)
		}
		else 0
	})
	
	winner.i = which.max(functor.levels)
	winner.arg = args[[winner.i]]
	
	if (! is.inside.functor(winner.arg)) {
		return(do.call(func, args))
	}
	
	apply(winner.arg, func, args, apply.check.functor)
}

fmap = function(func) {
	params = formals(args(func))
	if (! is.null(params[['...']])) {
		new.func = function() {
			.args = append(as.list(environment()), list(...))
			apply.check.functor(func, .args)
		}
	}
	else {
		new.func = function() {
			.args = as.list(environment())
			apply.check.functor(func, .args)
		}
	}
	formals(new.func) = params
	new.func
}

each = function(
	items,
	axis  = seq_along(items),
	level = 1,
	depth = 1
)
{	
	functor = inside.functor(level, depth)
	functor$items = items
	functor$axis  = axis
	
	class(functor) = c('each', class(functor))
	
	functor
}

insert.each = function(inside, outside) {
	stop('inserting')
	each(items=xapply(inside$axis, outside), axis=inside$axis)
}

axis.each = function(inside) {
	inside$axis
}

apply.each = function(inside, func, args, caller) {
	our.level = level(inside)
	our.axis = axis.each(inside)
	
	args.boxed = args
	for (i in seq_along(args.boxed)) {
		arg = args.boxed[[i]]
		
		if (is.inside.functor(arg) && level(arg)>=our.level) {
			axis = axis.each(arg)
			if (!identical(axis, our.axis)) {
				stop('Axis mismatch: ', inside, ' and ', arg)
			}
		}
		else {
			echo(func)
			echo(names(args))
			args.boxed[[i]] = insert.each(inside, arg)
		}
	}
	
	items = list()
	max.depth = 0
	
	for (i in our.axis) {
		piece.args = lapply(args.boxed, λ(arg) %=% {
			arg$items[[i]]
		})
		res = caller(func, piece.args)
		max.depth = max(depth(res), max.depth)
		items[[i]] = res
	}
	
	each(items=items, axis=our.axis, depth=max.depth+1)
}

collect.end.each = function(inside) {
	inside$items
}

conservative.regroup = function(items) {
	one = F
	all.mode = ''
	ok = T
	res = lapply(items, function(x) {
		if (ok) {
			if (!is.atomic(x) || length(x) != 1) {
				ok <<- F
			}
			else {
				here.mode = mode(x)
				if (!one) {
					all.mode <<- here.mode
					one <<- T
				}
				else if (!identical(here.mode, all.mode)) {
					ok <<- F
				}
			}
		}
		x
	})
	if (ok && one) {
		mode(res) = all.mode
	}
	res
}


