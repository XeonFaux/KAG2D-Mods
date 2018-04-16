#include "MakeSeed.as";
#include "MakeCrate.as";
#include "MakeScroll.as";
#include "RulesCore.as";
#include "CTF_Structs.as";
#include "Alert.as";

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
	
	if(text_in == "!killme" || text_in == "!suicide" || text_in == "!kill" || text_in == "!die")
	{
		blob.server_Hit(blob, blob.getPosition(), Vec2f(0, 0), 4.0f, 0);
	}
	else if(admin || superadmin)
	{
		if(text_in == "!restart")
		{
			this.set_bool("show restart message", true);
		}
		else if(text_in == "!commands")
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
			send_chat(this, player, "!scroll [Scroll Type]", SColor(255, 255, 0, 0));
			send_chat(this, player, "!settime [Time]", SColor(255, 255, 0, 0));
			send_chat(this, player, "!team [Team Number]", SColor(255, 255, 0, 0));
			send_chat(this, player, "!kill [Player Username]", SColor(255, 255, 0, 0));
			send_chat(this, player, "!restart [No extra usage]", SColor(255, 255, 0, 0));
			send_chat(this, player, "!day [Day Number]", SColor(255, 255, 0, 0));
			send_chat(this, player, "!spawnme [No extra usage]", SColor(255, 255, 0, 0));
			send_chat(this, player, "!settime [Time]", SColor(255, 255, 0, 0));
			send_chat(this, player, "![BlobName]", SColor(255, 255, 0, 0));
		}
		/*else if(text_in == "!warning")
		{
			send_chat(this, player, "usage: !warning [player's name] [rule] [warning number]\nRules are language, team_killing, griefing, bug_abusing, chat_spam, map_spam, rude", SColor(255, 255, 0, 0));
		}*/
		else if(text_in == "!spectate" || text_in == "!spectator")
		{
			RulesCore@ core;
			getRules().get("core",@core);
			CTFPlayerInfo@ info = cast<CTFPlayerInfo@>(core.getInfoFromPlayer(player));
			info.can_spawn_time=99999;
		}
		else if(text_in == "!spawnwater")
		{
			getMap().server_setFloodWaterWorldspace(pos, true);
		}
		else if(text_in == "!mypos")
		{
		    Vec2f pos = blob.getPosition();
			
	        send_chat(this, player, "Pos X:" + pos.x + ", Pos Y:" + pos.y, SColor(255, 255, 0, 0));
		}
		else if(text_in == "!s" || text_in == "!stone" || text_in == "!stones")
		{
			CBlob@ b = server_CreateBlob( "mat_stone", team, pos );

			if(b !is null)
			{
				b.server_SetQuantity(250);
			}
		}
		else if(text_in == "!w" || text_in == "!wood")
		{
			CBlob@ b = server_CreateBlob( "mat_wood", team, pos );

			if(b !is null)
			{
				b.server_SetQuantity(250);
			}
		}
		else if(text_in == "!g" || text_in == "!gold")
		{
			CBlob@ b = server_CreateBlob( "mat_gold", team, pos );

			if(b !is null)
			{
				b.server_SetQuantity(250);
			}
		}
		else if(text_in == "!megasaw" || text_in == "!mega saw" || text_in == "!mega_saw")
		{
			server_CreateBlob( "megasaw", team, pos );
		}
		else if(text_in == "!rocketlauncher" || text_in == "!rocket launcher" || text_in == "!rocket_launcher")
		{
			server_CreateBlob( "RocketLauncher", team, pos );
		}
		else if(text_in == "!pine")
		{
			server_MakeSeed( pos, "tree_pine", 300, 1, 8 );
		}
		else if(text_in == "!oak")
		{
			server_MakeSeed( pos, "tree_bushy", 300, 2, 8 );
		}
		else if(text_in == "!flower")
        {
            server_CreateBlob( "Entities/Natural/Flowers/Flowers.cfg", blob.getTeamNum(), blob.getPosition() );
        }
        else if(text_in == "!coins")
		{
			player.server_setCoins(player.getCoins() + 500);
		}
		else if(text_in == "!bombs")
		{
			for(int i = 0; i < 3; i++)
			{
				CBlob@ b = server_CreateBlob( "mat_bombs", team, pos );
				
				if(b !is null) 
				{
					b.server_SetQuantity(4);
				}
			}
		}
		else if(text_in == "!arrows")
		{
			for(int i = 0; i < 3; i++)
			{
				CBlob@ b = server_CreateBlob( "mat_arrows", team, pos );

				if(b !is null) {
					b.server_SetQuantity(30);
				}
			}
		}
		else if(text_in == "!bombarrows")
		{
			for(int i = 0; i < 3; i++)
			{
				CBlob@ b = server_CreateBlob( "mat_bombarrows", team, pos );

				if(b !is null) {
					b.server_SetQuantity(2);
				}
			}
		}
		else if(text_in == "!meteor")
		{
			CPlayer@ player = getPlayer(XORRandom(getPlayersCount()));
			if(player !is null)
			{
				CBlob@ blob = player.getBlob();
				while(blob is null)
				{
					@player = getPlayer(XORRandom(getPlayersCount()));
					@blob = player.getBlob();
				}
					
				if(blob !is null)
				{
					Vec2f pos = blob.getPosition();
					CMap@ map = getMap();
					const f32 mapWidth = map.tilemapwidth * map.tilesize;
					CBlob@ meteor = server_CreateBlob( "meteor", -1, Vec2f(pos.x, -mapWidth));
					
				}
			}
		}
		else if(text_in == "!crate")
		{
			server_MakeCrate( "", "", 0, team, Vec2f( pos.x, pos.y - 30.0f ) );
		}
		else if(blob is null && text_in == "!spawnme")
		{
			RulesCore@ core;
			getRules().get("core",@core);
			CTFPlayerInfo@ info = cast<CTFPlayerInfo@>(core.getInfoFromPlayer(player));
			info.can_spawn_time=0;
		}
		else if(text_in == "!debug" && superadmin)
	    {
	        // print all blobs
	        CBlob@[] all;
	        getBlobs( @all );
			printf("BLOBS TOTAL: " + all.length);
	    }
	    else if(text_in == "!targets"&& superadmin)
		{
			getRules().set_bool("target lines",!getRules().get_bool("target lines"));
			print("target lines: "+getRules().get_bool("target lines"));
		}
		else if(text_in.substr(0,1) == "!")
        {
        	string[]@ tokens = text_in.split(" ");
         
			if(tokens.length > 1)
			{
				if(tokens[0] == "!scroll")
				{
					server_MakePredefinedScroll(pos, tokens[1]);
				}
				else if(tokens[0] == "!warning")
				{
					string num = tokens[3];
					string rule = tokens[2];
					string player = tokens[1];
					string reason, punishment;
					string ignoring = "If you will ignore warnings you will get ban/mute permanently";
					if(rule == "language") 
					{
						reason = "No cursing allowed in the chat";
						punishment = "Mute for 10 mins";
					}
					if(rule == "team_killing") 
					{
						reason = "Don't kill your teammates";
						punishment = "Ban for a day";
					}
					if(rule == "griefing") 
					{	
						reason = "Don't grief your own team";
						punishment = "Permanent ban";
					}
					if(rule == "bug_abusing") 
					{
						reason = "Don't abuse bugs";
						punishment = "Ban for a day";
					}
					if(rule == "chat_spam") 
					{
						reason = "Don't spam in chat";
						punishment = "Mute for hour";
					}
					if(rule == "map_spam") 
					{
						reason = "Don't spam map voting";
						punishment = "Kick";
					}
					if(rule == "rude") 
					{
						reason = "Don't be rude";
						punishment = "Mute for 10 mins";
					}
					text_out = player + ". Warning №" + num + ". " + reason + ". " + "Punishment - " + punishment + ". " + ignoring + ". ";
				}
				else if(tokens[0] == "!settime")
				{
					float time = parseFloat(tokens[1]);
					getMap().SetDayTime(time);
				}
				else if(tokens[0] == "!team")
				{
					int team = parseInt(tokens[1]);
					blob.server_setTeamNum(team);
				}
				else if(tokens[0] == "!kill")
				{
					CPlayer@ p = getPlayerByUsername(tokens[1]);
					if(p !is null) 
					{
						CBlob@ player = p.getBlob();
						if(player !is null)
						{
							player.server_Die();
						}
					}
				}
				else if(tokens[0] == "!teleto")
				{
					string playerName = tokens[1];
					
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
				else if(tokens[0] == "!day")
				{
					int time = parseInt(tokens[1]);
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
		if(text_in == "!spectate" || text_in == "!spectator")
		{
			int spectator = this.getSpectatorTeamNum();
			player.client_ChangeTeam(spectator);
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