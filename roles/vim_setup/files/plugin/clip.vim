" WSL2 only
function! CopyExternal() range
    let n = @n
    silent! normal gv"ny
    call system("echo '" . @n . "' | clip.exe")
    let @n = n
    normal! gv
endfunction

command! -range Copy call CopyExternal()
