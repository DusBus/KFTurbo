class W_SCARMK17_Fire extends SCARMK17Fire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnWeaponFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     MaxSpread=0.090000
     AmmoClass=class'W_SCARMK17_Ammo'
}