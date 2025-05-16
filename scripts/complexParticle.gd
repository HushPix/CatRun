class_name ComplexParticle extends Resource

@export var processMaterial: ParticleProcessMaterial
@export var amount: int = 3
@export var amountRatio: float = 1
@export var texture: ImageTexture = null

@export_group("Time")
@export var oneShot: bool = false
@export var lifeTime: float = 1
@export var fps: int = 15
@export var useFixedSeed: bool = false
@export var explosiveness: float = 0

@export_group("Drawing")
@export var VisibilityRect: Rect2 = Rect2(-100, -100, 200, 200)

@export_group("Trails")
@export var trailsToggle: bool = false
@export var trailLifeTime: float = 1
@export var trailSections: int = 2
@export var trailSubdivision: int = 2
