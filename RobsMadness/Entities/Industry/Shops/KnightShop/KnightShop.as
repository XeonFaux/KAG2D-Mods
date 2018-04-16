// Knight Workshop

#include "Requirements.as"
#include "ShopCommon.as";
#include "CheckSpam.as";

s32 cost_bomb = 20;
s32 cost_waterbomb = 30;
s32 cost_keg = 100;
s32 cost_mine = 30;
s32 cost_minimine = 3;
s32 cost_molotov = 30;

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_wood_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;
	
	AddIconToken("$molotov$", "Molotov.png", Vec2f(16, 16), 0);
	AddIconToken("$minimine$", "MiniMine.png", Vec2f(16,16), 0);

	ConfigFile cfg = ConfigFile();
	cfg.loadFile("ShopCosts.cfg");

	cost_bomb = cfg.read_s32("cost_bomb_plain", cost_bomb);
	cost_waterbomb = cfg.read_s32("cost_bomb_water", cost_waterbomb);
	cost_mine = cfg.read_s32("cost_mine", cost_mine);
	cost_keg = cfg.read_s32("cost_keg", cost_keg);
	cost_minimine = cfg.read_s32("cost_minimine", cost_minimine);
	cost_molotov = cfg.read_s32("cost_molotov", cost_molotov);

	// SHOP
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_Vec2f("shop menu size", Vec2f(6, 1));
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);

	// CLASS
	this.set_Vec2f("class offset", Vec2f(-6, 0));
	this.set_string("required class", "knight");

	{
		ShopItem@ s = addShopItem(this, "Bomb", "$bomb$", "mat_bombs", "small bomb", true);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_bomb);
	}
	{
		ShopItem@ s = addShopItem(this, "Water Bomb", "$waterbomb$", "mat_waterbombs", "stunning bomb", true);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_waterbomb);
	}
	{
		ShopItem@ s = addShopItem(this, "Mine", "$mine$", "mine", "self triggered bomb", false);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_mine);
	}
	{
		ShopItem@ s = addShopItem(this, "Minimine", "$minimine$", "minimine", "minimine for sapper", false);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_minimine);
	}
	{
		ShopItem@ s = addShopItem(this, "Keg", "$keg$", "keg", "large bomb", false);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_keg);
    }
	{
		ShopItem@ s = addShopItem(this, "Molotov", "$molotov$", "molotov", "fire bomb", false);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_molotov);
	}
	 
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if(caller.getConfig() == this.get_string("required class"))
	{
		this.set_Vec2f("shop offset", Vec2f_zero);
	}
	else
	{
		this.set_Vec2f("shop offset", Vec2f(6, 0));
	}
	this.set_bool("shop available", this.isOverlapping(caller));
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("/ChaChing.ogg");
	}
}
