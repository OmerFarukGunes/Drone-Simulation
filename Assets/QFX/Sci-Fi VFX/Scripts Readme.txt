--------------------------------------------------------------------------------------------------------------------
Animators
--------------------------------------------------------------------------------------------------------------------
______________
AnimationModule
Common settings to create the custom curve based on an animator

______________
DynamicShaderParameter
Shader parameter for the ShaderAnimator component

______________
LightAnimator
Light intensity of an animator

______________
ShaderAnimator
Curve based on an animator of the shader parameters

--------------------------------------------------------------------------------------------------------------------
______________
ControlledObject
It's a base object to allow you to specify a delay before running the object, and it won't execute the code if object is disabled.
“Stub” for Pool Controller in the next updates.
--------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------
Motion
--------------------------------------------------------------------------------------------------------------------

______________
LerpMotion
Component to achieve lerp motion of the object. Doesn’t use “alone”, only as a part of the secondary scripts.

______________
PhysicsMotion
Launches the objects toward to direction (requires rigidbody) and have an option to destroy on collision.

--------------------------------------------------------------------------------------------------------------------
Target
--------------------------------------------------------------------------------------------------------------------

______________
ObjectFinder
Settings and function to find specific object inside area, to find object which should contains Collider.

______________
TargetAttacher
Scripts to attach and detach object. It uses in the IAnimatorAbility script

--------------------------------------------------------------------------------------------------------------------
Utils
--------------------------------------------------------------------------------------------------------------------

______________
MaterialAdder
Adds the material to the all renderers of the objects

______________
MaterialReplacer
Replaces all materials of all object renderers by one material

______________
GroundAttacher
Attaches the object to the ground

______________
SelfDestroyer
Destroys the object after a delay

---------------------------------------------------------------------------------------------------------
Mouse
---------------------------------------------------------------------------------------------------------

______________
LookAtMouse
Rotates object to the mouse position

______________
MouseControlledObjectLauncher
Run or Stop "ControlledObject" by mouse click

---------------------------------------------------------------------------------------------------------
Collisions
---------------------------------------------------------------------------------------------------------

______________
ColliderCollisionDetector
Detects collisions by OnCollisionEnter event (Requires Collider)

______________
DistanceCollisionDetector
Casts a ray and checks the distance to object

---------------------------------------------------------------------------------------------------------
Fx
---------------------------------------------------------------------------------------------------------
______________
FxObject
FxRotationType

Stub to specify GameObject with rotation type in order to instantiate it by FxObjectInstancer

---------------------------------------------------------------------------------------------------------
Instancer
---------------------------------------------------------------------------------------------------------
______________
CollisionBasedFxInstancer
Instantiates FxObjects on collision event

______________
IEmitterKeeper
If you want to specify FxObjectRotationType to "LookAtEmitter", you need to inherit "projectile" of this interface and set EmitterTransform when you launch it.
To see an example, you can look up at SimpleProjectile and SimpleProjectileLauncher.

---------------------------------------------------------------------------------------------------------
Manager
---------------------------------------------------------------------------------------------------------

______________
ComponentsStartupController
Allows to specify order of ControlledObjectsExecution
Too see and example, you can look up at Hologram3 prefab.

---------------------------------------------------------------------------------------------------------
Utils
---------------------------------------------------------------------------------------------------------

______________
Rotator
Rotates the object

______________
TargetMarker
Allows to "mark" objects or positions and provides "marked" objects. For example, it uses in the HomingMissileLauncher.

---------------------------------------------------------------------------------------------------------
Specific
---------------------------------------------------------------------------------------------------------
______________
AreaProtectorController
Finds a object with "Enemy" class and starts to shoot him.
______________
EngineController
Changes the size of particles depended on speed power
______________
HealingAreaController
Finds a object wiith "Healable" class and attaches particles with it
______________
MotionCloner
Makes a copy of the object
______________
BeamScannerController
Finds object with "BeamScannable" class and changes color if the object is close to the target area
______________
TopographicScanner
Adds the post effect to the camera and TopographicScannable material to the object that touches scan

---------------------------------------------------------------------------------------------------------
Weapon
---------------------------------------------------------------------------------------------------------

______________
Beam Weapon
Creates a beam effect: LineRenderer between StartPosition and EndPosition with launch and impact effects

______________
PhysicsHomingMissile
The missile will be launched towards the launch position, and after a delay, it will follow the target (or coordinates).

______________
PhysicsHomingMissileLauncher
Launches PhysicsHomingMissiles
If you want to launch missile to the "marked" object, you need to select option "FollowTarget";otherwise, you need to
unselect it and set Mode of the TargetMarker to "Position."

______________
SimpleProjectile
The projectile just follows the forward direction.

______________
SimpleProjectileWeapon
Launches SimpleProjectiles with FireRate and LaunchEffect

______________
ProjectileLauncher
Just LaunchesProjectiles