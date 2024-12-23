class W_Claymore_Fire extends ClaymoreSwordFire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnMeleeFire(self);
    Super.DoFireEffect();
}

defaultproperties
{
     MeleeDamage=216
     weaponRange=110.000000
     WideDamageMinHitAngle=0.700000
     FireRate=1.050000
}