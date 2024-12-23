class W_BlowerThrower_Fire extends BlowerThrowerFire;

var int FireEffectCount;

function DoFireEffect()
{
     if (++FireEffectCount >= 10) { class'WeaponHelper'.static.OnWeaponFire(self); FireEffectCount = 0; }
     Super.DoFireEffect();
}

defaultproperties
{

}
