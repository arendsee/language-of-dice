" Vim syntax file
" Language: Language of Dice (lod)
" Maintainer: Zebulun Arendsee
" Latest Revision: 25 September 2015
" -----------------------------------------------------------------------------
" INSTALLATION
" Run the following in your UNIX terminal
" $ mkdir -p ~/.vim/syntax/
" $ mkdir -p ~/.vim/ftdetect/
" $ cp lod.vim ~/.vim/syntax/
" $ echo 'au BufRead,BufNewFile *.lod set filetype=lod' > ~/.vim/ftdetect/lod.vim

if exists("b:current_syntax")
  finish
endif

" define keywords
syn keyword statement min max sum yield while done if else elif

" define constants
syn match constant '\d\+'
syn match constant '\d\+d\d\+'
syn region constant start="'" end="'"
syn region constant start='"' end='"'

" define TODO
syn keyword tag contained TODO NOTE

" define comments
syn match comment '\/\/.*$' contains=tag
syn region comment start='\/\*' end='\*\/' contains=tag


let b:current_syntax = "lod"
hi def link statement     Statement
hi def link constant      Constant
hi def link comment       Comment
hi def link todo          Todo
