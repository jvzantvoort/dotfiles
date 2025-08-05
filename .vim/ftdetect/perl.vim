augroup PERL
	autocmd BufReadPre,FileReadPre *.pl if &filetype == "" | setlocal ft=perl | endif
	autocmd BufReadPre,FileReadPre *.pm if &filetype == "" | setlocal ft=perl | endif
augroup END
