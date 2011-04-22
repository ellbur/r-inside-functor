
conservative.regroup = function(items) {
	one = FALSE
	all.mode = ''
	ok = TRUE
	res = lapply(items, function(x) {
		if (ok) {
			if (!is.atomic(x) || length(x) != 1) {
				ok <<- FALSE
			}
			else {
				here.mode = mode(x)
				if (!one) {
					all.mode <<- here.mode
					one <<- TRUE
				}
				else if (!identical(here.mode, all.mode)) {
					ok <<- FALSE
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

