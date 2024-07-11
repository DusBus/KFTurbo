class KFPHUDObject extends Object
	within KFPHUDKillingFloor;

simulated function Initialize()
{
	
}

simulated function Tick(float DeltaTime)
{
	
}

simulated function Draw(Canvas C)
{

}

static function String GetStringOfZeroes(int NumberOfDigits)
{
	local String Result;

	Result = string(0);

	while (Len(Result) < NumberOfDigits)
	{
		Result = "0" $ Result;
	}

	return Result;
}

static function String FillStringWithZeroes(String String, int NumberOfDigits)
{
	if (Len(String) > NumberOfDigits)
	{
		return Right(String, NumberOfDigits);
	}

	while (Len(String) < NumberOfDigits)
	{
		String = "0" $ String;
	}

	return String;
}

static final function DrawTextMeticulous(Canvas C, String String, float SizeX)
{
	local String StringToDraw;
	local float SubStringSizeX, SubStringSizeY;
	local float RootX, RootY;

	SizeX /= float(Len(String));

	RootX = C.CurX;
	RootY = C.CurY;

	while (Len(String) > 0)
	{
		StringToDraw = Left(String, 1);

		C.TextSize(StringToDraw, SubStringSizeX, SubStringSizeY);
		C.CurX += (SizeX * 0.5f) - (SubStringSizeX * 0.5f);

		C.DrawText(StringToDraw);

		if (Len(String) == 1)
		{
			break;
		}

		RootX += SizeX;
		C.CurX = RootX;
		C.CurY = RootY;
		String = Right(String, Len(String) - 1);
	}
}