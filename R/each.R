
#' Creates an "inside" functor that iterates over elements in a sequence.

#' @param object The sequence to iterate over. See below.
#' @param level  The precedence level of the functor.
#' @param ...    Extra arguments to control unpacking and packing

#' @return An inside.functor that will iterate over elements in the sequence.

#' @note
#' \code{object} should support methods \code{unpack}, \code{pack} and
#' \code{make.axis}.  These methods are provided for list, numeric, logical,
#' character, integer, and may be defined for other types of object.

#' @seealso
#' \code{\link{collect}}
#' \code{\link{fmap}}
#' \code{\link{unpack}}
#' \code{\link{pack}}
#' \code{\link{make.axis}}
each = function(object, level=2, ...) {
	make.each(object, level=level, ...)
}

#' Extracts a sequence from an object.

#' @param object The object from which to extract a sequence.
#' @param ...    Extra arguments used by methods.

#' @seealso
#' \code{\link{each}}, which is where \code{unpack} is used,
#' \code{\link{pack}}, for the inverse operation,
#' \code{\link{make.axis}}

#' @examples
#' # The unpack method for lists is defined like
#' unpack.list = function(object, ...) {
#'     object
#' }
#' # Because a list is already a sequence.
unpack = function(object, ...) {
	UseMethod('unpack')
}

#' Collects a sequence back into an object.

#' @param object Either the object from which the sequence was
#'  extracted, or one of similar shape.
#' @param items The sequence to be recollected.
#' @param ... Extra arguments for methods.

#' @return Something resembling \code{object}, but with the elements replaced
#' by \code{items}.

#' @seealso
#' \code{\link{each}}, which is where \code{pack} is used,
#' \code{\link{unpack}}, for the inverse operation,
#' \code{\link{make.axis}}

#' @examples
#' # pack for lists is defined like
#' pack.list = function(object, items) {
#'     conservative.regroup(items)
#' }
pack = function(object, items, ...) {
	UseMethod('pack')
}

#' Creates an axis to loop over.

#' @param object The object to create an axis for.
#' @param ...    Extra objects used by methods.

#' @return A sequence. It should be something you can loop over
#' with for (... in ...).

#' @note If two axises compare equal with identical(), then they are assumed to
#' represent the \emph{same} real dimension, whatever that is. If you want to
#' make an axis more unique, you can add attributes to it.

#' @examples
#' # make.axis for lists is defined like
#' make.axis.list = function(object) {
#'     seq_along(object)
#' }
make.axis = function(object, ...) {
	UseMethod('make.axis')
}

make.each = function(
	object,
	items  = unpack(object, ...),
	axis   = make.axis(object, ...),
	level  = 2,
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

insert.each = function(inside, outside) {
	make.each(
		object = inside$object,
		items  = lapply(inside$axis, function(.) outside),
		axis   = inside$axis
	)
}

corresponds = function(arg, inside) {
    UseMethod('corresponds')
}

corresponds.default = function(arg, inside) {
    F
}

alignable = function(arg, inside) {
    UseMethod('alignable')
}

corresponding = function(arg, inside, i) {
    UseMethod('corresponding')
}

corresponding.each = function(arg, inside, i) {
    part = arg$items[[i]]
    arg$items[[i]]
}

correspondence = function(object, ref, level=1, depth=1) {
    cor = make.each(
        object,
        level  = level,
        depth  = depth,
    )
    cor$ref    = ref
    
    class(cor) = c('correspondence', class(cor))
    cor
}

pond = function(object, ref=NULL) {
    correspondence(object, ref)
}

`%for%` = function(object, ref) {
    correspondence(object, ref)
}

corresponds.correspondence = function(arg, inside) {
    if (is.null(arg$ref)) {
        T
    }
    else {
        identical(arg$axis, inside$axis)
    }
} 

alignable.correspondence = function(arg, inside) {
    identical(arg$axis, inside$axis)
}

apply.functor.each = function(inside, func, args, index, caller) {
	our.level  = level(inside)
	our.axis   = inside$axis
	our.object = inside$object
    
	args.boxed = args
	for (i in seq_along(args.boxed)) {
		arg = args.boxed[[i]]
		
        if (i == index) {
            args.boxed[[i]] = arg
        }
        else if (corresponds(arg, inside)) {
			if (!alignable(arg, inside)) {
				stop('Axis mismatch: ', inside, ' and ', arg)
			}
		}
		else {
			args.boxed[[i]] = insert.each(inside, arg)
		}
	}
    
	items = list()
	max.depth = 0
	
	for (i in our.axis) {
		piece.args = lapply(args.boxed, function (arg) {
			corresponding(arg, inside, i)
		})
		res = caller(func, piece.args)
		max.depth = max(depth(res), max.depth)
		items[[i]] = res
	}
	
	make.each(
		object = our.object,
		items  = items,
		axis   = our.axis,
        level  = our.level,
		depth  = max.depth+1
	)
}

collect.end.each = function(inside) {
    extra.call(pack, inside$pack.opts, inside$object, inside$items)
}

extra.call = function(func, args, ...) {
    do.call(func, append(list(...), args))
}

