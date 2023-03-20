DefaultMovingObjectSuspendDistance = 24
X_AXIS = 1
Y_AXIS = 2
Z_AXIS = 4
XY_AXIS = 3
XZ_AXIS = 5
YZ_AXIS = 6
BOUNCEOBJ_REST_TOP_OR_BOTTOM = 1
BOUNCEOBJ_REST_ANY_SIDE = 2
BOUNCEOBJ_REST_TRAFFIC_CONE = 3
GameObjExceptions = [
	SkaterLanded
	SkaterBailed
	ObjectInRadius
	ObjectOutofRadius
	AnyObjectInRadius
]
CarExceptions = [
	ObjectInRadius
	ObjectOutofRadius
]
BouncyObjExceptions = [
	ObjectInRadius
	ObjectOutofRadius
	Bounce
	DoneBouncing
]
