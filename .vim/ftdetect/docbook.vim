augroup DOCBOOK
	autocmd BufReadPre,FileReadPre *.book if &filetype == "" | setlocal ft=docbk | endif
	autocmd BufReadPre,FileReadPre *.dbk if &filetype == "" | setlocal ft=docbk | endif
	autocmd BufReadPre,FileReadPre *.article if &filetype == "" | setlocal ft=docbk | endif
augroup END
