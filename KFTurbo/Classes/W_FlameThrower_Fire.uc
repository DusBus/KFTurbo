class W_Flamethrower_Fire extends FlameBurstFire;

var int FireEffectCount;

function DoFireEffect()
{
     if (++FireEffectCount >= 5) { class'WeaponHelper'.static.OnWeaponFire(self); FireEffectCount = 0; }
     Super.DoFireEffect();
}

defaultproperties
{
     ProjectileClass=class'KFTurbo.W_FlameThrower_Proj'
     Spread=0.002200
     AmmoClass=class'W_Flamethrower_Ammo'
}
