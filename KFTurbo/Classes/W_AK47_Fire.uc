class W_AK47_Fire extends AK47Fire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnWeaponFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     AmmoClass=Class'KFTurbo.W_AK47_Ammo'
     MaxSpread=0.096000
}
