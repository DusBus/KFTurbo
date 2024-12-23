class W_SPShotgun_Weap extends SPAutoShotgun;

function AddReloadedAmmo()
{
	Super.AddReloadedAmmo();
	if (Role == ROLE_Authority) { class'WeaponHelper'.static.OnWeaponReload(Self); }
}

defaultproperties
{
     MagCapacity=20
     ReloadRate=3.750000
     ReloadAnimRate=0.880000
     Weight=8.000000
     FireModeClass(0)=Class'KFTurbo.W_SPShotgun_Fire'
     FireModeClass(1)=Class'KFTurbo.W_SPShotgun_Fire_Alt'
     PickupClass=Class'KFTurbo.W_SPShotgun_Pickup'
     AttachmentClass=Class'KFTurbo.W_SPShotgun_Attachment'
}
