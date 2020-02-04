command! -bang -nargs=* PyCoverageClear call pyCoverage#Clear(<q-args>)
command! -bang -nargs=* PyCoverage call pyCoverage#Buffer(<q-args>)
