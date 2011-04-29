
#' Create the common attributes for an inside.functor.
#'
#' "Precedence" is used to resolve conflicts when multiple
#' functors are specified in a single call. The functor with the
#' highest precedence number gets to decide how to handle the
#' call.
#'
#' "Nestedness" makes sense for functors that "contain" something
#' in them, e.g. \code{\link{each}}. It is 0 for something that is
#' not a functor, 1 for a functor containing something that is not
#' a functor, etc.
#'
#' Specific functors will typically take the returned list and
#' add elements to it, and augment the class().
#'
#' A specific functor should implement
#' \tabular{l}{
#' \code{\link{apply.functor}}
#' \code{\link{collect.end}}
#' }

#' @param level The precedence of the functor. See below.
#' @param depth The nestedness of the functor. See below.

#' @return A list with the components
#' \tabular{ll}{
#' \code{level} \tab The precedence of the functor. \cr
#' \code{depth} \tab The nestedness of the functor. \cr
#' }

#' @seealso
#' \code{\link{each}} for an example of a functor,
#' \code{\link{fmap}} for functorizing functions.

#' @examples

#' # The `each' functor uses `inside.functor' like
#' make.each = function(
#'     object,
#'     items  = unpack(object, ...),
#'     axis   = make.axis(object, ...),
#'     level  = 1,
#'     depth  = 1,
#'     ...
#' )
#' {
#'     functor = inside.functor(level, depth)
#'     functor$object    = object
#'     functor$items     = items
#'     functor$axis      = axis
#'     functor$pack.opts = list(...)
#'     
#'     class(functor) = c('each', class(functor))
#'     
#'     functor
#' }
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

#' Apply a function to its arguments, taking into account
#' the behavior of the inside.functor.
#'
#' Specific functors will implement methods for this function.

#' @param functior The functor that will alter the behavior of the function
#' @param func     The function to apply.
#' @param args     The arguments to the function.
#' @param caller   Either \code{do.call} or \code{apply.check.functor}

#' @return The result of applying \code{func} to \code{args} under the
#' influence of the functor. The result should still have the functor
#' applied to it.

#' @seealso \code{\link{apply.functor.each}} for an example definition,
#' and \code{\link{apply.check.functor}} for the function using this
#' function.
apply.functor = function(functor, func, args, index, caller) {
	UseMethod('apply.functor')
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
			apply.functor(functor, collect, list(functor), 1, do.call)
		}
	}
}

collect.all = function(functor) {
    if (!is.inside.functor(functor)) {
        functor
    }
    else {
        collect.all(collect(functor))
    }
}

collect.end = function(functor) {
	UseMethod('collect.end')
}

collect.end.default = function(functor) {
    functor
}

apply.check.functor = function(func, args) {
	if (length(args) == 0) {
		return(func())
	}
	
	functor.levels = lapply(args, function(x) {
		if (is.inside.functor(x)) {
			level(x)
		}
		else {
			0
		}
	})
	
	winner.i = which.max(functor.levels)
	winner.arg = args[[winner.i]]
	
	if (! is.inside.functor(winner.arg)) {
		return(do.call(func, args))
	}
	
	apply.functor(winner.arg, func, args, winner.i, apply.check.functor)
}

list.elim.missing = function(env) {
	res = list()
	env = as.list(env, all.names=TRUE)
	env.names = names(env)
	
	for (i in seq_along(env)) {
		name = env.names[[i]]
		if (!identical(env[[i]], alist(x=)$x) && !identical(name, '...')) {
			res[[name]] = env[[i]]
		}
	}
	
	res
}

fmap = function(func) {
	params = formals(args(func))
	if (! is.null(params[['...']])) {
		new.func = function() {
			.args = append(list.elim.missing(environment()), list(...))
			apply.check.functor(func, .args)
		}
	}
	else {
		new.func = function() {
			.args = list.elim.missing(environment())
			apply.check.functor(func, .args)
		}
	}
	params = lapply(params, function(.) alist(x=)$x)
	formals(new.func) = params
	new.func
}

