extends Node 

##Player movement 
var movements
var pickedpath = ""
var direction 
var VolBig = 0.0
var VolSmall = 0.0
var objectPicked = false
var SPEED = 10.0
var JUMP_VELOCITY = 20.0
var bump = false
var state = "static"
var pick = "NONE"
var ProgBar = 1;
var CURRENT = "NORMAL"
##Scalers
var sizeM = Vector3()
var sizestandard = 2
var sizefactor = 2
var MaxCap=4.0
var MinCap=0.1
var Scalerate = 0.02
var target_scale

##Menu stuff
var Escswitch = 0
var menuskip = false
