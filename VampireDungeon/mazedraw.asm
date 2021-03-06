;************************************************************
;*** Routine for plotting part of the dungeon to screenram
;*** (C) Noltisoft - by Heiko Nolte, 2020
;************************************************************
cls       = $e544
chrin     = $ffe4
zeroadr   = $fb
mazedef   = $0400

;*****************************************
;*** Initialize maze
;*****************************************
*=$033C; DEC:828
@init_maze 
        lda #<mazedef ; LSB
        sta zeroadr
        lda #>mazedef ; MSB
        sta zeroadr+1
@init_maze_loop
        lda #$04
        ldy #$00
        sta (zeroadr),y
        inc zeroadr
        bne *+4
        inc zeroadr+1
        lda zeroadr+1
        cmp #$07
        bne @init_maze_loop
        lda zeroadr
        cmp #$85
        bne @init_maze_loop
        rts

*=$CC00; DEC: 52224
@start
          jsr            @plot_scrn_data_win
          jsr            @plot_player_win
          rts
;******************************************
;*** Plot part of the maze to the screen
;******************************************
@plot_scrn_data_win
@plot_scrn_data
          ldy            #00
@plot_scrn_data_inc1
          tya
          clc
          adc            scrn_data_yp
          sta            maze_data_peek_yp
          tya
          clc
          adc            scrn_plot_yp
          sta            plot_y
          ldx            #00
@plot_scrn_data_inc2
          cpx            #02
          bne            @plot_scrn_data_char
          cpy            #02
          bne            @plot_scrn_data_char  
          jmp            @plot_scrn_data_inc
@plot_scrn_data_char          
          txa
          clc
          adc            scrn_data_xp
          sta            maze_data_peek_xp
          txa
          clc
          adc            scrn_plot_xp
          sta            plot_x
          tya
          pha
          txa
          pha
          jsr            @maze_data_peek
          pla
          tax
          pla
          tay
          lda            maze_data_peek_val
          cmp            #$04
          bne            @plot_scrn_data_item
          lda            scrn_data_wall_sym
          sta            plot_chr
          lda            scrn_data_wall_col
          sta            plot_color
          jmp            @plot_scrn_data_chr
@plot_scrn_data_item
          cmp            #$06
          bne            @plot_scrn_data_door
          lda            scrn_data_item_sym
          sta            plot_chr
          lda            scrn_data_item_col
          sta            plot_color
          jmp            @plot_scrn_data_chr
@plot_scrn_data_door
          cmp            #$07
          bne            @plot_scrn_data_potion
          lda            scrn_data_door_sym
          sta            plot_chr
          lda            scrn_data_door_col
          sta            plot_color
          jmp            @plot_scrn_data_chr
@plot_scrn_data_potion
          cmp            #$08
          bne            @plot_scrn_data_treasure
          lda            scrn_data_potion_sym
          sta            plot_chr
          lda            scrn_data_potion_col
          sta            plot_color
          jmp            @plot_scrn_data_chr
@plot_scrn_data_treasure
          cmp            #$09
          bne            @plot_scrn_data_space
          lda            scrn_data_treasure_sym
          sta            plot_chr
          lda            scrn_data_treasure_col
          sta            plot_color
          jmp            @plot_scrn_data_chr
@plot_scrn_data_space
          lda            #32
          sta            plot_chr
@plot_scrn_data_chr
          tya
          pha
          txa
          pha
          jsr            @scrn_plot
          pla
          tax
          pla
          tay
@plot_scrn_data_inc
          inx
          cpx            scrn_data_width
          beq            @plot_scrn_data_line
          jmp            @plot_scrn_data_inc2
@plot_scrn_data_line
          iny
          cpy            scrn_data_width
          beq            @plot_scrn_data_end
          jmp            @plot_scrn_data_inc1
@plot_scrn_data_end
          rts
;********************************
;*** Plot player to the screen
;********************************
@plot_player_win
          lda            scrn_data_player_xp
          sta            plot_x
          lda            scrn_data_player_yp
          sta            plot_y
          lda            scrn_data_player_sym
          sta            plot_chr
          lda            scrn_data_player_col
          sta            plot_color
          jsr            @scrn_plot
          rts
;*********************************
;*** Plot a character to screen
;*********************************
@scrn_plot
          ldy            #0
          ldx            #0
