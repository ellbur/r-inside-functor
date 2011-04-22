
#' @name insidefunctor-package
#' @docType package
#'
#' Functors that are applied based on the arguments
#' of a function, rather than applied to the function
#' itself.
#'
#' @seealso
#' \code{\link{each}}
#' \code{\link{collect}}
#' \code{\link{fmap}}
#'
#' @examples
#'
#' x = c(1, 2, 3)
#' sin. = fmap(sin)
#' y = collect(sin.(each(x)))
#' print(y)
#' 
#' x = c(1, 2, 3)
#' lists = collect(fmap(replicate)(
#' 	each(x),
#' 	each(x)
#' ))
#' print(lists)
#' lens = collect(fmap(length)(each(lists)))
#' print(lens)
#'
NA

