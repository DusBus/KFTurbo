![](./KFTurbo/readme/TurboSticker.png)

# KFTurbo

Killing Floor Turbo is a balance overhaul mod for Killing Floor that also adds some QoL features.


## Balance
KFTurbo's goal is to take underused perks and weapons and bring them inline with the competency of established weapons in the meta by either improving them or reworking them to make them more viable during high difficulty gameplay. When balancing, KFTurbo considers the M14 LAR Sharpshooter and M32 M79 Demolitions as the baseline to compare other perks and loadouts against. Weapons that are considered too strong or cause boring gameplay have been nerfed (such as the Crossbow), or removed (such as the ZED guns).


## Changelog
KFTurbo has a changelog containing all gameplay changes [here](./changelog.md).

## Setup
To play KFTurbo, make sure [Server Perks](https://forums.tripwireinteractive.com/index.php?threads/mut-per-server-stats.36898/) and [Server Achievements](https://github.com/scaryghost/ServerAchievements) are installed on the server. Once those are installed, download the latest `KFTurbo.zip` from the [releases page](https://github.com/KFPilot/KFTurbo/releases) and drag and drop all the files in the `StagedKFTurboGitHub` folder into the server's `System` folder. Releases come with a `ServerPerks.ini` and `ServerAchievements.ini` which provide the default setup for KFTurbo.

The following are required to be set in a server's launch command for KFTurbo to function properly at startup;

`?game=KFTurbo.KFTurboGameType`

`?Mutator=ServerPerksMut.ServerPerksMut,ServerAchievements.SAMutator,KFTurbo.KFTurboMut,KFTurboServer.KFTurboServerMut`

To play with the Randomizer mutator, add `KFTurboRandomizer.KFTurboRandomizerMut` to the list of mutators.

To play on KFTurbo Plus difficulty, the GameType launch parameter must be set to `?game=KFTurbo.KFTurboGameTypePlus`.

If a server is using Marco's [KFMapVoteV2](https://forums.tripwireinteractive.com/index.php?threads/mod-voting-handler-fix.43202/), ensure that, for the KFTurbo voting option, the GameType is set to either Killing Floor Turbo Game Type or Killing Floor Turbo+ Game Type and that the following mutators are enabled;
- Server Veterancy Handler V7
- Server Achievements
- Killing Floor Turbo
- Killing Floor Turbo Server

## Credits
Marco for [Server Perks](https://forums.tripwireinteractive.com/index.php?threads/mut-per-server-stats.36898/) (and extra help)!

Scary Ghost for [Server Achievements](https://github.com/scaryghost/ServerAchievements).

RuneStorm for grenades assets from [Ballistics Weapons](https://www.runestorm.com/ballistic).

BroodOvermind for the [Classy Gorefast](https://steamcommunity.com/sharedfiles/filedetails/?id=112768245).
