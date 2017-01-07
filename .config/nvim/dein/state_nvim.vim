if g:dein#_cache_version != 100 | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/Users/Yoneoka/dotfiles/.config/nvim/init.vim', '/Users/Yoneoka/.config/nvim/dein/applescript.toml', '/Users/Yoneoka/.config/nvim/dein/colorscheme.toml', '/Users/Yoneoka/.config/nvim/dein/csharp.toml', '/Users/Yoneoka/.config/nvim/dein/elixir.toml', '/Users/Yoneoka/.config/nvim/dein/git.toml', '/Users/Yoneoka/.config/nvim/dein/go.toml', '/Users/Yoneoka/.config/nvim/dein/java.toml', '/Users/Yoneoka/.config/nvim/dein/markdown.toml', '/Users/Yoneoka/.config/nvim/dein/operator.toml', '/Users/Yoneoka/.config/nvim/dein/python.toml', '/Users/Yoneoka/.config/nvim/dein/ruby.toml', '/Users/Yoneoka/.config/nvim/dein/swift.toml', '/Users/Yoneoka/.config/nvim/dein/tex.toml', '/Users/Yoneoka/.config/nvim/dein/textobject.toml', '/Users/Yoneoka/.config/nvim/dein/toml.toml', '/Users/Yoneoka/.config/nvim/dein/tool.toml', '/Users/Yoneoka/.config/nvim/dein/unite.toml', '/Users/Yoneoka/.config/nvim/dein/view.toml', '/Users/Yoneoka/.config/nvim/dein/vim.toml'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/Users/Yoneoka/.config/nvim/dein'
let g:dein#_runtime_path = '/Users/Yoneoka/.config/nvim/dein/.cache/init.vim/.dein'
let g:dein#_cache_path = '/Users/Yoneoka/.config/nvim/dein/.cache/init.vim'
let &runtimepath = '/Users/Yoneoka/.cache/nvim/repos/github.com/Shougo/dein.vim,/Users/Yoneoka/.config/nvim,/etc/xdg/nvim,/Users/Yoneoka/.local/share/nvim/site,/usr/local/share/nvim/site,/Users/Yoneoka/.config/nvim/dein/repos/github.com/kmnk/vim-unite-giti,/Users/Yoneoka/.config/nvim/dein/.cache/init.vim/.dein,/usr/share/nvim/site,/usr/local/Cellar/neovim/0.1.7/share/nvim/runtime,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/Users/Yoneoka/.local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/Yoneoka/.config/nvim/after,/Users/Yoneoka/.config/nvim/dein/.cache/init.vim/.dein/after'
filetype off
    let g:jedi#goto_command             = ""
    let g:jedi#goto_assignments_command = ""
    let g:jedi#goto_definitions_command = ""
    let g:jedi#documentation_command    = "<SID>[command]d"
    let g:jedi#usages_command           = ""
    let g:jedi#rename_command           = ""
  let g:previm_open_cmd = 'open -a "Google Chrome"'
    nnoremap <SID>[git] <Nop>
    nmap     <SID>[plugin]g <SID>[git]
    nnoremap <SID>[git]ad :<C-u>Gwrite<CR>
    nnoremap <SID>[git]bl :<C-u>Gblame<CR>
    nnoremap <SID>[git]br :<C-u>Git branch<Space>
    nnoremap <SID>[git]ch :<C-u>Git checkout<Space>
    nnoremap <SID>[git]cm :<C-u>Gcommit -m ""<LEFT>
    nnoremap <SID>[git]cu :<C-u>Gcommit -m "update"<LEFT>
    nnoremap <SID>[git]ca :<C-u>Gcommit -m "add: "<LEFT>
    nnoremap <SID>[git]cr :<C-u>Gcommit -m "remove: "<LEFT>
    nnoremap <SID>[git]cf :<C-u>Gcommit -m "fix: "<LEFT>
    nnoremap <SID>[git]cc :<C-u>Gcommit -m "change: "<LEFT>
    nnoremap <SID>[git]co :<C-u>Gcommit<CR>
    nnoremap <SID>[git]di :<C-u>Gdiff<CR>
    nnoremap <SID>[git]me :<C-u>Git merge<Space>
    nnoremap <SID>[git]pl :<C-u>Git pull<CR>
    nnoremap <SID>[git]ps :<C-u>Git push<CR>
    nnoremap <SID>[git]sh :<C-u>Git stash<CR>
    nnoremap <SID>[git]st :<C-u>Gstatus<CR>
    let g:alpaca_tags#config = { '_' : '-R --sort=yes --languages=+Ruby --languages=-js,JavaScript', 'js' : '--languages=+js', '-js' : '--languages=-js,JavaScript', 'vim' : '--languages=+Vim,vim', 'php' : '--languages=+php', '-vim' : '--languages=-Vim,vim', '-style': '--languages=-css,scss,js,JavaScript,html', 'scss' : '--languages=+scss --languages=-css', 'css' : '--languages=+css', 'java' : '--languages=+java $JAVA_HOME/src', 'ruby': '--languages=+Ruby', 'coffee': '--languages=+coffee', '-coffee': '--languages=-coffee', 'bundle': '--languages=+Ruby', }
    let b:javagetset_enable_K_and_R = 1   " K$R style
    let b:javagetset_add_this       = 1   " add this.
    autocmd vimrc Filetype java nnoremap <SID>[plugin]j <SID>[getset]
    autocmd vimrc Filetype java nmap     <buffer><SID>[getset]g <Plug>JavagetsetInsertGetterOnly
    autocmd vimrc Filetype java nmap     <buffer><SID>[getset]s <Plug>JavagetsetInsertSetterOnly
    autocmd vimrc Filetype java nmap     <buffer><SID>[getset]b <Plug>JavagetsetInsertBothGetterSetter
    autocmd vimrc Filetype java vmap     <buffer><SID>[getset]g <Plug>JavagetsetInsertGetterOnly
    autocmd vimrc Filetype java vmap     <buffer><SID>[getset]s <Plug>JavagetsetInsertSetterOnly
    autocmd vimrc Filetype java vmap     <buffer><SID>[getset]b <Plug>JavagetsetInsertBothGetterSetter
    nmap s <Plug>(operator-replace)
    nmap S <Plug>(operator-replace)$
    nmap <silent>ys <Plug>(operator-surround-append)
    nmap <silent>ds <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
    nmap <silent>cs <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
    let g:unite_source_history_yank_enable      = 1     " Enable history yank
    let g:unite_source_file_mru_limit           = 200   " Maximum number of mru list
    let g:unite_source_file_mru_filename_format = ''    " Maximum number of mru list
    let g:unite_enable_start_insert             = 1     " Start in insert mode
    let g:unite_source_history_yank_enable      = 1
    nnoremap <SID>[unite]   <Nop>
    nmap     <SID>[plugin]u <SID>[unite]
    nnoremap <SID>[unite]bu :<C-u>Unite buffer<CR>
    nnoremap <SID>[unite]co :<C-u>Unite command<CR>
    nnoremap <SID>[unite]de :<C-u>Unite dein<CR>
    nnoremap <SID>[unite]f  :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
    nnoremap <SID>[unite]he :<C-u>Unite help<CR>
    nnoremap <SID>[unite]hf :<C-u>Unite file_mru buffer<CR>
    nnoremap <SID>[unite]hy :<C-u>Unite history/yank<CR>
    nnoremap <SID>[unite]nb :<C-u>Unite dein<CR>
    nnoremap <SID>[unite]pc :<C-u>Unite -auto-preview colorscheme<CR>
    nnoremap <SID>[unite]pf :<C-u>Unite -auto-preview font<CR>
    nnoremap <SID>[unite]pt :<C-u>Unite -auto-preview transparency<CR>
    nnoremap <SID>[unite]qf :<C-u>Unite -no-quit -direction=botright quickfix<CR>
    nnoremap <SID>[unite]re :<C-u>Unite -buffer-name=register register<CR>
    nnoremap <SID>[unite]so :<C-u>Unite source<CR>
    nnoremap <SID>[unite]u  :<C-u>Unite<CR>
    nnoremap <SID>[unite]yr :<C-u>Unite yankround<CR>
    let g:gitgutter_map_keys                = 0
    if has('win32') || has('win64')
        let g:gitgutter_sign_added              = '+ '
       let g:gitgutter_sign_modified           = '> '
        let g:gitgutter_sign_removed            = '* '
        let g:gitgutter_sign_removed_first_line = '* '
        let g:gitgutter_sign_modified_removed   = '*>'
    else
        let g:gitgutter_sign_added              = '✚ '
        let g:gitgutter_sign_modified           = '➜ '
        let g:gitgutter_sign_removed            = '✘ '
        let g:gitgutter_sign_removed_first_line = '✘ '
        let g:gitgutter_sign_modified_removed   = '✘➜'
    endif
    nnoremap <silent><SID>[git]gt   :<C-u>GitGutterToggle<CR>
    nnoremap <silent><SID>[git]gh   :<C-u>GitGutterLineHighlightsToggle<CR>
    nnoremap <silent><SID>[git]hn   :<C-u>GitGutterNextHunk<CR>
    nnoremap <silent><SID>[git]hp   :<C-u>GitGutterPrevHunk<CR>
    nnoremap <silent><SID>[git]ha   :<C-u>GitGutterStageHunk<CR>
    nnoremap <silent><SID>[git]hh   :<C-u>GitGutterRevertHunk<CR>
    nnoremap <silent><SID>[git]hp   :<C-u>GitGutterPrevHunk<CR>
    nnoremap <silent><SID>[git]hn   :<C-u>GitGutterNextHunk<CR>
  set background=dark
  autocmd vimrc VimEnter * nested colorscheme Tomorrow-Night
    let g:unite_split_rule = 'botright'
    let g:unite_split_rule = 'botright'
    nnoremap <SID>[unite-git] <Nop>
    nmap     <SID>[unite]g    <SID>[unite-git]
    nnoremap <SID>[unite-git]g :<C-u>Unite giti<CR>
    let g:unite_source_ruby_require_cmd = expand('$HOME/.rbenv/shims/ruby')
    nnoremap <SID>[unite]rb  :<C-u>Unite<CR>
    let g:monster#completion#rcodetools#backend = "async_rct_complete"
    let g:deoplete#sources#omni#input_patterns = {   "ruby" : '[^. *\t]\.\w*\|\h\w*::',}
