*-----------------------------------------------------------
* Title      : Zorq Quest
* Written by : Evan McCormack
* Date       :
* Description:
*-----------------------------------------------------------
    org $1000

*-------------------------------------------------------
*
*-------------------------------------------------------

*-------------------------------------------------------
*Validation values to be used, modify as needed
*Add additional validation values as required
*-------------------------------------------------------
exit        EQU 0      used to exit assembly program
min_feed    EQU 100    min feed requirement
min_horses  EQU 1      min number of horses
max_horses  EQU 9      max number of horses
min_soldier EQU 6      min soldiers
min_charge  EQU 1      min rate of fuel use based of speed (oats for horses)
max_charge  EQU 5      max rate e.g. Flank       
hit_point   EQU 5      points accumilated on castle (objective) strike
miss_point  EQU 8      points deducted for ordinace miss

mine_loc    EQU 100    example for a hit


*Start of Game
start:
    move.b  #100,$4000 put score/health in memory location $4000
    lea     $4000,A3   assign address A3 to that memory location


    bsr     welcome    branch to the welcome subroutine
    bsr     input      branch to the input subroutine
    bsr     game       branch to the game subroutine
*Game loop
    org     $3000      the rest of the program is to be located from 3000 onwards

*-------------------------------------------------------
*-------------------Game Subroutine---------------------
*-------------------------------------------------------
game:
    bsr     gameloop   branch to gameloop subroutine
    rts                return from game: subroutine
          
end:
    simhalt

*-------------------------------------------------------
*-------------------Welcome Subroutine------------------
*-------------------------------------------------------
welcome:
    bsr     endl            branch to endl subroutine
    move.b  #0, $2000
    move.w  #2, $2000
    move.w  #6, $2500
    move.l  #200, $3000
    move.l  #500, $1500
    lea     welcome_msg,A1  assign message to address register A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15             trap and interpret value in D0
    
    move.b  #4,D0
    trap    #15
    bsr     endl            branch to endl subroutine
    rts                     return from welcome: subroutine


*-------------------------------------------------------
*---------Gameplay Input Values Subroutine--------------
*-------------------------------------------------------    
input:

    bsr     clear_screen    clears the screen
    bsr     gameloop
    move.b  #14,D0          move literal 14 to DO
    trap    #15             trap and interpret value in D0
    move.b  #23,D0
    trap    #15
    rts

*-------------------------------------------------------
*----------------Gameloop (main loop)-------------------
*------------------------------------------------------- 
gameloop:

    bsr     update          branch to update game subroutine 
    bsr     clear_screen    clears the screen

    bsr     gameplay        branch to gameplay subroutine
    bsr     clear_screen    clears the screen
    move.b  #4, D0
    trap    #15
    bsr     hud             branch to display HUD subroutine
    bsr     clear_screen    clears the screen
    bsr     replay          branch to replay game subroutine
    bsr     clear_screen    clears the screen

    move.b  #23, D0
    trap    #15
    rts                     return from gameloop: subroutine

*-------------------------------------------------------
*---------------Update Mission Progress-----------------
*  Move to battle location, engage enemy, fire and take
*  fire, complete mission and return to base
*------------------------------------------------------- 
update:

    lea     ownedSalt_msg,A1
    move.b  #14,D0
    trap    #15
    move.l  $1500, D1
    move.l  #3, D0
    trap    #15
    
    lea     ownedhorses_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.w  $2000,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedSoldiers_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15
    move.w  $2500,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedFeed_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15
    move.l  $3000,D1
    move.l  #3, D0
    trap    #15
    
    bsr     decorate
    lea     dire_msg,A1  assign message to address register A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    lea     barracks_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15         
    move.b  #4, D0
    trap    #15      
    cmp     #1,D1
    beq     barracks
    cmp     #2,D1
    beq     stables
    cmp     #3,D1
    beq     battle
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop
    lea     update_msg,A1   
    bsr     decorate
    rts
    
