extends GPUParticles2D

@export var ComplexParticleList: Dictionary [StringName, ComplexParticle]

func _ready() -> void:
	SignalManager.emitPlayerParticle.connect(emitParticleEffect)
	emitting = false


func emitParticleEffect(particleName: StringName) -> void:
	var currentParticle = ComplexParticleList[particleName]
	process_material = currentParticle.processMaterial
	setUpComplexParticle(currentParticle)
	emitting = true

func setUpComplexParticle(complexParticle: ComplexParticle) -> void:
	process_material = complexParticle.processMaterial
	amount = complexParticle.amount
	amount_ratio = complexParticle.amountRatio
	texture = complexParticle.texture
	one_shot = complexParticle.oneShot
	lifetime = complexParticle.lifeTime
	fixed_fps = complexParticle.fps
	use_fixed_seed = complexParticle.useFixedSeed
	explosiveness = complexParticle.explosiveness
	visibility_rect = complexParticle.VisibilityRect
	trail_enabled = complexParticle.trailsToggle
	trail_lifetime = complexParticle.trailLifeTime
	trail_sections = complexParticle.trailSections
	trail_section_subdivisions = complexParticle.trailSubdivision
	
