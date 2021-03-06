return {
	actorController = {
		projectiles = {
			{
				Action = "combo1_1",
				HurtPosition = 0,
				Projectile = {
					BundleName = "effects/prefab/mingjiang/10009_prefab",
					AssetName = "10009_combo1_1",
				},
				ProjectilGoName = "10009_combo1_1",
				FromPosHierarchyPath = "",
				DelayProjectileEff = 0.2,
				DeleProjectileDelay = 0.0,
				ProjectilNodeHierarchyPath = "",
				ProjectileBtnName = "combo1",
			},
			{
				Action = "combo1_3",
				HurtPosition = 0,
				Projectile = {
					BundleName = "effects/prefab/mingjiang/10009_prefab",
					AssetName = "10009_combo1_1",
				},
				ProjectilGoName = "10009_combo1_1",
				FromPosHierarchyPath = "",
				DelayProjectileEff = 0.3,
				DeleProjectileDelay = 0.0,
				ProjectilNodeHierarchyPath = "guadian",
				ProjectileBtnName = "combo3",
			},
			{
				Action = "combo1_2",
				HurtPosition = 0,
				Projectile = {
					BundleName = "effects/prefab/mingjiang/10009_prefab",
					AssetName = "10009_combo1_1",
				},
				ProjectilGoName = "10009_combo1_1",
				FromPosHierarchyPath = "",
				DelayProjectileEff = 0.0,
				DeleProjectileDelay = 0.0,
				ProjectilNodeHierarchyPath = "guadian",
				ProjectileBtnName = "combo2",
			},
			{
				Action = "combo1_2",
				HurtPosition = 0,
				Projectile = {
					BundleName = "effects/prefab/mingjiang/10009_prefab",
					AssetName = "10009_combo1_1",
				},
				ProjectilGoName = "10009_combo1_1",
				FromPosHierarchyPath = "",
				DelayProjectileEff = 0.2,
				DeleProjectileDelay = 0.0,
				ProjectilNodeHierarchyPath = "guadian",
				ProjectileBtnName = "combo2_1",
			},
		},
		hurts = {},

		beHurtEffecct = {},

		hurtEffectName = "",
		beHurtNodeName = "",
		beHurtAttach = false,
		hurtEffectFreeDelay = 0.0,
		QualityCtrlList = {},

	},
	actorTriggers = {
		effects = {
			{
				triggerEventName = "attack1/begin",
				triggerDelay = 0.0,
				triggerFreeDelay = 0.0,
				effectGoName = "10009_attack2",
				effectAsset = {
					BundleName = "effects/prefab/mingjiang/10009_prefab",
					AssetName = "10009_attack2",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "attack2",
			},
			{
				triggerEventName = "attack2/begin",
				triggerDelay = 0.0,
				triggerFreeDelay = 0.0,
				effectGoName = "10009_attack1",
				effectAsset = {
					BundleName = "effects/prefab/mingjiang/10009_prefab",
					AssetName = "10009_attack1",
				},
				playerAtTarget = true,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "attack1",
			},
			{
				triggerEventName = "attack1/begin",
				triggerDelay = 0.0,
				triggerFreeDelay = 0.0,
				effectGoName = "10009_attack2_1",
				effectAsset = {
					BundleName = "effects/prefab/mingjiang/10009_prefab",
					AssetName = "10009_attack2_1",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "attack2_1",
			},
			{
				triggerEventName = "combo1_1/begin",
				triggerDelay = 0.2,
				triggerFreeDelay = 0.0,
				effectGoName = "10009_combo1",
				effectAsset = {
					BundleName = "effects/prefab/mingjiang/10009_prefab",
					AssetName = "10009_combo1",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "combo1",
			},
			{
				triggerEventName = "combo1_3/begin",
				triggerDelay = 0.3,
				triggerFreeDelay = 0.0,
				effectGoName = "10009_combo3",
				effectAsset = {
					BundleName = "effects/prefab/mingjiang/10009_prefab",
					AssetName = "10009_combo3",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "combo3",
			},
			{
				triggerEventName = "combo1_2/begin",
				triggerDelay = 0.0,
				triggerFreeDelay = 0.0,
				effectGoName = "10009_combo1",
				effectAsset = {
					BundleName = "effects/prefab/mingjiang/10009_prefab",
					AssetName = "10009_combo1",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "combo2",
			},
			{
				triggerEventName = "combo1_2/begin",
				triggerDelay = 0.2,
				triggerFreeDelay = 0.0,
				effectGoName = "10009_combo1",
				effectAsset = {
					BundleName = "effects/prefab/mingjiang/10009_prefab",
					AssetName = "10009_combo1",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "combo2_1",
			},
		},
		halts = {},

		sounds = {
			{
				soundEventName = "combo1_1/begin",
				soundDelay = 0.0,
				soundAudioAsset = {
					BundleName = "audios/sfxs/tianshenskill/tianshen15",
					AssetName = "tianshen15_attack1",
				},
				soundAudioGoName = "tianshen15_attack1",
				soundIsMainRole = false,
			},
			{
				soundEventName = "attack1/begin",
				soundDelay = 0.0,
				soundAudioAsset = {
					BundleName = "audios/sfxs/tianshenskill/tianshen15",
					AssetName = "tianshen15_skill1",
				},
				soundAudioGoName = "tianshen15_skill1",
				soundIsMainRole = false,
			},
			{
				soundEventName = "attack2/begin",
				soundDelay = 0.0,
				soundAudioAsset = {
					BundleName = "audios/sfxs/tianshenskill/tianshen15",
					AssetName = "tianshen15_skill2",
				},
				soundAudioGoName = "tianshen15_skill2",
				soundIsMainRole = false,
			},
			{
				soundEventName = "combo1_2/begin",
				soundDelay = 0.0,
				soundAudioAsset = {
					BundleName = "audios/sfxs/tianshenskill/tianshen15",
					AssetName = "tianshen15_attack2",
				},
				soundAudioGoName = "tianshen15_attack2",
				soundIsMainRole = false,
			},
			{
				soundEventName = "combo1_3/begin",
				soundDelay = 0.0,
				soundAudioAsset = {
					BundleName = "audios/sfxs/tianshenskill/tianshen15",
					AssetName = "tianshen15_attack3",
				},
				soundAudioGoName = "tianshen15_attack3",
				soundIsMainRole = false,
			},
		},
		cameraShakes = {},

		cameraFOVs = {},

		sceneFades = {},

		footsteps = {},

	},
	actorBlinker = {
		blinkFadeIn = 0.0,
		blinkFadeHold = 0.0,
		blinkFadeOut = 0.0,
	},
	TimeLineList = {},

}