*-------------------------------------------------------
*------------------------Barracks-----------------------
*-------------------------------------------------------
barracks:
    lea     ownedSalt_msg,A1
    move.b  #14,D0
    trap    #15
    move.l  $1500, D1
    move.l  #3, D0
    trap    #15
    
    lea     ownedhorses_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.w  $2000,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedSoldiers_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15
    move.w  $2500,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedFeed_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15
    move.l  $3000,D1
    move.l  #3, D0
    trap    #15
    bsr     decorate

    lea     return_msg,A1 
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    lea     hire_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.b  #4,D0
    trap    #15
    cmp     #1,D1
    beq     update
    bne     hiring
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop
    rts
    
*-------------------------------------------------------
*------------------------Hiring-------------------------
*-------------------------------------------------------
hiring:
    lea     ownedSalt_msg,A1
    move.b  #14,D0
    trap    #15
    move.l  $1500, D1
    move.l  #3, D0
    trap    #15
   
    lea     ownedhorses_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.w  $2000,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedSoldiers_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15
    move.w  $2500,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedFeed_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15
    move.l  $3000,D1
    move.l  #3, D0
    trap    #15
    bsr     decorate

    lea     hiring_msg,A1
    move.b  #0, D5
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.b  #4,D0
    trap    #15
    move.w  $2500, D2
    add.w   D1, D2
    move.w  D2, $2500 
    move.w  #25, D4

    move.l  $1500, D5
    mulu.w  D4, D1
    sub.l   D1, D5
    move.l  D5, $1500

    cmp     #0, $1500
    blt     replay
 

    bsr     update
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop
    rts

     
*-------------------------------------------------------
*------------------------Stables------------------------
*-------------------------------------------------------
stables:
    lea     ownedSalt_msg, A1
    move.b  #14,D0
    trap    #15
    move.l  $1500, D1
    move.l  #3, D0
    trap    #15
    
    lea     ownedHorses_msg, A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.w  $2000,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedSoldiers_msg, A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15
    move.w  $2500,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedFeed_msg, A1
    move.w  #14,D0          move literal 14 to DO
    trap    #15
    move.l  $3000,D1
    move.l  #3, D0
    trap    #15
    bsr     decorate

    lea     return_msg, A1 
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    lea     stableshop_msg, A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.b  #4,D0
    trap    #15
    cmp     #1,D1
    beq     update
    cmp     #2,D1
    beq     buyingFeed
    cmp     #3,D1
    beq     horses
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop
    rts
    
*-------------------------------------------------------
*------------------------Buying Feed--------------------
*-------------------------------------------------------
buyingFeed:

    lea     ownedSalt_msg, A1
    move.b  #14,D0
    trap    #15
    move.l  $1500, D1
    move.l  #3, D0
    trap    #15
    
    lea     ownedHorses_msg, A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.w  $2000,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedSoldiers_msg, A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15
    move.w  $2500,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedFeed_msg, A1
    move.w  #14,D0          move literal 14 to DO
    trap    #15
    move.l  $3000,D1
    move.l  #3, D0
    trap    #15
    bsr     decorate

    move.l  #1, D4          Feed Currency
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    lea     feed_msg, A1
    trap    #15 
    move.b  #4, D0
    trap    #15 
    move.l  $3000, D2       move value for feed to D2
    add.l   D1, D2          add the input valu to the amount of feed already owned
    move.l  D2, $3000       move it back into the memory location
    move.l  $1500, D5
    mulu.w  D4, D1
    sub.l   D1, D5
    move.l  D5, $1500

    cmp     #0, $1500
    blt     replay
    
    bsr     update
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop
    rts
    
