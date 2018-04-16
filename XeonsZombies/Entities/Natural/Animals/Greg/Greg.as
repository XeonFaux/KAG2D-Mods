

#include "CreatureCommon.as";

const int COINS_ON_DEATH = 25;

void onInit(CBlob@ this)
{
	TargetInfo[] infos;

	{
		TargetInfo i("player", 1.0f, true, true);
		infos.push_back(i);
	}
	
	this.set("target infos", @infos);

	this.set_u16("coins on death", COINS_ON_DEATH);
	this.set_f32(target_searchrad_property, 512.0f);

    this.getSprite().SetEmitSound("Wings.ogg");
    this.getSprite().SetEmitSoundPaused(false);

    this.getSprite().PlayRandomSound("/GregCry");
	this.getShape().SetRotationsAllowed(false);

	this.getBrain().server_SetActive(true);

	this.set_f32("gib health", 0.0f);
    this.Tag("flesh");
	
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1 )
{
	if (blob !is null && blob is this.getBrain().getTarget())
	{
		this.server_AttachTo(blob, "PICKUP");
	}
}

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
	if (damage >= 0.0f)
	{
	    this.getSprite().PlaySound( "/ZombieHit" );
    }
	return damage;
}

void onDie( CBlob@ this )
{
    this.getSprite().PlaySound("/GregRoar");	
}

void onRender(CSprite@ this)
{
	if((getLocalPlayer().getUsername() == "0DarkShadow0" || getLocalPlayer().getUsername() == "xTheSwiftOnex" || getLocalPlayer().getUsername() == "XeonFaux") && getRules().get_bool("target lines"))
	{
		CBlob@ blob = this.getBlob();
		CBlob@ target = blob.getBrain().getTarget();

		if (target !is null)
		{
			Vec2f mypos = getDriver().getScreenPosFromWorldPos(blob.getPosition());
			Vec2f targetpos = getDriver().getScreenPosFromWorldPos(target.getPosition());
			GUI::DrawArrow2D( mypos,targetpos , SColor(0xffdd2212) );
		}
	}
}