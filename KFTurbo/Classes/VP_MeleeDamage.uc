//Represents a user's vanilla stat value for this progress type.
class VP_MeleeDamage extends SRCustomProgressInt;

//Hook into killing scrakes as a Berserker here and provide bonus EXP.
function NotifyPlayerKill( Pawn Killed, class<DamageType> damageType )
{
     if (RepLink == None ||  RepLink.StatObject == None || RepLink.OwnerPRI == None || RepLink.OwnerPRI.ClientVeteranSkill != class'V_Berserker')
     {
          return;
     }

     if (P_Scrake(Killed) == None)
     {
          return;
     }

     RepLink.StatObject.AddMeleeDamage(Killed.HealthMax * 0.5f); //Bonus melee damage.
}

defaultproperties
{
     ProgressName="Steam Melee Damage"
}
