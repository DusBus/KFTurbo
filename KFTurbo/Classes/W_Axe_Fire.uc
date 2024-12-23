class W_Axe_Fire extends AxeFire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnMeleeFire(self);
    Super.DoFireEffect();
}

defaultproperties
{

}