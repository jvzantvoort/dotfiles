if exists('b:did_ftplugin')
	finish
endif


let b:did_ftplugin = 1

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

set rtp+=$GOPATH/src/golang.org/x/lint/misc/vim

augroup LspGo
	au!
	autocmd User lsp_setup call lsp#register_server({
				\ 'name': 'go-lang',
				\ 'cmd': {server_info->['gopls']},
				\ 'whitelist': ['go'],
				\ })
	autocmd FileType go setlocal omnifunc=lsp#complete
augroup END
