function! config#coverCmd()
	return get(g:, "py_coverage_cmd", "coverage run -m unittest discover")
endfunction
