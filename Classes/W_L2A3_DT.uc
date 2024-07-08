class W_L2A3_DT extends DamTypeMAC10MPInc
	abstract;


static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
	if( Killed.IsA('ZombieStalker') )
     {
          KFStatsAndAchievements.AddStalkerKill();
     }
}

static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
	KFStatsAndAchievements.AddBullpupDamage(Amount);
	KFStatsAndAchievements.AddFlameThrowerDamage(Amount);
	KFStatsAndAchievements.AddMac10BurnDamage(Amount);
}

defaultproperties
{
     bDealBurningDamage=True
     WeaponClass=Class'KFTurbo.W_L2A3_Weap'
     DeathString="%k killed %o (L2A3)."
     HeadShotDamageMult=1.100000
     
     bRagdollBullet=True
     KDamageImpulse=5500.000000
     KDeathVel=175.000000
     KDeathUpKick=15.000000
}
