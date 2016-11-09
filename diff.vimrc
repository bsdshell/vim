diff --git a/vim.vimrc b/vim.vimrc
index 1fae360..5337168 100644
--- a/vim.vimrc
+++ b/vim.vimrc
@@ -1,13 +1,23 @@
 syntax enable
+
+
+" -------------------------------------------------------------------------------- 
+" TODO remove it 
+" Wed Nov  2 22:01:32 PDT 2016
 "hi search         ctermbg=Gray ctermfg=Brown
-highlight Cursor  ctermfg=green guifg=green guibg=white
-highlight iCursor ctermfg=green guifg=green guibg=white
-hi User1          ctermbg=white ctermfg=brown   guibg=white guifg=brown
-hi User2          ctermbg=LightGray ctermfg=Magenta guibg=LightGray guifg=Magenta
-hi User3          ctermbg=blue  ctermfg=green guibg=blue  guifg=green
-hi User4          ctermbg=brown  ctermfg=white guibg=white  guifg=black
-hi User5          ctermbg=DarkGray  ctermfg=green guibg=#FFFFFE  guifg=brown
-hi User6          ctermbg=gray ctermfg=blue guibg=gray guifg=blue
+"highlight Cursor  ctermfg=green guifg=green guibg=white
+"highlight iCursor ctermfg=green guifg=green guibg=white
+" set the current line Bold
+
+set cursorline
+
+"hi User1          ctermbg=red ctermfg=brown   guibg=white     guifg=brown   
+"hi User2          ctermbg=LightGray ctermfg=Magenta guibg=LightGray guifg=Magenta 
+"hi User3          ctermbg=blue      ctermfg=green   guibg=blue      guifg=green   
+"hi User4          ctermbg=brown     ctermfg=white   guibg=white     guifg=black   
+"hi User5          ctermbg=DarkGray  ctermfg=green   guibg=yellow    guifg=brown   
+"hi User6          ctermbg=gray      ctermfg=blue    guibg=gray      guifg=blue    
+"hi User7          ctermbg=white     ctermfg=red     guibg=gray      guifg=blue    
 
 "=====================================================================
 set undofile                " Save undo's after file closes
@@ -17,6 +27,8 @@ set undoreload=10000        " number of lines to save for undo
 "---------------------------------------------------------------------
 let s:word_code = '<,k>|code'
 
+let mapleader=","
+
 " /search case insensitive, case sensitive
 set ic "set noic
 
@@ -27,7 +39,9 @@ set statusline=%F
 set statusline+=\[%-2.5n]
 set statusline+=\ %l:%c\ %r\ %m
 set statusline+=\ %{CheckToggleBracketGroup()}
-set statusline+=\ \[%{CheckWordPhrase()}]
+set statusline+=%1*\ \[%{CheckWordPhrase()}]
+set statusline+=%2*\ \[%{CheckIgnoreCase()}]
+set statusline+=%3*\ \[%{ShowWatch()}]
 set hls
 set autoindent
 set smartindent
@@ -45,7 +59,9 @@ set backspace=2
 set omnifunc=csscomplete#CompleteCSS
 set path+=**
 set wildmenu
-let mapleader=","
+set tags+=/Users/cat/.vim/tags/java.tags
+
+
 
 "-------------------------------------------------------------------------------- 
 " Use Vim 8 timer to save file every 2 seconds
@@ -235,27 +251,75 @@ if &completefunc == ''
 endif
 " -------------------------------------------------------------------------------- 
 
+
+"let gtimer = timer_start(2000, 'SaveFile',{'repeat':-1})
+"func! SaveFile(gtimer)
+  "silent! :w!
+"endfunc
+
+"func! StartTimer()
+    "let gtimer = timer_start(2000, 'SaveFile',{'repeat':-1})
+"endfunc
+
+function! StopWatch(numSecond)
+let  s:watchTimer = timer_start(2000, 'ShowWatch',{'repeat': a:numSecond})
+endfunc
+
+function! ShowWatch()
+    let dict = timer_info(s:watchTimer)
+    let sec = dict['repeat']['repeat']
+    return g(sec / 60). ':' . (sec % 60)
+endfunc
+
+
+" -------------------------------------------------------------------------------- 
+" toggle between ignoreCase and noignorecase 
+" -------------------------------------------------------------------------------- 
+
+function! CheckIgnoreCase()
+        return '<,i>|' . (&ic == 1 ? 'ic' : 'noic') 
+endfunc
+function! ToggleIgnoreCase()
+    if &ic == 1 
+        set noic
+        hi User2 ctermfg=yellow ctermbg=0
+        :redrawstatus
+    elseif &ic == 0
+        set ic 
+        hi User2 ctermfg=cyan ctermbg=0
+        :redrawstatus
+    endif
+endfunc
+
 " -------------------------------------------------------------------------------- 
 " toggle between abbreviation and phrase
 " -------------------------------------------------------------------------------- 
-if &completefunc == 'LineCompleteFromFile'
-    let s:word_code = '<,k>|word'
+let s:dict_key = {'word':'<,k>|word', 'code':'<,k>|code'}
+"if &completefunc == 'LineCompleteFromFile'
+if &completefunc == 'LineNew'
+    let s:word_code = s:dict_key['word'] 
 elseif &completefunc == 'CompleteAbbre'
-    let s:word_code = '<,k>|code'
+    let s:word_code = s:dict_key['code']
 endif
 
 function! CheckWordPhrase()
+    "if &completefunc == 'LineCompleteFromFile'
+    :redrawstatus
     return s:word_code
 endfunction
 
 function! ToggleCompletefunc()
     "let l:pos = getpos(".")
-    if &completefunc == 'LineCompleteFromFile'
+    "if &completefunc == 'LineCompleteFromFile'
+    if &completefunc == 'LineNew'
         set completefunc=CompleteAbbre
-        let s:word_code = '<,k>|code'
+        let s:word_code = s:dict_key['code'] 
+        hi User1 ctermfg=gray ctermbg=4
     elseif &completefunc == 'CompleteAbbre'
-        set completefunc=LineCompleteFromFile
-        let s:word_code = '<,k>|word'
+        "set completefunc=LineCompleteFromFile
+        set completefunc=LineNew
+        let s:word_code = s:dict_key['word'] 
+        hi User1 ctermfg=red ctermbg=0
     endif
     "call setpos(".", l:pos)
 
@@ -269,31 +333,141 @@ endfunction
 " 2. Grep all text from the file and insern to list
 " 3. Insert the text to quickfix with flag [j] since line completion only works in loaded buffer[why]
 " 4. Match the string with completefunc
+"function! LineCompleteFromFile(findstart,base)
+    "if a:findstart
+        "" column to begin searching from (first non-whitespace column):
+        
+	    "let line = getline('.')
+        "let init_col = col('.')
+	    "let start = col('.') - 1
+
+	    "while start > 0 && line[start - 1] =~ '\S'
+	      "let start -= 1
+	    "endwhile
+
+        "let list = split(strpart(line, 0, init_col-1), '\s\+')
+        "let index = len(list) - 1 
+        "while index >= 0 
+            "let index -= 1
+        "endwhile
+
+        "" return  [  bin_] => 2
+	    "return start
+    "else
+        "let l:path = '/Users/cat/myfile/github/vim/myword.utf-8.add'
+        "let matches = []
+
+        "for phrase in readfile(l:path)
+            "if phrase =~ '^' . a:base
+                "call add(matches, phrase)
+            "endif
+        "endfor
+
+        "return matches
+    "endif
+"endfunction
+
 function! LineCompleteFromFile(findstart,base)
+    "if a:findstart
+	    "return 3 
+    "else
+        "let matches = ['dog', 'cat', 'pig']
+        "return matches
+    "endif
+
     if a:findstart
-        " column to begin searching from (first non-whitespace column):
-        
+	    return 4 
+    else
+        let matches = []
+        call add(matches, 'dog')
+        return matches
+    endif
+endfunction
+
+let g:lineMatch = []
+function! LineNew(findstart,base)
+    let matches = []
+    if a:findstart
+	    let start = col('.') - 1
+        let list = LongestMatch()
+        if  len(list) > 1 
+            let start = list[1]
+            let g:lineMatch = list[3]
+        else
+            "-2 To cancel silently and stay in completion mode.[h complete-functions] 
+            let start = -2
+        endif
+	    return start 
+    else
+       "return  {
+        "\   'word': a:key,
+        "\   'menu': strpart(snipFormatted, 0, 80),
+        "\ } 
+        "return g:lineMatch 
+        let tmpMat = ['dog', 'cat']
+        "return {'word' : tmpMat, 'refresh', 'always'}
+        call add(g:lineMatch, {'word' : 'last word', 'menu': 'cool', 'abbr' : 'abbr_ las word'})
+        call add(g:lineMatch, {'word' : 'How to however', 'menu': 'However, this is cool stuff', 'abbr' : 'However'})
+	    return {'words': g:lineMatch, 'refresh': 'always'}
+
+    endif
+endfunc
+
+function! LongestMatch()
 	    let line = getline('.')
+        let init_col = col('.')
 	    let start = col('.') - 1
-	    while start > 0 && line[start - 1] =~ '\S'
-	      let start -= 1
-	    endwhile
+        if strlen(strpart(line, 0, init_col-1)) == 0
+            return [[]] 
+        endif
 
-        " return  [  bin_] => 2
-	    return start
-    else
-        let l:path = '/Users/cat/myfile/github/vim/myword.utf-8.add'
-        let matches = []
+        let list = split(strpart(line, 0, init_col-1), '\s\+')
+        let index = len(list) - 1 
+        let substr = ""
+        let min = -1 
+        let minIndex = -1 
+        let maxDist = ['', -1, -1]
+        let maxStr = ""
+        let matchPhrase= []
 
-        for phrase in readfile(l:path)
-            if phrase =~ '^' . a:base
-                call add(matches, phrase)
+        let l:path = '/Users/cat/myfile/github/vim/myword.utf-8.add'
+        "let l:path = '/Users/cat/myfile/github/vim/try.txt'
+        let keylist = readfile(l:path)
+        while index >= 0 
+            let str = list[index]
+            let long = 0
+            if substr == ""
+                let substr = str 
+            else
+                let substr = str .  '\s\+' . substr 
             endif
