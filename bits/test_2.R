
to.all.vectors = λ(name, method, env=parent.frame()) %=% {
	env[[name %+% '.list']]      = method
	env[[name %+% '.numeric']]   = method
	env[[name %+% '.logical']]   = method
	env[[name %+% '.character']] = method
	env[[name %+% '.numeric']]   = method
}

foo = λ(..) %=% {
	UseMethod('foo')
}

foo.list = λ(x) %=% {
	length(x)
}
to.all.vectors('foo', foo.list)

