#include "MakeSeed.as";
#include "MakeCrate.as";
#include "RulesCore.as";
#include "CTF_Structs.as";
#include "Alert.as";

// There is an easy way for single line multi-commands if I feel like implementing it with Args[0], Args[1], etc.

bool onServerProcessChat( CRules@ this, const string& in text_in, string& out text_out, CPlayer@ player )
{
	if(player is null)
		return true;
	
	string name = player.getUsername();
	
	const bool superadmin = getSecurity().getPlayerSeclev(player).getName() == "Super Admin";
	const bool admin = getSecurity().getPlayerSeclev(player).getName() == "Admin";
	
    CBlob@ blob = player.getBlob();
    if(blob is null){
        return true;
    }
	
	bool chatVisible = true;
    string[]@ args = text_in.split(" ");
	
	Vec2f pos = blob.getAimPos();
	int team = blob.getTeamNum();
	
	if(args != null){
		if(args[0] == "!killme" || args[0] == "!suicide" || args[0] == "!kill" || args[0] == "!die")
		{
			blob.server_Hit(blob, blob.getPosition(), Vec2f(0, 0), 4.0f, 0);
			return true;
		}
		else if(admin || superadmin)
		{
			if(args[0] == "!restart")
			{
				this.set_bool("show restart message", true);
				return true;
			}
			else if(args[0] == "!commands")
			{
				send_chat(this, player, "!warning [player's name] [rule] [warning number(How many times warned)]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!restart [No extra usage]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!s or !stone or !stones [No extra usage]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!g or !gold [No extra usage]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!w or !wood [No extra usage]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!pine [No extra usage]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!oak [No extra usage]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!flower [No extra usage]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!coins [No extra usage]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!settime [Time]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!team [Team Number]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!kill [Player Username]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!restart [No extra usage]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!day [Day Number]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!spawnme [No extra usage]", SColor(255, 255, 0, 0));
				send_chat(this, player, "!settime [Time]", SColor(255, 255, 0, 0));
				send_chat(this, player, "![BlobName]", SColor(255, 255, 0, 0));
				return true;
			}
			/*else if(args[0] == "!warning")
			{
				send_chat(this, player, "usage: !warning [player's name] [rule] [warning number]\nRules are language, team_killing, griefing, bug_abusing, chat_spam, map_spam, rude", SColor(255, 255, 0, 0));
				return true;
			}*/
			else if(args[0] == "!spawnwater")
			{
				getMap().server_setFloodWaterWorldspace(pos, true);
				return true;
			}
			else if(args[0] == "!mypos")
			{
				Vec2f pos = blob.getPosition();
				
				send_chat(this, player, "Pos X:" + pos.x + ", Pos Y:" + pos.y, SColor(255, 255, 0, 0));
				return true;
			}
			else if(args[0] == "!s" || args[0] == "!stone" || args[0] == "!stones")
			{
				CBlob@ b = server_CreateBlob( "mat_stone", team, pos );

				if(b !is null)
				{
					b.server_SetQuantity(250);
				}
				return true;
			}
			else if(args[0] == "!w" || args[0] == "!wood")
			{
				CBlob@ b = server_CreateBlob( "mat_wood", team, pos );

				if(b !is null)
				{
					b.server_SetQuantity(250);
				}
				return true;
			}
			else if(args[0] == "!g" || args[0] == "!gold")
			{
				CBlob@ b = server_CreateBlob( "mat_gold", team, pos );

				if(b !is null)
				{
					b.server_SetQuantity(250);
				}
				return true;
			}
			else if(args[0] == "!pine")
			{
				server_MakeSeed( pos, "tree_pine", 300, 1, 8 );
				return true;
			}
			else if(args[0] == "!oak")
			{
				server_MakeSeed( pos, "tree_bushy", 300, 2, 8 );
				return true;
			}
			else if(args[0] == "!flower")
			{
				server_CreateBlob( "Entities/Natural/Flowers/Flowers.cfg", blob.getTeamNum(), blob.getPosition() );
				return true;
			}
			else if(args[0] == "!coins")
			{
				player.server_setCoins(player.getCoins() + 500);
				return true;
			}
			else if(args[0] == "!bombs")
			{
				for(int i = 0; i < 3; i++)
				{
					CBlob@ b = server_CreateBlob( "mat_bombs", team, pos );
					
					if(b !is null) 
					{
						b.server_SetQuantity(4);
					}
				}
				return true;
			}
			else if(args[0] == "!arrows")
			{
				for(int i = 0; i < 3; i++)
				{
					CBlob@ b = server_CreateBlob( "mat_arrows", team, pos );

					if(b !is null) {
						b.server_SetQuantity(30);
					}
				}
				return true;
			}
			else if(args[0] == "!bombarrows")
			{
				for(int i = 0; i < 3; i++)
				{
					CBlob@ b = server_CreateBlob( "mat_bombarrows", team, pos );

					if(b !is null) {
						b.server_SetQuantity(2);
					}
				}
				return true;
			}
			else if(args[0] == "!crate")
			{
				server_MakeCrate( "", "", 0, team, Vec2f( pos.x, pos.y - 30.0f ) );
				return true;
			}
			else if(blob is null && args[0] == "!spawnme")
			{
				RulesCore@ core;
				getRules().get("core",@core);
				CTFPlayerInfo@ info = cast<CTFPlayerInfo@>(core.getInfoFromPlayer(player));
				info.can_spawn_time=0;
				return true;
			}
			else if(args[0] == "!debug" && superadmin)
			{
				// print all blobs
				CBlob@[] all;
				getBlobs( @all );
				printf("BLOBS TOTAL: " + all.length);
				return true;
			}
			else if(args[0] == "!targets"&& superadmin)
			{
				getRules().set_bool("target lines",!getRules().get_bool("target lines"));
				print("target lines: "+getRules().get_bool("target lines"));
				return true;
			}
			if(args.length > 1)
			{
				if(args[0] == "!warning")
				{
					string num = args[3];
					string rule = args[2];
					string player = args[1];
					string reason, punishment;
					string ignoring = "If you will ignore warnings you will get ban/mute permanently";
					if(rule == "language") 
					{
						reason = "No cursing allowed in the chat";
						punishment = "Mute for 10 mins";
					}
					else if(rule == "team_killing") 
					{
						reason = "Don't kill your teammates";
						punishment = "Ban for a day";
					}
					else if(rule == "griefing") 
					{	
						reason = "Don't grief your own team";
						punishment = "Permanent ban";
					}
					else if(rule == "bug_abusing") 
					{
						reason = "Don't abuse bugs";
						punishment = "Ban for a day";
					}
					else if(rule == "chat_spam") 
					{
						reason = "Don't spam in chat";
						punishment = "Mute for hour";
					}
					else if(rule == "map_spam") 
					{
						reason = "Don't spam map voting";
						punishment = "Kick";
					}
					else if(rule == "rude") 
					{
						reason = "Don't be rude";
						punishment = "Mute for 10 mins";
					}
					text_out = player + ". Warning №" + num + ". " + reason + ". " + "Punishment - " + punishment + ". " + ignoring + ". ";
				}
				else if(args[0] == "!settime")
				{
					float time = parseFloat(args[1]);
					getMap().SetDayTime(time);
				}
				else if(args[0] == "!team")
				{
					int team = parseInt(args[1]);
					blob.server_setTeamNum(team);
				}
				else if(args[0] == "!kill")
				{
					CPlayer@ p = getPlayerByUsername(args[1]);
					if(p !is null) 
					{
						CBlob@ player = p.getBlob();
						if(player !is null)
						{
							player.server_Die();
						}
					}
				}
				else if(args[0] == "!teleto")
				{
					string playerName = args[1];
					
					for(uint i = 0; i < getPlayerCount(); i++)
					{
						CPlayer@ teletoPlayer = getPlayer(i);
						if      (teletoPlayer !is null && teletoPlayer.getUsername() == playerName)
						{
							CBlob@ teletoBlob = teletoPlayer.getBlob();
							if    (teletoBlob !is null)
							{
								blob.setPosition(teletoBlob.getPosition());
								blob.setVelocity( Vec2f_zero );			  
								blob.getShape().PutOnGround();
							}
						}
					}
				}
				else if(args[0] == "!day")
				{
					int time = parseInt(args[1]);
					int day_cycle = getRules().daycycle_speed * 60;
					int gamestart = getRules().get_s32("gamestart");
					int dayNumber = ((getGameTime()-gamestart)/getTicksASecond()/day_cycle)+1;
					int extra = (time - dayNumber)*day_cycle*getTicksASecond();
					getRules().set_s32("gamestart",gamestart-extra);
					getMap().SetDayTime(time);
				}
				return true;
			}
			string name = text_in.substr(1, text_in.size());
				
			server_CreateBlob( name, team, pos );
		}
		return true;
	}
	return true;
}

