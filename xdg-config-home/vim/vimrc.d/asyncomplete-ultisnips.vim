if has('python3') && exists("*asyncomplete#regester_source")
  let g:UltiSnipsExpandTrigger="<c-e>"
  call asyncomplete#register_source(
      \ asyncomplete#sources#ultisnips#get_source_options({
          \ 'name': 'ultisnips',
          \ 'allowlist': ['*'],
          \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
      \ }))
endif
