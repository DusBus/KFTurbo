//Killing Floor Turbo TurboCardDeck_ProCon
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboCardDeck_ProCon extends TurboCardDeck;

function ActivateExtraMoneyTraderTime(TurboCardReplicationInfo CGRI)
{
    class'TurboWaveEventHandler'.static.RegisterWaveHandler(CGRI, class'ExtraMoneyTraderTimeWaveEventHandler');
}

function ActivateFasterReloadSmallerMag(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWeaponReloadRate(1.3f);
    CGRI.ModifyWeaponMagazineAmmo(0.75f);
}

function ActivateHandSizeWaveSize(TurboCardReplicationInfo CGRI)
{
    CGRI.IncreaseSelectionCount();
    class'TurboWaveEventHandler'.static.RegisterWaveHandler(CGRI, class'IncreaseHandSizeWaveSizeWaveSizeModifier');
    class'IncreaseHandSizeWaveSizeWaveSizeModifier'.static.OnWaveStarted(KFTurboGameType(CGRI.Level.Game), KFTurboGameType(CGRI.Level.Game).WaveNum);
}

function ActivateScrakeDamUpFleshpoundDamDown(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyPlayerFleshpoundDamage(0.7f);
    CGRI.ModifyPlayerScrakeDamage(1.25f);
}

function ActivateBriskPace(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWaveSpeed(3.f);
    class'TurboWaveEventHandler'.static.RegisterWaveHandler(CGRI, class'SmallerFasterWavesWaveSizeModifier');
    class'SmallerFasterWavesWaveSizeModifier'.static.OnWaveStarted(KFTurboGameType(CGRI.Level.Game), KFTurboGameType(CGRI.Level.Game).WaveNum);
}

function ActivateSpecialization(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyOnPerkDamage(1.15f);
    CGRI.ModifyOffPerkDamage(0.7f);
}

function ActivatePrecisionExplosives(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyExplosiveDamage(1.15f);
    CGRI.ModifyExplosiveRadius(0.7f);
}

function ActivateVeryDeepAmmoPockets(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWeaponMaxAmmo(1.2f);
    CGRI.ModifyWeaponReloadRate(0.8f);
}

function ActivateEscalation(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyPlayerDamage(1.2f);
    CGRI.ModifyZombieDamage(0.8f);
}

function ActivateSurplus(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWaveSpeed(1.15f);
    class'TurboWaveEventHandler'.static.RegisterWaveHandler(CGRI, class'SurplusWaveSizeModifier');
    class'SurplusWaveSizeModifier'.static.OnWaveStarted(KFTurboGameType(CGRI.Level.Game), KFTurboGameType(CGRI.Level.Game).WaveNum);
}

function ActivateDoubleEdgeSword(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyPlayerDamage(1.1f);
    CGRI.ModifyFriendlyFireScale(1.1f);
}

function ActivateHeavyAmmunition(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWeaponMaxAmmo(0.8f);
    CGRI.ModifyPlayerRangedDamage(1.1f);
}

function ActivateMagazineOverclock(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWeaponFireRate(1.1f);
    CGRI.ModifyWeaponReloadRate(0.8f);
}

function ActivatePrecisionFire(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWeaponFireRate(0.9f);
    CGRI.ModifyWeaponSpreadAndRecoil(0.7f);
}

function ActivateThinSkinned(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyPlayerSpeed(1.1f);
    CGRI.ModifyZombieDamage(1.1f);
}

function ActivatePremiumWeapons(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyWeaponFireRate(1.05f);
    CGRI.ModifyWeaponReloadRate(1.05f);
    CGRI.ModifyWeaponSpreadAndRecoil(0.95f);

    CGRI.ModifyTraderPriceMultiplier(1.1f);
}

function ActivateTurtleShell(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyPlayerSpeed(0.9f);
    CGRI.ModifyZombieDamage(0.9f);
}

function ActivatePaidInBlood(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyPlayerMaxHealth(0.85f);
    CGRI.ModifyTraderPriceMultiplier(0.5f);
}

