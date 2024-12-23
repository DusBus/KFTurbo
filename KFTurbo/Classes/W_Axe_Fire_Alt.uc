class W_Axe_Fire_Alt extends AxeFireB;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnMeleeFire(self);
    Super.DoFireEffect();
}

defaultproperties
{

}