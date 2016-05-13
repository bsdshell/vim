syntax enable
hi search         ctermbg=Gray ctermfg=Brown
highlight Cursor  ctermfg=green guifg=green guibg=white
highlight iCursor ctermfg=green guifg=green guibg=white
hi User1          ctermbg=white ctermfg=brown   guibg=white guifg=brown
hi User2          ctermbg=LightGray ctermfg=Magenta guibg=LightGray guifg=Magenta
hi User3          ctermbg=blue  ctermfg=green guibg=blue  guifg=green
hi User4          ctermbg=brown  ctermfg=white guibg=white  guifg=black
hi User5          ctermbg=DarkGray  ctermfg=green guibg=#FFFFFE  guifg=brown
hi User6          ctermbg=gray ctermfg=blue guibg=gray guifg=blue

"=====================================================================
cd %:p:h
set laststatus=2
set statusline=%F
set statusline+=\[%-2.5n]
set statusline+=\ %l:%c\ %r\ %m
set hls
set autoindent
set smartindent
set nocp
set ruler
set tabstop=4
set shiftwidth=4
set expandtab
set showcmd
set nobackup
set nowritebackup
set noswapfile
set autochdir
set backspace=2
set dictionary=/home/user/.vim/myword/myword.txt
 
"=====================================================================
" objc header file
autocmd BufRead *.h,*.m,*.mm set complete+=k/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/Foundation.framework/Headers/*
autocmd BufRead *.h,*.m,*.mm set complete+=k/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks/Foundation.framework/Headers/*
autocmd BufRead *.h,*.m,*.mm set complete+=k/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk/System/Library/Frameworks/Foundation.framework/Headers/*
autocmd BufRead *.h,*.m,*.mm set complete+=k/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/System/Library/Frameworks/Foundation.framework/Versions/C/Headers/*
autocmd BufRead *.h,*.m,*.mm set complete+=k/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk/System/Library/Frameworks/Foundation.framework/Versions/C/Headers/*
autocmd BufRead *.h,*.m,*.mm set complete+=k/Users/cat/myfile/github/*
autocmd BufRead *.tex,*.html set complete+=k/Users/cat/myfile/github/math/*

:set notimeout          " don't timeout on mappings
:set ttimeout           " do timeout on terminal key codes
:set timeoutlen=100     " timeout after 100 msec
:set autoread

" compare current buffer file and file modified outside
"command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
"	 	\ | diffthis | wincmd p | diffthis

set t_Co=256
set background=light
"----------------------------------------------
" https://gist.github.com/yasith/1508312
"fix the solarized scheme issue in Terminal
if !has('gui_running')
  let g:solarized_termcolors=&t_Co
  let g:solarized_termtrans=1
endif
"----------------------------------------------
colorscheme default
"colorscheme solarized
"colorscheme haskellcolor
"=====================================================================
map <Left>       :nohlsearch <CR>
imap <Left><Esc> :nohlsearch <CR>
map <F7>         :vertical   res +5 <CR>
map <F8>         :vertical   res -5 <CR>
map <F2>         :tabp       <CR>
map <F3>         :tabn       <CR>
map <F4>         :tabnew     <CR>
imap <F2><Esc>   :tabp       <CR>
imap <F3><Esc>   :tabn       <CR>
imap <F4><Esc>   :tabnew     <CR>
map <F5>         :call       MaximizeToggle() <CR>
map <S-F10>      :call       ToggleColorScheme() <CR>
nnoremap <F6>    :call ToggleBracketGroup()<CR>
map <F1>         :tabnew /Library/WebServer/Documents/tiny3/noteindex.txt <CR>

"inoremap <F6> <C-R>=ListMonths()<CR>
func! ListMonths()
  call complete(col('.'), ['January', 'February', 'March',
    \ 'April', 'May', 'June', 'July', 'August', 'September',
    \ 'October', 'November', 'December'])
  return ''
endfunc

" inoremap <F6> <C-R>=CompleteMonths()<CR>

fun! CompleteMonths(findstart, base)
	  if a:findstart
	    " locate the start of the word
	    let line = getline('.')
	    let start = col('.') - 1
	    while start > 0 && line[start - 1] =~ '\a'
	      let start -= 1
	    endwhile
	    return start
	  else
	    " find months matching with "a:base"
	    let res = []
	    for m in split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec")
	      if m =~ '^' . a:base
            call add(res, m)
	      endif
	    endfor
	    return res
	  endif
	endfun
"set completefunc=CompleteMonths

" -----------------------------------------------------------------------------
" Read vimrc file and capture all the iabbr, store it in a list
" Usage: type prefix<C-X><C-U>
" Ref: http://vi.stackexchange.com/questions/7750/how-to-manage-and-remember-many-abbreviations-in-my-vimrc/7763#7763
" -----------------------------------------------------------------------------
                 
function! CaptureCmd(excmd)
    let l:abbList = []
    redir=> l:result
    :silent exec a:excmd
    redir END
    let l:list = split(l:result, '\n')
    for item in l:list
        ":silent echo "[" . item . "]\n"
        "echo "[" . item . "]\n"
        call substitute(item, '^\s*[ic]\s\+\(\S\+\)\s\+', '\=add(abbList, submatch(1))', 'g')
    endfor
    for abbItem in l:abbList
        ":silent echo "{" . abbItem . "}\n"
        "echo "{" . abbItem . "}\n"
    endfor
    return l:abbList
endfunc

function! GetAbbreviation()
    let abbrev_list = []
    call substitute(join(readfile($MYVIMRC), "\n"), '\s*iabbr\s\+\(<expr>\|<buffer>\)\?\s*\(\S\+\)', '\=add(abbrev_list, submatch(2))', 'g')
    return abbrev_list
endfunc

function! CompleteAbbre(findstart, base)
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let l:start = col('.') - 1
        while l:start > 0 && (line[l:start - 1] =~ '\a')
            "echo "l:start=" . l:start
            ":1sleep
            let l:start -= 1
        endwhile

        "debug
        "echo "last l:start=" . l:start
        ":3sleep

        return l:start
    else
        " find classes matching "a:base"
        " let l:abbmatch = GetAbbreviation()
        let l:abbmatch = CaptureCmd("iab")
        let res = []
        for m in l:abbmatch
            if m =~ '^' . a:base
            "if m =~ a:base
                call add(res, m)
            endif
        endfor
        return res
    endif
endfun
" -----------------------------------------------------------------------------
" end
" -----------------------------------------------------------------------------



map _in :call IncreaseColor() <CR>

let g:buffermanage = 1
"noremap <F5>  :call ToggleBufMag() <CR>
"map <F6> :call CloseBufferManager() <CR>

map ,nl :.,$s/\S.*\S/\0<br>/gc <bar> :nohlsearch <CR>
map ,n  :nohlsearch <CR>
"map ,l  :.,.s/\S.*\S$/\\[ \0 \\]/gc <bar> :nohlsearch <CR>
map ,,  :.,$s/\S.*\S/\0\<br>/gc <bar> :nohlsearch <CR>

" prefix <CR> to a line
map ,c :.,$s/\S.*\S/\\<CR>\0/gc <bar> :nohlsearch <CR>

imap ,nl :.,.s/^\S.*$/\0<br>/gc <bar> :nohlsearch <CR>
imap ,w <Esc> :w! <CR>
map  ,w :w! <CR>

"------------------------------------------------------------------
" vimrc file
"------------------------------------------------------------------
cabbr sv :source /Users/cat/myfile/github/vim/vim.vimrc <bar> :tabdo e! <CR>
cabbr ev :tabe /Users/cat/myfile/github/vim/vim.vimrc
cabbr eb :tabe ~/.bashrc
cabbr mk :mksession! $sess <CR>
cabbr qn :tabe /Users/cat/myfile/github/quicknote/quicknote.txt
cabbr mm :marks
cabbr Tiny :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome  tiny3.com  -incongnito <CR>

" command line mode
"-----------------------------------------------------------------
"cmap ss :.,$s///gc
" one line loop command
"cmap loo let x=line(".") <bar> let c = x <bar> while(c < x + 10) <bar> echo getline(c) <bar> let c = c + 1 <bar> endwhile
" append [x] to the end of line
"cmap app let x = 0 <bar> g/$/s//\='[' . x . ']'/ <bar> let x = x + 1
:cmap SS .,$s/<C-R><C-W>//gc
:cmap White /\S\zs\s\+$
"-----------------------------------------------------------------

"------------------------------------------------------------------
" vim function mapping
"------------------------------------------------------------------
cabbr bufm :call ToggleBufferManager() <CR>
cabbr pl   :call ListTabPage() <CR>
"------------------------------------------------------------------

" Add block code to noteindex file
autocmd BufRead *.txt iabbr <buffer> bl '[ ]
                                    \<CR>`[
                                    \<CR>
                                    \<CR>`]' . "\<Esc>" . '3k' . '1h'

augroup Java
au!
autocmd BufRead *.java setlocal completefunc=CompleteAbbre
autocmd BufRead *.tex  setlocal completefunc=CompleteAbbre

" Move the cursor to the beginning of the line
autocmd BufRead *.java iabbr <expr> jsys_system_out 'System.out.println(xxx)' . "\<Esc>" . "^" . ":.,.s/xxx/i/gc" . "<CR>"
                                                    
autocmd BufRead *.java iabbr <expr> forr_one_for_loop 'for(int xxx=0; xxx<10; xxx++){
                                         \<CR>}' . "\<Esc>" . "1k" . "^". ":.,.s/xxx/i/gc" . "<CR>"

autocmd BufRead *.java iabbr <expr> for2_two_for_loop 'for(int xxx=0; xxx < 9; xxx++){
                                      \<CR>for(int xxx=0; xxx < 9; xxx++){
                                      \<CR>}
                                      \<CR>}' . "\<Esc>" . "3k" . "^" . ":.,.s/xxx/i/gc" . "<CR>"



autocmd BufRead *.java iabbr <expr> jim 'import java.io.*;
                                 \<CR>import java.lang.String;
                                 \<CR>import java.util.*;' . "\<Esc>" . "^"

autocmd BufRead *.java iabbr <expr> jl 'List<String> list = new ArrayList<String>();' . "\<Esc>" . "^" . ":.,.s/String/Integer/gc" . "<CR>"

autocmd BufRead *.java iabbr <expr> jm 'Map<String, Integer> map = new HashMap<String, Integer>();' . "\<Esc>" . "^"
         
autocmd BufRead *.java iabbr <expr> jda 'List<String> list = new ArrayList<String>();
                                        \<CR>List<String> list = new LinkedList<String>();
                                        \<CR>List<String> list = new Stack<String>();
                                        \<CR>List<String> list = new Vector<String>();
                                        \<CR>Queue<String> queue = new ArrayList<String>();
                                        \<CR>Queue<String> queue = new PriorityQueue<String>();' . "\<Esc>" . "^"
augroup END

"------------------------------------------------------------------
" all shell script snippet
" augroup Shell begin
"------------------------------------------------------------------
augroup Shell
au!
autocmd BufRead *.sh iabbr <buffer> forr 'for i in
                                    \<CR>do
                                    \<CR>echo "$i"
                                    \<CR>done'. "\<Esc>" . "2h"

autocmd BufRead *.sh iabbr <buffer>   iff 'if [ $# -gt 0 ]; then
                                    \<CR>echo "arg $1"
                                    \<CR>if [ $1 = "w" ]; then
                                    \<CR>echo "do sth"
                                    \<CR>elif [ $1 = "t" ]; then
                                    \<CR>echo "do other sth"
                                    \<CR>fi
                                    \<CR>else
                                    \<CR>echo "Usage"
                                    \<CR>fi' . "\<Esc>" . "2h"




augroup END
"------------------------------------------------------------------
" augroup Shell End
"------------------------------------------------------------------

"------------------------------------------------------------------
" cpp mapping
"------------------------------------------------------------------
augroup cpp
au!

"autocmd BufWritePost *.cpp      :silent exec ':!g++ -I /usr/local/include/eigen3 -o %:p:r %:p' | :! %:p:r
"autocmd BufWritePost *.cpp      :silent exec ':!g++ -std=c++11 -o %:p:r %:p' | :! %:p:r

"autocmd BufWritePost *.cpp  :silent exec ':!g++ -std=c++11 -o %:p:r %:p' | :! %:p:r

autocmd BufRead *.cpp  set makeprg=g++\ -std=c++11\ %
autocmd BufWritePost *.cpp  :silent exec ':make' | :! %:p:r

augroup END


"------------------------------------------------------------------
" placeholders mapping
" ref: http://vim.wikia.com/wiki/Text_template_with_placeholders
" placeholder holder
"------------------------------------------------------------------
:imap <buffer> ;fo <C-O>mzfor( %%%; %%%; %%%)<CR>{ // %%%<CR>%%%<CR>}<CR><C-O>'z;;
:imap <buffer> ;; <C-O>/%%%<CR><C-O>c3l
:nmap <buffer> ;; /%%%<CR>c3l
"---------------------------------------------------------------

"------------------------------------------------------------------
" placeholders mapping
" ref: http://vim.wikia.com/wiki/Simple_placeholders
" Enable and disable augroup
" map to <F6>
"------------------------------------------------------------------
function! ToggleBracketGroup()
    if empty(maparg('(', 'i'))
        echo "imap: <c-j> ( [ { $ #"
            inoremap <buffer> <c-j> <Esc>/<++><CR><Esc>cf>
            inoremap <buffer> ( ()<++><Esc>F)i
            inoremap <buffer> [ []<++><Esc>F]i
            inoremap <buffer> { {}<++><Esc>F}i
            inoremap <buffer> $ $$<++><Esc>F$i
            inoremap <buffer> # \[ \\]<++><++><Esc>F\i
    else
         echo "iummap: <c-j> ( [ { $ #"
         iunmap <buffer> <c-j>
         iunmap <buffer> (
         iunmap <buffer> [
         iunmap <buffer> {
         iunmap <buffer> $
         iunmap <buffer> #
    endif
endfunction
"------------------------------------------------------------------

augroup latex
au!

" Call Chrome from command line with url
" Pass url to Chrome in command line
autocmd BufRead  *.tex,*.html cabbr example :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome http://zsurface.com/html/indexLatexExample.html -incongnito <CR>
autocmd BufRead  *.tex,*.html cabbr Greek   :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome http://zsurface.com/image/greek1.png -incongnito <CR>
autocmd BufRead  *.tex,*.html cabbr Font    :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome http://zsurface.com/image/latexfont.png -incongnito <CR>
autocmd BufRead  *.vimrc,*.html cabbr Color   :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome https://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg<CR>
autocmd BufRead  *.vimrc,*.html cabbr Mat   :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome  http://localhost/zsurface/html/indexLatexMatrix.html<CR>



autocmd FileType tex cabbr ln :tabe /Users/cat/myfile/github/math/latexnote.tex

"autocmd FileType tex cabbr ee :.,$s/\S.*\S/\\\[ \0\ \\\]/gc <bar> :nohlsearch <CR>
"autocmd FileType tex cabbr ed :.,$s/\S.*\S/\$\0\$/gc <bar> :nohlsearch <CR>
"autocmd FileType tex cabbr el :.,$s/\S.*\S/\0\ \\\\/gc <bar> :nohlsearch <CR>

autocmd FileType tex iabbr nl \newline <CR>
autocmd FileType tex iabbr bc \mathbb{C}
autocmd FileType tex iabbr bq \mathbb{Q}
autocmd FileType tex iabbr bn \mathbb{N}
autocmd FileType tex iabbr br \mathbb{R}
autocmd FileType tex iabbr gro   $(\mathbb{N}, +)$
autocmd FileType tex iabbr grtau $\Huge \color{red}\tau$
autocmd FileType tex iabbr lmapq $\phi: \mathbb{Q} \rightarrow \mathbb{Q}$
autocmd FileType tex iabbr lmapr $\phi: \polyringr{x} \rightarrow  \polyringr{x}$
autocmd FileType tex iabbr lmapn $\phi: \polyringn{x} \rightarrow  \polyringn{x}$
autocmd FileType tex iabbr lmapc $\phi: \mathbb{C} \rightarrow \mathbb{C}$
autocmd FileType tex iabbr <buffer> fra  '\frac{}{}'
autocmd FileType tex iabbr <buffer> mdet '\det (\mathbf{A} - \lambda \mathbf{I}) = 0'
autocmd FileType tex iabbr <buffer> deta '\det (\mathbf{A})'
autocmd FileType tex iabbr <buffer> detb '\det (\mathbf{B})'
autocmd FileType tex iabbr <buffer> detc '\det (\mathbf{C})' 
autocmd FileType tex iabbr <buffer> ast  '^{\ast}' 
autocmd FileType tex iabbr <buffer> bfa  '\mathbf{A}' 
autocmd FileType tex iabbr <buffer> bfai '\mathbf{A^{\ast}}' 
autocmd FileType tex iabbr <buffer> bfaa '$\mathbf{A}$' 
autocmd FileType tex iabbr <buffer> bfb  '\mathbf{B}' 
autocmd FileType tex iabbr <buffer> bfbi '\mathbf{B^{\ast}}' 
autocmd FileType tex iabbr <buffer> bfbb '$\mathbf{B}$'
autocmd FileType tex iabbr <buffer> bfc  '\mathbf{C}'
autocmd FileType tex iabbr <buffer> bfci '\mathbf{C^{\ast}}'
autocmd FileType tex iabbr <buffer> bfcc '$\mathbf{C}$'
autocmd FileType tex iabbr <buffer> bfq  '\mathbf{Q}'
autocmd FileType tex iabbr <buffer> bfqq '$\mathbf{Q}$'
autocmd FileType tex iabbr <buffer> bfp  '\mathbf{P}'
autocmd FileType tex iabbr <buffer> bfpi '\mathbf{P^{\ast}}'
autocmd FileType tex iabbr <buffer> bfpp '$\mathbf{P}$'
autocmd FileType tex iabbr <buffer> bfi  '\mathbf{I}'
autocmd FileType tex iabbr <buffer> bfii '$\mathbf{I}$'
autocmd FileType tex iabbr <buffer> bb '\[ \]'
autocmd FileType tex iabbr <buffer> ff '$ $'
autocmd FileType tex iabbr <buffer> noi '\setlength\parindent{0pt}'

autocmd FileType tex iabbr <buffer> noi '\setlength\parindent{0pt}'
autocmd FileType tex iabbr <buffer> bigo '$\mathcal{O}(2^n) \mathcal{O}(n\log{}n)$'

" visual mode substitute or select mode
autocmd FileType tex vmap  mbf  :s/\%V.*\%V/\\mathbf{\0}/ <CR>
autocmd FileType tex vmap  mbf$ :s/\%V.*\%V/$\\mathbf{\0}$/ <CR>

autocmd FileType tex vmap  tbf  :s/\%V.*\%V/\\textbf{\0}/ <CR>
autocmd FileType tex vmap  tbf$ :s/\%V.*\%V/$\\textbf{\0}$/ <CR>

" enclose with bracket
autocmd FileType tex cabbr <buffer> 00$ ':s/\\\S\+/$\0$/gc'
autocmd FileType tex cabbr <buffer> 00( ':s/\\\S\+/(\0)/gc'
autocmd FileType tex cabbr <buffer> 00[ ':s/\\\S\+/[\0]/gc'
autocmd FileType tex cabbr <buffer> 00{ ':s/\\\S\+/{\0}/gc'

" summary notation
autocmd FileType tex iabbr <buffer> summ 's = \sum_{k=0}^{\infty} \frac{1}{k}'
"autocmd FileType tex iabbr <buffer> tee '\[ \text{} \]'
autocmd FileType tex iabbr <buffer> boo '\[ \mbox{ } \]'
autocmd FileType tex iabbr <buffer> box '\mbox{ }'
autocmd FileType tex iabbr <buffer> lr( '\left( \right)'
autocmd FileType tex iabbr <buffer> lr[ '\left[ \right]'
autocmd FileType tex iabbr <buffer> lr{ '\left{ \right}'
autocmd FileType tex iabbr <buffer> lr< '\left< \right>'
autocmd FileType tex iabbr <buffer> inn '\left< \vec{u} \,, \vec{v} \right>'
autocmd FileType tex iabbr <buffer> sq  '\sqrt{a + b}'

autocmd FileType tex iabbr <buffer> ctc '$\phi: \mathbb{C} \rightarrow \mathbb{C}$'
autocmd FileType tex iabbr <buffer> qtc '$\phi: \mathbb{Q} \rightarrow \mathbb{Q}$'
autocmd FileType tex iabbr <buffer> por '$\phi: \polyringr{x} \rightarrow  \polyringr{x}$'

autocmd BufRead *.tex,*.html iabbr <buffer> vv '\left[ \begin{array}{cc}
                                 \<CR>c_1 \\
                                 \<CR>c_2 \\
                                 \<CR>\vdots \\
                                 \<CR>c_n
                                 \<CR>\end{array}
                                 \<CR>\right]'


autocmd BufRead *.tex,*.html iabbr <buffer> detp '\[ \chi(\lambda) = \left\| \begin{array}{ccc}
                                      \<CR>\lambda - a & -b & -c \\
                                      \<CR>-d & \lambda - e & -f \\
                                      \<CR>-g & -h & \lambda - i \end{array} \right\| \]'

autocmd BufRead *.tex,*.html iabbr <buffer> mat( '\[ \left( \begin{array}{ccc}
                                        \<CR>a & b & c \\
                                        \<CR>d & e & f \\
                                        \<CR>g & h & i \end{array} \right)\]'

autocmd BufRead *.tex,*.html iabbr <buffer> det22 '\[ \left\| \begin{array}{cc}
                                  \<CR>a & b \\
                                  \<CR>c & d \end{array} \right\| \] '

autocmd BufRead *.tex,*.html iabbr <buffer> matv '\[ \left\| \begin{array}{ccc}
                                  \<CR>a & b & c \\
                                  \<CR>d & e & f \\
                                  \<CR>g & h & i \end{array} \right\| \] '


autocmd BufRead *.tex,*.html iabbr <buffer> bmat 'A_{m,n} =
                                 \<CR>\begin{pmatrix}
                                 \<CR>a_{1,1} & a_{1,2} & \cdots & a_{1,n} \\
                                 \<CR>a_{2,1} & a_{2,2} & \cdots & a_{2,n} \\
                                 \<CR>\vdots  & \vdots  & \ddots & \vdots  \\
                                 \<CR>a_{m,1} & a_{m,2} & \cdots & a_{m,n}
                                 \<CR>\end{pmatrix}'

autocmd BufRead *.tex,*.html iabbr <buffer> matr 'A= \begin{bmatrix}
                                \<CR>\cos(\beta) & -\sin(\beta)\\
                                \<CR>\sin(\beta) & \cos(\beta)
                                \<CR>\end{bmatrix}'

autocmd BufRead *.tex,*.html iabbr <buffer> mat1 'A= \begin{bmatrix}
                                \<CR>1 & 2\\
                                \<CR>3 & 4
                                \<CR>\end{bmatrix}'

autocmd BufRead *.tex,*.html iabbr <buffer> mat2 'A= \begin{bmatrix}
                                \<CR>1 & 2\\
                                \<CR>3 & 4
                                \<CR>\end{bmatrix}'

autocmd BufRead *.tex,*.html iabbr <buffer> mati 'A= \begin{bmatrix}
                                \<CR>1 & 0\\
                                \<CR>0 & 1
                                \<CR>\end{bmatrix}'

autocmd BufRead *.tex,*.html iabbr <buffer> mat3 'A= \begin{bmatrix}
                                \<CR>1 & 2 & 3\\
                                \<CR>4 & 5 & 6\\
                                \<CR>7 & 8 & 9
                                \<CR>\end{bmatrix}'

autocmd BufRead *.tex,*.html iabbr <buffer> mati3 'A= \begin{bmatrix}
                                \<CR>1 & 0 & 0\\
                                \<CR>0 & 1 & 0\\
                                \<CR>0 & 0 & 1
                                \<CR>\end{bmatrix}'

autocmd BufRead *.tex,*.html iabbr <buffer> t66 '\begin{tabular}{\|c\|c\|c\|c\|c\|c\|} \hline
                                 \<CR>10 & 20 & 30 & 40 & 50 & 50 \\ \hline
                                 \<CR>22 & 28 & 38 & 48 & 58 & 50 \\ \hline
                                 \<CR>28 & 38 & 48 & 58 & 68 & 50 \\ \hline
                                 \<CR>33 & 18 & 18 & 28 & 99 & 50 \\ \hline
                                 \<CR>98 & 18 & 18 & 28 & 88 & 50 \\ \hline
                                 \<CR>98 & 18 & 18 & 28 & 88 & 50 \\ \hline
                                 \<CR>\end{tabular}'

autocmd  BufRead *.tex,*.html iabbr <buffer> t55 '\begin{tabular}{\|c\|c\|c\|c\|c\|} \hline
                                 \<CR>10 & 20 & 30 & 40 & 50 \\ \hline
                                 \<CR>22 & 28 & 38 & 48 & 58 \\ \hline
                                 \<CR>28 & 38 & 48 & 58 & 68 \\ \hline
                                 \<CR>33 & 28 & 18 & 18 & 99 \\ \hline
                                 \<CR>98 & 28 & 18 & 18 & 88 \\ \hline
                                 \<CR>\end{tabular}'

autocmd BufRead *.tex,*.html iabbr <buffer> t44 '\begin{tabular}{\|c\|c\|c\|c\|} \hline
                                 \<CR>10 & 20 & 30 & 40 \\ \hline
                                 \<CR>22 & 28 & 37 & 48 \\ \hline
                                 \<CR>28 & 38 & 48 & 58 \\ \hline
                                 \<CR>33 & 10 & 11 & 12 \\ \hline
                                 \<CR>\end{tabular}'

autocmd BufRead *.tex,*.html iabbr <buffer> t33 '\begin{tabular}{\|c\|c\|c\|} \hline
                                 \<CR>10 & 20 & 30  \\ \hline
                                 \<CR>22 & 28 & 38  \\ \hline
                                 \<CR>28 & 38 & 48  \\ \hline
                                 \<CR>\end{tabular}'

autocmd BufRead *.tex,*.html iabbr <buffer> eqq '\begin{equation}
                                       \<CR>\begin{aligned}
                                       \<CR>x & = y + 1
                                       \<CR>x & = z + 3
                                       \<CR>\end{aligned}
                                       \<CR>\end{equation}'
                
autocmd BufRead *.tex,*.html iabbr <buffer> begg '\begin{equation}
                                        \<CR>\begin{aligned}
                                        \<CR>\end{aligned}
                                        \<CR>\end{equation}'

autocmd BufRead *.tex,*.html iabbr <buffer> enum '\begin{enumerate}
                                        \<CR>\item
                                        \<CR>\item
                                        \<CR>\end{enumerate}'


autocmd BufRead *.tex,*.html iabbr <buffer> eqb '\begin{equation}
                                 \<CR>\begin{aligned}'

autocmd BufRead *.tex,*.html iabbr <buffer> eqe '\end{aligned}
                                  \<CR>\end{equation}'


autocmd BufRead *.tex,*.html iabbr <buffer> img '\begin{figure}
                                  \<CR>\centering
                                  \<CR>%\includegraphics[scale=0.5,height=1cm, width=6cm]{/Users/cat/myfile/github/image/spiral2.png} \\
                                  \<CR>\includegraphics[scale=0.3]{/Users/cat/myfile/github/image/spiral2.png} \\
                                  \<CR>\end{figure} \\'


autocmd BufRead *.tex,*.html iabbr gro $(\mathbb{N}, +)$
autocmd BufRead *.tex,*.html iabbr cml <p><CR>$\Large \color{red}\lambda$
        \<CR>Rename file name of default screenshots in Mac OSX, Open your Terminal and type:<br><br>
        \<CR><span style="color:#FFF; background:#000;border-radius:3px; padding:2px;">
        \<CR>defaults write com.apple.screencapture name "myName"<br>
        \<CR></span><br>
        \<CR>And type:<br><br>
        \<CR><span style="color:#FFF; background:#000;border-radius:3px; padding:2px;">
        \<CR>killall SystemUIServer
        \<CR></span>
        \<CR></p>

autocmd BufRead *.tex,*.html iabbr gr \[
                         \<CR>\alpha     \theta     \tau      \beta
                         \<CR>\vartheta  \pi        \upsilon  \gamma
                         \<CR>\gamma     \varpi     \phi      \delta
                         \<CR>\kappa     \rho       \varphi   \epsilon
                         \<CR>\lambda    \varrho    \chi      \varepsilon
                         \<CR>\mu        \sigma     \psi      \zeta
                         \<CR>\nu        \varsigma  \omega    \eta
                         \<CR>\xi        \Gamma     \Lambda   \Sigma
                         \<CR>\Psi       \Delta     \Upsilon  \Omega
                         \<CR>\Theta     \Pi        \Phi
                         \<CR>\]


autocmd BufRead *.tex,*.html iabbr ma \begin{bmatrix}
        \<CR>1 & 2  & 3 \\
        \<CR>4 & 5  & 6 \\
        \<CR>7 & 8  & 9 \\
        \<CR>\end{bmatrix}


autocmd FileType tex iabbr xcc blackColor
        \<CR>darkGrayColor
        \<CR>lightGrayColor
        \<CR>whiteColor
        \<CR>grayColor
        \<CR>redColor
        \<CR>greenColor
        \<CR>blueColor
        \<CR>cyanColor
        \<CR>yellowColor
        \<CR>magentaColor
        \<CR>orangeColor
        \<CR>purpleColor
        \<CR>brownColor
        \<CR>clearColor

augroup END
"------------------------------------------------------------------
"latex end
"------------------------------------------------------------------


" searchkey
iabbr skk // searchkey:


autocmd BufRead *.html iabbr <buffer> ioss '<div class="mytext">
                                        \<CR>The App shows how to use simple animation on iPhone.<br>
                                        \<CR>1. Load images to array<br>
                                        \<CR></div><br>
                                        \<CR><div class="cen">
                                        \<CR><img src="http://localhost/zsurface/image/kkk.png" width="80%" height="80%" /><br>
                                        \<CR><a href="https://github.com/bsdshell/xcode/tree/master/OneRotateBlockApp">Source Code</a>
                                        \<CR></div>'

autocmd BufRead *.html iabbr <buffer> myw '<div class="mytitle">
                                        \<CR>Find the maximum Height of a Binary Tree
                                        \<CR></div>
                                        \<CR><div class="mytext">
                                        \<CR>The height of binary tree is the maximum distance from the root to the children<br>
                                        \<CR></div>'

" escape single quote
autocmd BufRead *.html iabbr <buffer> tipp '<!-- begin tooltip-wrap-->
                    \<CR><div class="tooltip-wrap">
                    \<CR>$$\textbf{sqare root}$$
                    \<CR>\[
                    \<CR>\sqrt{x}
                    \<CR>\]
                    \<CR><div class="tooltip-content">
                    \<CR><div class="tex2jax_ignore">
                    \<CR><pre style="background:#FFF" onClick="clip(document.getElementById(''copy23''));" id="copy23">
                    \<CR>\sqrt{x}
                    \<CR></pre>
                    \<CR></div>
                    \<CR></div>
                    \<CR></div>
                    \<CR><!-- end tooltip-wrap-->'
"compile latex
"autocmd FileType tex map  <F10> :!pdflatex % <CR> :!open -a /Applications/Adobe\ Acrobat\ Reader\ DC.app/Contents/MacOS/AdobeReader %<.pdf <CR>
autocmd BufRead *.tex map  <F9> :w! <bar> :!pdflatex %:p <CR> :!open %:p:r.pdf <CR>

" save file and compile latex file
"autocmd BufWritePost *.tex      :silent exec ':!pdflatex %:p ' | :!open %:p:r.pdf

augroup commentcode
au!

" vimrc
autocmd BufRead *.vimrc vmap xx   :s/\%V\_^\%V/"/g <CR>
autocmd BufRead *.vimrc vmap xu   :s/\%V\_^\s*\zs"\%V//g <CR>

" objectivec
autocmd BufRead *.m,*.h,*.java,*.cpp,*.c vmap  xx  :s/\%V\_^\%V/\/\//g <CR>
autocmd BufRead *.m,*.h,*.java,*.cpp,*.c vmap  xu  :s/\%V\_^\s*\zs\/\/\%V//g <CR>

" tex
autocmd BufRead *.tex vmap  xx  :s/\%V\_^\%V/%/g <CR>
autocmd BufRead *.tex vmap  xu  :s/\%V\_^\s*\zs%\%V//g <CR>

augroup END

"-----------------------------------------------------------------
" Xcode mapping
" BufRead is better than FileType, don't ask me why
"-----------------------------------------------------------------
augroup Xcode
au!

" run CoreApp test cases from command line
autocmd BufRead *.m,*.h  map  <F9> :!/Users/cat/myfile/github/xcode/CoreApp/test.sh

autocmd BufRead *.m,*.h cabbr ttd :call Test(@")<CR>
autocmd BufRead *.m,*.h cabbr df  :call Defun()<CR>
autocmd BufRead *.m,*.h cabbr dv  :call DeVariable()<CR>
autocmd BufRead *.m,*.h cabbr ffu :call FindFun()<CR>
autocmd BufRead *.m,*.h cabbr ffr :call RemoveDuplicatedTabs()<CR>
autocmd BufRead *.m,*.h cabbr ww  :call HeaderSource()<CR>
autocmd BufRead *.m,*.h call XcodeColor()

autocmd BufRead *.m,*.h iabbr <buffer> recc 'CGRect rect = CGRectMake(0, 0, 10, 10);'
autocmd BufRead *.m,*.h iabbr <buffer> pot  'CGPoint point = CGPointMake(1, 2);'
autocmd BufRead *.m,*.h iabbr <buffer> caa  'CAShapeLayer* myLayer = [CAShapeLayer layer];'
autocmd BufRead *.m,*.h iabbr <buffer> nsv  '[NSValue valueWithCGPoint:point];'

autocmd BufRead *.m,*.h iabbr <buffer> pre  'NSLog(@"%s", __PRETTY_FUNCTION__);'
autocmd BufRead *.m,*.h iabbr <buffer> nsp  'NSLog(@"point[%@]", [NSValue valueWithCGPoint:point]);'
autocmd BufRead *.m,*.h iabbr <buffer> nsr  'NSLog(@"rect[%@]", [NSValue valueWithCGRect:rect]);'
autocmd BufRead *.m,*.h iabbr <buffer> nsf  'NSLog(@"rect[%f]", float);'
autocmd BufRead *.m,*.h iabbr <buffer> nsf2 'NSLog(@"f1[%f] f2[%f]", f1, f2);'
autocmd BufRead *.m,*.h iabbr <buffer> nsf3 'NSLog(@"f1[%f] f2[%f] f3[%f]", f1, f2, f3);'
autocmd BufRead *.m,*.h iabbr <buffer> nsd  'NSLog(@"d1[%d] ", d1);'
autocmd BufRead *.m,*.h iabbr <buffer> nsd2 'NSLog(@"d1[%d] f2[%d]", d1, d2);'
autocmd BufRead *.m,*.h iabbr <buffer> nsd3 'NSLog(@"d1[%d] f2[%d] f3[%d]", d1, d2, d3);'

autocmd BufRead *.m,*.h iabbr <buffer> forr 'for(int i=0; i<num; i++){
                                      \<CR>}'
autocmd BufRead *.m,*.h iabbr <buffer> forr2 'for(int i=0; i<num1; i++){
                                            \<CR>for(int j=0; j<num2; j++){
                                            \<CR>}
                                        \<CR>}'

autocmd BufRead *.m,*.h iabbr <buffer> arrm 'NSMutableArray* array = [[NSMutableArray alloc]init];'

autocmd BufRead *.m,*.h iabbr xpp [path moveToPoint:CGPointMake(location.x, location.y)];
        \<CR>[path addLineToPoint:CGPointMake(location.x + width, location.y)];
        \<CR>[path addLineToPoint:CGPointMake(location.x + width, location.y + height)];
        \<CR>[path addLineToPoint:CGPointMake(location.x, location.y + height)];
        \<CR>[path addLineToPoint:CGPointMake(location.x, location.y)];

autocmd BufRead *.m,*.h iabbr timm [NSTimer scheduledTimerWithTimeInterval:self.delayInterval
        \<CR>target:self
        \<CR>selector:@selector(suspendDisplay:)<CR>userInfo:nil<CR>repeats:NO];<CR><CR>-(void)suspendDisplay:(NSTimer*)timer{<CR>}

autocmd BufRead *.m,*.h iabbr imav UIImageView* _imageView;
                    \<CR>@property (nonatomic, retain) UIImageView* imageView;
                    \<CR>@synthesize imageView = _imageView;
                    \<CR>self.imageView = [[UIImageView alloc]initWithFrame:self.window.bounds];
                    \<CR>self.imageView.image=[UIImage imageNamed:@"myimage.jpg"];
                    \<CR>[self.window addSubview:self.imageView];

autocmd BufRead *.m,*.h iabbr labb UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 300, 300)];
                    \<CR>[myLabel setTextColor:[UIColor redColor]];
                    \<CR>[myLabel setBackgroundColor:[UIColor clearColor]];
                    \<CR>[myLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
                    \<CR>[myLabel setText:@"Supper Simple Application"];
                    \<CR>[self.window addSubview:myLabel];

     
augroup END
"-----------------------------------------------------------------
" Save and restore current split windows
"-----------------------------------------------------------------


function! MaximizeToggle()
  let s:tmpssop = &ssop
  let s:tmphidden = &hidden
  exec "set ssop-=" . 'tabpages'
  exec "set ssop?"
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
  let &ssop = s:tmpssop
  let &hidden = s:tmphidden
  "exec "set ssop+=" . 'tabpages'
endfunction
"-----------------------------------------------------------------
func! MyPath()
     return '|' . expand("%:p:t") . '|'
endfunc


"-----------------------------------------------------------------
" return short path from a given path
"  input: /home/user/code
" output: user/code

func! ShortPath()
     let retPath = expand("%:p:h")
     let list = split(retPath, '/')
     let len = len(list)
     if len > 1
         let retPath = list[len-2] . '/' . list[len-1]
     endif
     return '| ' . retPath . ' |'
endfunc

"-----------------------------------------------------------------
" display git branch in statusline

" func! GitBranch()
"     let branch = system('git branch')
"     let list = split(branch, "\n")
"     let blist = []
"     for bra in list
"         if match(bra, '\* \w\+') != -1
"             let blist = split(bra, " ")
"         endif
"     endfor
"     if len(blist) > 1
"         return "{" . blist[1] . "}"
"     else
"         return ""
" endfunc

"-----------------------------------------------------------------
" map and unmap keys


let g:keymap = 0
func! MapKey()
    if g:keymap == 0

        let g:keymap = 1
    else
        :map <F7> <Nop>
        :map <F8> <Nop>

        :map <F1> <Nop>
        :map <F2> <Nop>
        :map <F3> <Nop>

        :imap <F1> <Nop>
        :imap <F2> <Nop>

        :map <S-F10> <Nop>
        :map <F4> <Nop>


        echo "nunmap my key"

        let g:keymap = 0
    endif
endfunc

"-----------------------------------------------------------------
" redirect Ex command to tab file
"-----------------------------------------------------------------
function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
"-----------------------------------------------------------------
command! -nargs=+ -complete=command Rd call TabMessage(<q-args>)
" usee scratch buffer
command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
"-----------------------------------------------------------------

" searchkey: ctermfg ctermbg xterm color highlight
func! XcodeColor()
    syn match Property "\<_[a-zA-Z0-9]\+\>"
    "highlight Property ctermfg=55 cterm=bold
    "highlight Property ctermfg=142 cterm=bold
    highlight Property ctermfg=058

    syn match Colon ":"
    highlight Colon ctermfg=red

    syn match RightArrow "->"
    "highlight RightArrow ctermfg=white
    hi link RightArrow Special

    syn match MyBracket /\[\|\]/
    hi link MyBracket Identifier
    "highlight MyBracket ctermfg=blue

    syn match CurlyBracket "{\|}"
    "highlight CurlyBracket ctermfg=196
    highlight CurlyBracket ctermfg=128
endfunc


"-----------------------------------------------------------------
func! ListTabPage()
    let buflist = []
    let t = 1
    let list = []
    " get number of tabs
    while t <= tabpagenr('$')
       let buflist = tabpagebuflist(t)
       " numbers of window
       let winNum = 0
       while  winNum < tabpagewinnr(t, '$')
            let fname  = bufname(buflist[winNum])
            let name   = fnamemodify(fname, ':p:t')
            let tabNum = printf("%2d", t)
            let bufNum = printf("%2d", buflist[winNum])
            let item   = '[' . tabNum . '][' . bufNum . ']' . name
            let winNum = winNum + 1
            :call add(list, item)
       endwhile
       let t = t + 1
    endwhile
    "echo list
    "let l:tmpname = "/private/tmp/bufername33334asdf.x"
    let l:tmpname = tempname()
    :call writefile(list, l:tmpname, "b")
    exec "set splitright"
    exec "vsplit " . l:tmpname
    exec "set nonumber"
    exec "vertical resize 30"

    syn match MySource /.*\.m/
    highlight MySource ctermbg=white
    syn match MyHead /.*\.h/
    highlight MyHead ctermfg=gray

    exec "normal \<C-W>h"
endfunc
"-----------------------------------------------------------------
func! ListCompare(i1, i2)
     let l1 = split(a:i1, ":")
     let l2 = split(a:i2, ":")
     return l1[1] == l2[1] ? 0 : l1[1] > l2[1] ? 1 : -1
endfunc

func! BufferList()
  let currbufnr = 1
  let bufList = []
  let bufcount = bufnr("$")
  while currbufnr <= bufcount
    if bufexists(currbufnr) != 0
      let currbufname = bufname(currbufnr)
        if filereadable(currbufname) && buflisted(currbufname) && strlen(currbufname) > 0
            let path = fnamemodify(currbufname, ':p:h')
            let name = fnamemodify(currbufname, ':p:t')
            call add(bufList, path)
        endif
    endif
    let currbufnr = currbufnr + 1
  endwhile
  return bufList
endfunc

"-----------------------------------------------------------------
func! ToggleBufferManager(flag)
    let l:tmpname =  "/private/tmp/12345.x"
    if exists("s:win_tmpname")
        if a:flag =~ "o"
          exec "set splitright"
          exec "vsplit " . l:tmpname
          exec "w! " . l:tmpname
          exec "set nonumber"
          exec "set modifiable"
          exec "vertical resize 30"
        elseif a:flag =~ "n"
          echo s:win_tmpname
          exec ":close " . s:win_tmpname[1]
          exec "bdelete " . s:win_tmpname[0]
          let s:win_tmpname = BufferManager()
        endif
   else
        let s:win_tmpname = BufferManager()
        :echo s:win_tmpname[0]
    endif
endfunc
command! -nargs=1 Bf :call ToggleBufferManager("<args>")
"-----------------------------------------------------------------
"==============================================================================
func! BufferManager()
  "let l:tmpname = tempname()
  let retlist = []
  let l:tmpname =  "/private/tmp/12345.x"
  let bufcount = bufnr("$")
  let nummatches = 0
  let buflist = []
  let firstmatchingbufnr = 0
  let dict = {}
  let currbufnr = 1
  while currbufnr <= bufcount
    if bufexists(currbufnr) != 0
      let currbufname = bufname(currbufnr)
        let nummatches += 1
        let firstmatchingbufnr = currbufnr
        let namelist = []
        if filereadable(currbufname) && buflisted(currbufname) && strlen(currbufname) > 0
            let namelist = split(currbufname, "/")

            "let fullbuffer =  currbufnr . ":" . namelist[len(namelist)-1]
            let path = fnamemodify(currbufname, ':p:h')
            let name = fnamemodify(currbufname, ':p:t')

            " check if dict contains the key
            if has_key(dict, path) == 0
               let dict[path] = []
            endif
            let bname = currbufnr . ':' . name
            if currbufnr < 10
                let bname = currbufnr . ' :' . name
            endif
            call add(dict[path], bname)

        endif
    endif
    let currbufnr = currbufnr + 1
  endwhile

  for [key, list] in items(dict)
     call sort(list, "ListCompare")
  endfor

  let treeList = []

  for key in sort(keys(dict))
     call add(treeList, key)
     for item in dict[key]
          call add(treeList, item)
     endfor
     call add(treeList, "")
  endfor

  :call writefile(treeList, l:tmpname, "b")
  echo l:tmpname
  exec "set splitright"
  exec "vsplit " . l:tmpname
  exec "set nonumber"
  exec "set modifiable"
  exec "w! " . l:tmpname
  exec "vertical resize 30"

  call add(retlist, l:tmpname)
  call add(retlist, winnr('$'))
  return retlist
endfunc
"-----------------------------------------------------------------
func! BufSel(pattern)
  let bufcount = bufnr("$")
  let currbufnr = 1
  let nummatches = 0
  let firstmatchingbufnr = 0
  while currbufnr <= bufcount
    if(bufexists(currbufnr))
      let currbufname = bufname(currbufnr)
      if(match(currbufname, a:pattern) > -1)
        echo currbufnr . ": ". bufname(currbufnr)
        let nummatches += 1
        let firstmatchingbufnr = currbufnr
      endif
    endif
    let currbufnr = currbufnr + 1
  endwhile
  if(nummatches == 1)
    execute ":buffer ". firstmatchingbufnr
  elseif(nummatches > 1)
    let desiredbufnr = input("Enter buffer number: ")
    if(strlen(desiredbufnr) != 0)
      execute ":buffer ". desiredbufnr
    endif
  else
    echo "No matching buffers"
  endif
endfunc

"Bind the BufSel() function to a user-command
command! -nargs=1 Bs :call BufSel("<args>")
"-----------------------------------------------------------------


"-----------------------------------------------------------------
" Fix the missing -cp option in java
" Assume java file is in current buffer
func! CompileJava()
    let path = expand("%")
    exec ":!javac " . path
    let jclassName = expand("%:p:t:r")
    let cwd = getcwd()
    let full = ":!java -cp " . cwd . ":. " . jclassName
    exec  full
endfunc
"-----------------------------------------------------------------
func! CompileHaskell()
    let path = expand("%")
    exec ":!runhaskell " . path
endfunc
"-----------------------------------------------------------------
" Change solarized color scheme background light/dark
func! ToggleColorScheme()
          let s:currColor = g:colors_name
          echo "color scheme=" . s:currColor
          if s:currColor == "solarized"
            let s:bg = synIDattr(synIDtrans(hlID("Normal")), "bg")
            echo "color=" . s:bg
            if s:bg == "#002b36"
                echo "Change color to #fdf6e3"
                exec 'hi Normal		guibg=' .  "#fdf6e3"
            else
                echo "Change color to #002b36"
                exec 'hi Normal		guibg=' .  "#002b36"
            endif
          endif
endfunc
"-----------------------------------------------------------------
" set background color, it only works for Terminal, not for GUI
let g:colorCode = synIDattr(hlID("Normal"), "bg#")
if g:colorCode == -1
    let g:colorCode = 187
endif
func! IncreaseColor()
    if g:colorCode < 256
        echo g:colorCode
        let g:colorCode = g:colorCode + 1
        "exec 'hi Normal guifg=yellow	guibg=white ctermfg=black ctermbg=' .  g:colorCode
        exec 'hi Normal guibg=' . g:colorCode . ' ctermbg=' .  g:colorCode
    endif
        exec 'hi Normal guibg=' . g:colorCode . ' ctermbg=' .  g:colorCode
endfunc

func! DecreaseColor()
    if g:colorCode > 0
        let g:colorCode = g:colorCode - 1
        "exec 'hi Normal		guifg=yellow	guibg=white ctermfg=black ctermbg=' .  g:colorCode
        exec 'hi Normal		guibg=' . g:colorCode . '   ctermbg=' .  g:colorCode
    endif
        exec 'hi Normal		guibg=' . g:colorCode . '   ctermbg=' .  g:colorCode
endfunc
"-----------------------------------------------------------------

func! CurTabFileName( )
  return fnamemodify(bufname(winbufnr(tabpagewinnr(0))),':t')
endfun

func! SortBuffer()
    for i in range(tabpagenr('$'),1, -1)
        for j in range(1, i-1)
            " goto the first tab
            :tabr
            let curTab = CurTabFileName()
            :tabn
            let nextTab = CurTabFileName()

            if curTab > nextTab
                :tabp
                exec ":tabmove " . j
            endif
        endfor
    endfor
endfunc


func! RemoveDuplicatedTabs()
    let NONAME = "NO_NAME"
    let invertDict = {}
    for i in range(tabpagenr('$'),1, -1)
        let curTab = CurTabFileName()
        if curTab == ""
            let curTab = NONAME
        endif

        let invertDict[i] = curTab
        :tabn
    endfor

    let tabOffset = 0
    let newDict = {}
    for tabNum in sort(keys(invertDict))
        let tabName = get(invertDict, tabNum)
        let isDupNum = get(newDict, tabName)

        if isDupNum == 0
            let newDict[tabName] = 1
        else
            let newTabNum = tabNum - tabOffset
            echo "===================== tabclose " . newTabNum . "  " .tabName
            exec ":tabclose! " . newTabNum
            let tabOffset = tabOffset + 1
        endif
    endfor
    call SortBuffer()
endfunc



func! HeaderSource()
    let s:count   = line(".")
    let extension = expand("%:e")
    let fsource   = expand("%:p:r") . ".m"
    let fheader   = expand("%:p:r") . ".h"
    echo fsource
    if extension == "h"
        execute "edit +" . s:count . " " . fsource
    elseif extension == "m"
        execute "edit +" . s:count . " " . fheader
    endif
endfunc

" generate test template from register @"
func! Test(title)
    let input = a:title
    let list = matchlist(input, '\(+\|-\)([^)]*)\zs[^:]*')
    echo list
    let comment = substitute(input, "{", "", "g")
    let output = "-(void)test_" . list[0] . "{\n\t//" . comment . "\n}\n"
    echo output
    let @0 = output
    execute "put 0"
endfunc

func! DeClass()
    let line = getline(".")
    let tokens = split(line, " ")
endfunc


func! DeVariable()
    let input = expand("<cword>")
    " Get all the curr buffer #
    let all = range(0, bufnr('$'))
    let res = []
    for bn in all
        let name = bufname(bn)

        " expand full path
        let fullpath = expand("%:p:r") . ".h"
        let s:count=0
        for line in readfile(fullpath)
            if line =~ input
                execute "edit +" . s:count . " " . fullpath
                return
            endif
            let s:count = s:count + 1
        endfor
    endfor
endfunc

func! FindFun()
    let input = expand("<cword>")
    " Get all the curr buffer #
    let all = range(0, bufnr('$'))
    for bn in all
        let fullName = bufname(bn)
        let name = fnamemodify(fullName, ":t")
        let curName = expand("%:p:t")

        " match file name [*.m]
        if  name != curName && name =~ '\(\~\|\/\|\w\|\d\)\+\.m'
            let s:count=0
            for line in readfile(fullName)

                " match method defintion in ObjectiveC
                "if line =~ '^\s*\(+\|-\)\s*(\(\*\|\w\)\+)'. input
                if line =~ input
                    execute "edit +" . s:count . " " . fullName
                    return
                endif
                let s:count = s:count + 1
            endfor
        endif
    endfor
endfunc


func! Defun()
    let input = expand("<cword>")
    " Get all the curr buffer #
    let all = range(0, bufnr('$'))
    for bn in all
        let name = bufname(bn)
        " match file name [*.m]
        if name =~ '\(\~\|\/\|\w\|\d\)\+\.m'
            let s:lineNum=1
            for line in readfile(name)

                " match method defintion in ObjectiveC
                if line =~ '^\s*\(+\|-\)\s*(\(\*\|\w\)\+)'. input
                    echo line
                    execute "tabe +" . s:lineNum . " " . name 
                    return
                endif
                let s:lineNum = s:lineNum + 1
            endfor
        endif
    endfor
endfunc


" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine guibg=#2d2d2d
  hi CursorColumn guibg=#2d2d2d
  hi MatchParen guifg=#f6f3e8 guibg=#857b6f gui=bold
  hi Pmenu 		guifg=#f6f3e8 guibg=#444444
  hi PmenuSel 	guifg=#000000 guibg=#cae682
endif

"follwoing color will overwrite the colorscheme
" General colors
"hi Cursor 		guifg=NONE    guibg=#656565 gui=none
"hi Normal 		guifg=#f6f3e8 guibg=#242424 gui=none
"hi NonText 		guifg=#808080 guibg=#303030 gui=none
"hi LineNr 		guifg=#857b6f guibg=#000000 gui=none
"hi StatusLine 	guifg=#f6f3e8 guibg=#444444 gui=italic
"hi StatusLineNC guifg=#857b6f guibg=#444444 gui=none
"hi VertSplit 	guifg=#444444 guibg=#444444 gui=none
"hi Folded 		guibg=#384048 guifg=#a0a8b0 gui=none
"hi Title		guifg=#f6f3e8 guibg=NONE	gui=bold
"hi Visual		guifg=#f6f3e8 guibg=#444444 gui=none
"hi SpecialKey	guifg=#808080 guibg=#343434 gui=none

" Syntax highlighting
"hi Comment 		guifg=#99968b gui=italic
"hi Todo 		guifg=#8f8f8f gui=italic
"hi Constant 	guifg=#e5786d gui=none
"hi String 		guifg=#95e454 gui=italic
"hi Identifier 	guifg=#cae682 gui=none
"hi Function 	guifg=#cae682 gui=none
"hi Type 		guifg=#cae682 gui=none
"hi Statement 	guifg=#8ac6f2 gui=none
"hi Keyword		guifg=#8ac6f2 gui=none
"hi PreProc 		guifg=#e5786d gui=none
"hi Number		guifg=#e5786d gui=none
"hi Special		guifg=#e7f6da gui=none