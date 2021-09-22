if exists("g:loaded_textobj_keyvalue_pair") || &cp | finish | endif

let g:loaded_textobj_keyvalue_pair = 1

let g:textobj_keyvalue_pair_VERSION = '1.0.0'

call textobj#user#plugin('keyvalue', {
\   '_': {
\     '*sfile*': expand('<sfile>:p'),
\     'select-a-function': 's:selectKeyValA',
\     'select-a': 'ak',
\     'select-i-function': 's:selectKeyValI',
\     'select-i': 'ik',
\   }
\ })

function! s:selectKeyValA() abort
  let nobackup = 0
  let pos = getpos('.')
  normal! T,
  let head = getpos('.')
  if head == pos
    normal! T{
    let head = getpos('.')
    if head == pos
      if match(getline('.'), ':')
        normal! ^
        let head = getpos('.')
      else
        return 0
      endif
    else
      let nobackup = 1
    endif
  endif

  normal! f,
  let tail = getpos('.')
  if tail == head
    normal! t}
    let tail = getpos('.')
    if tail == head
      normal! $
      let tail = getpos('.')
    elseif nobackup == 0
      let head = [head[0], head[1], head[2] - 1, head[3]]
      let tail = [tail[0], tail[1], tail[2] - 1, tail[3]]
    endif
  endif

  call setpos('.', pos)
  return ['v', head, tail]
endfunction

function! s:selectKeyValI() abort
  let pos = getpos('.')
  normal! F,
  let head = getpos('.')
  if head == pos
    normal! T{
    let head = getpos('.')
    if head == pos
      if match(getline('.'), ':')
        normal! ^
        let head = getpos('.')
      else
        return 0
      endif
    else
      normal! w
      let head = getpos('.')
    endif
  else
    normal! w
    let head = getpos('.')
  endif

  normal! f,
  let tail = getpos('.')
  if tail == head
    normal! f}
    let tail = getpos('.')
    if tail == head
      if match(getline('.'), ':')
        normal! $
        let tail = getpos('.')
      endif
    else
      normal! b
      let tail = getpos('.')
    endif
  else
    normal! b
    let tail = getpos('.')
  endif

  call setpos('.', pos)
  return ['v', head, tail]
endfunction
