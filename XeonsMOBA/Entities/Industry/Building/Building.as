// Genreic building

#include "Requirements.as"
#include "ShopCommon.as";
#include "Descriptions.as";
#include "WARCosts.as";
#include "CheckSpam.as";

//are builders the only ones that can finish construction?
const bool builder_only = false;

void onInit( CBlob@ this )
{	 
	CMap@ map = this.getMap();
	Vec2f tilepos = this.getPosition()-Vec2f(0,4);
	TileType cavewall = map.getTile(tilepos).type;
	if (cavewall != CMap::tile_ground_back){
		this.server_Die();
	}
	this.set_TileType("background tile", CMap::tile_wood_back);
	//this.getSprite().getConsts().accurateLighting = true;

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	// SHOP

	this.set_Vec2f("shop offset", Vec2f(0, 0));
	this.set_Vec2f("shop menu size", Vec2f(4,7));	
	this.set_string("shop description", "Construct");
	this.set_u8("shop icon", 12);
	
	this.Tag(SHOP_AUTOCLOSE);
	
	{
		ShopItem@ s = addShopItem( this, "Knight Shop", "$knightshop$", "knightshop", "Spawns Knights to fight for your cause!" );
		AddRequirement( s.requirements, "blob", "mat_wood", "Wood", 500 );
	}	
	{
		ShopItem@ s = addShopItem( this, "Archer Shop", "$archershop$", "archershop", "Spawns Archers to fight for your cause!" );
		AddRequirement( s.requirements, "blob", "mat_wood", "Wood", 400 );
	}
	{
		ShopItem@ s = addShopItem( this, "Heavy Knight Shop", "$hknightshop$", "hknightshop", "Spawns Heavy Knights to fight for your cause!" );
		AddRequirement( s.requirements, "blob", "mat_wood", "Wood", 800 );
	}
	{
		ShopItem@ s = addShopItem( this, "Chicken Shop", "$chickenshop$", "chickenshop", "Spawns Chickens... for what purpose?!" );
		AddRequirement( s.requirements, "blob", "mat_wood", "Wood", 100 );
	}
	{
		ShopItem@ s = addShopItem( this, "Trader Shop", "$trader2$", "trader2", "Buy Potions!" );
		AddRequirement( s.requirements, "blob", "mat_wood", "Wood", 100 );
	}
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	if(this.isOverlapping(caller))
		this.set_bool("shop available", !builder_only || caller.getName() == "builder" );
	else
		this.set_bool("shop available", false );
}
								   
void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	bool isServer = getNet().isServer();
	if (cmd == this.getCommandID("shop made item"))
	{
		this.Tag("shop disabled"); //no double-builds
		
		CBlob@ caller = getBlobByNetworkID( params.read_netid() );
		CBlob@ item = getBlobByNetworkID( params.read_netid() );
		if (item !is null && caller !is null)
		{
			this.getSprite().PlaySound("/Construct.ogg" ); 
			this.getSprite().getVars().gibbed = true;
			this.server_Die();

			// open factory upgrade menu immediately
			if (item.getName() == "factory")
			{
				CBitStream factoryParams;
				factoryParams.write_netid( caller.getNetworkID() );
				item.SendCommand( item.getCommandID("upgrade factory menu"), factoryParams );
			}
		}
	}
}
