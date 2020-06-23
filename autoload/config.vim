function! config#testRunner()
	return get(g:, "py_coverage_runner", "unittest")
endfunction