function ActivateDealWithDevil(TurboCardReplicationInfo CGRI)
{
    CGRI.ActivateRandomSuperCard();
    CGRI.ActivateRandomEvilCard();
}

function ActivateDistractedDriving(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyStalkerMeleeDamage(2.f);
    CGRI.ModifyStalkerDistraction(1.5f);
}

function ActivateHighSpeedLowDrag(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyPlayerMaxCarryWeight(-1);
    CGRI.ModifyPlayerSpeed(1.1f);
}

function ActivateUnlicensedPractitioner(TurboCardReplicationInfo CGRI)
{
    CGRI.ModifyMedicHealPotency(1.25f);
    CGRI.ModifyNonMedicHealPotency(0.5f);
}

defaultproperties
{
    Begin Object Name=ExtraMoneyTraderTime Class=TurboCard_ProCon
        CardName(0)="Short Term"
        CardName(1)="Reward"
        CardDescriptionList(0)="All players receive"
        CardDescriptionList(1)="500 extra dosh"
        CardDescriptionList(2)="each wave but"
        CardDescriptionList(3)="trader time is"
        CardDescriptionList(4)="reduced by 25%."
        OnActivateCard=ActivateExtraMoneyTraderTime
    End Object
    DeckCardObjectList(0)=TurboCard'ExtraMoneyTraderTime'

    Begin Object Name=FasterReloadSmallerMag Class=TurboCard_ProCon
        CardName(0)="Sawed Off"
        CardName(1)="Magazines"
        CardDescriptionList(0)="Increases reload"
        CardDescriptionList(1)="speed of all"
        CardDescriptionList(2)="weapons by 20% and"
        CardDescriptionList(3)="reduces magazine"
        CardDescriptionList(4)="size by 30%."
        OnActivateCard=ActivateFasterReloadSmallerMag
    End Object
    DeckCardObjectList(1)=TurboCard'FasterReloadSmallerMag'

    Begin Object Name=HandSizeWaveSize Class=TurboCard_ProCon
        CardName(0)="Mo' Cards"
        CardName(1)="Mo' Problems"
        CardDescriptionList(0)="Increases card"
        CardDescriptionList(1)="selection by 1"
        CardDescriptionList(2)="but increases wave"
        CardDescriptionList(3)="size by 25%."
        OnActivateCard=ActivateHandSizeWaveSize
    End Object
    DeckCardObjectList(2)=TurboCard'HandSizeWaveSize'

    Begin Object Name=ScrakeDamUpFleshpoundDamDown Class=TurboCard_ProCon
        CardName(0)="Fleshpound++"
        CardName(1)="Scrake--"
        CardDescriptionList(0)="Fleshpounds take"
        CardDescriptionList(1)="30% less damage"
        CardDescriptionList(2)="but Scrakes take"
        CardDescriptionList(3)="25% more damage."
        OnActivateCard=ActivateScrakeDamUpFleshpoundDamDown
    End Object
    DeckCardObjectList(3)=TurboCard'ScrakeDamUpFleshpoundDamDown'

    Begin Object Name=BriskPace Class=TurboCard_ProCon
        CardName(0)="Brisk Pace"
        CardDescriptionList(0)="Reduces wave size"
        CardDescriptionList(1)="by 25% but"
        CardDescriptionList(2)="increases wave"
        CardDescriptionList(3)="speed by 200%."
        OnActivateCard=ActivateBriskPace
    End Object
    DeckCardObjectList(4)=TurboCard'BriskPace'

    Begin Object Name=Specialization Class=TurboCard_ProCon
        CardName(0)="Specialization"
        CardDescriptionList(0)="Increases on-perk"
        CardDescriptionList(1)="weapon damage by"
        CardDescriptionList(2)="15% but reduces"
        CardDescriptionList(3)="off-perk damage"
        CardDescriptionList(4)="by 30%."
        OnActivateCard=ActivateSpecialization
    End Object
    DeckCardObjectList(5)=TurboCard'Specialization'

    Begin Object Name=PrecisionExplosives Class=TurboCard_ProCon
        CardName(0)="Precision"
        CardName(1)="Explosives"
        CardDescriptionList(0)="Increases explosive"
        CardDescriptionList(1)="damage by 15% but"
        CardDescriptionList(2)="reduces explosive"
        CardDescriptionList(3)="range by 30%."
        OnActivateCard=ActivatePrecisionExplosives
    End Object
    DeckCardObjectList(6)=TurboCard'PrecisionExplosives'

    Begin Object Name=VeryDeepAmmoPockets Class=TurboCard_ProCon
        CardName(0)="Awkwardly Deep"
        CardName(1)="Ammo Pockets"
        CardDescriptionList(0)="Increases max"
        CardDescriptionList(1)="ammo by 20% but"
        CardDescriptionList(2)="reduces reload"
        CardDescriptionList(3)="speed by 20%."
        OnActivateCard=ActivateVeryDeepAmmoPockets
    End Object
    DeckCardObjectList(7)=TurboCard'VeryDeepAmmoPockets'

    Begin Object Name=Escalation Class=TurboCard_ProCon
        CardName(0)="Conflict"
        CardName(1)="Escalation"
        CardDescriptionList(0)="Increases damage"
        CardDescriptionList(1)="by players and"
        CardDescriptionList(2)="zeds by 20%."
        OnActivateCard=ActivateEscalation
    End Object
    DeckCardObjectList(8)=TurboCard'Escalation'

    Begin Object Name=Surplus Class=TurboCard_ProCon
        CardName(0)="Compound"
        CardName(1)="Surplus"
        CardDescriptionList(0)="Increases dosh"
        CardDescriptionList(1)="received from"
        CardDescriptionList(2)="kills by 15%"
        CardDescriptionList(3)="and wave size by 25%."
        OnActivateCard=ActivateSurplus
    End Object
    DeckCardObjectList(9)=TurboCard'Surplus'

    Begin Object Name=DoubleEdgeSword Class=TurboCard_ProCon
        CardName(0)="Double Edged"
        CardName(1)="Sword"
        CardDescriptionList(0)="Increases player"
        CardDescriptionList(1)="damage by 10%"
        CardDescriptionList(2)="and friendly"
        CardDescriptionList(3)="fire damage by 10%."
        OnActivateCard=ActivateDoubleEdgeSword
    End Object
    DeckCardObjectList(10)=TurboCard'DoubleEdgeSword'

    Begin Object Name=HeavyAmmunition Class=TurboCard_ProCon
        CardName(0)="Heavy"
        CardName(1)="Ammunition"
        CardDescriptionList(0)="Increases player"
        CardDescriptionList(1)="ranged damage by"
        CardDescriptionList(2)="10% but reduces"
        CardDescriptionList(3)="max ammo by 20%."
        OnActivateCard=ActivateHeavyAmmunition
    End Object
    DeckCardObjectList(11)=TurboCard'HeavyAmmunition'

    Begin Object Name=MagazineOverclock Class=TurboCard_ProCon
        CardName(0)="Magazine"
        CardName(1)="Overclock"
        CardDescriptionList(0)="Increases firerate"
        CardDescriptionList(1)="by 10% but reduces"
        CardDescriptionList(2)="reload speed by 20%."
        OnActivateCard=ActivateMagazineOverclock
    End Object
    DeckCardObjectList(12)=TurboCard'MagazineOverclock'

    Begin Object Name=PrecisionFire Class=TurboCard_ProCon
        CardName(0)="Precision"
        CardName(1)="Shooting"
        CardDescriptionList(0)="Reduces spread"
        CardDescriptionList(1)="by 30% but reduces"
        CardDescriptionList(2)="firerate by 10%."
        OnActivateCard=ActivatePrecisionFire
    End Object
    DeckCardObjectList(13)=TurboCard'PrecisionFire'

    Begin Object Name=ThinSkinned Class=TurboCard_ProCon
        CardName(0)="Thin Skinned"
        CardDescriptionList(0)="Increases player"
        CardDescriptionList(1)="speed 10% but"
        CardDescriptionList(2)="increases damage"
        CardDescriptionList(3)="taken from"
        CardDescriptionList(4)="zeds by 10%."
        OnActivateCard=ActivateThinSkinned
    End Object
    DeckCardObjectList(14)=TurboCard'ThinSkinned'

    Begin Object Name=PremiumWeapons Class=TurboCard_ProCon
        CardName(0)="Premium"
        CardName(1)="Weapons"
        CardDescriptionList(0)="Increases weapon"
        CardDescriptionList(1)="firerate, reload"
        CardDescriptionList(2)="and accuracy"
        CardDescriptionList(3)="by 5% but"
        CardDescriptionList(4)="increases trader"
        CardDescriptionList(5)="prices by 15%."
        OnActivateCard=ActivatePremiumWeapons
    End Object
    DeckCardObjectList(15)=TurboCard'PremiumWeapons'

    Begin Object Name=TurtleShell Class=TurboCard_ProCon
        CardName(0)="Turtle Shell"
        CardDescriptionList(0)="Reduces damage"
        CardDescriptionList(1)="to players by"
        CardDescriptionList(2)="10% and player"
        CardDescriptionList(3)="move speed by 10%."
        OnActivateCard=ActivateTurtleShell
    End Object
    DeckCardObjectList(16)=TurboCard'TurtleShell'

    Begin Object Name=PaidInBlood Class=TurboCard_ProCon
        CardName(0)="Price Paid"
        CardName(1)="In Blood"
        CardDescriptionList(0)="Reduces player"
        CardDescriptionList(1)="health by 15%"
        CardDescriptionList(2)="and trader"
        CardDescriptionList(3)="prices by 50%."
        OnActivateCard=ActivatePaidInBlood
    End Object
    DeckCardObjectList(17)=TurboCard'PaidInBlood'
    
    Begin Object Name=DealWithDevil Class=TurboCard_ProCon
        CardName(0)="A Deal With"
        CardName(1)="The Devil"
        CardDescriptionList(0)="In exchange for"
        CardDescriptionList(1)="receiving a"
        CardDescriptionList(2)="random Super"
        CardDescriptionList(3)="card, receive"
        CardDescriptionList(4)="a random Evil"
        CardDescriptionList(5)="card as well."
        OnActivateCard=ActivateDealWithDevil
    End Object
    DeckCardObjectList(18)=TurboCard'DealWithDevil'
    
    Begin Object Name=DistractedDriving Class=TurboCard_ProCon
        CardName(0)="Distracted"
        CardName(1)="Driving"
        CardDescriptionList(0)="Stalkers are"
        CardDescriptionList(1)="more distracting"
        CardDescriptionList(2)="and deal 100%"
        CardDescriptionList(3)="more damage."
        OnActivateCard=ActivateDistractedDriving
    End Object
    DeckCardObjectList(19)=TurboCard'DistractedDriving'
    
    Begin Object Name=HighSpeedLowDrag Class=TurboCard_ProCon
        CardName(0)="High Speed"
        CardName(1)="Low Drag"
        CardDescriptionList(0)="Decreases max"
        CardDescriptionList(1)="carry capacity"
        CardDescriptionList(2)="by 1. Increases"
        CardDescriptionList(3)="player movement"
        CardDescriptionList(4)="speed by 10%."
        OnActivateCard=ActivateHighSpeedLowDrag
    End Object
    DeckCardObjectList(20)=TurboCard'HighSpeedLowDrag'
    
    Begin Object Name=UnlicensedPractitioner Class=TurboCard_ProCon
        CardName(0)="Unlicensed"
        CardName(1)="Practitioner"
        CardDescriptionList(0)="Increases heal"
        CardDescriptionList(1)="potency for"
        CardDescriptionList(2)="Field Medics by"
        CardDescriptionList(3)="25% but reduces"
        CardDescriptionList(4)="heal potency"
        CardDescriptionList(5)="for non Field"
        CardDescriptionList(6)="Medics by 50%."
        OnActivateCard=ActivateUnlicensedPractitioner
    End Object
    DeckCardObjectList(21)=TurboCard'UnlicensedPractitioner'


    /*
        Medic Charge Rate +
        Damage Taken +

        
     */
}