*-------------------------------------------------------
*------------------------Horses-------------------------
*-------------------------------------------------------
horses:
    lea     ownedSalt_msg, A1
    move.b  #14,D0
    trap    #15
    move.l  $1500, D1
    move.l  #3, D0
    trap    #15
    
    lea     ownedHorses_msg, A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.w  $2000,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedSoldiers_msg, A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15
    move.w  $2500,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedFeed_msg, A1
    move.w  #14,D0          move literal 14 to DO
    trap    #15
    move.l  $3000,D1
    move.l  #3, D0
    trap    #15
    bsr     decorate

    move.l  #0050, D4          Feed Currency
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    lea     horses_msg, A1
    trap    #15 
    move.b  #4, D0
    trap    #15 
    move.w  $2000, D2       move value for feed to D2
    add.b   D1, D2          add the input valu to the amount of feed already owned
    move.w  D2, $2000       move it back into the memory location
    move.l  $1500, D5
    mulu.w  D4, D1
    sub.l   D1, D5
    move.l  D5, $1500

    cmp     #0, $1500
    blt     replay
    
    bsr     update
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop
    rts

*-------------------------------------------------------
*------------------------Battle-------------------------
*-------------------------------------------------------
battle:
    lea     ownedSalt_msg,A1
    move.b  #14,D0
    trap    #15
    move.l  $1500, D1
    move.l  #3, D0
    trap    #15
    
    lea     ownedhorses_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.w  $2000,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedSoldiers_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15
    move.w  $2500,D1
    move.w  #3, D0
    trap    #15
    
    lea     ownedFeed_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15
    move.l  $3000,D1
    move.l  #3, D0
    trap    #15
    bsr     decorate

    lea     return_msg,A1 
    move.b  #14,D0          move literal 14 to DO
    trap    #15 

    lea     battleDire_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.b  #4, D0
    trap    #15
    cmp     #1, D1
    beq     update
    cmp     #2, D1
    beq     North
    cmp     #3, D1
    beq     East
*    cmp     #4, D1
*    beq     South
    cmp     #5, D1
    beq     West
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop
    rts
*-------------------------------------------------------
*------------------------North--------------------------
*-------------------------------------------------------
north:
    lea     north_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.b  #4,D0
    trap    #15
    cmp     #1,D1
    beq     update
    cmp     #2,D1
    beq     attackN
    bsr     endl            print a CR and LF
    bsr     decorate 
    rts

attackN:
     lea    attack_msg, A1
     move.b  #14,D0          move literal 14 to DO
     trap    #15 
     move.b  #4,D0
     trap    #15
     cmp     #1,D1
     beq     win
     cmp     #1,D1
     bgt     win
     cmp     #1,D1
     blt     replay
     bsr     endl            print a CR and LF
     bsr     decorate 
     rts
     
*-------------------------------------------------------
*------------------------East---------------------------
*-------------------------------------------------------
east:
    lea     east_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    move.b  #4,D0
    trap    #15
    cmp     #1,D1
    beq     update
    cmp     #2,D1
    beq     attackE
    bsr     endl            print a CR and LF
    bsr     decorate 
    rts

attackE:
     lea    attack_msg, A1
     move.b  #14,D0          move literal 14 to DO
     trap    #15 
     move.b  #4,D0
     trap    #15
     cmp     #5,D1
     beq     win
     cmp     #5,D1
     bgt     win
     cmp     #5,D1
     bgt     replay
     bsr     endl            print a CR and LF
     bsr     decorate 
     rts

*-------------------------------------------------------
*------------------------West---------------------------
*-------------------------------------------------------
west:
    lea     west_msg,A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15 
    bsr     update
    bsr     endl            print a CR and LF
    bsr     decorate 
    rts
  
*-------------------------------------------------------
*------------------------Win----------------------------
*-------------------------------------------------------
win:
    lea     win_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     update
    bsr     endl            print a CR and LF
    bsr     decorate 
    rts
*-------------------------------------------------------
*---------------Draw Mission Updates--------------------
* Draw the game progress information, status regarding
* mission
*------------------------------------------------------- 
draw:
    bsr     endl
    bsr     decorate
    lea     draw_msg,A1
    bsr     decorate
    rts

