class W_Axe_Fire extends AxeFire;

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

}