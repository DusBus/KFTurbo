class W_LAR_Weap extends Winchester;

simulated function BringUp(optional Weapon PrevWeapon)
{
     class'WeaponHelper'.static.WeaponCheckForHint(Self, 15);

     Super.BringUp(PrevWeapon);
}

defaultproperties
{
     PickupClass=Class'KFTurbo.W_LAR_Pickup'

	HudImage=None
	SelectedHudImage=None
	HudImageRef="KillingFloorHUD.WeaponSelect.winchester_unselected"
	SelectedHudImageRef="KillingFloorHUD.WeaponSelect.Winchester"
     
     Skins(0)=None
     Skins(1)=None
     SkinRefs(0)="KF_Weapons_Trip_T.Rifles.winchester_cmb"
     SkinRefs(1)="KF_Weapons_Trip_T.Rifles.winchester_cmb"

     Mesh=None
     MeshRef="KF_Weapons_Trip.Winchester_Trip"
}
