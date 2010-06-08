Hotkeys:
Enter hotkeys in the bindings section under the keys you want for them, either in the tibia hotkeys options, or in EruBot bindings window, by right-clicking the Bindings button or going to the menu and clicking Configure -> Bindings. Enter bindings preceded by !eb. You can also have backup commands in a binding if the first is not required or fails somehow, seperated by semicolons. Names are case-sensitive. Multiple word names must be surrounded by double quotations as in "Alyster Dark".

Some available commands:
!eb rune (runeid) (max. hp% of target for use) (target list or name)
e.g. !eb rune uh 100% Eruanno
UH Eruanno if his hp is <= 100%.
!eb rune uh 70% self
UH the player self if hp is less than 70%
!eb rune sd 80% enemy
SD whoever is in the attack retina otherwise in the enemy list
!eb spam (x coord) (y coord) (z coord) itemid1, itemid2, itemid3...
if x and y are between -15 and 15 then the coordinates are treated relative to the player
eg !eb spam -1 0 0 3031 3447
spams alternating gp and arrows in the square to the left of the player
!eb spam 32513 32385 7 3031 3447 3492
spams alternating coins, arrows and worms on the exact coordinates given (somewhere on ground level judging by the z=7)