*-------------------------------------------------------
*-------------------Horse(s) Charge Speed---------------
* horses speed to and from a mission
*------------------------------------------------------- 


*-------------------------------------------------------
*------------------Mission Distance---------------------
* Distance to battle location
*------------------------------------------------------- 
distance:
    bsr     endl
    bsr     decorate
    lea     distance_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*---Game Play (Mission Progress, Battle Maneuvers)------
*------------------------------------------------------- 
gameplay:
    bsr     endl
    bsr     decorate
    lea     gameplay_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    bsr     collision
    rts

*-------------------------------------------------------
*-----------------Heads Up Display (Score)--------------
* Retrieves the score from memory location
*-------------------------------------------------------   
hud:

    bsr     endl
    bsr     decorate
    lea     hud_msg,A1
    move.b  #14,D0
    trap    #15
    move.b  (A3),D1     retrieve the value A3 point to and move to D1         intrepret value in D0, which 3 which displays D1
    bsr     decorate
    rts

*-------------------------------------------------------
*-----------------------Taking Fire---------------------
* This could be used for collision detection, if 
*-------------------------------------------------------
collision:
    move.b  #mine_loc,D1
    cmp     #100,D1 is( x == 100)?
	bne     collision_miss if x is equal to 100, then hit
collision_hit:
    *hit
    lea     hit_msg,A1
    move    #14,D0
    trap    #15
    rts
    
collision_miss:
    *miss
    lea     miss_msg,A1
    move    #14,D0
    trap    #15
    rts

*-------------------------------------------------------
*--------------------------Loop-------------------------
*-------------------------------------------------------
loop:
    move.b  #5, D3 loop counter D3=5
next:
    lea     loop_msg,A1
    move.b  #14,D0
    trap    #15
	sub     #1,D3   decrement loop counter
    bne     next    repeat until D0=0

*-------------------------------------------------------
*------------------Screen Decoration--------------------
*-------------------------------------------------------
decorate:
    move.b  #60, D3
    bsr     endl
out:
    lea     loop_msg,A1
    move.b  #14,D0
    trap    #15
	sub     #1,D3   decrement loop counter
    bne     out	    repeat until D0=0
    bsr     endl
    rts
    
clear_screen: 
    move.b  #11,D0      clear screen
    move.w  #$ff00,D1
    trap    #15
    rts
*-------------------------------------------------------
*------------------------Replay-------------------------
*-------------------------------------------------------
replay:
    bsr     endl
    lea     replay_msg,A1
    move.b  #14,D0
    trap    #15
    
    move.b  #4,D0
    trap    #15

    cmp     #exit,D1
    beq     end         if SR Z register contains 1 beq => Branch Equals
    bsr     gameloop

endl:
    movem.l D0/A1,-(A7)
    move    #14,D0
    lea     crlf,A1
    trap    #15
    movem.l (A7)+,D0/A1
    rts
    
*-------------------------------------------------------
*-------------------Data Delarations--------------------
*-------------------------------------------------------

crlf:           dc.b    $0D,$0A,0
ownedSalt_msg:      dc.b    $0D,$0A
                    dc.b    'Salt owned : ',0
                    dc.b    $0D,$0A, 0
ownedHorses_msg:    dc.b    $0D,$0A
                    dc.b    'Horses owned : ',0
                    dc.b    $0D,$0A, 0
ownedSoldiers_msg:  dc.b    $0D,$0A
                    dc.b    'Soldiers owned : ',0
                    dc.b    $0D,$0A,0
ownedFeed_msg:      dc.b    $0D,$0A
                    dc.b    'Feed owned : ',0
                    dc.b    $0D,$0A,0
