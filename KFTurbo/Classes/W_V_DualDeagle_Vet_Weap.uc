class W_V_DualDeagle_Vet_Weap extends W_DualDeagle_Weap;

var byte WeaponTier, PreviousWeaponTier;
var float NextVeterancyCheckTime;

simulated function WeaponTick(float DeltaTime)
{
     Super.WeaponTick(DeltaTime);

     if (NextVeterancyCheckTime < Level.TimeSeconds)
     {
          UpdateWeaponTier(); 
     }
}

simulated function UpdateWeaponTier()
{
     NextVeterancyCheckTime = Level.TimeSeconds + 1.f + (FRand() * 1.f);
     WeaponTier = class'VetWeaponHelper'.static.GetPlayerWeaponTier(Pawn(Owner), class'V_Sharpshooter');
     if (WeaponTier == PreviousWeaponTier)
     { 
          return;
     } 

     PreviousWeaponTier = WeaponTier;

     if (Role == ROLE_Authority)
     {
          if (W_V_DualDeagle_Vet_Attachment(ThirdPersonActor) != None)
          {
               W_V_DualDeagle_Vet_Attachment(ThirdPersonActor).SetWeaponTier(WeaponTier);
          }

          if (W_V_DualDeagle_Vet_Attachment(altThirdPersonActor) != None)
          {
               W_V_DualDeagle_Vet_Attachment(altThirdPersonActor).SetWeaponTier(WeaponTier);
          }
     }
     
     UpdateSkin();
}

simulated function UpdateSkin()
{
     local array<int> SkinIndexList;
     class'VetWeaponHelper'.static.UpdateWeaponSkin(Self, WeaponTier, SkinIndexList);
}

defaultproperties
{
	ItemName="Dual Neon Handcannons"

	DemoReplacement=Class'KFTurbo.W_V_Deagle_Vet_Weap'
	PickupClass=Class'KFTurbo.W_V_DualDeagle_Vet_Pickup' 
	AttachmentClass=Class'KFTurbo.W_V_DualDeagle_Vet_Attachment'
	Skins(0)=Shader'KFTurbo.Vet.Handcannon_Vet_SHDR'
}