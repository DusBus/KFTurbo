class TurboMonsterCollectionSquad extends Object
     editinlinenew;

//We can add more!
enum EMonster
{
     Clot,
     Crawler,
     Gorefast,
     Stalker,
     Scrake,
     Fleshpound,
     Bloat,
     Siren,
     Husk,

     //In case for some reason we want to manually specify.
     Gorefast_Classy,
     Gorefast_Assassin,
     Crawler_Jumper,
     Bloat_Fathead,
     Siren_Caroler
};

struct SquadEntry
{
     var EMonster Monster;
     var int Count;
};
var array<SquadEntry> Squad;
var bool bEntireSquadMustFit;

defaultproperties
{
     bEntireSquadMustFit=true
}