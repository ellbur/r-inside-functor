
eval.with.checks = function(exp) {
	if (! (is.expression(exp) || is.language(exp))) {
		eval(exp)
	}
	else if (is.symbol(exp)) {
		eval(exp)
	}
	else {
		if (length(exp) == 1) {
			eval.with.checks(exp[[1L]])
		}
		else {
			elem.trans = list()
			
			for (i in seq_along(exp)) {
				elem.trans[[i]] = eval.with.checks(exp[[i]])
			}
			
			do.call(apply.check.functor, elem.trans)
		}
	}
}

map = function(exp) {
	exp = substitute(exp)
	collect(eval.with.checks(exp))
}

