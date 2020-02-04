"" Clear clears all coverage in the current buffer
function! pyCoverage#Clear(cmdArgs)
	call clearmatches()
endfunction


"" Buffer highlights coverage in the current buffer
function! pyCoverage#Buffer(cmdArgs)
	let pathToScript='/Users/Shawn/dev/src/github.com/ShawnROGrady/vim-py-coverage'
	let coverCmd='coverage run -m unittest discover'
	let curFile=@%
	let output=systemlist(coverCmd." && ".'coverage json -o -'." | python ".pathToScript."/main.py"." ".curFile)
	if v:shell_error
		" TODO: maybe report something?
		echo output
		return
	endif

	"" first mark everything as normal text
	let curLine = 1
	while curLine <= line('$')
		call matchaddpos('pyCoverageNormalText', [curLine])
		let curLine += 1
	endwhile

	for outLine in output
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
