class KFTurboLaneZombieVolume extends ZombieVolume;

//I can't believe how ZombieVolume implements this...
function NotifyNewWave(int CurWave)
{
	local int Index;

	if (DisabledWaveNums.Length == 0)
	{
		return;
	}

	for (Index = 0; Index < DisabledWaveNums.Length; Index++)
	{
		if (DisabledWaveNums[Index] == CurWave)
		{
			if (bVolumeIsEnabled)
			{
				bVolumeIsEnabled = false;
				TriggerEvent(ToggledEnabledEvent,Self,None);
				return;
			}
		}
	}

	if(!bVolumeIsEnabled)
	{
		bVolumeIsEnabled = true;
		TriggerEvent(ToggledEnabledEvent,Self,None);
	}
}

defaultproperties
{

}
