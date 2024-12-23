class W_BlowerThrower_Weap extends BlowerThrower;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
     if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     PickupClass=Class'KFTurbo.W_BlowerThrower_Pickup'
     InventoryGroup=4
}
