class W_V_MK23_Cyber_Weap extends W_MK23_Weap;

var array<Material> LoadedStateMaterialList;
var array<string> LoadedStateMaterialRefList;

var int LastKnownMagAmmo;

simulated function BeginPlay()
{
	Super.BeginPlay();
}

simulated function ClientReload()
{
     Super.ClientReload();

     Skins[0] = LoadedStateMaterialList[3];
}

simulated function ClientFinishReloading()
{
     Super.ClientFinishReloading();
     UpdateSkin();
}

simulated function ClientInterruptReload()
{
     Super.ClientFinishReloading();
     UpdateSkin();
}

simulated function WeaponTick(float DeltaTime)
{
     Super.WeaponTick(DeltaTime);

     if (Level.NetMode == NM_DedicatedServer || bIsReloading)
     {
          return;
     }

     UpdateSkin();
}

simulated function UpdateSkin()
{
     if (LastKnownMagAmmo == MagAmmoRemaining)
     {
          return;
     }

     LastKnownMagAmmo = MagAmmoRemaining;

     if (MagAmmoRemaining > 6)
     {
          Skins[0] = LoadedStateMaterialList[0];
          return;
     }
     
     if (MagAmmoRemaining > 0)
     {
          Skins[0] = LoadedStateMaterialList[1];
          return;
     }

     
     Skins[0] = LoadedStateMaterialList[2];
}

static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
     Super.PreloadAssets(Inv, bSkipRefCount);

	Inv.LinkSkelAnim(MeshAnimation'Cyber_MK23_anim');

     W_V_MK23_Cyber_Weap(Inv).LoadedStateMaterialList[0] = Material(DynamicLoadObject(default.LoadedStateMaterialRefList[0], class'Material'));
     W_V_MK23_Cyber_Weap(Inv).LoadedStateMaterialList[1] = Material(DynamicLoadObject(default.LoadedStateMaterialRefList[1], class'Material'));
     W_V_MK23_Cyber_Weap(Inv).LoadedStateMaterialList[2] = Material(DynamicLoadObject(default.LoadedStateMaterialRefList[2], class'Material'));
     W_V_MK23_Cyber_Weap(Inv).LoadedStateMaterialList[3] = Material(DynamicLoadObject(default.LoadedStateMaterialRefList[3], class'Material'));
}

defaultproperties
{
     LoadedStateMaterialRefList(0)="KFTurbo.Cyber.Cyber_MK23_SHDR"
     LoadedStateMaterialRefList(1)="KFTurbo.Cyber.Cyber_MK23_Warn_SHDR"
     LoadedStateMaterialRefList(2)="KFTurbo.Cyber.Cyber_MK23_Empty_SHDR"
     LoadedStateMaterialRefList(3)="KFTurbo.Cyber.Cyber_MK23_Reload_SHDR"

     ReloadAnim="Reload"

     SkinRefs(0)="KFTurbo.Turbo.MK23_Turbo_SHDR"
     PickupClass=Class'KFTurbo.W_V_MK23_Cyber_Pickup'
     AttachmentClass=Class'KFTurbo.W_V_MK23_Cyber_Attachment'
     Skins(0)=Shader'KFTurbo.Turbo.MK23_Turbo_SHDR'
}
