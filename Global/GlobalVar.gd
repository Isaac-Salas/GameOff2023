extends Node 

var VolBig = 0.0
var VolSmall = 0.0
var objectPicked = null
var sizeM = Vector3()
var sizestandard = 2
var sizefactor = 2
var SPEED = 10.0
var JUMP_VELOCITY = 20.0
var bump = false
var state = "static"
var pick = "NONE"
var ProgBar = 1;
var CURRENT = "NORMAL"
var MaxCap=4.0
var MinCap=0.1
var Scalerate = 0.02
