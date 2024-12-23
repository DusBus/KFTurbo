class W_MKb42_Fire extends MKb42Fire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnWeaponFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     MaxSpread=0.102000
     AmmoClass=class'W_MKb42_Ammo'
}