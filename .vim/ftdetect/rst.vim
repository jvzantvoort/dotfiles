if did_filetype()
	finish
endif

augroup RST
	autocmd BufRead,BufNewFile *.irst set filetype=rst
augroup END
