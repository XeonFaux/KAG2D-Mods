#include "RunnerCommon.as";

const f32 speed_modifier = 1.30f;

void onTick( CBlob@ this )
{
    if (getGameTime() >= this.get_u32("SpdPotEnd") || this.hasTag("dead"))
    {
        this.getCurrentScript().runFlags |= Script::remove_after_this;
    }
	else
	{
		RunnerMoveVars@ moveVars;
		if (this.get("moveVars", @moveVars))
		{
			moveVars.walkFactor *= speed_modifier;
		}
	}
}