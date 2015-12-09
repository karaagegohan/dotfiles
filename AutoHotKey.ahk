;=== Reload ====================================================== {{{

vk1Csc079 & vk1Dsc07B::   ; 変換 + 無変換
    Reload
Return

;=== Reload ====================================================== }}}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vk1Csc079 : 変換
;; vk1Dsc07B : 無変換
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

vk1Csc079 & h:: Send, {Blind}{Left}
vk1Csc079 & j:: Send, {Blind}{Down}
vk1Csc079 & k:: Send, {Blind}{Up}
vk1Csc079 & l:: Send, {Blind}{Right}
vk1Dsc07B & Space:: Send, {sc029}
vk1Csc079 & Space:: Send, {sc029}
sc070:: Send, {sc029}