-        endfor
+            
+            for phrase in keylist 
+                let tmpList = matchstrpos(phrase, substr)
+                if tmpList[1] != -1
+                    if (tmpList[2] - tmpList[1]) > (maxDist[2] - maxDist[1])
+                        "call remove(matchPhrase, 0, -1)
+                        let matchPhrase = []
+                        call add(matchPhrase, phrase)
+                        let maxDist = tmpList 
+                    elseif (tmpList[2]-tmpList[1]) == (maxDist[2] - maxDist[1])
+                        call add(matchPhrase, phrase)
+                        let maxDist = tmpList 
+                    endif
+                endif
+            endfor
+            let index -= 1
+        endwhile
+
+        let biglist = [] 
+        if len(maxDist) > 0
+            let biglist = matchstrpos(line, maxDist[0])
+        endif
+
+        call add(biglist, matchPhrase)
+        return biglist 
+endfunc
 
-        return matches
-    endif
-endfunction
 "---------------------------------------------------------------------
 
 "inoremap . .<C-X><C-U>
@@ -502,1587 +676,4 @@ func! FoldJavaMethod()
 endfunc
 
 
-" ================================================================================ 
-" copy method code with <leader>c 
-" -------------------------------------------------------------------------------- 
-func! CopyJavaMethod()
-        let l:list = JavaMethodScope()
-        exec list[0] . ','  l:list[1] . 'y' 
-endfunc
-
-func! CountOpenBracket(line)
-    let l:count = 0
-    let l:index = 0
-    while l:index < strlen(a:line)
-        if a:line[l:index] =~ '{'
-            let l:count +=1
-        endif
-        let l:index +=1
-    endwhile
-    return l:count
-endfunc
-
-func! CountCloseBracket(line)
-    let l:count = 0
-    let l:index = 0
-    while l:index < strlen(a:line)
-        if a:line[l:index] =~ '}'
-            let l:count +=1
-        endif
-        let l:index +=1
-    endwhile
-    return l:count
-endfunc
-" -------------------------------------------------------------------------------- 
-func! CompleteJava()
-        let l:javaClassName = ""
-        let l:path = ""
-        let l:line = getline('.')
-        let l:objList = []
-        let l:obj_instance = ""
-
-        if l:line[col('.') - 2] =~ '\.'
-            " str.{}
-            let substr = strpart(l:line, 0, col('.')-2)
-            let l:obj_instance =  matchstr(substr, '\w\+$')
-        elseif l:line[col('.')-2] =~ '\w'
-            " str.get{}
-            let l:objList = split(strpart(l:line, 0, col('.')-1), '\.')
-            echo l:objList
-            if len(l:objList) > 1
-                let l:obj_instance = l:objList[-2]
-            endif
-        endif
-
-        " str. -> str
-        " str.get -> [str, get]
-        let l:obj_type = FindType(l:obj_instance)
-        let l:classFileName = l:obj_type . '.java'
-        
-        let l:pathList = GetJavaImportPath()
-        for l:plist in l:pathList
-            let l:dirList = split(l:plist, '\.')
-            if len(l:dirList) > 1
-                if l:dirList[-1] =~ '*'
-                    call filter(l:dirList, 'v:val !~ "*"')
-                    let l:path = join(l:dirList, '/') 
-                else
-                    let l:path = join(l:dirList[0:len(l:dirList)-2], '/') 
-                    if l:obj_type =~ l:dirList[-1]
-                        let l:classFileName = l:dirList[-1] . '.java'
-                    endif
-                endif
-
-                let l:findCmd = 'find /Users/cat/myfile/github/Jsource/' . l:path . ' -name ' .  l:classFileName . ' -print'
-                let l:javaClassName = system(l:findCmd)
-
-                if strlen(l:javaClassName) > 0
-                    break
-                endif
-            endif
-        endfor
-        let l:javaClassName = substitute(l:javaClassName, '\n\+', '', '')
-
-        let l:newlist = GetMethod(l:javaClassName)
-
-        if len(l:objList) > 1
-            let l:mList = []
-            for item in l:newlist
-                if l:item =~ '^' . l:objList[-1]
-                    call add(l:mList, l:item)
-                endif
-            endfor
-
-            call complete(col(".") - strlen(l:objList[-1]), l:mList)
-        else
-            call complete(col("."), l:newlist)
-        endif
-
-        return ''
-endfunc
-
-fun! FindType(strbase)
-    let l:lnum = line(".")
-    let l:start = col('.')
-    let l:lineCount = 100 
-    let l:declareType = ""
-
-    let l:dotObj = matchstr(a:strbase, '\w\+', 0)
-
-    while l:lineCount > 0
-        let line = getline(l:lnum)
-
-        if strlen(l:dotObj) > 0
-            " [String str;]
-            let l:noInitTypePat = '\(\w\+\)\s\+' . l:dotObj . '\s*;' 
-            let l:noInitTypePatList = matchlist(line, l:noInitTypePat, 0) 
-
-            " [String str,] e.g. argument 
-            let l:argumentPat = '\w\+\s*<\s*\w\+\s*>\s*' . l:dotObj . '\s*,' 
-            let l:argumentPatList= matchlist(line, l:argumentPat, 0) 
-
-
-            " [String str = null;]
-            let l:noNewTypePat = '\(\w\+\)\s\+' . l:dotObj . '\s*=\s*\S\+\s*;' 
-            let l:noNewTypePatList = matchlist(line, l:noNewTypePat, 0) 
-
-            " [String str = new String('a')] 
-            let l:simpleTypePat = '\w\+\s\+' . l:dotObj . '\s*=\s*new\s*\(\w\+\)\s*(\p*)' 
-            let l:simpleTypePatList = matchlist(line, l:simpleTypePat, 0) 
-            
-            " [List<String> list = new ArrayList<String>();]
-            let l:complexTypePat = '\w\+\s*<\s*\w\+\s*>\s*' . l:dotObj . '\s*=\s*new\s*\(\w\+\)\s*<\s*\w\+\s*>\s*(\p*)'
-            let l:complexTypePatList = matchlist(line, l:complexTypePat)
-
-            " [Map<Integer, Integer> map = new HashMap<Integer, Integer>();] 
-            let l:mapTypePat = '\w\+\s*<\s*\w\+\s*,\s*\w\+\s*>\s*' . l:dotObj . '\s*=\s*new\s*\(\w\+\)\s*<\s*\w\+\s*,\s*\w\+\s*>\s*(\p*)'
-            let l:mapTypePatList = matchlist(line, l:mapTypePat)
-
-            if len(l:simpleTypePatList) > 1
-                let l:declareType = l:simpleTypePatList[1]
-                if strlen(l:declareType) > 0
-                    return l:declareType
-                endif
-            elseif  len(l:complexTypePatList) > 1
-                let l:declareType = l:complexTypePatList[1]
-                if strlen(l:declareType) > 0
-                    return l:declareType
-                endif
-            elseif len(l:mapTypePatList) > 1
-                let l:declareType = l:mapTypePatList[1]
-                if strlen(l:declareType) > 0
-                    return l:declareType
-                endif
-            elseif len(l:noNewTypePatList) > 1
-                let l:declareType = l:noNewTypePatList[1]
-                if strlen(l:declareType) > 0
-                    return l:declareType
-                endif
-            elseif len(l:noInitTypePatList) > 1
-                let l:declareType = l:noInitTypePatList[1]
-                if strlen(l:declareType) > 0
-                    return l:declareType
-                endif
-            elseif len(l:argumentPatList) > 1
-                let l:declareType = l:argumentPatList[1]
-                if strlen(l:declareType) > 0
-                    return l:declareType
-                endif
-            endif
-        endif
-
-        let l:lineCount -= 1
-        let l:lnum -= 1 
-    endwhile
-
-    return l:declareType
-endfunc
-
-function! GetJavaImportPath()
-        let l:retList = []
-        " Java default package: import java.lang.*
-        call add(l:retList, 'java.lang.*')
-        let l:count = 1 
-        let l:lastNum = 10 
-        while l:count < l:lastNum 
-            let l:line = getline(l:count)
-                            
-            let l:list = matchlist(l:line, '\(import\)\s\+\([a-zA-Z0-9\*\._]\+\)\s*;')
-
-            "let l:list = matchlist(l:line, '\(import\)\s*\([a-zA-Z$_][a-zA-Z0-9$]*\)')
-            if len(l:list) > 0
-                if len(l:list[1]) > 0 && len(l:list[2]) > 0
-                    call add(l:retList, l:list[2])
-                endif
-            endif
-            let l:count += 1
-        endwhile
-        return l:retList
-endfunc
-
-
-
-function! GetMethod(fname)
-    let list = []
-    let mpat = '\(public\)\s\+\(static\)\?\s*\(\p\+\)\s\+\(\w\+\)(\(\p\|\s\)*)\s*'
-    let l:methodPattern = '\(\w\+\s*([^)]*)\)'
-
-    for line in readfile(a:fname)
-        let str = matchstr(line, mpat, 0)
-        let methodList = matchlist(str, l:methodPattern, 0) 
-        if len(methodList) > 0
-            if len(methodList[0]) > 0 
-                call add(list, methodList[0])
-            endif
-        endif
-    endfor
-    return sort(list)
-endfunc
-
-"inoremap <F6> <C-R>=ListMonths()<CR>
-func! ListMonths()
-  call complete(col('.'), ['January', 'February', 'March',
-    \ 'April', 'May', 'June', 'July', 'August', 'September',
-    \ 'October', 'November', 'December'])
-  return ''
-endfunc
-
-"fun! CompleteMonths(findstart, base)
-"	  if a:findstart
-"	    " locate the start of the word
-"	    let line = getline('.')
-"	    let start = col('.') - 1
-"	    while start > 0 && line[start - 1] =~ '\a'
-"	      let start -= 1
-"	    endwhile
-"	    return start
-"	  else
-"	    " find months matching with "a:base"
-"       " Jan<- is a:base, current word under the cursor
-"        let matches = split("cat dog cow")
-"        let dict   = {}
-"        "let word   = {'word':'myword', 'abbr':'myabbr'}
-"        "let word   = {'word':'myword', 'abbr':'myabbr', 'menu':'mymenu\n menu1 \n menu2', 'info':'myinfo'}
-"        let word   = {'word':'myword', 'abbr':'myabbr', 'menu': "mymenu\n menu1 \n menu2"}
-"        let matches[1] = word
-"        let res    = []
-"	    for m in split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec")
-"            if m =~ '^' . a:base
-"                call add(res, m)
-"                let dict = {'words': matches, 'refresh': 'always'}
-"            endif
-"        endfor
-"	    "return res
-"        return dict
-"	  endif
-"endfun
-"set completefunc=CompleteMonths
-"
-
-" -----------------------------------------------------------------------------
-" Read vimrc file and capture all the iabbr, store it in a list
-" Usage: type prefix<C-X><C-U>
-" Ref: http://vi.stackexchange.com/questions/7750/how-to-manage-and-remember-many-abbreviations-in-my-vimrc/7763#7763
-" -----------------------------------------------------------------------------
-function! CaptureCmd(excmd)
-    let l:abbList = []
-    redir=> l:result
-    :silent exec a:excmd
-    redir END
-    let l:list = split(l:result, '\n')
-    for item in l:list
-        call substitute(item, '^\s*[ic]\s\+\(\S\+\)\s\+', '\=add(abbList, submatch(1))', 'g')
-    endfor
-
-    return l:abbList
-endfunc
-
-function! GetAbbreviation()
-    let abbrev_list = []
-    call substitute(join(readfile($MYVIMRC), "\n"), '\s*iabbr\s\+\(<expr>\|<buffer>\)\?\s*\(\S\+\)', '\=add(abbrev_list, submatch(2))', 'g')
-    return abbrev_list
-endfunc
-
-function! CompleteAbbre(findstart, base)
-    if a:findstart
-        " locate the start of the word
-        let line = getline('.')
-        let l:start = col('.') - 1
-        while l:start > 0 && (line[l:start - 1] =~ '\a')
-            let l:start -= 1
-        endwhile
-
-        return l:start
-    else
-        " find classes matching "a:base"
-        " let l:abbmatch = GetAbbreviation()
-        let l:abbmatch = CaptureCmd("iab")
-        let res = []
-        for m in l:abbmatch
-            if m =~ '^' . a:base
-            "if m =~ a:base
-                call add(res, m)
-            endif
-        endfor
-        return sort(res)
-    endif
-endfun
-" -----------------------------------------------------------------------------
-" end
-" -----------------------------------------------------------------------------
-
-map _in :call IncreaseColor() <CR>
-let g:buffermanage = 1
-"noremap <F5>  :call ToggleBufMag() <CR>
-"map <F6> :call CloseBufferManager() <CR>
-
-map <leader>s :nohlsearch <CR>
-" prefix <CR> to a line, remove highlight search
-
-"imap <leader>n :.,.s/^\S.*$/\0<br>/gc <bar> :nohlsearch <CR>
-
-"imap <Esc> ww :w! <CR>
-"map  ww :w! <CR>
-" ref: http://vim.wikia.com/wiki/Map_Ctrl-S_to_save_current_or_new_files
-:noremap  <F1> :w!<CR>
-:inoremap <F1> <ESC>:w!<CR>
-"------------------------------------------------------------------
-" vimrc file
-"------------------------------------------------------------------
-" copy current lines to clipboard
-" Note: DON NOT put <CR> at the end of line, otherwise cursor will goto next line
-"------------------------------------------------------------------
-cabbr kk .g/\S*\%#\S*/y <bar> let @*=@" 
-cabbr sv :source /Users/cat/myfile/github/vim/vim.vimrc <bar> :tabdo e! 
-cabbr ev :tabe /Users/cat/myfile/github/vim/vim.vimrc
-cabbr eb :tabe ~/.bashrc
-cabbr ep :tabnew /etc/profile 
-cabbr mk :mksession! $sess                                  " save vim session
-cabbr qn :tabe /Users/cat/myfile/github/quicknote/quicknote.txt " quick node
-cabbr mm :marks
-
-cabbr Wo :tabe /Users/cat/myfile/github/vim/myword.utf-8.add    " My words file
-cabbr Tiny :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome  tiny3.com  -incongnito 
-cabbr Res :!open /Users/cat/GoogleDrive/NewResume/aronsitu00resume.pdf     
-cabbr Sni :tabnew $g/snippets/objectivec.m 
-cabbr Sty :%!astyle --style=java 
-cabbr Esty :tabe /Library/WebServer/Documents/zsurface/style.css
-cabbr Enote :tabe /Library/WebServer/Documents/zsurface/html/indexDailyNote.html
-cabbr Evimt :tabe /Library/WebServer/Documents/zsurface/html/indexVimTricks.html
-cabbr Eng :tabe /Library/WebServer/Documents/zsurface/html/indexEnglishNote.html  
-cabbr Ec :tabe /Library/WebServer/Documents/zsurface/html/indexCommandLineTricks.html  
-cabbr Ep  :tabnew /Users/cat/myfile/vimprivate/private.vimrc
-cabbr FF  :call JavaComment() <CR> 
-cabbr No  :tabnew /Library/WebServer/Documents/tiny3/noteindex.txt 
-cabbr Job :tabnew /Users/cat/GoogleDrive/job/recruiter_email.txt 
-cabbr Ky :let @*=expand("%:p")
-cabbr Tz :!/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal /bin/zsh & <CR>
-cabbr Tf :!/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal /bin/fish & <CR>
-cabbr Tb :!/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal /bin/bash & <CR>
-
-
-noremap  <leader>k :call ToggleCompletefunc()<CR>
-inoremap <leader>k <C-R>=ToggleCompletefunc()<CR>
-
-"map <leader>n  :b #<CR>
-    
-
-" not a good idea to save file with timer. use CursorHoldI instread
-"cabbr Tt :call StartTimer() <CR>
-"cabbr Ts :call timer_stop(gtimer) <CR>
-
-
-" command line mode
-"-----------------------------------------------------------------
-" multiple command in map
-" cmap ss :.,$s///gc
-" one line loop command
-" cmap loo let x=line(".") <bar> let c = x <bar> while(c < x + 10) <bar> echo getline(c) <bar> let c = c + 1 <bar> endwhile
-" append [x] to the end of line
-" cmap app let x = 0 <bar> g/$/s//\='[' . x . ']'/ <bar> let x = x + 1
-
-" visual word, select word under cursor and do something about it
-:cmap SS .,$s/<C-R><C-W>//gc
-:cmap BB s/<C-R><C-W>/\[\0\]/ <CR> 
-
-:cmap SV vim /<C-R><C-W>/ **/*.m
-:cmap White /\S\zs\s\+$
-"-----------------------------------------------------------------
-
-"------------------------------------------------------------------
-" vim function mapping
-"------------------------------------------------------------------
-cabbr bufm :call ToggleBufferManager() <CR>
-cabbr pl   :call ListTabPage() <CR>
-"------------------------------------------------------------------
-
-" Add block code to noteindex file
-autocmd BufEnter *.txt iabbr <buffer> bl [ ]
-                                    \<CR>`[
-                                    \<CR>
-                                    \<CR>`]
-
-
-" -------------------------------------------------------------------------------- 
-" Color the noteindex.txt file
-" 
-" Mon Aug 15 23:16:54 PDT 2016
-" It is very slow when the all the regex is enabled so disable it for now
-" autocmd BufEnter * if @% == 'noteindex.txt' | :call NoteColor() | endif 
-
-
-"-------------------------------------------------------------------------------- 
-" Fri Aug 12 13:50:59 PDT 2016
-" Vim is very slow if VimEnter is enabled here
-" autocmd VimEnter * :call RunSnippet() 
-"-------------------------------------------------------------------------------- 
-
-" disable it temporally 
-" autocmd BufEnter,BufRead * :call SourceSnippet() 
-"autocmd VimEnter *.h,*.m :call RunSnippet() 
-"autocmd BufEnter,BufRead *.h,*.m :call SourceSnippet() 
-
-" repeating 80 characters 
-"===============================================================================
-autocmd BufEnter * iabbr <expr> r= "// ".'<C-o>80i=<Esc>' . "<CR>"  
-autocmd BufEnter * iabbr <expr> r- "// ".'<C-o>80i-<Esc>' . "<CR>"
-"-------------------------------------------------------------------------------
-
-"map ,,  :.,$s/\S.*\S/\0\<br>/gc <bar> :nohlsearch <CR>
-"autocmd BufEnter *.vimrc map <buffer> <leader>n :.,$s/\S.*\S/\0\<CR\>/gc <bar> :nohlsearch <CR>
-"autocmd BufEnter *.html  map <buffer> <leader>n :.,$s/\S.*\S/\0\<br\>/gc <bar> :nohlsearch <CR>
-"autocmd BufEnter *.tex   map <buffer>  :.,$s/\S.*\S/\0\/\//gc <bar> :nohlsearch <CR>
-
-"map ,l  :.,.s/\S.*\S$/\\[ \0 \\]/gc <bar> :nohlsearch <CR>
-"map <leader>,  :.,$s/\S.*\S/\0\<br>/gc <bar> :nohlsearch <CR>
-
-" switch buffer
-map <leader>n  :b #<CR>
-
-
-augroup Java
-au!
-
-
-
-" Move the cursor to the beginning of the line
-autocmd BufEnter *.java iabbr <expr> jprr_system_out_println 'System.out.println(xxx)' . "\<Esc>" . "^" . ":.,.s/xxx/i/gc" . "<CR>"
-                                                    
-autocmd BufEnter *.java iabbr <expr> forr_one_for_loop 'for(int xxx=0; xxx<10; xxx++){
-                                         \<CR>}' . "\<Esc>" . "1k" . "^". ":.,.s/xxx/i/gc" . "<CR>"
-
-autocmd BufEnter *.java iabbr <expr> for2_two_for_loop 'for(int xxx=0; xxx < 9; xxx++){
-                                      \<CR>for(int xxx=0; xxx < 9; xxx++){
-                                      \<CR>}
-                                      \<CR>}' . "\<Esc>" . "3k" . "^" . ":.,.s/xxx/i/gc" . "<CR>"
-
-
-
-autocmd BufEnter *.java iabbr <expr> jim 'import java.io.*;
-                                 \<CR>import java.lang.String;
-                                 \<CR>import java.util.*;' . "\<Esc>" . "^"
-
-autocmd BufEnter *.java iabbr <expr> jl 'List<String> list = new ArrayList<String>();' . "\<Esc>" . "^" . ":.,.s/String/Integer/gc" . "<CR>"
-
-autocmd BufEnter *.java iabbr <expr> jm_HashMap 'Map<String, Integer> map = new HashMap<String, Integer>();' . "\<Esc>" . "^"
-autocmd BufEnter *.java iabbr <expr> jll_ListOfList 'ArrayList<ArrayList<String>> list2d = new ArrayList<ArrayList<String>>();' . "\<Esc>" . "^"
-         
-augroup END
-
-"------------------------------------------------------------------
-" all shell script snippet
-" augroup Shell begin
-"------------------------------------------------------------------
-augroup Shell
-au!
-autocmd BufEnter *.sh iabbr <buffer> forr 'for i in
-                                    \<CR>do
-                                    \<CR>echo "$i"
-                                    \<CR>done'. "\<Esc>" . "2h"
-
-autocmd BufEnter *.sh iabbr <buffer>   iff 'if [ $# -gt 0 ]; then
-                                    \<CR>echo "arg $1"
-                                    \<CR>if [ $1 = "w" ]; then
-                                    \<CR>echo "do sth"
-                                    \<CR>elif [ $1 = "t" ]; then
-                                    \<CR>echo "do other sth"
-                                    \<CR>fi
-                                    \<CR>else
-                                    \<CR>echo "Usage"
-                                    \<CR>fi' . "\<Esc>" . "2h"
-
-
-
-
-"------------------------------------------------------------------
-" augroup Shell End
-"------------------------------------------------------------------
-
-"------------------------------------------------------------------
-" cpp mapping, compile cpp, compile g++, cpp compile
-"------------------------------------------------------------------
-
-"autocmd BufEnter *.cpp  set makeprg=g++\ -std=c++11\ %:p
-"autocmd BufWritePost *.cpp  g++ -std=c++11 %:p <bar> :silent :! %:p:r <CR>
-
-" work
-"autocmd filetype cpp nnoremap <F9> :w <bar> exec '!g++ -std=c++11 '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
-
-
-"au BufEnter *.cpp set makeprg=g++\ -g\ %\ -o\ %< 
-"au BufEnter *.c set makeprg=gcc\ -g\ %\ -o\ %< 
-"au BufEnter *.py set makeprg=python\ % 
-"map <F9> :call CompileGcc()<CR>
-"func! CompileGcc()
-"    silent make
-"endfunc
-"
-
-
-
-
-"------------------------------------------------------------------
-" placeholders mapping
-" ref: http://vim.wikia.com/wiki/Text_template_with_placeholders
-" placeholder holder
-"------------------------------------------------------------------
-":imap <buffer> <leader>m <C-O>mzfor( %%%; %%%; %%%)<CR>{ // %%%<CR>%%%<CR>}<CR><C-O>'z;;
-":imap <buffer> <leader>n <C-O>/%%%<CR><C-O>c3l
-":nmap <buffer> <leader>k /%%%<CR>c3l
-"---------------------------------------------------------------
-
-autocmd BufEnter  *.html :hi Error term=reverse ctermfg=none ctermbg=none
-
-"-------------------------------------------------------------------------------- 
-" redirect output shell commands to scratch buffer
-" gx: http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window 
-"-------------------------------------------------------------------------------- 
-command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
-function! s:ExecuteInShell(command)
-  let command = join(map(split(a:command), 'expand(v:val)'))
-  let winnr = bufwinnr('^' . command . '$')
-  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
-  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
-  echo 'Execute ' . command . '...'
-  silent! execute 'silent %!'. command
-  silent! execute 'resize ' . line('$')
-  silent! redraw
-  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
-  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
-  echo 'Shell command ' . command . ' executed.'
-endfunction
-
-
-"-----------------------------------------------------------------
-" get definition from dict.org and redirect to tab 
-"-----------------------------------------------------------------
-function! Dict()
-    let dict_output = system("curl dict://dict.org/d:" . expand("<cword>"))
-    tabnew
-    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
-    silent put=dict_output
-endfunc
-
-
-"-----------------------------------------------------------------
-" redirect Ex command to tab file
-"-----------------------------------------------------------------
-function! TabMessage(cmd)
-redir => message
-silent execute a:cmd
-redir END
-if empty(message)
-echoerr "no output"
-else
-" use [new] instead of [tabnew] below if you prefer split windows instead of tabs
-tabnew
-setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
-silent put=message
-endif
-endfunction
-
-command! -nargs=+ -complete=command Rd call TabMessage(<q-args>)
-" use scratch buffer
-command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
-"-----------------------------------------------------------------
-
-"------------------------------------------------------------------
-" placeholders mapping
-" ref: http://vim.wikia.com/wiki/Simple_placeholders
-" Enable and disable augroup
-" map to <F6>
-"------------------------------------------------------------------
-function! ToggleBracketGroup()
-if empty(maparg('(', 'i'))
-    echo "imap: <c-j> ( [ { $ #"
-        inoremap <buffer> <c-j> <Esc>/<++><CR><Esc>cf>
-        inoremap <buffer> ( ()<++><Esc>F)i
-        inoremap <buffer> [ []<++><Esc>F]i
-        inoremap <buffer> { {}<++><Esc>F}i
-        inoremap <buffer> $ $$<++><Esc>F$i
-        inoremap <buffer> # \[ \\]<++><++><Esc>F\i
-
-else
-     echo "iummap: <c-j> ( [ { $ #"
-     iunmap <buffer> <c-j>
-     iunmap <buffer> (
-     iunmap <buffer> [
-     iunmap <buffer> {
-     iunmap <buffer> $
-     iunmap <buffer> #
-endif
-endfunction
-
-" Check whether placeholder is enable or not
-fun! CheckToggleBracketGroup()
-if(empty(maparg('(', 'i')))
-    return "-"
-else
-    return "{}"
-endif 
-endfun
-
-augroup Latex
-au!
-
-" -------------------------------------------------------------------------------- 
-" gf http://tex.stackexchange.com/questions/62182/shortcut-for-inserting-matching-endsomething-in-vim 
-" add \begin{environment} \end{environment}
-" Y=>yank link p=> paste to next line k => goto current+1 line I => goto beginning of line
-" A=> goto the end of line
-map  <C-B>      YpkI\begin{<ESC>A}<ESC>jI\end{<ESC>A}<esc>kA
-map! <C-B> <ESC>YpkI\begin{<ESC>A}<ESC>jI\end{<ESC>A}<esc>kA
-
-" Call Chrome from command line with url
-" Pass url to Chrome in command line
-
-autocmd BufEnter  *.tex,*.html cabbr Lexample :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome http://zsurface.com/html/indexLatexExample.html -incongnito <CR>
-autocmd BufEnter  *.tex,*.html cabbr Greek   :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome http://zsurface.com/image/greek1.png -incongnito <CR>
-autocmd BufEnter  *.tex,*.html cabbr Font    :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome http://zsurface.com/image/latexfont.png -incongnito <CR>
-autocmd BufEnter  *.vimrc,*.html cabbr Color :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome https://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg<CR>
-autocmd BufEnter  *.vimrc,*.html,*.tex cabbr Mat   :!/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome  http://localhost/zsurface/html/indexLatexMatrix.html<CR>
-
-autocmd BufEnter *.tex cabbr ln :tabe /Users/cat/myfile/github/math/latexnote.tex
-
-"autocmd BufEnter *.tex cabbr ee :.,$s/\S.*\S/\\\[ \0\ \\\]/gc <bar> :nohlsearch <CR>
-"autocmd BufEnter *.tex cabbr ed :.,$s/\S.*\S/\$\0\$/gc <bar> :nohlsearch <CR>
-
-autocmd BufEnter *.tex map   <buffer> <leader>, :.,$s/\S.*\S/\0\ \\\\/gc <bar> :nohlsearch <CR>
-
-autocmd BufEnter *.tex,*.html iabbr <buffer> nl \newline <CR>
-autocmd BufEnter *.tex,*.html iabbr <buffer> bc \mathbb{C}
-autocmd BufEnter *.tex,*.html iabbr <buffer> bq \mathbb{Q}
-autocmd BufEnter *.tex,*.html iabbr <buffer> bn \mathbb{N}
-autocmd BufEnter *.tex,*.html iabbr <buffer> br \mathbb{R}
-autocmd BufEnter *.tex,*.html iabbr <buffer> gro   $(\mathbb{N}, +)$
-autocmd BufEnter *.tex,*.html iabbr <buffer> grtau $\Huge \color{red}\tau$
-autocmd BufEnter *.tex,*.html iabbr <buffer> lmapq $\phi: \mathbb{Q} \rightarrow \mathbb{Q}$
-autocmd BufEnter *.tex,*.html iabbr <buffer> lmapr $\phi: \polyringr{x} \rightarrow  \polyringr{x}$
-autocmd BufEnter *.tex,*.html iabbr <buffer> lmapn $\phi: \polyringn{x} \rightarrow  \polyringn{x}$
-autocmd BufEnter *.tex,*.html iabbr <buffer> lmapc $\phi: \mathbb{C} \rightarrow \mathbb{C}$
-autocmd BufEnter *.tex,*.html iabbr <buffer> mdet \det (\mathbf{A} - \lambda \mathbf{I}) = 0
-autocmd BufEnter *.tex,*.html iabbr <buffer> deta \det (\mathbf{A})
-autocmd BufEnter *.tex,*.html iabbr <buffer> detb \det (\mathbf{B})
-autocmd BufEnter *.tex,*.html iabbr <buffer> detc \det (\mathbf{C}) 
-autocmd BufEnter *.tex,*.html iabbr <buffer> ast  ^{\ast} 
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfa  \mathbf{A} 
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfai \mathbf{A^{\ast}} 
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfaa $\mathbf{A}$ 
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfb  \mathbf{B} 
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfbi \mathbf{B^{\ast}} 
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfbb $\mathbf{B}$
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfc  \mathbf{C}
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfci \mathbf{C^{\ast}}
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfcc $\mathbf{C}$
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfq  \mathbf{Q}
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfqq $\mathbf{Q}$
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfp  \mathbf{P}
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfpi \mathbf{P^{\ast}}
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfpp $\mathbf{P}$
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfi  \mathbf{I}
-autocmd BufEnter *.tex,*.html iabbr <buffer> bfii $\mathbf{I}$
-autocmd BufEnter *.tex,*.html iabbr <buffer> bb \[ \]
-autocmd BufEnter *.tex,*.html iabbr <buffer> dd $ $
-autocmd BufEnter *.tex,*.html iabbr <buffer> noi \setlength\parindent{0pt}
-
-" visual mode substitute or select mode, selection mode, highlight
-autocmd BufEnter *.tex,*.html vmap  mbf  :s/\%V.*\%V/\\mathbf{\0}/ <CR>
-autocmd BufEnter *.tex,*.html vmap  mbf$ :s/\%V.*\%V/$\\mathbf{\0}$/ <CR>
-autocmd BufEnter *.tex,*.html vmap  tbf  :s/\%V.*\%V/\\textbf{\0}/ <CR>
-autocmd BufEnter *.tex,*.html vmap  tbf$ :s/\%V.*\%V/$\\textbf{\0}$/ <CR>
-autocmd BufEnter *.tex,*.html vmap  0$ :s/\%V\S.*\S\%V/$\0$/ <CR>
-autocmd BufEnter *.tex,*.html vmap  1$ :s/\%V$\%V//gc <CR>
-autocmd BufEnter *.tex,*.html vmap  0[ :s/\%V\S.*\S\%V/\\[ \0 \\]/ <CR>
-
-" -------------------------------------------------------------------------------- 
-" enclose with bracket
-"  x => $x$
-" not very useful so far
-"autocmd BufEnter *.tex,*.html cabbr <buffer> 0$ :s/\k*\%#\k*/$\0$/ <bar> :nohlsearch <CR>
-
-" exec to normal mode :exec "normal! 3k"
-autocmd BufEnter *.tex,*.html cabbr <buffer> 00$ :.s/\(^\s*\)\(\S.*\S\)/\1$\2\$/ <bar> :nohlsearch <bar> :exec "normal! 1k0" <CR>
-autocmd BufEnter *.tex,*.html iabbr <buffer> fra  \frac{}{}<ESC>F{
-autocmd BufEnter *.tex,*.html cabbr <buffer> 0( :s/\\\S\+/(\0)/gc <bar> :nohlsearch <CR>
-
-" my file => \mbox{my file}
-autocmd BufEnter *.tex,*.html cabbr <buffer> 0b  :.s/\(^\s*\)\(\S.*\S\)/\1\\mbox{\2\}/gc <bar> :nohlsearch <CR>
-autocmd BufEnter *.tex,*.html cabbr <buffer> 0{ :s/\\\S\+/{\0}/gc <bar> :nohlsearch <CR>
-
-" select block code and enclose with brackets [:h \%V]
-" autocmd BufEnter *.tex,*.html vmap  ii :s/\%V\_.*\%V/\\[\0\\]/ <CR>
-" apparently :s/\%V\_.*\%V/\\[\0\\]/ put double pair of brackets, not sure why
-" -------------------------------------------------------------------------------- 
-autocmd BufEnter *.tex,*.html vmap  1[ :s/\%V\_.*\%V/\\[ \0 \\]/gc <CR>
-" -------------------------------------------------------------------------------- 
-
-" -------------------------------------------------------------------------------- 
-" remove \[ \] from selected code
-" -------------------------------------------------------------------------------- 
-autocmd BufEnter *.tex,*.html vmap  x[ :s/\%V\\\]\\|\\\[\%V// <CR>
-autocmd BufEnter *.tex,*.html vmap  0b :s/\%V.*\%V/\\mbox{\0}/ <CR>
-
-
-" summary notation
-autocmd BufEnter *.tex,*.html iabbr <buffer> summ s = \sum_{k=0}^{\infty} \frac{1}{k}
-"autocmd BufEnter *.tex,*.html iabbr <buffer> tee \[ \text{} \]
-autocmd BufEnter *.tex,*.html iabbr <buffer> boo \[ \mbox{ } \]
-autocmd BufEnter *.tex,*.html iabbr <buffer> box \mbox{ }
-autocmd BufEnter *.tex,*.html iabbr <buffer> lr( \left( \right)
-autocmd BufEnter *.tex,*.html iabbr <buffer> lr[ \left[ \right]
-autocmd BufEnter *.tex,*.html iabbr <buffer> lr{ \left{ \right}
-autocmd BufEnter *.tex,*.html iabbr <buffer> lr< \left< \right>
-autocmd BufEnter *.tex,*.html iabbr <buffer> inn \left< \vec{u} \,, \vec{v} \right>
-autocmd BufEnter *.tex,*.html iabbr <buffer> sq  \sqrt{a + b}
-
-autocmd BufEnter *.tex,*.html iabbr <buffer> ctc $\phi: \mathbb{C} \rightarrow \mathbb{C}$
-autocmd BufEnter *.tex,*.html iabbr <buffer> qtc $\phi: \mathbb{Q} \rightarrow \mathbb{Q}$
-autocmd BufEnter *.tex,*.html iabbr <buffer> por $\phi: \polyringr{x} \rightarrow  \polyringr{x}$
-
-autocmd BufEnter *.tex,*.html iabbr <buffer> gro $(\mathbb{N}, +)$
-
-augroup END
-
-"------------------------------------------------------------------
-"latex end
-"------------------------------------------------------------------
-
-
-" searchkey
-iabbr skk // searchkey:
-
-"map <leader>,  :.,$s/\S.*\S/\0\<br>/gc <bar> :nohlsearch <CR>
-
-autocmd BufEnter *.html map   <buffer> <leader>, :.,$s/\S.*\S/\0\<br>/gc <bar> :nohlsearch <CR>
-
-autocmd BufEnter *.html vmap  <buffer> span :s/\%V.*\%V/<span class="wbold">\0<\/span>/ <CR>
-autocmd BufEnter *.html vmap  <buffer> bo :s/\%V.*\%V/<span class="bo">\0<\/span>/ <CR>
-autocmd BufEnter *.html vmap  <buffer> cmd  :s/\%V.*\%V/<span class="cmd">\0<\/span>/ <CR>
-autocmd BufEnter *.html vmap  <buffer> sou  :s/\%V.*\%V/<span class="source">\0<\/span>/ <CR>
-autocmd BufEnter *.html cmap  <buffer> Cmd  :s/\S*\%#\S*/<span class="cmd">\0<\/span>/ <CR>
-autocmd BufEnter *.java,*.h,*.c,*.cpp,*.vimrc vmap  <buffer> str  :s/\%V.*\%V/"\0"/ <CR>
-
-autocmd BufEnter *.html iabbr <buffer> ioss <div class="mytitle">
-                                            \<CR>My Title
-                                            \<CR></div>
-                                            \<CR><div class="mytext">
-                                            \<CR>The App shows how to use simple animation on iPhone.<br>
-                                            \<CR>1. Load images to array<br>
-                                            \<CR></div><br>
-                                            \<CR><div class="cen">
-                                            \<CR><img src="http://localhost/zsurface/image/kkk.png" width="40%" height="40%" /><br>
-                                            \<CR><a href="https://github.com/bsdshell/xcode/tree/master/OneRotateBlockApp">Source Code</a>
-                                            \<CR></div>
-
-autocmd BufEnter *.html iabbr <buffer> myw <div class="mytitle">
-                                        \<CR>Find the maximum Height of a Binary Tree
-                                        \<CR></div>
-                                        \<CR><div class="mytext">
-                                        \<CR>The height of binary tree is the maximum distance from the root to the children<br>
-                                        \<CR></div>
-
-" escape single quote
-autocmd BufEnter *.html iabbr <buffer> tipp <!-- begin tooltip-wrap-->
-                    \<CR><div class="tooltip-wrap">
-                    \<CR>$$\textbf{sqare root}$$
-                    \<CR>\[
-                    \<CR>\sqrt{x}
-                    \<CR>\]
-                    \<CR><div class="tooltip-content">
-                    \<CR><div class="tex2jax_ignore">
-                    \<CR><pre class="lbox" onClick="clip(document.getElementById('copy23'));" id="copy23">
-                    \<CR>\sqrt{x}
-                    \<CR></pre>
-                    \<CR></div>
-                    \<CR></div>
-                    \<CR></div>
-                    \<CR><!-- end tooltip-wrap-->
-
-autocmd BufEnter *.html iabbr <buffer> cml <p><CR>$\Large \color{red}\lambda$
-        \<CR>Rename file name of default screenshots in Mac OSX, Open your Terminal and type:<br><br>
-        \<CR><span style="color:#FFF; background:#000;border-radius:3px; padding:2px;">
-        \<CR>defaults write com.apple.screencapture name "myName"<br>
-        \<CR></span><br>
-        \<CR>And type:<br><br>
-        \<CR><span style="color:#FFF; background:#000;border-radius:3px; padding:2px;">
-        \<CR>killall SystemUIServer
-        \<CR></span>
-        \<CR></p>
-
-" -------------------------------------------------------------------------------- 
-" latexmk  -pdf => output pdf file
-" -------------------------------------------------------------------------------- 
-autocmd BufEnter *.tex  map  <F9> :call CompileLatex()<CR>
-autocmd BufEnter *.cpp  map  <F9> :call CompileCpp()<CR>
-" -------------------------------------------------------------------------------- 
-" check for error in Tex file
-autocmd BufEnter *.tex  map  <leader><F9> :w! <bar> :!pdflatex %:p <CR>:!open %:p:r.pdf <CR>
-
-"autocmd BufEnter tex map  <F10> :!pdflatex % <CR> :!open -a /Applications/Adobe\ Acrobat\ Reader\ DC.app/Contents/MacOS/AdobeReader %<.pdf <CR>
-"autocmd BufEnter *.tex  map  <F9> :w! <bar> :!latexmk -pdf %:p <CR> :!asy %:p:r-*.asy <CR> :!open %:p:r.pdf <CR>
-"autocmd BufEnter *.tex  map  <F9> :w! <bar> :!latexmk -pdf -synctex=1 -file-line-error %:p <CR> :!asy %:p:r-*.asy <CR> :!open -a /Applications/Skim.app/Contents/MacOS/Skim %:p:r.pdf <CR>
-"autocmd BufEnter *.tex  map  <F9> :w! <bar> :!latexmk -pdf -file-line-error %:p <CR> :!asy %:p:r-*.asy <CR> :!open -a /Applications/Skim.app/Contents/MacOS/Skim %:p:r.pdf <CR>
-"autocmd BufEnter *.tex  map  <F9> :w! <bar> :!pdflatex %:p <CR> :!open -g %:p:r.pdf <CR> :wincmd p <CR> 
-autocmd BufEnter *.java map  <F9> :w! <bar> :!/Users/cat/myfile/script/jav.sh % <CR>
-autocmd BufEnter *.hs   map  <F9> :w! <bar> :!runhaskell % <CR>
-
-" save file and compile latex file
-"autocmd BufWritePost *.tex      :silent exec ':!pdflatex %:p ' | :!open %:p:r.pdf
-
-augroup commentcode
-au!
-
-" vimrc
-autocmd BufEnter *.vimrc vmap xx   :s/\%V\_^\%V/"/g <CR>
-autocmd BufEnter *.vimrc vmap xu   :s/\%V\_^\s*\zs"\%V//g <CR>
-
-" objectivec
-autocmd BufEnter *.m,*.h,*.java,*.cpp,*.c vmap  xx  :s/\%V\_^\%V/\/\//g <CR>
-autocmd BufEnter *.m,*.h,*.java,*.cpp,*.c vmap  xu  :s/\%V\_^\s*\zs\/\/\%V//g <CR>
-
-" tex
-autocmd BufEnter *.tex vmap  xx  :s/\%V\_^\%V/%/g <CR>
-autocmd BufEnter *.tex vmap  xu  :s/\%V\_^\s*\zs%\%V//g <CR>
-
-" haskell 
-autocmd BufEnter *.hs vmap  xx  :s/\%V\_^\%V/--/g <CR>
-autocmd BufEnter *.hs vmap  xu  :s/\%V\_^\s*\zs--\%V//g <CR>
-
-
-
-"-----------------------------------------------------------------
-" Haskell mapping
-" BufEnter is better than FileType, don't ask me why
-"-----------------------------------------------------------------
-
-
-"-----------------------------------------------------------------
-" Xcode mapping
-" BufEnter is better than FileType, don't ask me why
-"-----------------------------------------------------------------
-augroup Xcode
-au!
-
-" run CoreApp test cases from command line
-autocmd BufEnter *.m,*.h  map  <F9> :!/Users/cat/myfile/github/xcode/CoreApp/test.sh
-
-autocmd BufEnter *.m,*.h cabbr ttd :call Test(@")<CR>
-autocmd BufEnter *.m,*.h cabbr df  :call Defun()<CR>
-autocmd BufEnter *.m,*.h cabbr dv  :call DeVariable()<CR>
-autocmd BufEnter *.m,*.h cabbr ffu :call FindFun()<CR>
-autocmd BufEnter *.m,*.h cabbr ffr :call RemoveDuplicatedTabs()<CR>
-autocmd BufEnter *.m,*.h cabbr ww  :call HeaderSource()<CR>
-autocmd BufEnter *.m,*.h call XcodeColor()
-
-
-"autocmd BufEnter *.m,*.h iabbr <buffer> recc CGRect rect = CGRectMake(0, 0, 10, 10);
-"autocmd BufEnter *.m,*.h iabbr <buffer> pot  CGPoint point = CGPointMake(1, 2);
-"autocmd BufEnter *.m,*.h iabbr <buffer> caa  CAShapeLayer* myLayer = [CAShapeLayer layer];
-"autocmd BufEnter *.m,*.h iabbr <buffer> nsv  [NSValue valueWithCGPoint:point];
-"
-
-
-autocmd BufEnter *.m,*.h iabbr <buffer> debb AppDelegate* appDe = (AppDelegate*)[[UIApplication sharedApplication] delegate];
-                                        \<CR>NSLog(@"[%ld][%s]->", appDe.debugCount++, __PRETTY_FUNCTION__); 
-
-autocmd BufEnter *.m,*.h iabbr <buffer> pree NSLog(@"%s", __PRETTY_FUNCTION__);
-
-autocmd BufEnter *.m,*.h iabbr <buffer> forr for(int i=0; i<num; i++){
-                                      \<CR>}
-autocmd BufEnter *.m,*.h iabbr <buffer> forr2 'for(int i=0; i<num1; i++){
-                                            \<CR>for(int j=0; j<num2; j++){
-                                            \<CR>}
-                                        \<CR>}
-
-autocmd BufEnter *.m,*.h iabbr <buffer> arrm 'NSMutableArray* array = [[NSMutableArray alloc]init];
-
-autocmd BufEnter *.m,*.h iabbr xpp [path moveToPoint:CGPointMake(location.x, location.y)];
-        \<CR>[path addLineToPoint:CGPointMake(location.x + width, location.y)];
-        \<CR>[path addLineToPoint:CGPointMake(location.x + width, location.y + height)];
-        \<CR>[path addLineToPoint:CGPointMake(location.x, location.y + height)];
-        \<CR>[path addLineToPoint:CGPointMake(location.x, location.y)];
-
-autocmd BufEnter *.m,*.h iabbr <buffer> timm [NSTimer scheduledTimerWithTimeInterval:self.delayInterval
-        \<CR>target:self
-        \<CR>selector:@selector(suspendDisplay:)<CR>userInfo:nil<CR>repeats:NO];<CR><CR>-(void)suspendDisplay:(NSTimer*)timer{<CR>}
-
-autocmd BufEnter *.m,*.h iabbr <buffer> imav UIImageView* _imageView;
-                    \<CR>@property (nonatomic, retain) UIImageView* imageView;
-                    \<CR>@synthesize imageView = _imageView;
-                    \<CR>self.imageView = [[UIImageView alloc]initWithFrame:self.window.bounds];
-                    \<CR>self.imageView.image=[UIImage imageNamed:@"myimage.jpg"];
-                    \<CR>[self.window addSubview:self.imageView];
-
-autocmd BufEnter *.m,*.h iabbr <buffer> labb UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 300, 300)];
-                    \<CR>[myLabel setTextColor:[UIColor redColor]];
-                    \<CR>[myLabel setBackgroundColor:[UIColor clearColor]];
-                    \<CR>[myLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
-                    \<CR>[myLabel setText:@"Supper Simple Application"];
-                    \<CR>[self.window addSubview:myLabel];
-
-     
-augroup END
-
-"-----------------------------------------------------------------
-" Save and restore current split windows
-"-----------------------------------------------------------------
-function! MaximizeToggle()
-  let s:tmpssop = &ssop
-  let s:tmphidden = &hidden
-  exec "set ssop-=" . 'tabpages'
-  exec "set ssop?"
-  if exists("s:maximize_session")
-    exec "source " . s:maximize_session
-    call delete(s:maximize_session)
-    unlet s:maximize_session
-    let &hidden=s:maximize_hidden_save
-    unlet s:maximize_hidden_save
-  else
-    let s:maximize_hidden_save = &hidden
-    let s:maximize_session = tempname()
-    set hidden
-    exec "mksession! " . s:maximize_session
-    only
-  endif
-  let &ssop = s:tmpssop
-  let &hidden = s:tmphidden
-  "exec "set ssop+=" . 'tabpages'
-endfunction
-"-----------------------------------------------------------------
-func! MyPath()
-     return '|' . expand("%:p:t") . '|'
-endfunc
-
-
-"-----------------------------------------------------------------
-" return short path from a given path
-"  input: /home/user/code
-" output: user/code
-
-func! ShortPath()
-     let retPath = expand("%:p:h")
-     let list = split(retPath, '/')
-     let len = len(list)
-     if len > 1
-         let retPath = list[len-2] . '/' . list[len-1]
-     endif
-     return '| ' . retPath . ' |'
-endfunc
-
-"-----------------------------------------------------------------
-" display git branch in statusline
-
-" func! GitBranch()
-"     let branch = system('git branch')
-"     let list = split(branch, "\n")
-"     let blist = []
-"     for bra in list
-"         if match(bra, '\* \w\+') != -1
-"             let blist = split(bra, " ")
-"         endif
-"     endfor
-"     if len(blist) > 1
-"         return "{" . blist[1] . "}"
-"     else
-"         return ""
-" endfunc
-
-"-----------------------------------------------------------------
-" map and unmap keys
-
-
-let g:keymap = 0
-func! MapKey()
-    if g:keymap == 0
-
-        let g:keymap = 1
-    else
-        :map <F7> <Nop>
-        :map <F8> <Nop>
-
-        :map <F1> <Nop>
-        :map <F2> <Nop>
-        :map <F3> <Nop>
-
-        :imap <F1> <Nop>
-        :imap <F2> <Nop>
-
-        :map <S-F10> <Nop>
-        :map <F4> <Nop>
-
-
-        echo "nunmap my key"
-
-        let g:keymap = 0
-    endif
-endfunc
-
-
-" searchkey: ctermfg ctermbg xterm color highlight
-func! XcodeColor()
-    syn match Property "\<_[a-zA-Z0-9]\+\>"
-    "highlight Property ctermfg=55 cterm=bold
-    "highlight Property ctermfg=142 cterm=bold
-    highlight Property ctermfg=058
-
-    syn match Colon ":"
-    highlight Colon ctermfg=red
-
-    syn match RightArrow "->"
-    "highlight RightArrow ctermfg=white
-    hi link RightArrow Special
-
-    syn match MyBracket /\[\|\]/
-    hi link MyBracket Identifier
-    "highlight MyBracket ctermfg=blue
-
-    syn match CurlyBracket "{\|}"
-    "highlight CurlyBracket ctermfg=196
-    highlight CurlyBracket ctermfg=128
-endfunc
-
-" searchkey: note color notecolor, note highlight, notehighlight
-func! NoteColor()
-    syn match Property "\<_[a-zA-Z0-9]\+\>"
-    "highlight Property ctermfg=55 cterm=bold
-    "highlight Property ctermfg=142 cterm=bold
-    highlight Property ctermfg=058
-
-    syn match Colon ":"
-    highlight Colon ctermfg=red
-
-    syn match RightArrow "->"
-    "highlight RightArrow ctermfg=white
-    hi link RightArrow Special
-
-    
-
-    syn match CurlyBracket "{\|}"
-    "highlight CurlyBracket ctermfg=196
-    highlight CurlyBracket ctermfg=128
-
-    "syn match Title /\[\zs[^:\]]\+/
-    "hi link Title Comment 
-
-""    syn match MyBracket /:\@!\[\|\]/
-""    "hi link MyBracket Identifier
-""    highlight MyBracket ctermfg=red
-"
-
-
-
-    syn match MyBracket /(\|)/
-    highlight MyBracket ctermfg=green
-
-    " TODO fix [123]
-    "syn match MyNumber /\(\s\|[\[\]{}():<>]\)\zs-\?\d\+\(\.\d\)*\ze\(\s\|[\[\]{}():<>]\)/
-    syn match MyNumber /\s*\d\+\s*/
-    "syn match MyNumber /\[\zs\d\+\ze\]/
-    highlight MyNumber ctermfg=60
-
-    "syn region String matchgroup=Quote start=+"+  skip=+\\"+  end=+"+
-
-    syn match MyFun /\w\+::\(\p*\)*->\(\p*\)*/
-    hi link MyFun Function 
-
-    syn match MyBlock /`\[\|`\]/
-    hi link MyBlock Special
-
-    syn match MyKeyWord /\sString\s\|\sNSString\s\|\star\s\|\sgpg\s\|\sList\|\sArrayList/
-    highlight  MyKeyWord ctermfg=33 
-
-    syn match MyMainKey /\s*new\s*/
-    highlight  MyMainKey ctermfg=200 
-
-    syn match MyNameKey /\s*CTRL\s*\|\s*ALT\s*\|\s*Command\s*\|\s*Shift\s*/
-    highlight  MyNameKey ctermfg=107 
-
-    syn match AngleBracket /<\|>/
-    highlight  AngleBracket ctermfg=red 
-
-    syn match Assignment /[^=]\zs=\ze[^=]/
-    highlight  Assignment ctermfg=magenta 
-
-    syn match MyEqual /==/
-    highlight  MyEqual ctermfg=brown 
-
-    syn match MyOperator /+\|\*\|-/
-    highlight  MyOperator ctermfg=130 
-
-    syn match MyEqual /\s\/\/\s.*$/
-    highlight  MyEqual ctermfg=150 
-
-    syn match CodeKeyword /\(\s\|[\[{(:<]\)\zsif\ze\(\s\|[\\\]}):>]\)\|\s*then\s*\|\s*public\s*\|\s*static\s*\|\s*for\ze\(\s\|[\[\]{}()]\)\|\s*do\s*\|\s*done\s*/
-    highlight  CodeKeyword ctermfg=white cterm=bold 
-
-    syn match CodeKeyword /\s*while\s*\|\s*try\s*/
-    highlight  CodeKeyword ctermfg=white cterm=bold 
-
-    
-    syn match CodeKeyword /\s*where\s*\|\s*static\s*\|\s*void\s*\|\(\s\|[\[\]{}():<>]\)int\ze\(\s\|[\[\]{}():<>]\)\|\s*else\s*\|\s*return\s*\|\s*self\s*/
-    highlight  CodeKeyword ctermfg=white  cterm=bold
-
-    syn match NSKey /NS\h\+/
-    highlight  NSKey ctermfg=64
-    "highlight  NSKey ctermfg=72  cterm=bold
-
-    syn match CGKey /CG\h\+/
-    highlight  CGKey ctermfg=70
-
-    syn match UIKey /UI\h\+/
-    highlight  UIKey ctermfg=81
-
-    syn match  HaskellKeyword /\([\[]\)\zsInt\ze\([\]]\|\s\|$\)/
-    highlight  HaskellKeyword  ctermfg=26 cterm=bold 
-
-    syn match MySquareBracket /`\@!\[\|`\@!\]/
-    highlight MySquareBracket ctermfg=blue
-
-    syn match  LinuxCmd /\s*grep\s*\|\s*awk\s*\|\s*ls\s*\|\s*echo\s*\|\s*sort\s*/
-    highlight  LinuxCmd ctermfg=129 
-
-    syn match MyString /"[^"]*"/
-    highlight MyString  ctermfg=90 
-
-endfunc
-
-
-
-"-----------------------------------------------------------------
-func! ListTabPage()
-    let buflist = []
-    let t = 1
-    let list = []
-    " get number of tabs
-    while t <= tabpagenr('$')
-       let buflist = tabpagebuflist(t)
-       " numbers of window
-       let winNum = 0
-       while  winNum < tabpagewinnr(t, '$')
-            let fname  = bufname(buflist[winNum])
-            let name   = fnamemodify(fname, ':p:t')
-            let tabNum = printf("%2d", t)
-            let bufNum = printf("%2d", buflist[winNum])
-            let item   = '[' . tabNum . '][' . bufNum . ']' . name
-            let winNum = winNum + 1
-            :call add(list, item)
-       endwhile
-       let t = t + 1
-    endwhile
-    "echo list
-    "let l:tmpname = "/private/tmp/bufername33334asdf.x"
-    let l:tmpname = tempname()
-    :call writefile(list, l:tmpname, "b")
-    exec "set splitright"
-    exec "vsplit " . l:tmpname
-    exec "set nonumber"
-    exec "vertical resize 30"
-
-    syn match MySource /.*\.m/
-    highlight MySource ctermbg=white
-    syn match MyHead /.*\.h/
-    highlight MyHead ctermfg=gray
-
-    exec "normal \<C-W>h"
-endfunc
-"-----------------------------------------------------------------
-func! ListCompare(i1, i2)
-     let l1 = split(a:i1, ":")
-     let l2 = split(a:i2, ":")
-     return l1[1] == l2[1] ? 0 : l1[1] > l2[1] ? 1 : -1
-endfunc
-
-func! BufferList()
-  let currbufnr = 1
-  let bufList = []
-  let bufcount = bufnr("$")
-  while currbufnr <= bufcount
-    if bufexists(currbufnr) != 0
-      let currbufname = bufname(currbufnr)
-        if filereadable(currbufname) && buflisted(currbufname) && strlen(currbufname) > 0
-            let path = fnamemodify(currbufname, ':p:h')
-            let name = fnamemodify(currbufname, ':p:t')
-            call add(bufList, path)
-        endif
-    endif
-    let currbufnr = currbufnr + 1
-  endwhile
-  return bufList
-endfunc
-
-"-----------------------------------------------------------------
-func! ToggleBufferManager(flag)
-    let l:tmpname =  "/private/tmp/12345.x"
-    if exists("s:win_tmpname")
-        if a:flag =~ "o"
-          exec "set splitright"
-          exec "vsplit " . l:tmpname
-          exec "w! " . l:tmpname
-          exec "set nonumber"
-          exec "set modifiable"
-          exec "vertical resize 30"
-        elseif a:flag =~ "n"
-          echo s:win_tmpname
-          exec ":close " . s:win_tmpname[1]
-          exec "bdelete " . s:win_tmpname[0]
-          let s:win_tmpname = BufferManager()
-        endif
-   else
-        let s:win_tmpname = BufferManager()
-        :echo s:win_tmpname[0]
-    endif
-endfunc
-command! -nargs=1 Bf :call ToggleBufferManager("<args>")
-"-----------------------------------------------------------------
-"==============================================================================
-func! BufferManager()
-  "let l:tmpname = tempname()
-  let retlist = []
-  let l:tmpname =  "/private/tmp/12345.x"
-  let bufcount = bufnr("$")
-  let nummatches = 0
-  let buflist = []
-  let firstmatchingbufnr = 0
-  let dict = {}
-  let currbufnr = 1
-  while currbufnr <= bufcount
-    if bufexists(currbufnr) != 0
-      let currbufname = bufname(currbufnr)
-        let nummatches += 1
-        let firstmatchingbufnr = currbufnr
-        let namelist = []
-        if filereadable(currbufname) && buflisted(currbufname) && strlen(currbufname) > 0
-            let namelist = split(currbufname, "/")
-
-            "let fullbuffer =  currbufnr . ":" . namelist[len(namelist)-1]
-            let path = fnamemodify(currbufname, ':p:h')
-            let name = fnamemodify(currbufname, ':p:t')
-
-            " check if dict contains the key
-            if has_key(dict, path) == 0
-               let dict[path] = []
-            endif
-            let bname = currbufnr . ':' . name
-            if currbufnr < 10
-                let bname = currbufnr . ' :' . name
-            endif
-            call add(dict[path], bname)
-
-        endif
-    endif
-    let currbufnr = currbufnr + 1
-  endwhile
-
-  for [key, list] in items(dict)
-     call sort(list, "ListCompare")
-  endfor
-
-  let treeList = []
-
-  for key in sort(keys(dict))
-     call add(treeList, key)
-     for item in dict[key]
-          call add(treeList, item)
-     endfor
-     call add(treeList, "")
-  endfor
-
-  :call writefile(treeList, l:tmpname, "b")
-  echo l:tmpname
-  exec "set splitright"
-  exec "vsplit " . l:tmpname
-  exec "set nonumber"
-  exec "set modifiable"
-  exec "w! " . l:tmpname
-  exec "vertical resize 30"
-
-  call add(retlist, l:tmpname)
-  call add(retlist, winnr('$'))
-  return retlist
-endfunc
-"-----------------------------------------------------------------
-func! BufSel(pattern)
-  let bufcount = bufnr("$")
-  let currbufnr = 1
-  let nummatches = 0
-  let firstmatchingbufnr = 0
-  while currbufnr <= bufcount
-    if(bufexists(currbufnr))
-      let currbufname = bufname(currbufnr)
-      if(match(currbufname, a:pattern) > -1)
-        echo currbufnr . ": ". bufname(currbufnr)
-        let nummatches += 1
-        let firstmatchingbufnr = currbufnr
-      endif
-    endif
-    let currbufnr = currbufnr + 1
-  endwhile
-  if(nummatches == 1)
-    execute ":buffer ". firstmatchingbufnr
-  elseif(nummatches > 1)
-    let desiredbufnr = input("Enter buffer number: ")
-    if(strlen(desiredbufnr) != 0)
-      execute ":buffer ". desiredbufnr
-    endif
-  else
-    echo "No matching buffers"
-  endif
-endfunc
-
-"Bind the BufSel() function to a user-command
-command! -nargs=1 Bs :call BufSel("<args>")
-"-----------------------------------------------------------------
-
-
-"-----------------------------------------------------------------
-" Fix the missing -cp option in java
-" Assume java file is in current buffer
-func! CompileJava()
-    let path = expand("%")
-    exec ":!javac " . path
-    let jclassName = expand("%:p:t:r")
-    let cwd = getcwd()
-    let full = ":!java -cp " . cwd . ":. " . jclassName
-    exec  full
-endfunc
-"-----------------------------------------------------------------
-func! CompileHaskell()
-    let path = expand("%")
-    exec ":!runhaskell " . path
-endfunc
-"-----------------------------------------------------------------
-" Change solarized color scheme background light/dark
-func! ToggleColorScheme()
-          let s:currColor = g:colors_name
-          echo "color scheme=" . s:currColor
-          if s:currColor == "solarized"
-            let s:bg = synIDattr(synIDtrans(hlID("Normal")), "bg")
-            echo "color=" . s:bg
-            if s:bg == "#002b36"
-                echo "Change color to #fdf6e3"
-                exec 'hi Normal		guibg=' .  "#fdf6e3"
-            else
-                echo "Change color to #002b36"
-                exec 'hi Normal		guibg=' .  "#002b36"
-            endif
-          endif
-endfunc
-"-----------------------------------------------------------------
-" set background color, it only works for Terminal, not for GUI
-let g:colorCode = synIDattr(hlID("Normal"), "bg#")
-if g:colorCode == -1
-    let g:colorCode = 187
-endif
-func! IncreaseColor()
-    if g:colorCode < 256
-        echo g:colorCode
-        let g:colorCode = g:colorCode + 1
-        "exec 'hi Normal guifg=yellow	guibg=white ctermfg=black ctermbg=' .  g:colorCode
-        exec 'hi Normal guibg=' . g:colorCode . ' ctermbg=' .  g:colorCode
-    endif
-        exec 'hi Normal guibg=' . g:colorCode . ' ctermbg=' .  g:colorCode
-endfunc
-
-func! DecreaseColor()
-    if g:colorCode > 0
-        let g:colorCode = g:colorCode - 1
-        "exec 'hi Normal		guifg=yellow	guibg=white ctermfg=black ctermbg=' .  g:colorCode
-        exec 'hi Normal		guibg=' . g:colorCode . '   ctermbg=' .  g:colorCode
-    endif
-        exec 'hi Normal		guibg=' . g:colorCode . '   ctermbg=' .  g:colorCode
-endfunc
-"-----------------------------------------------------------------
-
-func! CurTabFileName( )
-  return fnamemodify(bufname(winbufnr(tabpagewinnr(0))),':t')
-endfun
-
-func! SortBuffer()
-    for i in range(tabpagenr('$'),1, -1)
-        for j in range(1, i-1)
-            " goto the first tab
-            :tabr
-            let curTab = CurTabFileName()
-            :tabn
-            let nextTab = CurTabFileName()
-
-            if curTab > nextTab
-                :tabp
-                exec ":tabmove " . j
-            endif
-        endfor
-    endfor
-endfunc
-
-
-func! RemoveDuplicatedTabs()
-    let NONAME = "NO_NAME"
-    let invertDict = {}
-    for i in range(tabpagenr('$'),1, -1)
-        let curTab = CurTabFileName()
-        if curTab == ""
-            let curTab = NONAME
-        endif
-
-        let invertDict[i] = curTab
-        :tabn
-    endfor
-
-    let tabOffset = 0
-    let newDict = {}
-    for tabNum in sort(keys(invertDict))
-        let tabName = get(invertDict, tabNum)
-        let isDupNum = get(newDict, tabName)
-
-        if isDupNum == 0
-            let newDict[tabName] = 1
-        else
-            let newTabNum = tabNum - tabOffset
-            echo "===================== tabclose " . newTabNum . "  " .tabName
-            exec ":tabclose! " . newTabNum
-            let tabOffset = tabOffset + 1
-        endif
-    endfor
-    call SortBuffer()
-endfunc
-
-
-
-func! HeaderSource()
-    let s:count   = line(".")
-    let extension = expand("%:e")
-    let fsource   = expand("%:p:r") . ".m"
-    let fheader   = expand("%:p:r") . ".h"
-    echo fsource
-    if extension == "h"
-        execute "edit +" . s:count . " " . fsource
-    elseif extension == "m"
-        execute "edit +" . s:count . " " . fheader
-    endif
-endfunc
-
-" generate test template from register @"
-func! Test(title)
-    let input = a:title
-    let list = matchlist(input, '\(+\|-\)([^)]*)\zs[^:]*')
-    echo list
-    let comment = substitute(input, "{", "", "g")
-    let output = "-(void)test_" . list[0] . "{\n\t//" . comment . "\n}\n"
-    echo output
-    let @0 = output
-    execute "put 0"
-endfunc
-
-func! DeClass()
-    let line = getline(".")
-    let tokens = split(line, " ")
-endfunc
-
-
-func! DeVariable()
-    let input = expand("<cword>")
-    " Get all the curr buffer #
-    let all = range(0, bufnr('$'))
-    let res = []
-    for bn in all
-        let name = bufname(bn)
-
-        " expand full path
-        let fullpath = expand("%:p:r") . ".h"
-        let s:count=0
-        for line in readfile(fullpath)
-            if line =~ input
-                execute "edit +" . s:count . " " . fullpath
-                return
-            endif
-            let s:count = s:count + 1
-        endfor
-    endfor
-endfunc
-
-func! FindFun()
-    let input = expand("<cword>")
-    " Get all the curr buffer #
-    let all = range(0, bufnr('$'))
-    for bn in all
-        let fullName = bufname(bn)
-        let name = fnamemodify(fullName, ":t")
-        let curName = expand("%:p:t")
-
-        " match file name [*.m]
-        if  name != curName && name =~ '\(\~\|\/\|\w\|\d\)\+\.m'
-            let s:count=0
-            for line in readfile(fullName)
-
-                " match method defintion in ObjectiveC
-                "if line =~ '^\s*\(+\|-\)\s*(\(\*\|\w\)\+)'. input
-                if line =~ input
-                    execute "edit +" . s:count . " " . fullName
-                    return
-                endif
-                let s:count = s:count + 1
-            endfor
-        endif
-    endfor
-endfunc
-
-func! Defun()
-    let input = expand("<cword>")
-    " Get all the curr buffer #
-    let all = range(0, bufnr('$'))
-    for bn in all
-        let name = bufname(bn)
-        " match file name [*.m]
-        if name =~ '\(\~\|\/\|\w\|\d\)\+\.m'
-            let s:lineNum=1
-            for line in readfile(name)
-
-                " match method defintion in ObjectiveC
-                if line =~ '^\s*\(+\|-\)\s*(\(\*\|\w\)\+)'. input
-                    echo line
-                    execute "tabe +" . s:lineNum . " " . name 
-                    return
-                endif
-                let s:lineNum = s:lineNum + 1
-            endfor
-        endif
-    endfor
-endfunc
-
-
-" Vim >= 7.0 specific colors
-if version >= 700
-  hi CursorLine guibg=#2d2d2d
-  hi CursorColumn guibg=#2d2d2d
-  hi MatchParen guifg=#f6f3e8 guibg=#857b6f gui=bold
-  hi Pmenu 		guifg=#f6f3e8 guibg=#444444
-  hi PmenuSel 	guifg=#000000 guibg=#cae682
-endif
-
-"follwoing color will overwrite the colorscheme
-" General colors
-"hi Cursor 		guifg=NONE    guibg=#656565 gui=none
-"hi Normal 		guifg=#f6f3e8 guibg=#242424 gui=none
-"hi NonText 		guifg=#808080 guibg=#303030 gui=none
-"hi LineNr 		guifg=#857b6f guibg=#000000 gui=none
-"hi StatusLine 	guifg=#f6f3e8 guibg=#444444 gui=italic
-"hi StatusLineNC guifg=#857b6f guibg=#444444 gui=none
-"hi VertSplit 	guifg=#444444 guibg=#444444 gui=none
-"hi Folded 		guibg=#384048 guifg=#a0a8b0 gui=none
-"hi Title		guifg=#f6f3e8 guibg=NONE	gui=bold
-"hi Visual		guifg=#f6f3e8 guibg=#444444 gui=none
-"hi SpecialKey	guifg=#808080 guibg=#343434 gui=none
-
-" Syntax highlighting
-"hi Comment 		guifg=#99968b gui=italic
-"hi Todo 		guifg=#8f8f8f gui=italic
-"hi Constant 	guifg=#e5786d gui=none
-"hi String 		guifg=#95e454 gui=italic
-"hi Identifier 	guifg=#cae682 gui=none
-"hi Function 	guifg=#cae682 gui=none
-"hi Type 		guifg=#cae682 gui=none
-"hi Statement 	guifg=#8ac6f2 gui=none
-"hi Keyword		guifg=#8ac6f2 gui=none
-"hi PreProc 		guifg=#e5786d gui=none
-"hi Number		guifg=#e5786d gui=none
-"hi Special		guifg=#e7f6da gui=none
+" =====================================================
