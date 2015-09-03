^r::
    Reload
Return

^l::
    ; MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl
    ; ControlGetText, text, %OutputVarControl%, ahk_id %OutputVarWin%
    ; MsgBox, %text%
Return

vk1Csc079 & i:: Send, {Up}
vk1Csc079 & k:: Send, {Down}
