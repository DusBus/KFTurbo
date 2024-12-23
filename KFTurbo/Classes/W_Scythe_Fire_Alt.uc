class W_Scythe_Fire_Alt extends ScytheFireB;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnMeleeFire(self);
     Super.DoFireEffect();
}

simulated function Timer()
{
    class'MeleeHelper'.static.PerformMeleeSwing(KFWeapon(Weapon), Self);
}

defaultproperties
{
     MeleeDamage=270
     weaponRange=125.000000
     hitDamageClass=Class'KFTurbo.W_Scythe_DT'
     WideDamageMinHitAngle=0.100000
     FireRate=1.450000
}