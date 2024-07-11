class W_ThompsonSMG_DT extends DamTypeMAC10MPInc
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
     WeaponClass=Class'KFTurbo.W_ThompsonSMG_Weap'
     DeathString="%k killed %o (Thompson SMG)."
     HeadShotDamageMult=1.100000
     
     bRagdollBullet=True
     KDamageImpulse=5500.000000
     KDeathVel=175.000000
     KDeathUpKick=15.000000
}
