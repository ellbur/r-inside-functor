
env.fmap = new.env(hash=T)
(function(base.env) {
	fill.all = function(env) {
		if (is.null(env)) {
		}
		else if (identical(env, emptyenv())) {
		}
		else {
			names = ls(env)
			for (name in names) {
				val = env[[name]]
				if (is.function(val)) {
					# Why does this behave like I _am_ protecting `name` and I'm
					# _not_ protecting `val`?
					(function(val) {
						delayedAssign(name %+% '.', fmap(val), as=env.fmap)
					})(val)
				}
			}
			fill.all(parent.env(env))
		}
	}
	fill.all(base.env)
})(environment())

