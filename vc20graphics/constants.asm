;*****************************************
;*** Constants used for VIC20 programming
;*****************************************

ZERO_PAGE_PTR1 = $FB ; zero page pointer address
ZERO_PAGE_PTR2 = $FD ; zero page pointer address

VIC_COLOR=$900F         ; vic color register

; background colors
BGCOL_BLACK=0*16
BGCOL_WHITE=1*16
BGCOL_RED=2*16
BGCOL_CYAN=3*16
BGCOL_PURPLE=4*16
BGCOL_GREEN=5*16
BGCOL_BLUE=6*16
BGCOL_YELLOW=7*16
BGCOL_ORANGE=8*16
BGCOL_LIGHT_ORANGE=9*16
BGCOL_PINK=10*16
BGCOL_LIGHT_CYAN=11*16
BGCOL_LIGHT_PURPLE=12*16
BGCOL_LIGHT_GREEN=13*16
BGCOL_LIGHT_BLUE=14*16
BGCOL_LIGHT_YELLOW=15*16

; border colors
BDCOL_BLACK=0 AND 7
BDCOL_WHITE=1 AND 7
BDCOL_RED=2 AND 7
BDCOL_CYAN=3 AND 7
BDCOL_PURPLE=4 AND 7
BDCOL_GREEN=5 AND 7
BDCOL_BLUE=6 AND 7
BDCOL_YELLOW=7 AND 7

; char colors
COL_BLACK=0 
COL_WHITE=1
COL_RED=2
COL_CYAN=3
COL_PURPLE=4
COL_GREEN=5
COL_BLUE=6
COL_YELLOW=7

SCR_ROWS=23
SCR_COLS=22

 