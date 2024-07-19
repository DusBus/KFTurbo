class KFTurboMasterServerUplink extends IpDrv.MasterServerUplink
	config(KFTurboServer);

var config string ServerColorString;

var config int BlueGradientSteps;
var config array<string> BlueStringGradient;

final function string ApplyGradientToString(String BaseString)
{
	local string GradientString;
	local int StringIndex;
	local int GradientIndex;

	GradientString = "";
	GradientIndex = 0;

	for (StringIndex = 0; StringIndex < Len(BaseString); StringIndex += BlueGradientSteps)
	{
		if (GradientIndex >= BlueStringGradient.Length)
		{
			break;
		}

		GradientString = GradientString $ BlueStringGradient[GradientIndex] $ Mid(BaseString, StringIndex, BlueGradientSteps);
		GradientIndex++;
	}

	GradientString = GradientString $ Mid(BaseString, StringIndex);

	return GradientString;
}

//Slim down the info the server provides to relevant data.
event Refresh()
{
	if ( (!bInitialStateCached) || ( Level.TimeSeconds > CacheRefreshTime )  )
	{
		Level.Game.GetServerInfo(FullCachedServerState);
		
		if (ServerColorString != "")
		{
			FullCachedServerState.ServerName = ServerColorString;
		}

		FullCachedServerState.MapName = ApplyGradientToString(FullCachedServerState.MapName);

		class'GameInfo'.static.AddServerDetail( FullCachedServerState, "Server Mode", Eval(Level.NetMode == NM_ListenServer, "non-dedicated", "dedicated") );
    	class'GameInfo'.static.AddServerDetail( FullCachedServerState, "Server Version", Level.ROVersion );
   		class'GameInfo'.static.AddServerDetail( FullCachedServerState, "VAC Secured", Eval(Level.Game.IsVACSecured(), "Enabled", "Disabled"));
		class'GameInfo'.static.AddServerDetail( FullCachedServerState, "Max Spectators", Level.Game.MaxSpectators );

		if ( Level.Game.AccessControl != None && Level.Game.AccessControl.RequiresPassword() )
		{
			class'GameInfo'.static.AddServerDetail( FullCachedServerState, "Passworded", "True" );
		}

		ApplyServerFlags(FullCachedServerState);
		AppendMutators(FullCachedServerState);
		AppendGameModeInfo(FullCachedServerState);

		CachedServerState = FullCachedServerState;

		Level.Game.GetServerPlayers(FullCachedServerState);

		ServerState 		= FullCachedServerState;
		CacheRefreshTime 	= Level.TimeSeconds + 60;
		bInitialStateCached = false;
	}
	else if (Level.Game.NumPlayers != CachePlayerCount)
	{
		ServerState = CachedServerState;

		Level.Game.GetServerPlayers(ServerState);

		FullCachedServerState = ServerState;
	}
	else
	{
		ServerState = FullCachedServerState;
	}

	CachePlayerCount = Level.Game.NumPlayers;
}

function ApplyServerFlags(out GameInfo.ServerResponseLine ServerState)
{
	local float GameDifficulty;
	GameDifficulty = Level.Game.GameDifficulty;

	if (GameDifficulty >= 7.f)
	{
        ServerState.Flags = ServerState.Flags | 512;
	}
	else if (GameDifficulty >= 5.f)
	{
        ServerState.Flags = ServerState.Flags | 256;
	}
	else if (GameDifficulty >= 4.f)
	{
        ServerState.Flags = ServerState.Flags | 128;
	}
	else if (GameDifficulty >= 2.f)
	{
        ServerState.Flags = ServerState.Flags | 64;
	}
	else if (GameDifficulty >= 1.f)
	{
        ServerState.Flags = ServerState.Flags | 32;
	}

	if (Level.Game.IsVACSecured())
	{
		ServerState.Flags = ServerState.Flags | 16;
	}

	if (Level.Game.AccessControl.RequiresPassword())
	{
		ServerState.Flags = ServerState.Flags | 1;
	}
}

function AppendMutators(out GameInfo.ServerResponseLine ServerState)
{
	local Mutator Mutator;
	local String MutatorName;
	local int Index, ListLength;
	local bool bFound;

	for (Mutator = Level.Game.BaseMutator.NextMutator; Mutator != None; Mutator = Mutator.NextMutator)
	{
		MutatorName = Mutator.GetHumanReadableName();

		//Make these more readable. :)
		if (MutatorName ~= "ServerPerksMut")
		{
			MutatorName = "Server Perks";
		}
		else if (MutatorName ~= "SAMutator")
		{
			MutatorName = "Server Achievements";
		}

		for ( Index=0; Index<ServerState.ServerInfo.Length; Index++ )
		{
			if ( (ServerState.ServerInfo[Index].Value ~= MutatorName) && (ServerState.ServerInfo[Index].Key ~= "Mutator") )
			{
				bFound = true;
				break;
			}
		}

		if ( !bFound )
		{
			ListLength = ServerState.ServerInfo.Length;
			ServerState.ServerInfo.Length = ListLength + 1;
			ServerState.ServerInfo[ListLength].Key = "Mutator";
			ServerState.ServerInfo[ListLength].Value = ApplyGradientToString(MutatorName);
		}
	}
}

function AppendGameModeInfo(out GameInfo.ServerResponseLine ServerState)
{
	local string GameTypeString;
	local KFTurboGameType GameType;

	GameType = KFTurboGameType(Level.Game);
	
	if (GameType == None)
	{
		return;
	}

	if (GameType.IsTestGameType())
	{
		GameTypeString = "Turbo Test Mode";
	}
	else if (GameType.IsHighDifficulty())
	{
		GameTypeString = "Turbo+ Game Mode";
	}
	else
	{
		GameTypeString = "Turbo Game Mode";
	}
	
	class'GameInfo'.static.AddServerDetail( ServerState, "Game Mode", ApplyGradientToString(GameTypeString));
}

defaultproperties
{

}
