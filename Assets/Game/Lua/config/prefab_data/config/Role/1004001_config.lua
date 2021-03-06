return {
	actorController = {
		projectiles = {
			{
				Action = "combo1_3",
				HurtPosition = 0,
				Projectile = {
					BundleName = "effects/prefab/role/1004/1004_combo3_1_prefab",
					AssetName = "1004_combo3_1",
				},
				ProjectilGoName = "1004_combo3_1",
				FromPosHierarchyPath = "model/weapon_point/texiao_guadian01",
				DelayProjectileEff = 0.35,
				DeleProjectileDelay = 0.0,
				ProjectilNodeHierarchyPath = "",
				ProjectileBtnName = "combo3",
			},
			{
				Action = "combo1_1",
				HurtPosition = 0,
				Projectile = {
					BundleName = "effects/prefab/role/1004/1004_combo1_1_prefab",
					AssetName = "1004_combo1_1",
				},
				ProjectilGoName = "1004_combo1_1",
				FromPosHierarchyPath = "model/weapon_point/texiao_guadian01",
				DelayProjectileEff = 0.1,
				DeleProjectileDelay = 0.0,
				ProjectilNodeHierarchyPath = "",
				ProjectileBtnName = "combo1",
			},
			{
				Action = "combo1_2",
				HurtPosition = 0,
				Projectile = {
					BundleName = "effects/prefab/role/1004/1004_combo1_1_prefab",
					AssetName = "1004_combo1_1",
				},
				ProjectilGoName = "1004_combo1_1",
				FromPosHierarchyPath = "model/weapon_point/texiao_guadian01",
				DelayProjectileEff = 0.0,
				DeleProjectileDelay = 0.0,
				ProjectilNodeHierarchyPath = "",
				ProjectileBtnName = "combo2",
			},
			{
				Action = "attack5",
				HurtPosition = 0,
				Projectile = {
					BundleName = "effects/prefab/role/1004/attack5_zidan_prefab",
					AssetName = "attack5_zidan",
				},
				ProjectilGoName = "attack5_zidan",
				FromPosHierarchyPath = "",
				DelayProjectileEff = 0.1,
				DeleProjectileDelay = 0.0,
				ProjectilNodeHierarchyPath = "",
				ProjectileBtnName = "attack5",
			},
			{
				Action = "attack11",
				HurtPosition = 0,
				Projectile = {
					BundleName = "effects/prefab/other/xiannv_qunshang_prefab",
					AssetName = "xiannv_qunshang",
				},
				ProjectilGoName = "xiannv_qunshang",
				FromPosHierarchyPath = "model/weapon_point/texiao_guadian01",
				DelayProjectileEff = 0.0,
				DeleProjectileDelay = 0.0,
				ProjectilNodeHierarchyPath = "",
				ProjectileBtnName = "attack11",
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
				triggerEventName = "attack3/begin",
				triggerDelay = 0.3,
				triggerFreeDelay = 0.0,
				effectGoName = "1004_attack02_1_xc",
				effectAsset = {
					BundleName = "effects/prefab/role/1004/1004_attack02_1_xc_prefab",
					AssetName = "1004_attack02_1_xc",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "atk3",
			},
			{
				triggerEventName = "attack2/begin",
				triggerDelay = 0.6,
				triggerFreeDelay = 0.0,
				effectGoName = "1004_attack03_1",
				effectAsset = {
					BundleName = "effects/prefab/role/1004/1004_attack03_1_prefab",
					AssetName = "1004_attack03_1",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "atk2",
			},
			{
				triggerEventName = "attack4/begin",
				triggerDelay = 0.5,
				triggerFreeDelay = 0.0,
				effectGoName = "1004_attack04_1",
				effectAsset = {
					BundleName = "effects/prefab/role/1004/1004_attack04_1_prefab",
					AssetName = "1004_attack04_1",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "atk4",
			},
			{
				triggerEventName = "attack4/begin",
				triggerDelay = 0.4,
				triggerFreeDelay = 0.0,
				effectGoName = "1004_attack04_2",
				effectAsset = {
					BundleName = "effects/prefab/role/1004/1004_attack04_2_prefab",
					AssetName = "1004_attack04_2",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "atk4_1",
			},
			{
				triggerEventName = "attack1/begin",
				triggerDelay = 0.3,
				triggerFreeDelay = 0.0,
				effectGoName = "1004_attack1",
				effectAsset = {
					BundleName = "effects/prefab/role/1004/1004_attack1_prefab",
					AssetName = "1004_attack1",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "atk1",
			},
			{
				triggerEventName = "attack1/begin",
				triggerDelay = 0.3,
				triggerFreeDelay = 0.0,
				effectGoName = "1004_attack1_1",
				effectAsset = {
					BundleName = "effects/prefab/role/1004/1004_attack1_1_prefab",
					AssetName = "1004_attack1_1",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "atk1_1",
			},
			{
				triggerEventName = "combo1_3/begin",
				triggerDelay = 0.15,
				triggerFreeDelay = 0.0,
				effectGoName = "1004_combo3",
				effectAsset = {
					BundleName = "effects/prefab/role/1004/1004_combo3_prefab",
					AssetName = "1004_combo3",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "combo3",
			},
			{
				triggerEventName = "attack2/begin",
				triggerDelay = 0.55,
				triggerFreeDelay = 0.0,
				effectGoName = "1004_attack03",
				effectAsset = {
					BundleName = "effects/prefab/role/1004/1004_attack03_prefab",
					AssetName = "1004_attack03",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "atk3_1",
			},
			{
				triggerEventName = "combo1_1/begin",
				triggerDelay = 0.0,
				triggerFreeDelay = 0.0,
				effectGoName = "1004_combo1",
				effectAsset = {
					BundleName = "effects/prefab/role/1004/1004_combo1_prefab",
					AssetName = "1004_combo1",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "combo1",
			},
			{
				triggerEventName = "combo1_2/begin",
				triggerDelay = 0.0,
				triggerFreeDelay = 0.0,
				effectGoName = "1004_combo1",
				effectAsset = {
					BundleName = "effects/prefab/role/1004/1004_combo1_prefab",
					AssetName = "1004_combo1",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "combo2",
			},
			{
				triggerEventName = "attack6/begin",
				triggerDelay = 0.0,
				triggerFreeDelay = 0.0,
				effectGoName = "Buff_zhuahen",
				effectAsset = {
					BundleName = "effects/prefab/buff/buff_zhuahen_prefab",
					AssetName = "Buff_zhuahen",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "attack6",
			},
			{
				triggerEventName = "attack7/begin",
				triggerDelay = 0.0,
				triggerFreeDelay = 0.0,
				effectGoName = "BUFF_fuhuo",
				effectAsset = {
					BundleName = "effects/prefab/buff/buff_fuhuo_prefab",
					AssetName = "BUFF_fuhuo",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "attack7",
			},
			{
				triggerEventName = "attack8/begin",
				triggerDelay = 0.0,
				triggerFreeDelay = 0.0,
				effectGoName = "BUFF_wudi_01",
				effectAsset = {
					BundleName = "effects/prefab/buff/buff_wudi_01_prefab",
					AssetName = "BUFF_wudi_01",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "attack8",
			},
			{
				triggerEventName = "attack9/begin",
				triggerDelay = 0.0,
				triggerFreeDelay = 0.0,
				effectGoName = "BUFF_bianji",
				effectAsset = {
					BundleName = "effects/prefab/buff/buff_bianji_prefab",
					AssetName = "BUFF_bianji",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "attack9",
			},
			{
				triggerEventName = "attack10/begin",
				triggerDelay = 0.0,
				triggerFreeDelay = 0.0,
				effectGoName = "chengzhujineng_htmd",
				effectAsset = {
					BundleName = "effects/prefab/misc/chengzhujineng_htmd_prefab",
					AssetName = "chengzhujineng_htmd",
				},
				playerAtTarget = false,
				referenceNodeHierarchyPath = "",
				isAttach = false,
				isRotation = false,
				triggerStopEvent = "",
				effectBtnName = "attack10",
			},
		},
		halts = {},

		sounds = {
			{
				soundEventName = "combo1_1/begin",
				soundDelay = 0.0,
				soundAudioAsset = {
					BundleName = "audios/sfxs/roleskill/role4",
					AssetName = "role4_attack1",
				},
				soundAudioGoName = "role4_attack1",
				soundIsMainRole = false,
			},
			{
				soundEventName = "combo1_2/begin",
				soundDelay = 0.0,
				soundAudioAsset = {
					BundleName = "audios/sfxs/roleskill/role4",
					AssetName = "role4_attack2",
				},
				soundAudioGoName = "role4_attack2",
				soundIsMainRole = false,
			},
			{
				soundEventName = "combo1_3/begin",
				soundDelay = 0.0,
				soundAudioAsset = {
					BundleName = "audios/sfxs/roleskill/role4",
					AssetName = "role4_attack3",
				},
				soundAudioGoName = "role4_attack3",
				soundIsMainRole = false,
			},
			{
				soundEventName = "attack1/begin",
				soundDelay = 0.0,
				soundAudioAsset = {
					BundleName = "audios/sfxs/roleskill/role4",
					AssetName = "role4_skill1",
				},
				soundAudioGoName = "role4_skill1",
				soundIsMainRole = false,
			},
			{
				soundEventName = "attack3/begin",
				soundDelay = 0.2,
				soundAudioAsset = {
					BundleName = "audios/sfxs/roleskill/role4",
					AssetName = "role4_skill2",
				},
				soundAudioGoName = "role4_skill2",
				soundIsMainRole = false,
			},
			{
				soundEventName = "attack2/begin",
				soundDelay = 0.0,
				soundAudioAsset = {
					BundleName = "audios/sfxs/roleskill/role4",
					AssetName = "role4_skill3",
				},
				soundAudioGoName = "role4_skill3",
				soundIsMainRole = false,
			},
			{
				soundEventName = "attack4/begin",
				soundDelay = 0.0,
				soundAudioAsset = {
					BundleName = "audios/sfxs/roleskill/role4",
					AssetName = "role4_skill4",
				},
				soundAudioGoName = "role4_skill4",
				soundIsMainRole = false,
			},
		},
		cameraShakes = {
			{
				CameraShakeBtnName = "??????3_????????????",
				eventName = "attack3/begin",
				numberOfShakes = 15,
				distance = 0.15,
				speed = 100.0,
				delay = 0.55,
				decay = 0.08,
			},
			{
				CameraShakeBtnName = "??????4_????????????",
				eventName = "attack4/begin",
				numberOfShakes = 9,
				distance = 0.25,
				speed = 80.0,
				delay = 0.8,
				decay = 0.05,
			},
		},
		cameraFOVs = {},

		sceneFades = {},

		footsteps = {},

	},
	actorBlinker = nil,
	TimeLineList = {},

}