﻿// BuilderShop.as

#include "Requirements.as"
#include "ShopCommon.as";
#include "Descriptions.as";
#include "WARCosts.as";
#include "CheckSpam.as";

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_wood_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	// SHOP
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_Vec2f("shop menu size", Vec2f(4, 5));
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);

	// CLASS
	this.set_Vec2f("class offset", Vec2f(-6, 0));
	this.set_string("required class", "builder");

	{
		ShopItem@ s = addShopItem(this, "Lantern", "$lantern$", "lantern", Descriptions::lantern, false);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 10);
	}
	{
		ShopItem@ s = addShopItem(this, "Bucket", "$bucket$", "bucket", Descriptions::bucket, false);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 10);
	}
	{
		ShopItem@ s = addShopItem(this, "Sponge", "$sponge$", "sponge", Descriptions::sponge, false);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 15);
	}
	{
		ShopItem@ s = addShopItem(this, "Boulder", "$boulder$", "boulder", Descriptions::boulder, false);
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 35);
	}
	{
		ShopItem@ s = addShopItem(this, "Trampoline", "$trampoline$", "trampoline", Descriptions::trampoline, false);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 150);
	}
	{
		ShopItem@ s = addShopItem(this, "Saw", "$saw$", "saw", Descriptions::saw, false);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 150);
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 100);
	}
	{
		ShopItem@ s = addShopItem(this, "Drill", "$drill$", "drill", Descriptions::drill, false);
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 100);
		AddRequirement(s.requirements, "coin", "", "Coins", 25);
	}
	{
		ShopItem@ s = addShopItem(this, "Mega Drill", "$megadrill$", "megadrill", "The Drill to end all Drills.", false);
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 1000);
		AddRequirement(s.requirements, "blob", "mat_gold", "Gold", 500);
		AddRequirement(s.requirements, "coin", "", "Coins", 250);
	}
	{
		ShopItem@ s = addShopItem(this, "Mega Saw", "$megasaw$", "megasaw", "The Saw to end all Saws.", false);
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 1000);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 1000);
		AddRequirement(s.requirements, "coin", "", "Coins", 250);
	}
	{
		ShopItem@ s = addShopItem(this, "Mega Sponge", "$mega_sponge$", "mega_sponge", "This sponge is a godsend...", false);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 75);
		AddRequirement(s.requirements, "coin", "", "Coins", 25);
	}
	//{
	//	ShopItem@ s = addShopItem(this, "Diving Helmet", "$divinghelmet$", "divinghelmet", "We're going on an adventure! Under the ocean..", false);
	//	AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 50);
	//	AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 50);
	//	AddRequirement(s.requirements, "coin", "", "Coins", 10);
	//}
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
	if(cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("/ChaChing.ogg");
	}
}

void onHealthChange(CBlob@ this, f32 oldHealth)
{
	CSprite@ sprite = this.getSprite();
	if(sprite !is null)
	{
		Animation@ destruction = sprite.getAnimation("destruction");
		if(destruction !is null)
		{
			f32 frame = Maths::Floor((this.getInitialHealth() - this.getHealth()) / (this.getInitialHealth() / sprite.animation.getFramesCount()));
			sprite.animation.frame = frame;
		}
	}
}