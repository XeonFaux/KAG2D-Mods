void onInit( CBlob@ this )
{
	this.addCommandID("scroll transform bison");
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	caller.CreateGenericButton( 11, Vec2f_zero, this, this.getCommandID("scroll transform bison"), "Transforms a nearby chicken into a Bison", params );
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if(cmd == this.getCommandID("scroll transform bison"))
	{
		bool transformed = false;
		
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if    (caller !is null)
		{
			CBlob@[] blobsInRadius;	   
			if(this.getMap().getBlobsInRadius(this.getPosition(), 128.0f, @blobsInRadius)) 
			{
				for(uint i = 0; i < blobsInRadius.length; i++)
				{
					CBlob@ b = blobsInRadius[i];
					
					if(b.getName() == "chicken")
					{
						server_CreateBlob("bison", caller.getTeamNum(), b.getPosition()); 
					    b.server_Die();
						
						transformed = true;
						break;
					}
				}
			}
		}
		
		if(transformed)
		{
			this.server_Die();
		}
	}
}