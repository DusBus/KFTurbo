class W_SPGrenade_Fire extends SPGrenadeFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnWeaponFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     ProjectileClass=Class'KFTurbo.W_SPGrenade_Proj'
     AmmoClass=Class'KFTurbo.W_SPGrenade_Ammo'
}