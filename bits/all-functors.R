
env.fmap = NULL

do.all.functors = function(base.env) {
	env.fmap = new.env()
	
	fill.all = function(env) {
		if (is.null(env)) {
		}
		else if (identical(env, emptyenv())) {
		}
		else {
			names = ls(env)
			for (name in names) {
				fill(env, name)
			}
			fill.all(parent.env(env))
		}
	}
	
	fill = function(env, name) {
		val = env[[name]]
		
		if (is.function(val)) {
			name.plus = name %+% '.'
			delayedAssign(name.plus, fmap(val), as=env.fmap)
		}
	}
	
	fill.all(base.env)
}

do.all.functors(.GlobalEnv)

