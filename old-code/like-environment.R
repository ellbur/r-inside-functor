
env.fmap = new.env()
class(env.fmap) = 'env.fmap'

`[[.env.fmap` = function(env, name) {
	n = nchar(name)
	last = substr(name, n, n)
	
	if (last == '.') {
		first = substr(name, 1, n-1)
		if (exists(first, env$parent)) {
			fmap(get(first, env$parent))
		}
		else {
			NULL
		}	
	}
	else {
		NULL
	}
}

