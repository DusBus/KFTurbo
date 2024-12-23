class W_Claymore_Fire_Alt extends ClaymoreSwordFireB;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnMeleeFire(self);
    Super.DoFireEffect();
}

defaultproperties
{
     MeleeDamage=324
     weaponRange=110.000000
     WideDamageMinHitAngle=0.700000
     FireRate=1.250000
}