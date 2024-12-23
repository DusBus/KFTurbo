class W_SeekerSix_Fire extends SeekerSixFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnWeaponFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     ProjectileClass=Class'KFTurbo.W_SeekerSix_Proj'
     AmmoClass=Class'KFTurbo.W_SeekerSix_Ammo'
}