let g:jedi#auto_initialization = 1
let g:jedi#rename_command      = ""
let g:jedi#popup_on_dot        = 1
    let g:lightline = { 'colorscheme': 'wombat', 'mode_map': {'c': 'NORMAL'}, 'active': {   'left': [     ['mode', 'paste'],     ['fugitive', 'gitgutter', 'filename'],   ],   'right': [     ['lineinfo'],     ['percent'],     ['nextbuffername', 'fileformat', 'fileencoding', 'filetype'],   ] }, 'component_function': {   'modified': 'MyModified',   'time': 'MyTime',   'readonly': 'MyReadonly',   'fugitive': 'MyFugitive',   'filename': 'MyFilename',   'fileformat': 'MyFileformat',   'filetype': 'MyFiletype',   'fileencoding': 'MyFileencoding',   'mode': 'MyMode',   'syntastic': 'SyntasticStatuslineFlag',   'charcode': 'MyCharCode',   'gitgutter': 'MyGitGutter',   'nextbuffername': 'MyNextBufferName', }, 'separator': {'left': '', 'right': ''}, 'subseparator': {'left': '|', 'right': '|'} }
    function! MyModified() "{{{
        return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
    endfunction "}}}
    function! MyTime() "{{{
        return winwidth('.') > 110 ? strftime("%Y/%m/%d %H:%M:%S", localtime()) : (winwidth('.') > 90 ? strftime("%Y/%m/%d", localtime()) : '')
    endfunction "}}}
    function! MyReadonly() "{{{
        return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '-' : ''
    endfunction "}}}
    function! MyFilename() "{{{
        return ('' != MyReadonly() ? MyReadonly() . ' ' : '') . (&ft == 'vimfiler' ? vimfiler#get_status_string() :  &ft == 'unite' ? unite#get_status_string() :  &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') : '' != expand('%:t') ? expand('%:t') : '[No Name]') . ('' != MyModified() ? ' ' . MyModified() : '')
    endfunction "}}}
    function! MyFugitive() "{{{
        try
            if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
                let _ = fugitive#head()
                return strlen(_) ? _ : ''
            endif
        catch
        endtry
        return ''
    endfunction "}}}
    function! MyFileformat() "{{{
        return winwidth('.') > 70 ? &fileformat : ''
    endfunction "}}}
    function! MyFiletype() "{{{
        return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
    endfunction "}}}
    function! MyFileencoding() "{{{
        return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
    endfunction "}}}
    function! MyMode() "{{{
        return winwidth('.') > 60 ? lightline#mode() : ''
    endfunction "}}}
    function! MyGitGutter() "{{{
        if ! exists('*GitGutterGetHunkSummary') || ! get(g:, 'gitgutter_enabled', 0) || winwidth('.') <= 90
            return ''
        endif
        let symbols = [  g:gitgutter_sign_added,  g:gitgutter_sign_modified,  g:gitgutter_sign_removed ]
        let hunks = GitGutterGetHunkSummary()
        let ret = []
        for i in [0, 1, 2]
            if hunks[i] > 0
                call add(ret, symbols[i] . hunks[i])
            endif
        endfor
        return join(ret, ' ')
    endfunction "}}}
    function! MyCharCode() "{{{
        if winwidth('.') <= 70
            return ''
        endif
        redir => ascii
        silent! ascii
        redir END
        if match(ascii, 'NUL') != -1
            return 'NUL'
        endif
        let nrformat = '0x%02x'
        let encoding = (&fenc == '' ? &enc : &fenc)
        if encoding == 'utf-8'
            let nrformat = '0x%04x'
        endif
        let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')
        let nr = printf(nrformat, nr)
        return "'". char ."' ". nr
    endfunction "}}}
    function! MyNextBufferName() abort "{{{
        try
            redir => ls
            silent! ls
            redir END
            let s:cur_index = 0
            let s:buffers = split(ls, '\n')
            for s:buffer in s:buffers
                if match(s:buffer, '%a') != -1
                    break
                endif
                let s:cur_index = s:cur_index + 1
            endfor
            let s:max_index = len(s:buffers) - 1
            let s:nex_index = s:cur_index + 1
            if s:nex_index == s:max_index + 1
                let s:nex_index = 0
            endif
            let s:pre_index = s:cur_index - 1
            if s:pre_index == -1
                let s:pre_index = s:max_index
            endif
            let s:pre_name = matchstr(s:buffers[s:pre_index], '"\zs.*\ze"')
            let s:pre_name = fnamemodify(s:pre_name, ":t")
            let s:nex_name = matchstr(s:buffers[s:nex_index], '"\zs.*\ze"')
            let s:nex_name = fnamemodify(s:nex_name, ":t")
            let s:str_length = 10
            return '( ' . s:pre_name[0:s:str_length] . ' <=|=> ' . s:nex_name[0:s:str_length] . ' )'
        catch
        endtry
    endfunction "}}}
    function! MyNextBufferName() "{{{
      function! s:file_pass_filter(files)
        let l:ret = []
        for l:file  in a:files
          if !isdirectory(l:file)
            call add(l:ret, l:file)
          endif
        endfor
        return l:ret
      endfunction
      let l:current_file = expand('%:p') 
      let l:files = s:file_pass_filter(split(glob(expand('%:p:h') . "/*"), "\n"))
      if len(l:files) <= 1
        return ""
      endif
      let l:cnt = match(l:files, l:current_file)
      let l:next = fnamemodify(l:files[(l:cnt + 1) % len(l:files)], ":t")
      let l:prev = fnamemodify(l:files[(l:cnt - 1) % len(l:files)], ":t")
      return l:next . " : " . l:prev"
    endfunction "}}}
    set list listchars=tab:\¦\ 
    let g:indentLine_color_term = 239
    let g:indentLine_color_gui = '#A4E57E'
    let g:indentLine_color_tty_light = 7 " (default: 4)
    let g:indentLine_color_dark = 1 " (default: 2)
