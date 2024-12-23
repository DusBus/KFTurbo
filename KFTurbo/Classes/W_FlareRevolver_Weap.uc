class W_FlareRevolver_Weap extends FlareRevolver;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
	if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

simulated function bool PutDown()
{
	if ( Instigator.PendingWeapon.class == class'W_DualFlare_Weap' )
	{
		bIsReloading = false;
	}

	return Super(KFWeapon).PutDown();
}

defaultproperties
{
     FireModeClass(0)=Class'KFTurbo.W_FlareRevolver_Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PickupClass=Class'KFTurbo.W_FlareRevolver_Pickup'
}