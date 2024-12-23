class W_Crossbow_Fire extends CrossbowFire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnWeaponFire(self);
    Super.DoFireEffect();
}

defaultproperties
{
     AmmoClass=Class'KFTurbo.W_Crossbow_Ammo'
}
