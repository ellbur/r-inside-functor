
to.all.vectors = function(name, method, env=parent.frame()) {
	`%+%` = function(a, b) {
		paste(a, b, sep='')
	}
	env[[name %+% '.list']]      = method
	env[[name %+% '.numeric']]   = method
	env[[name %+% '.logical']]   = method
	env[[name %+% '.character']] = method
}

unpack.list    = function(object) object
pack.list      = function(object, items) conservative.regroup(items)
make.axis.list = function(object) seq_along(object)

to.all.vectors('unpack',    unpack.list)
to.all.vectors('pack',      pack.list)
to.all.vectors('make.axis', make.axis.list)

