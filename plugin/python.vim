let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:py_coverage_py_cmd = ''

if has("python3")
	let g:py_coverage_py_cmd="python3"
elseif has("python")
	let g:py_coverage_py_cmd="python"
else
	finish
endif


if exists('g:py_coverage_loaded')
	finish
endif

"" TODO: there has to be a better way to do this
if g:py_coverage_py_cmd == "python3"
python3 << EOF
import sys
from os.path import normpath, join
import vim
plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '..', 'python'))
sys.path.insert(0, python_root_dir)
import plugin
EOF
elseif g:py_coverage_py_cmd == "python"
python << EOF
import sys
from os.path import normpath, join
import vim
plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '..', 'python'))
sys.path.insert(0, python_root_dir)
import plugin
EOF
endif


let g:py_coverage_loaded=1
