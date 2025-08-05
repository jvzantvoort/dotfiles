augroup GOTEXTTMPL
	autocmd BufReadPre,FileReadPre *.gtmpl if &filetype == "" | setlocal ft=gotexttmpl | endif
augroup GOTEXTTMPL
