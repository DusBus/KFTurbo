class W_FlareRevolver_Fire extends FlareRevolverFire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnWeaponFire(self);
    Super.DoFireEffect();
}

defaultproperties
{
     AmmoClass=Class'KFTurbo.W_FlareRevolver_Ammo'
     ProjectileClass=Class'KFTurbo.W_FlareRevolver_Proj'
}