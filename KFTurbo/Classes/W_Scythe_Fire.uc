class W_Scythe_Fire extends ScytheFire;

function DoFireEffect()
{
     class'WeaponHelper'.static.OnMeleeFire(self);
     Super.DoFireEffect();
}

defaultproperties
{
     MeleeDamage=240
     weaponRange=125.000000
     hitDamageClass=Class'KFTurbo.W_Scythe_DT'
     WideDamageMinHitAngle=0.200000
     FireRate=1.150000
}