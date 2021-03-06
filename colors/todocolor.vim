" Vim color file
" Maintainer:	Thorsten Maerz <info@netztorte.de>
" Last Change:	2006 Dec 07
" grey on black
" optimized for TFT panels

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
"colorscheme default
let g:colors_name = "todocolor"

" hardcoded colors :
" GUI Comment : #80a0ff = Light blue

" GUI
highlight Normal     guifg=Grey80	guibg=Black
highlight Search     guifg=Black	guibg=Red	gui=bold
highlight Visual     guifg=#404040			gui=bold
highlight Cursor     guifg=Black	guibg=Green	gui=bold
highlight Special    guifg=Orange
highlight Comment    guifg=#80a0ff
highlight StatusLine guifg=blue		guibg=white
highlight Statement  guifg=Yellow			gui=NONE
highlight Type						gui=NONE


" Console
highlight Normal     ctermfg=LightGrey	ctermbg=Black
highlight Search     ctermfg=Black	ctermbg=Red	cterm=NONE
highlight Visual					cterm=reverse
highlight Cursor     ctermfg=Black	ctermbg=Green	cterm=bold
highlight Special    ctermfg=Brown
highlight Comment    ctermfg=Blue
highlight StatusLine ctermfg=blue	ctermbg=white
highlight Statement  ctermfg=Yellow			cterm=NONE
highlight Type						cterm=NONE

syn match DashLine /---\+/
highlight DashLine guifg=Brown ctermfg=Brown

syn match NumberDot /\W\+\d\+\.\s\|^\d\+\.\s/
highlight NumberDot guifg=Red ctermfg=Red 


syn match DoubleDashLine /===\+/
highlight DoubleDashLine guifg=Green ctermfg=Green

syn match AceBug   /ACE-\d\+\c/
highlight ACEBug   guifg=Yellow ctermfg=Yellow

syn match MyTodo   /todo\c/
highlight MyTodo    guifg=Yellow ctermfg=Yellow

syn match FileName /\w\+\.\w\{2,4}\s\+\c/
highlight FileName  guifg=Cyan    ctermfg=Cyan 

syn match MyDate /\d\{1,2}\/\d\{2}\/\d\{4}/
highlight MyDate    guifg=Magenta ctermfg=Magenta

syn match MyString /\".*\"/
highlight MyString guifg=LightRed ctermfg=LightRed

syn match MyRightBracket /([^)]*)/
highlight MyRightBracket guifg=LightRed ctermfg=LightRed

syn match MyItem /Item:\c/
highlight MyItem guifg=#E8780C 

syn match MyDate /Date:\c/
highlight MyDate guifg=#52E90F 

syn match MyBranch /Branch:\c/
highlight MyBranch guifg=#F53986 

syn match MyTitle /Title:\c/
highlight MyTitle guifg=#FAAA2F

syn match MyDone /Done:\c/
highlight MyDone guifg=Magenta

syn match MyLetter /\s[A-Z]\./
highlight MyLetter guifg=#FAAA2F


