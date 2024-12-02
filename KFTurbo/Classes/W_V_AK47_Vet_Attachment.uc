class W_V_AK47_Vet_Attachment extends GoldenAK47Attachment;

var byte WeaponTier, PreviousTier;
var array<string> LoadedStateMaterialRefList;
var array<Material> LoadedStateMaterialList;

replication
{
	reliable if(bNetDirty && Role == ROLE_Authority)
		WeaponTier;
}

function PostBeginPlay()
{
     Super.PostBeginPlay();
     ApplyPlayerWeaponTier();
}

simulated function PostNetBeginPlay()
{
     Super.PostNetBeginPlay();
     UpdateWeaponTier(WeaponTier);
}

simulated function PostNetReceive()
{
     Super.PostNetReceive();
     UpdateWeaponTier(WeaponTier);
}

function ApplyPlayerWeaponTier()
{
     WeaponTier = class'VetWeaponHelper'.static.GetPlayerWeaponTier(Pawn(Owner), class'V_Commando');

     if (Level.NetMode != NM_DedicatedServer)
     {
          UpdateWeaponTier(WeaponTier);
     }
}

function SetWeaponTier(byte NewWeaponTier)
{
     WeaponTier = NewWeaponTier;
     UpdateWeaponTier(NewWeaponTier);
}

simulated function UpdateWeaponTier(byte NewWeaponTier)
{
     class'VetWeaponHelper'.static.UpdateWeaponAttachmentTier(Self, NewWeaponTier, PreviousTier, LoadedStateMaterialRefList, LoadedStateMaterialList);
     PreviousTier = WeaponTier;
}

static function PreloadAssets(optional KFWeaponAttachment Spawned)
{
     local W_V_AK47_Vet_Attachment WeaponAttachment;

     Super.PreloadAssets(Spawned);
	class'VetWeaponHelper'.static.PreloadVeterancyAttachmentAssets(Spawned, default.LoadedStateMaterialRefList, default.LoadedStateMaterialList);

     WeaponAttachment = W_V_AK47_Vet_Attachment(Spawned);
     if (WeaponAttachment != None)
     {
          WeaponAttachment.LoadedStateMaterialList = default.LoadedStateMaterialList;
          WeaponAttachment.ApplyPlayerWeaponTier();
     }
}

static function bool UnloadAssets()
{
     Super.UnloadAssets();
	class'VetWeaponHelper'.static.UnloadAttachmentAssets(default.LoadedStateMaterialList);
	return true;
}

defaultproperties
{
     bNetNotify=true

     LoadedStateMaterialRefList(0)="KFTurbo.VetTiers.AK47_Vet_3rd_Red_SHDR"
     LoadedStateMaterialRefList(1)="KFTurbo.VetTiers.AK47_Vet_3rd_Green_SHDR"
     LoadedStateMaterialRefList(2)="KFTurbo.VetTiers.AK47_Vet_3rd_Blue_SHDR"
     LoadedStateMaterialRefList(3)="KFTurbo.VetTiers.AK47_Vet_3rd_Pink_SHDR"
     LoadedStateMaterialRefList(4)="KFTurbo.VetTiers.AK47_Vet_3rd_Purple_SHDR"
     LoadedStateMaterialRefList(5)="KFTurbo.VetTiers.AK47_Vet_3rd_Orange_SHDR"
     LoadedStateMaterialRefList(6)="KFTurbo.VetTiers.AK47_Vet_3rd_Gold_SHDR"
     LoadedStateMaterialRefList(7)="KFTurbo.VetTiers.AK47_Vet_3rd_Plat_SHDR"
     LoadedStateMaterialRefList(8)="KFTurbo.VetTiers.AK47_Vet_3rd_Rainbow_SHDR"

     SkinRefs(0)="KFTurbo.Vet.AK47_Vet_3rd_SHDR"
}