welcome_msg:    dc.b    'You are the king of Eftre, a kingdom in Fanthre, '
                dc.b    $0D,$0A
                dc.b    'there is a swarm of monsters washing over the land '
                dc.b    $0D,$0A
                dc.b    'and you have lost your army to the first invasion to the west'
                dc.b    $0D,$0A
                dc.b    'Your only hope now is to rebuild your army and '
                dc.b    $0D,$0A
                dc.b    'make your way East to the ocean where you hear of ships you can leave on'
                dc.b    $0D,$0A
                dc.b    'ZorkQuest: Escape  Fanthre'
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0
dire_msg:       dc.b    'Which direction do you want to go?'
                dc.b    $0D,$0A,0
barracks_msg:   dc.b    '1) Barracks'
                dc.b    $0D,$0A
stables_msg:    dc.b    '2) Stables'
                dc.b    $0D,$0A
battle_msg:     dc.b    '3) Go to War'
                dc.b    $0D,$0A,0
hire_msg:       dc.b    '2) Hire soldiers'
                dc.b    $0D,$0A,0
hiring_msg:     dc.b    'How many soldiers do you wish to hire?'
                dc.b    $0D,$0A,0
return_msg:     dc.b    '1) Return to centre of town'
                dc.b    $0D,$0A,0
stableshop_msg: dc.b    '2) Buy feed'
                dc.b    $0D,$0A
                dc.b    '3) Buy horses'
                dc.b    $0D,$0A,0
feed_msg:       dc.b    'Each horse needs at least 100 units of feed'
                dc.b    $0D,$0A
                dc.b    'How much feed do you want to buy?'
                dc.b    $0D,$0A,0
horses_msg:     dc.b    'How many horses do you want to buy?'
                dc.b    $0D,$0A,0
battleDire_msg: dc.b    '2) Travel North, ' 
                dc.b    $0D,$0A
                dc.b    '3) Travel East'
                dc.b    $0D,$0A
*                dc.b    '4) Travel South'
*                dc.b    $0D,$0A
                dc.b    '5) Travel West'
                dc.b    $0D,$0A,0
win_msg:        dc.b    'You have conquered the land'
                dc.b    $0D,$0A,0
north_msg:      dc.b    'There seems to be a weak mountain tribe to the north'
                dc.b    $0D,$0A
                dc.b    '1) Return'
                dc.b    $0D,$0A
                dc.b    '2) Attack'
                dc.b    $0D,$0A,0
east_msg:       dc.b    'There is a very strong Kingdom to the East'
                dc.b    $0D,$0A
                dc.b    '1) Return'
                dc.b    $0D,$0A
                dc.b    '2) Attack'
                dc.b    $0D,$0A,0
west_msg:       dc.b    'The horde of monsters have gotten closer,'
                dc.b    $0D,$0A
                dc.b    'there is no travelling west anymore'
                dc.b    $0D,$0A,0
attack_msg:     dc.b    'How many soldiers will you send?',0
distance_msg:   dc.b    'Mission distance e.g. 40 (with 100 units of feed  '
                dc.b    $0D,$0A
                dc.b    'One Third speed 20 units remain for manuvouirs) horses '
                dc.b    $0D,$0A
                dc.b    'Horses without feed are lost.'
                dc.b    $0D,$0A
                dc.b    'Enter mission distance : ',0
soldiers_msg:       dc.b    'Each horses need at least 1 Knight and an Stable Hand'
                dc.b    $0D,$0A
                dc.b    'minimum requirement is 2 i.e. Stable Hand x 1 and Knight x 1.'
                dc.b    $0D,$0A
                dc.b    'Enter # of soldiers : ',0
gameplay_msg:   dc.b    'Add Gameplay !',0
update_msg:     dc.b    'Update Gameplay !',0
draw_msg:       dc.b    'Draw Screen !',0
hit_msg:        dc.b    'Strike!',0
miss_msg:       dc.b    'Miss!',0
loop_msg:       dc.b    '.',0
replay_msg:     dc.b    'Enter 0 to Quit any other number to replay : ',0
hud_msg:        dc.b    'Score : ',0

health:     ds.w    1
score:      ds.w    1 reserve space for score

    end start




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
