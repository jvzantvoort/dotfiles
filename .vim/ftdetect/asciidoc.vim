augroup ASCIIDOC
	autocmd BufReadPre,FileReadPre *.asd if &filetype == "" | setlocal ft=asciidoc | endif
	autocmd BufReadPre,FileReadPre *.adoc if &filetype == "" | setlocal ft=asciidoc | endif
	autocmd BufReadPre,FileReadPre *.asciidoc if &filetype == "" | setlocal ft=asciidoc | endif
augroup END