@plot_inc1
          iny
          iny
          inx
          cpx            plot_y
          bne            @plot_inc1
          lda            clrtable,y; Load y address offset into zeropage
          sta            zeroadr+1
          iny
          lda            clrtable,y
          sta            zeroadr
          lda            plot_color
          ldy            plot_x
          sta            (zeroadr),y; Set color using zero page and xoffset
          ldy            #0
          ldx            #0
@plot_inc2
          iny
          iny
          inx
          cpx            plot_y
          bne            @plot_inc2
          lda            scrtable,y; Load y address offset into zeropage
          sta            zeroadr+1
          iny
          lda            scrtable,y
          sta            zeroadr
          lda            plot_chr
          ldy            plot_x
          sta            (zeroadr),y; Set char using zero page and xoffset
          rts
;*****************************************
;*** Peek a value from maze definition.
;*****************************************
@maze_data_peek
          ldy            #0
          ldx            #0
@maze_data_peek_inc1
          iny
          iny
          inx
          cpx            maze_data_peek_yp
          bne            @maze_data_peek_inc1
          lda            scrnaddtable,y; Load y address offset into zeropage
          sta            zeroadr+1
          iny
          lda            scrnaddtable,y
          sta            zeroadr
          ldy            maze_data_peek_xp
          lda            (zeroadr),y; Peek value and store it to result address
          sta            maze_data_peek_val
          rts

;******************************************
;*** Variables and tables
;******************************************
scrtable
          BYTE           $C8, $00, $C8, $28, $C8, $50, $C8, $78, $C8, $A0, $C8, $C8
          BYTE           $C8, $F0, $C9, $18, $C9, $40, $C9, $68, $C9 ,$90, $C9, $B8
          BYTE           $C9, $E0, $CA, $08, $CA, $30, $CA, $58, $CA ,$80, $CA, $A8
          BYTE           $CA, $D0, $CA, $F8, $CB, $20, $CB, $48, $CB, $70, $CB, $98
          BYTE           $CB, $C0

clrtable
          BYTE           $D8, $00, $D8, $28, $D8, $50, $D8, $78, $D8, $A0, $D8, $C8
          BYTE           $D8, $F0, $D9, $18, $D9, $40, $D9, $68, $D9, $90, $D9, $B8
          BYTE           $D9, $E0, $DA, $08, $DA, $30, $DA, $58, $DA, $80, $DA, $A8
          BYTE           $DA, $D0, $DA, $F8, $DB, $20, $DB, $48, $DB, $70, $DB, $98
          BYTE           $DB, $C0
plot_x
          BYTE           $00
plot_y
          BYTE           $00
plot_color
          BYTE           $00
plot_chr
          BYTE           $00
*=$CF00; DEC:52992
scrn_plot_xp
          BYTE           $05
scrn_plot_yp
          BYTE           $05
scrn_data_xp
          BYTE           $00
scrn_data_yp
          BYTE           $00
scrn_data_width
          BYTE           $05
scrn_data_height
          BYTE           $05
scrn_data_wall_sym
          BYTE           $66
scrn_data_wall_col
          BYTE           $08
scrn_data_player_xp
          BYTE           $07
scrn_data_player_yp
          BYTE           $07
scrn_data_player_sym
          BYTE           $41
scrn_data_player_col
          BYTE           $07
scrn_data_item_sym
          BYTE           $42
scrn_data_item_col
          BYTE           $08
scrn_data_door_sym 
          BYTE           $43
scrn_data_door_col
          BYTE           $09
scrn_data_potion_sym
          BYTE           $44
scrn_data_potion_col
          BYTE           $0E
scrn_data_treasure_sym
          BYTE           $5E
scrn_data_treasure_col
          BYTE           $05
scrn_data_rows
          BYTE           $1E
scrn_data_cols
          BYTE           $1E
scrnaddtable
          BYTE $04, $00, $04, $1E, $04, $3C, $04, $5A, $04, $78, $04, $96, $04, $B4, $04, $D2, $04, $F0
          BYTE $05, $0E, $05, $2C, $05, $4A, $05, $68, $05, $86, $05, $A4, $05, $C2, $05, $E0, $05, $FE
          BYTE $06, $1C, $06, $3A, $06, $58, $06, $76, $06, $94, $06, $B2, $06, $D0, $06, $EE, $07, $0C
          BYTE $07, $2A, $07, $48, $07, $66
maze_data_peek_yp
          BYTE           $00
maze_data_peek_xp
          BYTE           $00
maze_data_peek_val
          BYTE           $00

