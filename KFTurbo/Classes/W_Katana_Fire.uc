class W_Katana_Fire extends KatanaFire;

function DoFireEffect()
{
    class'WeaponHelper'.static.OnMeleeFire(self);
    Super.DoFireEffect();
}

defaultproperties
{

}