bool onClientProcessChat(CRules@ this, const string& in text_in, string& out text_out, CPlayer@ player)
{
	const bool superadmin = getSecurity().getPlayerSeclev(player).getName() == "Super Admin";
	const bool admin = getSecurity().getPlayerSeclev(player).getName() == "Admin";
	string[]@ args = text_in.split(" ");
	if(admin || superadmin)
	{
		if(args[0] == "!teleto")
		{
			string playerName = args[1];
			
			for(uint i = 0; i < getPlayerCount(); i++)
			{
				CPlayer@ teletoPlayer = getPlayer(i);
				if      (teletoPlayer !is null && teletoPlayer.getUsername() == playerName)
				{
					CBlob@ teletoBlob = teletoPlayer.getBlob();
					if    (teletoBlob !is null)
					{
						player.getBlob().setPosition(teletoBlob.getPosition());
						player.getBlob().setVelocity( Vec2f_zero );			  
						player.getBlob().getShape().PutOnGround();
					}
				}
			}
		}
	}
	return true;
}

void send_chat(CRules@ this, CPlayer@ player, string x, SColor color)
{
    CBitStream params;
    params.write_netid(player.getNetworkID());
    params.write_u8(color.getRed());
    params.write_u8(color.getGreen());
    params.write_u8(color.getBlue());
    params.write_string(x);
    this.SendCommand(this.getCommandID("send_chat"), params);
}