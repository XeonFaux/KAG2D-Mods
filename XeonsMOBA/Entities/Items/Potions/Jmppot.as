const u16 EFFECT_DURATION = 50 * 30;

void onInit( CBlob@ this )
{
	this.Tag("activated");
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("activate"))
	{
		CBlob@ carrier = this.getCarriedBlob();
		if    (carrier !is null)
		{
			carrier.set_u32("JmpPotEnd", getGameTime() + EFFECT_DURATION);
			carrier.AddScript( "/JmpPotEffect.as" );
			
			this.getSprite().PlaySound("/Potion.ogg");
			
			if(getNet().isServer())
			{
			    this.server_Die();
			}
		}
    }
}