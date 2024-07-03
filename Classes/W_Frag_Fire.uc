class W_Frag_Fire extends FragFireFix;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    return Super.SpawnProjectile(Start, Dir);
}

function PostSpawnProjectile(Projectile P)
{
    local Quat ResultQuat;
	local vector X, Y, Z;

    Super.PostSpawnProjectile(P);

    if (P != None)
    {
		Weapon.GetViewAxes(X,Y,Z);
        ResultQuat = QuatFromRotator(P.Rotation);
        ResultQuat = QuatProduct(ResultQuat, QuatFromAxisAndAngle(X, 0.6f));
        ResultQuat = QuatProduct(ResultQuat, QuatFromAxisAndAngle(Y, -0.5f));
        ResultQuat = QuatProduct(ResultQuat, QuatFromAxisAndAngle(Z,-0.75f));
        P.SetRotation(QuatToRotator(ResultQuat));
    }
}

defaultproperties
{
    
}
