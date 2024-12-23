class W_M14_Fire extends M14EBRFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnWeaponFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     AmmoClass=Class'W_M14_Ammo'
}
