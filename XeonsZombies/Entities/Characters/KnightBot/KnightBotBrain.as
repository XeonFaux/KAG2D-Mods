// Knight brain

#define SERVER_ONLY

#include "BrainBotCommon.as"


void onInit(CBrain@ this)
{
	InitBrain(this);
	this.server_SetActive(true);
}

void onTick( CBrain@ this )
{
	SearchTarget( this, true, true );

    CBlob @blob = this.getBlob();
	CBlob @target = this.getTarget();

	this.getCurrentScript().tickFrequency = 29;
    if(target !is null)
    {
		this.getCurrentScript().tickFrequency = 1;

		u8 strategy = blob.get_u8("strategy");
		bool standground = blob.get_bool("standground");
		f32 distance;
		const bool visibleTarget = isVisible(blob, target, distance);
		if(visibleTarget && distance < 50.0f)
		{
			strategy = Strategy::attacking; 
		}

		if(strategy == Strategy::idle && !standground)
		{
			strategy = Strategy::chasing; 
		}
		else if(strategy == Strategy::chasing)
		{
		}
		else if(strategy == Strategy::attacking)
		{
			if(!visibleTarget || distance > 120.0f)
			{
				strategy = Strategy::chasing; 
			}
		}

		if(standground && visibleTarget && distance > (blob.getRadius()+10.0f))
		{
			@target = null;
			this.SetTarget( target );
			SearchTarget( this, true, true );
			@blob = this.getBlob();
			@target = this.getTarget();
			if(target !is null)
			{
				f32 distance2;
				const bool visibleTarget2 = isVisible( blob, target, distance2);
				if(visibleTarget2 && distance < (blob.getRadius()+10.0f)) {
					strategy = Strategy::attacking; 
				}
				else
				{
					strategy = Strategy::idle;
				}

				UpdateBlob( blob, target, strategy ); 
			}
		}
		else
		{
			UpdateBlob( blob, target, strategy ); 
		
	        // lose target if its killed (with random cooldown)

			if(LoseTarget( this, target )) {
				strategy = Strategy::idle;
			}
		}
		blob.set_u8("strategy", strategy);	  
    }

	FloatInWater( blob );
}

void UpdateBlob(CBlob@ blob, CBlob@ target, const u8 strategy)
{
	Vec2f targetPos = target.getPosition();
	Vec2f myPos = blob.getPosition();
	bool standground = blob.get_bool("standground");
	if(strategy == Strategy::chasing && !standground) 
	{
		DefaultChaseBlob(blob, target);		
	}
	else if(strategy == Strategy::attacking) 
	{
		AttackBlob(blob, target);
	}
}

	 
void AttackBlob(CBlob@ blob, CBlob @target)
{
    Vec2f mypos = blob.getPosition();
    Vec2f targetPos = target.getPosition();
    Vec2f targetVector = targetPos - mypos;
    f32 targetDistance = targetVector.Length();
	bool standground = blob.get_bool("standground");
    if(targetDistance > blob.getRadius() + 15.0f)
    {
		if(!isFriendAheadOfMe(blob, target) && !standground)
		{
			Chase(blob, target);
		}
    }

	JumpOverObstacles(blob);

    // aim always at enemy
    blob.setAimPos(targetPos);

	const u32 gametime = getGameTime();

	bool shieldTime = gametime - blob.get_u32("shield time") < uint(8 + 60 * 1.33f + XORRandom(20));
	bool backOffTime = gametime - blob.get_u32("backoff time") < uint(1 + XORRandom(20));

    if(target.isKeyPressed(key_action1)) // enemy is attacking me
    {
		int r = XORRandom(35);
		if(r < 2)
		{
			blob.set_u32("shield time", gametime);								  
			shieldTime = true;
		}
		else if(r > 32 && !shieldTime)
		{
			// raycast to check if there is a hole behind

			Vec2f raypos = mypos;
			raypos.x += targetPos.x < mypos.x ? 32.0f : -32.0f;
			Vec2f col;
			if(getMap().rayCastSolid(raypos, raypos + Vec2f(0.0f, 32.0f), col))
			{
				blob.set_u32("backoff time", gametime);
				backOffTime = true;
			}
		}	 		
    }
    else
    {
        // start attack
        if(XORRandom(Maths::Max(3, 30 - (60 + 4) * 2)) == 0 && (getGameTime() - blob.get_u32("attack time")) > 10)
        {
            blob.set_u32("attack time", gametime);
        }
    }

    if(shieldTime) // hold shield for a while
    {
        blob.setKeyPressed(key_action2, true);
    }
	else if(backOffTime) // back off for a bit
	{
		Runaway(blob, target);
	}
    else if(targetDistance < 40.0f && getGameTime() - blob.get_u32("attack time") < (Maths::Min(13, 60 + 3))) // release and attack when appropriate
    {
        if(!target.isKeyPressed( key_action1 )) {
            blob.setKeyPressed( key_action2, false );
        }

        blob.setKeyPressed( key_action1, true );
    }
}