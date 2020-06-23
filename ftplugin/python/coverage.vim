command! -bang -nargs=* PyCoverageClear call pyCoverage#Clear(<q-args>)
command! -bang -nargs=* -complet=file PyCoverage call pyCoverage#Buffer(<q-args>)
