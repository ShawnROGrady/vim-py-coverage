"" Clear clears all coverage in the current buffer
function! pyCoverage#Clear(cmdArgs)
	call clearmatches()
endfunction

"" Buffer highlights coverage in the current buffer
function! pyCoverage#Buffer(cmdArgs)
	if g:py_coverage_py_cmd == ''
		call pyCoverage#shell(a:cmdArgs)
	else
		call pyCoverage#python(a:cmdArgs)
	endif
endfunction

let s:autoload_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

function! pyCoverage#shell(cmdArgs)
	let pathToScript= s:autoload_root_dir.'/../python/main.py'
	let curFile=@%
	let output=systemlist(config#coverCmd()." && ".'coverage json -o -'." | python ".pathToScript." ".curFile)
	if v:shell_error
		" TODO: maybe report something?
		echo output
		return 1
	endif

	call pyCoverage#overlay(output)
endfunction

function! pyCoverage#python(cmdArgs)
	let coverCmd=config#coverCmd().' > /dev/null 2>&1' " TODO: I'm assuming this won't work across platforms
	let curFile=@%
	let coverOut=system(coverCmd." && ".'coverage json -o -')
	"" TODO: there has to be a better way to do this
	if g:py_coverage_py_cmd == 'python3'
		python3 plugin.parse_and_assign("l:coverOut", "l:curFile", "l:output")
	elseif g:py_coverage_py_cmd == 'python'
		python plugin.parse_and_assign("l:coverOut", "l:curFile", "l:output")
	else
		echo "unkown cmd: ".g:py_coverage_py_cmd
		return 1
	endif
	call pyCoverage#overlay(output)
endfunction

function! pyCoverage#overlay(output)
	"" first mark everything as normal text
	let curLine = 1
	while curLine <= line('$')
		call matchaddpos('pyCoverageNormalText', [curLine])
		let curLine += 1
	endwhile

	for outLine in a:output
		let pos = split(outLine, ':')
		if len(pos) != 2
			continue
		endif
		let colLen = strwidth(getline(pos[0]))
		if pos[1] == 'executed'
			call matchaddpos('pyCoverageCovered', [[str2nr(pos[0])]])
			call matchaddpos('pyCoverageCovered', [[str2nr(pos[0]), colLen]])
		elseif pos[1] == 'missing'
			call matchaddpos('pyCoverageUncover', [[str2nr(pos[0])]])
			call matchaddpos('pyCoverageUncover', [[str2nr(pos[0]), colLen]])
		endif
	endfor
endfunction
