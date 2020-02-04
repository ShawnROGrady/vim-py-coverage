"" treat normal text as comment
hi def link pyCoverageNormalText Comment

function! s:hi()
	hi def      pyCoverageCovered    ctermfg=green guifg=#A6E22E
	hi def      pyCoverageUncover    ctermfg=red guifg=#F92672
endfunction
call s:hi()
