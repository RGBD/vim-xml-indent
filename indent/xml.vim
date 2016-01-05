if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

let s:keepcpo= &cpo
set cpo&vim

setlocal indentexpr=GetXmlIndent(v:lnum)
setlocal indentkeys=o,O,*<Return>,<>>,<<>,/,{,}

if !exists('b:xml_indent_tag_begin_open')
  let b:xml_indent_tag_begin_open = '.\{-}<\a'
endif

if !exists('b:xml_indent_tag_end_open')
  let b:xml_indent_tag_end_open = '.\{-}<\/\a'
endif

if !exists('b:xml_indent_tag_self_close')
  let b:xml_indent_tag_self_close = '.\{-}/>'
endif

if !exists('b:xml_indent_tag_close')
  let b:xml_indent_tag_close = '.\{-}[^/%]>'
endif

let &cpo = s:keepcpo
unlet s:keepcpo

" [-- finish, if the function already exists --]
if exists('*GetXmlIndent')
  finish
endif

let s:keepcpo= &cpo
set cpo&vim

fun! <SID>XmlIndentWithPattern(line, pat)
  let s = substitute('x'.a:line, a:pat, "\1", 'g')
  return strlen(substitute(s, "[^\1].*$", '', ''))
endfun

" [-- check if it's xml --]
fun! <SID>XmlIndentSynCheck(lnum)
  if '' != &syntax
    let syn1 = synIDattr(synID(a:lnum, 1, 1), 'name')
    let syn2 = synIDattr(synID(a:lnum, strlen(getline(a:lnum)) - 1, 1), 'name')
    if '' != syn1 && syn1 !~ 'xml' && '' != syn2 && syn2 !~ 'xml'
      " don't indent pure non-xml code
      return 0
    elseif syn1 =~ '^xmlComment' && syn2 =~ '^xmlComment'
      " indent comments specially
      return -1
    endif
  endif
  return 1
endfun

if exists('*shiftwidth')
  let s:shiftwidth = function('shiftwidth')
else
  function s:shiftwidth()
    return &shiftwidth
  endfunction
endif

" [-- return the sum of indents of a:lnum --]
fun! <SID>XmlIndentSum(lnum, style, add)
  let line = getline(a:lnum)
  if a:style == match(line, '^\s*</')
    return (s:shiftwidth() *
          \  (<SID>XmlIndentWithPattern(line, b:xml_indent_tag_begin_open) * 2
          \ - <SID>XmlIndentWithPattern(line, b:xml_indent_tag_close) * 1
          \ - <SID>XmlIndentWithPattern(line, b:xml_indent_tag_self_close) * 2
          \ )) + a:add
  else
    return a:add
  endif
endfun

fun! GetXmlIndent(lnum)
  " Find a non-empty line above the current line.
  let lnum = prevnonblank(a:lnum - 1)

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  let check_lnum = <SID>XmlIndentSynCheck(lnum)
  let check_alnum = <SID>XmlIndentSynCheck(a:lnum)
  if 0 == check_lnum || 0 == check_alnum
    return indent(a:lnum)
  elseif -1 == check_lnum || -1 == check_alnum
    return -1
  endif

  let ind = <SID>XmlIndentSum(lnum, -1, indent(lnum))
  let ind = <SID>XmlIndentSum(a:lnum, 0, ind)

  return ind
endfun

let &cpo = s:keepcpo
unlet s:keepcpo
