//Killing Floor Turbo TurboMarkerType
//Special class that allows for special behaviour for a marked actor.
//Distributed under the terms of the GPL-2.0 License.
//For more information see https://github.com/KFPilot/KFTurbo.
class TurboMarkerType extends Object
    abstract;

static function float GetMarkerDuration(Actor MarkedActor, class<Actor> MarkActorClass, Object DataObject, class<Object> DataClass, int MarkerData)
{
    return 10.f;
}

static function bool ShouldReceiveLocationUpdate(Actor MarkedActor, class<Actor> MarkActorClass, Object DataObject, class<Object> DataClass, int MarkerData)
{
    return true;
}

static function String GenerateMarkerDisplayString(Actor MarkedActor, class<Actor> MarkActorClass, Object DataObject, class<Object> DataClass, int MarkerData)
{
    return "";
}