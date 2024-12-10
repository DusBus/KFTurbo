class W_V_SCARMK17_Vet_Weap extends W_SCARMK17_Weap;

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
     WeaponTier = class'VetWeaponHelper'.static.GetPlayerWeaponTier(Pawn(Owner), class'V_Commando');
     if (WeaponTier == PreviousWeaponTier)
     { 
          return;
     } 

     PreviousWeaponTier = WeaponTier;

     if (Role == ROLE_Authority)
     {
          if (W_V_SCARMK17_Vet_Attachment(ThirdPersonActor) != None)
          {
               W_V_SCARMK17_Vet_Attachment(ThirdPersonActor).SetWeaponTier(WeaponTier);
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
     ItemName="Neon SCARMK17"
     
     SkinRefs(0)="KFTurbo.Vet.SCAR_Vet_SHDR"
     PickupClass=Class'KFTurbo.W_V_SCARMK17_Vet_Pickup'
     AttachmentClass=Class'KFTurbo.W_V_SCARMK17_Vet_Attachment'
}
