//Core of the KFTurbo mod. Needed for server-side only changes.
class KFTurboServerMut extends Mutator;

var TurboRepLinkHandler RepLinkHandler;

simulated function PostBeginPlay()
{
	local ServerPerksMut ServerPerksMutator;
	Super.PostBeginPlay();

	if(Role == ROLE_Authority)
	{
		//Manages the creation of KFPRepLink for players joining.
		RepLinkHandler = Spawn(class'TurboRepLinkHandler', self);
	}

	//Tell server perks to turn off progression saving if we're disabling them.
	foreach Level.AllActors( class'ServerPerksMut', ServerPerksMutator )
	{
		ServerPerksMutator.bNoSavingProgress = !class'KFTurboGameType'.static.StaticAreStatsAndAchievementsEnabled(Self);
		break;
	}

	//Listen for disabling stats/achievements/perk selection.
	if (KFTurboGameType(Level.Game) != None)
	{
		KFTurboGameType(Level.Game).OnStatsAndAchievementsDisabled = OnStatsAndAchievementsDisabled;
		KFTurboGameType(Level.Game).LockPerkSelection = LockPerkSelection;
	}
}

function AddMutator(Mutator M)
{
	local ServerPerksMut ServerPerksMutator;

	Super.AddMutator(M);

	ServerPerksMutator = ServerPerksMut(M);
	
	//Tell server perks to turn off progression saving if we're disabling them.
	if (ServerPerksMutator != None)
	{
		ServerPerksMutator.bNoSavingProgress = !class'KFTurboGameType'.static.StaticAreStatsAndAchievementsEnabled(Self);
	}
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if (RepLinkHandler != none && ServerStStats(Other) != None)
	{
		RepLinkHandler.OnServerStatsAdded(ServerStStats(Other));
	}

	return true;
}

function OnStatsAndAchievementsDisabled()
{	
	local ServerPerksMut ServerPerksMut;

	foreach Level.AllActors( class'ServerPerksMut', ServerPerksMut )
		break;

	if (ServerPerksMut == None)
	{
		return;
	}

	ServerPerksMut.bNoSavingProgress = true;
}

function LockPerkSelection(bool bLock)
{	
	local ServerPerksMut ServerPerksMut;

	foreach Level.AllActors( class'ServerPerksMut', ServerPerksMut )
		break;

	if (ServerPerksMut == None)
	{
		return;
	}

	ServerPerksMut.bNoPerkChanges = bLock;
}

simulated function String GetHumanReadableName()
{
	return FriendlyName;
}

defaultproperties
{
	bAddToServerPackages=False
	GroupName="KF-KFTurboServer"
	FriendlyName="Killing Floor Turbo Server"
	Description="Mutator for KFTurbo Server."
}