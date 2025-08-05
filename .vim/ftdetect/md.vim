augroup MARKDOWN
	autocmd BufReadPre,FileReadPre *.md if &filetype == "" | setlocal ft=markdown | endif
augroup END
