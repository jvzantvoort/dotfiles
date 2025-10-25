if did_filetype()
	finish
endif

augroup PLANTUML
	autocmd BufRead,BufNewFile * :if getline(1) =~ '^.*startuml.*$'|  setfiletype plantuml | endif
	autocmd BufRead,BufNewFile *.pu,*.uml,*.plantuml,*.tuml set filetype=plantuml
augroup END
