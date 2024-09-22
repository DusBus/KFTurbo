//Killing Floor Turbo PlayerBleedActor
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class PlayerBleedActor extends Engine.Info;

var float BleedDamageMultiplier;
var float BleedDamageIntervalMultiplier;
var float BaseBleedInterval;
var float BaseBleedDamage;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    SetTimer(BaseBleedInterval, false);
}

function ModifyBleedAmount(float Modifier)
{
    BleedDamageMultiplier *= Modifier;
}

function ModifyBleedInterval(float Modifier)
{
    BleedDamageIntervalMultiplier *= Modifier;
}

function Timer()
{
    local Controller C;

    SetTimer(FMax(BaseBleedInterval * BleedDamageIntervalMultiplier, 0.1f), false);

    if (KFGameType(Level.Game) != None && !KFGameType(Level.Game).bWaveInProgress)
    {
        return;
    }

    for (C = Level.ControllerList; C != None; C = C.NextController)
    {
        if (PlayerController(C) != None && PlayerController(C).Pawn != None && !PlayerController(C).Pawn.bDeleteMe && PlayerController(C).Pawn.Health > 0)
        {
            PlayerController(C).Pawn.TakeDamage(BaseBleedDamage * BleedDamageMultiplier, None, PlayerController(C).Pawn.Location, vect(0, 0, 0), class'TurboHumanBleed_DT');
        }
    }
}

defaultproperties
{
    BleedDamageMultiplier=1.f
    BleedDamageIntervalMultiplier=1.f

    BaseBleedInterval=8.f
    BaseBleedDamage=5.f
}