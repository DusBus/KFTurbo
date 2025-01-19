class HoldoutZombieVolume extends ZombieVolume;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Tag == 'Default')
	{
		bVolumeIsEnabled = true;
	}
	else
	{
		bVolumeIsEnabled = false;
	}
}

function NotifyNewWave(int CurWave) {}

defaultproperties
{
	bVolumeIsEnabled = false
}
