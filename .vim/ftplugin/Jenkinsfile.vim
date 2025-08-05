if exists('b:did_ftplugin')
	finish
endif


let b:did_ftplugin = 1

augroup JENKINSFILE
	autocmd BufWritePost Jenkinsfile !jenkins_file_linter %
augroup END
