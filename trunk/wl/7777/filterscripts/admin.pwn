// === [Includes] ===
#include <a_samp>
#include <core>
#include <float>
#include <Dini>
#include <dudb>
#include <dutils>

// === [Some configuring] ===
#define JOIN_MESSAGES false
#define Leavemessages false
#define leavemessagecolor COLOR_RED
#define joinmessagecolor COLOR_RED

#define Level1Commands1 ">> /a [text], /clearchat, /kick [id] [reason], /akill [id], /warn [id] [reason], /getid [name]"
#define Level1Commands2 ">> /(un)freeze [id], /playerinfo [id], /asay [msg], /ip [id], /mute [id], /ajail [id] [time], /force [id]"
#define Level2Commands1 ">> /atele [teleportee id] [dest. id], /ban [id], /announce [msg], /giveweapon [id] [weaponid] [ammo]"
#define Level2Commands2 ">> /goto [id], /gethere [id], /eject [id], /sethealth [id] [amt], /setarmour [id] [amt] /healall, /armourall"
#define Level3Commands1 ">> /disarm [id], /disarmall, /explode [id], /time [0-23], /weather [weatherid], /getallhere"
#define Level3Commands2 ">> /setmoney [id] [amount], /jetpack, /setname [id] [name]"
#define Level4Commands1 ">> /setlevel [id] [lvl], /restart, /disarmall, /reloadbans, /reloadlogs, /mapname [name], /servername [name]"
// === [Color Defines] ===
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_DBLUE 0x2641FEAA
#define COLOR_BLUE 0x33AAFFFF
#define COLOR_GREEN 0x33AA33AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xFF0000FF
#define COLOR_LIGHTRED 0xFF6347AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_LIGHTGREEN 0x9ACD32AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_YELLOW2 0xF5DEB3AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_DBLUE 0x2641FEAA
#define COLOR_CYAN 0x00FFFFAA
#define COLOR_SYSTEM 0xEFEFF7AA


// === [Pragma] ===
#pragma unused ret_memcpy

// === [Forward] ===
forward IsStringAName(string[]);
forward GetPlayerID(string[]);
forward SendMessageToAdmins(color,const string[]);
forward Restart();
forward Unjail(giveplayerid);
// === [Loops] ===
new Mute[MAX_PLAYERS];
new level[MAX_PLAYERS];
new aMessage[MAX_PLAYERS];
new freeze[MAX_PLAYERS];
new WarnedTimes[MAX_PLAYERS];
new logged[MAX_PLAYERS];


// === [Enum] ===
enum pInfo
{
    pAdmin,
}

new PlayerInfo[MAX_PLAYERS][pInfo];

public OnFilterScriptInit()
{
	print("  *****************************************************  ");
	print("  *| Andre's Administration Filterscript Version 0.7 |*  ");
	print("  *****************************************************  ");
}
public OnPlayerPrivmsg(playerid, recieverid, text[])
{
	new string[256];
	new playername[MAX_PLAYER_NAME];
	new recievername[MAX_PLAYER_NAME];
	GetPlayerName(recieverid, recievername, sizeof(recievername));
	GetPlayerName(playerid, playername, sizeof(playername));
	format(string, sizeof(string), "AdmPM: PM from %s to %s: %s", playername, recievername, text);
 	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerInfo[i][pAdmin] >= 1 && i != playerid && i != recieverid)
		{
			SendClientMessage(i,  COLOR_CYAN, string);
		}
	}
	return 1;

}
// === [OnPlayerText] ===
public OnPlayerText(playerid,text[])
{
    if(Mute[playerid] == 1)
	{
		SendClientMessage(playerid, COLOR_RED, " 被禁言,公开频道发言失败,请联系管理员!");
		return 0;
    }
    if(Mute[playerid] == 0)
    {
		if(strfind(text, "Hack", true) == 0)
		{
		    SendClientMessageToAll(COLOR_RED, "Use /gm [id] [reason] to report a abusive player!");
		}
		if(strfind(text, "noob", true) == 0)
		{
		    SendClientMessageToAll(COLOR_RED, "Don't flame please!");
		}
		return 1;
	}
	return 0;
}


// === [OnPlayerConnect] ===
public OnPlayerConnect(playerid)
{
	//new string[256];
	new PlayerName[24];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
    if(dini_Exists(udb_encode(PlayerName)))
	{
		SendClientMessage(playerid, COLOR_BLUE, " 注册用户, /login 密码 登录.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_BLUE, " 本服务器无须注册!请不要使用纯数字(0~9)作为用户名!");
	}
	logged[playerid] = 0;
	freeze[playerid] = 0;
	level[playerid] = 0;
	PlayerInfo[playerid][pAdmin] = 0;
	#if JOIN_MESSAGES == true
	format(string, sizeof(string), "%s(%i) has connected the server", PlayerName, playerid);
	SendClientMessageToAll(joinmessagecolor, string);
	#endif
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	#if Leavemessages
	new PlayerName[30], string[256];
	switch (reason)
	{
 		case 0:
    	{
			GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
			format(string, 256, "%s has left the server (Timeout)", PlayerName);
			SendClientMessageToAll(leavemessagecolor, string);
		}
		case 1:
 		{
			GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
			format(string, 256, "%s has left the server (Leaving)", PlayerName);
			SendClientMessageToAll(leavemessagecolor, string);
		}
		case 2:
	 	{
			GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
			format(string, 256, "%s has left the server (Kicked/banned)", PlayerName);
			SendClientMessageToAll(leavemessagecolor, string);
		}
	}
	#endif
}

// === [OnPlayerCommandText] ===
public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[256];
	new idx;
	new tmp[256];
	new giveplayer[MAX_PLAYER_NAME];
	new sendername[MAX_PLAYER_NAME];
	new string[256];
	new playername[256];
	new tmp2[256];
	cmd = strtok(cmdtext, idx);
	new giveplayerid;
// === [Getid] ===
	if(strcmp(cmd,"/getid",true) == 0 || strcmp(cmd, "/id", true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,COLOR_DBLUE," 指南: /getid [关键字]");
			return 1;
		}
		format(string,sizeof(string)," 关键字: \"%s\": ",tmp);
		SendClientMessage(playerid,COLOR_RED,string);
		new found=0;
		for(new i=0; i <= MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
		  		new foundname[MAX_PLAYER_NAME];
		  		GetPlayerName(i, foundname, MAX_PLAYER_NAME);
				new namelen = strlen(foundname);
				new bool:searched=false;
		    	for(new pos=0; pos <= namelen; pos++)
				{
					if(searched != true)
					{
						if(strfind(foundname,tmp,true) == pos)
						{
			                found++;
							format(string,sizeof(string),"%d. %s (ID %d)",found,foundname,i);
							SendClientMessage(playerid, COLOR_GREEN ,string);
							searched = true;
						}
					}
				}
			}
		}
		return 1;
	}
// === [Register] ===
	if(strcmp(cmd, "/gmreg", true) == 0)
	{
	    tmp = strtok(cmdtext, idx);
 		GetPlayerName(playerid, playername, sizeof(playername));
        if(20 < strlen(tmp) || strlen(tmp) < 3)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 错误! 密码要长于等于 3 ,少于 20 个字符！");
			return 1;
		}
	    if(!strlen(tmp))
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /reg [password] ~ Will make You registered with the server!");

		else
		{
			if (!dini_Exists(udb_encode(playername)))
			{
				dini_Create(udb_encode(playername));
				dini_IntSet(udb_encode(playername), "password", udb_hash(tmp));
				dini_Set(udb_encode(playername),"pass",tmp);
    			dini_IntSet(udb_encode(playername), "level", 0);
				format(string, sizeof(string), "%s(%i) registered with password \"%s\"", playername, playerid, tmp);
				printf(string);
				format(string, sizeof(string), " 恭喜! %s ,注册成功. 密码: \"%s\". 请牢记,以免丢失!", playername, tmp);
				SendClientMessage(playerid, COLOR_PURPLE, string);
				SendClientMessage(playerid, COLOR_PURPLE, " 首次登录成功!");
				logged[playerid] = 1;
				PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "A error has occured while attempting to register with the server!");
				format(string, sizeof(string), "Username %s is already registered on this server!", playername,tmp);
				SendClientMessage(playerid, COLOR_RED, string);
			}
		}

		return 1;
	}
// === [Login] ===
	if(strcmp(cmd, "/login", true) == 0)
	{
		if(logged[playerid] == 1)
		{
		    SendClientMessage(playerid, COLOR_RED, " 你已经登录,不可重复登录!");
		    return 1;
		}
	    tmp = strtok(cmdtext, idx);

 		GetPlayerName(playerid, playername, sizeof(playername));
	    if(!strlen(tmp))
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /login 密码");

		else
		{
			if(dini_Exists(udb_encode(playername)))
			{
					tmp2 = dini_Get(udb_encode(playername), "password");
			  		if(udb_hash(tmp) != strval(tmp2))
	  				{
	  				    new PlayerName[24];
	  				    GetPlayerName(playerid, PlayerName, 30);
	  				    format(string, sizeof(string), " 错误! 请闭起眼睛心中默念我是 %s ,再试试.", PlayerName);
	  				    SendClientMessage(playerid, COLOR_RED, string);
					}
					else
					{
						logged[playerid] = 1;
						dini_Set(udb_encode(playername),"pass",tmp);
		                PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(playername), "level");
		                GameTextForPlayer(playerid, "~b~Successfully logged in!",2000,1);
		                PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		                if(PlayerInfo[playerid][pAdmin] == 0)
		                {
		                    new PlayerName[24];
	  				    	GetPlayerName(playerid, PlayerName, 30);
	  				    	format(string, sizeof(string), " 欢迎回来, %s , 今天没什么通知!", PlayerName);
	  				    	SendClientMessage(playerid, COLOR_CYAN, string);
						}
		                if(PlayerInfo[playerid][pAdmin] == 1)
                  		{
                    		new PlayerName[24];
	  				    	GetPlayerName(playerid, PlayerName, 30);
	  				    	format(string, sizeof(string), " 欢迎回来, %s , 权限: 1 (游戏管理员)", PlayerName);
	  				    	SendClientMessage(playerid, COLOR_CYAN, string);
						}
						if(PlayerInfo[playerid][pAdmin] == 2)
                  		{
                    		new PlayerName[24];
	  				    	GetPlayerName(playerid, PlayerName, 30);
	  				    	format(string, sizeof(string), " 欢迎回来, %s , 权限: 2 (高级游戏管理员)", PlayerName);
	  				    	SendClientMessage(playerid, COLOR_CYAN, string);
						}
						if(PlayerInfo[playerid][pAdmin] == 3)
                  		{
                    		new PlayerName[24];
	  				    	GetPlayerName(playerid, PlayerName, 30);
	  				    	format(string, sizeof(string), " 欢迎回来, %s , 权限: 3 (服务器管理员)", PlayerName);
	  				    	SendClientMessage(playerid, COLOR_CYAN, string);
						}
						if(PlayerInfo[playerid][pAdmin] == 4)
						{
						    new PlayerName[24];
	  				    	GetPlayerName(playerid, PlayerName, 30);
	  				    	format(string, sizeof(string), " 欢迎回来, %s , 权限: 4 (高级服务器管理员)", PlayerName);
	  				    	SendClientMessage(playerid, COLOR_CYAN, string);
						}
						return 1;
					}
			}
			else
			{
			    format(string, sizeof(string), "The account %s, does not exist on this server. Please type /reg [password] to create an account.", playername);
				SendClientMessage(playerid, COLOR_RED, string);
			}
		}

		return 1;
	}
// === [Adminhelp] ===
	if(strcmp(cmd, "/adminhelp", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
	    if(logged[playerid] == 1)
	    {
		    if(PlayerInfo[playerid][pAdmin] >= 1)
		    {
		        new PlayerName[30];
		        GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /adminhelp & succeeded - The player is admin!", PlayerName);
				if(PlayerInfo[playerid][pAdmin] == 1)
				{
					SendClientMessage(playerid, COLOR_RED, ">>-+== Level 1 Admin commands =====================================================================================");
					SendClientMessage(playerid, COLOR_YELLOW, Level1Commands1);
					SendClientMessage(playerid, COLOR_YELLOW, Level1Commands2);
				}
				if(PlayerInfo[playerid][pAdmin] == 2)
				{
				    SendClientMessage(playerid, COLOR_RED, ">>-+== Level 2 Admin commands =====================================================================================");
			 		SendClientMessage(playerid, COLOR_YELLOW, Level1Commands1);
					SendClientMessage(playerid, COLOR_YELLOW, Level1Commands2);
					SendClientMessage(playerid, COLOR_YELLOW, Level2Commands1);
					SendClientMessage(playerid, COLOR_YELLOW, Level2Commands2);
				}
				if(PlayerInfo[playerid][pAdmin] == 3)
				{
				    SendClientMessage(playerid, COLOR_RED, ">>-+== Level 3 Admin commands =====================================================================================");
					SendClientMessage(playerid, COLOR_YELLOW, Level1Commands1);
					SendClientMessage(playerid, COLOR_YELLOW, Level1Commands2);
					SendClientMessage(playerid, COLOR_YELLOW, Level2Commands1);
					SendClientMessage(playerid, COLOR_YELLOW, Level2Commands2);
					SendClientMessage(playerid, COLOR_YELLOW, Level3Commands1);
					SendClientMessage(playerid, COLOR_YELLOW, Level3Commands2);
				}
				if(PlayerInfo[playerid][pAdmin] == 4)
				{
				    SendClientMessage(playerid, COLOR_RED, ">>-+== Level 4 Admin commands =====================================================================================");
				    SendClientMessage(playerid, COLOR_YELLOW, Level1Commands1);
					SendClientMessage(playerid, COLOR_YELLOW, Level1Commands2);
					SendClientMessage(playerid, COLOR_YELLOW, Level2Commands1);
					SendClientMessage(playerid, COLOR_YELLOW, Level2Commands2);
					SendClientMessage(playerid, COLOR_YELLOW, Level3Commands1);
					SendClientMessage(playerid, COLOR_YELLOW, Level3Commands2);
					SendClientMessage(playerid, COLOR_YELLOW, Level4Commands1);
				}
				return 1;
			}
			else
			{
			    new PlayerName[30];
			    GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /adminhelp & FAILED - The player isn't admin", PlayerName);
	   			SendClientMessage(playerid, COLOR_CYAN, "You are not authorized to use this command!");
				return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
	}
	if(strcmp(cmd, "/servername", true) == 0)
	{
	    tmp = strtok(cmdtext, idx);
	    if(!strlen(tmp)) return SendClientMessage(playerid, COLOR_DBLUE," 指南: /servername [new name]");
	    if(logged[playerid] == 1)
	    {
	        if(PlayerInfo[playerid][pAdmin] >= 4)
	        {
	            format(tmp,sizeof(tmp),"hostname %s",cmdtext[11]);
	            SendRconCommand(tmp);
	            GetPlayerName(playerid, sendername, sizeof(sendername));
	            format(string, sizeof(string), "  新闻: %s(%i) has changed server name to: %s",sendername, playerid, cmdtext[11]);
	            SendClientMessageToAll(COLOR_BLUE,string);
	        }
	        else
	        {
	            SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
	        }
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
	    }
	    return 1;
	}
	if(strcmp(cmd, "/mapname", true) == 0)
	{
	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE," 指南: /mapname [new name]");
			return 1;
		}
		if(logged[playerid] == 1)
		{
		    if(PlayerInfo[playerid][pAdmin] >= 4)
		    {
				format(tmp,sizeof(tmp),"mapname %s",cmdtext[8]);
				SendRconCommand(tmp);
				GetPlayerName(playerid, sendername, sizeof(sendername));
				format(string, sizeof(string), "  新闻: %s(%i) has changed maps name to: %s",sendername, playerid, cmdtext[8]);
				SendClientMessageToAll(COLOR_BLUE,string);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Explode] ===
	if(strcmp(cmd, "/explode", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /explode [playerid]");
			return 1;
		}
		giveplayerid = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 3)
			{
			    if(IsPlayerConnected(giveplayerid))
			    {
					format(string, sizeof(string), " 新闻: 管理员 %s 对 %s 大吼:气功波!",sendername, giveplayer);
					SendClientMessageToAll(COLOR_BLUE, string);
					SetPlayerHealth(giveplayerid, 10);
					new Float:boomx, Float:boomy, Float:boomz;
					GetPlayerPos(giveplayerid,boomx, boomy, boomz);
					CreateExplosion(boomx, boomy , boomz, 7, 10);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /explode to explode %s", PlayerName, giveplayer);
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
	if(strcmp(cmd, "/setname", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		new tmpp[256];
		tmpp = strtok(cmdtext, idx);
		if(!strlen(tmpp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /setname [playerid] [new nick]");
			return 1;
		}
		giveplayerid = strval(tmpp);
		tmp = strtok(cmdtext, idx);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
		    if(PlayerInfo[playerid][pAdmin] >= 3)
		    {
		        if(IsPlayerConnected(giveplayerid))
		        {
					SetPlayerName(giveplayerid, tmp);
					format(string, sizeof(string), " 新闻: %s(%i) has changed Your name to %s", sendername, playerid, tmp);
					SendClientMessage(giveplayerid, COLOR_BLUE, string);
					format(string, sizeof(string), " 新闻: You have changed ID %i's name to %s", giveplayerid, tmp);
					SendClientMessage(playerid, COLOR_BLUE, string);
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
	  	return 1;
  	}
// === [Asay] ===
	if(strcmp(cmd, "/asay", true) == 0)
	{
		GetPlayerName(playerid, sendername, sizeof(sendername));
		PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		new length = strlen(cmdtext);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[64];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /asay [text]");
			return 1;
		}
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
				format(string, sizeof(string), " 管理员 %s 宣布: %s", sendername, result);
				SendClientMessageToAll(COLOR_BLUE,string);
				new PlayerName[30];
				GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /asay to send the message: %s", PlayerName, result);
	     	}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
				return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Goto] ===
 	if(strcmp(cmd, "/goto", true) == 0)
	{
		GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /goto [playerid]");
			return 1;
		}
		new Float:plocx,Float:plocy,Float:plocz;
		giveplayerid = strval(tmp);
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerConnected(giveplayerid))
				{
				    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					format(string, sizeof(string), " 新闻: 你传送到 %s(%i) 身边", giveplayer, giveplayerid);
					SendClientMessage(playerid, COLOR_BLUE, string);
					GetPlayerPos(giveplayerid, plocx, plocy, plocz);
					new intid = GetPlayerInterior(giveplayerid);
					SetPlayerInterior(playerid,intid);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /goto to go to %s", PlayerName, giveplayer);
					if (GetPlayerState(playerid) == 2)
					{
						new tmpcar = GetPlayerVehicleID(playerid);
						SetVehiclePos(tmpcar, plocx, plocy+4, plocz);
					}
					else
					{
							SetPlayerPos(playerid,plocx,plocy+2, plocz);
					}
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Gethere] ===
	if(strcmp(cmd, "/gethere", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /gethere [playerid]");
			return 1;
		}
		new Float:plocx,Float:plocy,Float:plocz;
		giveplayerid = strval(tmp);
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
			    if(IsPlayerConnected(giveplayerid))
			    {
				    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					format(string, sizeof(string), " 新闻: 你被传送到 %s(%i) 身边.",sendername,playerid);
					SendClientMessage(giveplayerid, COLOR_BLUE, string);
					format(string, sizeof(string), " 新闻: 你传送 %s(%i) 到身边.", giveplayer, giveplayerid);
					SendClientMessage(playerid, COLOR_BLUE, string);
					GetPlayerPos(playerid, plocx, plocy, plocz);
					new intid = GetPlayerInterior(playerid);
					SetPlayerInterior(giveplayerid,intid);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /gethere to get %s", PlayerName, giveplayer);

					if (GetPlayerState(giveplayerid) == 2)
					{
						new tmpcar = GetPlayerVehicleID(giveplayerid);
						SetVehiclePos(tmpcar, plocx, plocy+4, plocz);
					}
					else
					{
							SetPlayerPos(giveplayerid,plocx,plocy+2, plocz);
					}
				}
				else
				{
	                format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
            SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === {Getall] ===
	if(strcmp(cmd, "/getallhere", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 3)
			{
			    for(new i = 0; i < MAX_PLAYERS; i ++)
			    {
			        if(IsPlayerConnected(i))
			        {
						format(string, sizeof(string), " 新闻: 管理员 %s 传送所有玩家到身边.", sendername);
						SendClientMessage(i, COLOR_BLUE, string);
						new Float:ix, Float:iy, Float:iz;
						GetPlayerPos(playerid, ix, iy, iz);
						SetPlayerInterior(i, GetPlayerInterior(playerid));
						SetPlayerPos(i, ix, iy, iz+1);
						new PlayerName[30];
						GetPlayerName(playerid, PlayerName, 30);
						printf("[Command] %s has used /getallhere to get all", PlayerName);
					}
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Time] ===
	if(strcmp(cmd, "/time", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /time [0-23]");
			return 1;
		}
		new time;
		time = strval(tmp);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 3)
			{
			    if(time > 23)
				{
					SendClientMessage(playerid, COLOR_RED, "Invalid time! 0 - 23!");
				}
				else
				{
		            SetWorldTime(time);
					format(string, sizeof(string), " 新闻: Admin %s set the time to: %d",sendername,time);
					SendClientMessageToAll(COLOR_BLUE, string);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /time to set time to: %s", PlayerName, time);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Weather] ===
	if(strcmp(cmd, "/weather", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
		PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /weather [weather]");
			SendClientMessage(playerid, COLOR_DBLUE, "Weather IDs: /weatherids");
			return 1;
		}
		new weather;
		weather = strval(tmp);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 3)
			{
	            SetWeather(weather);
				format(string, sizeof(string), " 新闻: Admin %s set the weather to: %d",sendername,weather);
				SendClientMessageToAll(COLOR_BLUE, string);
				SendClientMessage(playerid, COLOR_DBLUE, "See wheater IDs at: /weatherids");
				new PlayerName[30];
				GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /weather to set weather to: %s", PlayerName, weather);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Weatherids] ===
 	if(strcmp(cmd, "/weatherids", true) == 0 || strcmp(cmd, "/weathers", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
		PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		if(PlayerInfo[playerid][pAdmin] >= 3)
		{
			SendClientMessage(playerid, COLOR_RED, ">>+-=================================== [Weather Ids: ] ================================");
			SendClientMessage(playerid, COLOR_YELLOW, ">>| 1 - Blue | 2 - Lighter Blue | 3 - Light (No color) | 4 - Even more lighter");
			SendClientMessage(playerid, COLOR_YELLOW, ">>| 5 - Normal Sun | 7 - (My PC = Beeped) | 8 - Rainy | 9 - Foggy | 10 - Standard weather");
			SendClientMessage(playerid, COLOR_YELLOW, ">>| 12 - Colourless, with alittle fog | 13 - Less foggy  | 15 - Little fog ");
			SendClientMessage(playerid, COLOR_YELLOW, ">>| 16 - Rainy | 17 - Hot | 19 - Sandstorm | 20 - Dark | 21 - Some very wierd weather ");
			SendClientMessage(playerid, COLOR_YELLOW, ">>| 23 - Atmosphere style (?) | 25 - Abit foggy | 27 - Abit \"White\" | 30 - Thunderstorm ");
			SendClientMessage(playerid, COLOR_YELLOW, ">>| 32 - Foggy | 33 - Hot | 35 - City weather | 37 - Warm | 38 - Even more city weather ");
			SendClientMessage(playerid, COLOR_YELLOW, ">>| 39 - Industrial weather | 40 - Yellow weather | 42 - Black fog | 43 - Industrial fog ");
			SendClientMessage(playerid, COLOR_YELLOW, ">>| 44 & 45 - Some wierd weather. -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- (c) IDs by PaoloP");
			SendClientMessage(playerid, COLOR_RED, ">>+-====================================================================================");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
		}
		return 1;
	}
	if(strcmp(cmd,"/gm",true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		GetPlayerName(giveplayerid, giveplayer, sizeof(sendername));
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,COLOR_DBLUE," 指南: /gm id 原因");
			return 1;
		}
		giveplayerid = strval(tmp);
		if(IsPlayerConnected(giveplayerid))
		{
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' ')) {
				idx++;
				}
				new offset = idx;
				new result[64];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1))) {
				result[idx - offset] = cmdtext[idx];
				idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					SendClientMessage(playerid,COLOR_WHITE,"SERVER: /gm [id] [reason]");
					return 1;
				}
				GetPlayerName(giveplayerid, giveplayer, sizeof(sendername));
				format(string,sizeof(string)," 注意: 玩家 %s (%d) 被 %s (%d) 举报. [原因: %s]", giveplayer, giveplayerid, sendername, playerid,result);
				for(new i=0;i<MAX_PLAYERS;i++)
				{
					if(IsPlayerConnected(i) && PlayerInfo[i][pAdmin] >= 1)
					{
						SendClientMessage(i,COLOR_RED,string);
					}
				}
		}
		else
		{
			format(string, sizeof(string), "%d is not an active player.", giveplayerid);
			SendClientMessage(playerid, COLOR_RED, string);
		}
		return 1;
	}
// === [Slap] ===
 	if(strcmp(cmd, "/slap", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /slap [playerid]");
			return 1;
		}
		new Float:health;
		new Float:px, Float:py, Float:pz;
		giveplayerid = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(IsPlayerConnected(giveplayerid))
			    {
					GetPlayerHealth(giveplayerid, health);
					SetPlayerHealth(giveplayerid, health-5);
					GetPlayerPos(giveplayerid, px, py, pz);
					SetPlayerPos(giveplayerid, px, py, pz+5);
					format(string, sizeof(string), " 新闻: %s was slapped by %s",giveplayer, sendername);
					SendClientMessageToAll(COLOR_BLUE, string);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /slap to slap %s", PlayerName, giveplayer);
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Reloadbans] ===
	if(strcmp(cmd,"/reloadbans",true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		if(logged[playerid] == 1)
		{
		    if(PlayerInfo[playerid][pAdmin] == 4)
		    {
				SendClientMessage(playerid, COLOR_RED, "You have successfully re-loaded bans!");
				SendRconCommand("reloadbans");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Reloadlogs] ===
	if(strcmp(cmd,"/reloadlogs",true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] == 4)
			{
				SendRconCommand("reloadlogs");
				SendClientMessage(playerid, COLOR_RED, "You have successfully re-loaded logs!");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
	if(strcmp(cmd,"/loadfs",true) == 0)
	{
	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /loadfs [filterscript name]");
			return 1;
		}
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] == 4)
			{
				format(string,sizeof(string),"loadfs %s",tmp);
				SendRconCommand(string);
				format(string,sizeof(string)," 新闻: If the name You've entered for the FS, %s.amx is loaded",tmp);
				SendClientMessage(playerid,COLOR_BLUE,string);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}

	if(strcmp(cmd,"/unloadfs",true) == 0)
	{
	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /unloadfs [filterscript name]");
			return 1;
		}
		if(logged[playerid] == 1)
		{
		    if(PlayerInfo[playerid][pAdmin] == 4)
		    {
				format(string,sizeof(string),"unloadfs %s",tmp);
				SendRconCommand(string);
				format(string,sizeof(string)," 新闻: If the name You've entered for the FS, %s.amx is unloaded",tmp);
				SendClientMessage(playerid,COLOR_BLUE,string);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}

	if(strcmp(cmd,"/changemode",true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /changemode [mode name]");
			return 1;
		}
		if(logged[playerid] == 1)
		{
		    if(PlayerInfo[playerid][pAdmin] == 4)
		    {
				format(string,sizeof(string),"changemode %s",tmp);
				SendRconCommand(string);
				format(string,sizeof(string)," 新闻: Trying to change mode to %s...",tmp);
				SendClientMessage(playerid,COLOR_BLUE,string);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Giveweapon] ===
    if(strcmp(cmd,"/giveweapon",true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		new weaponid;
		new giveammo;
		tmp = strtok(cmdtext, idx);
		if(logged[playerid] == 0)
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE," 指南: /giveweapon [id] [weaponid] [ammo]");
			return 1;
		}
        giveplayerid = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE," 指南: /giveweapon [id] [weaponid] [ammo]");
			return 1;
		}
		weaponid = strval(tmp);
		if(weaponid < 0 || weaponid > 46)
		{
		    SendClientMessage(playerid, COLOR_RED, " 错误: Invalid weapon ID.");
		    return 1;
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			giveammo = 100000;
		}
		giveammo = strval(tmp);
		if(giveammo < 0 || giveammo > 100000)
		{
		    SendClientMessage(playerid, COLOR_RED, " 错误: Invalid ammo.");
		    return 1;
		}
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 3)
			{
			    if(IsPlayerConnected(giveplayerid))
			    {
					GivePlayerWeapon(giveplayerid, weaponid, giveammo);
					GetPlayerName(playerid, sendername, sizeof(sendername));
					new weaponname[20];
					GetWeaponName(weaponid, weaponname, sizeof(weaponname));
					GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
					format(string,sizeof(string)," 新闻: You gave %s \"%s\" with %d ammo",giveplayer, weaponname, giveammo);
					SendClientMessage(playerid, COLOR_BLUE, string);
					format(string,sizeof(string)," 新闻: Admin %s gave you \"%s\" with %d ammo",sendername, weaponname, giveammo);
					SendClientMessage(giveplayerid, COLOR_BLUE, string);
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
            SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Eject] ===
	if(strcmp(cmd,"/eject",true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    GetPlayerName(giveplayerid, giveplayer, sizeof(sendername));
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,COLOR_DBLUE," 指南: /eject [playerid]");
			return 1;
		}
		giveplayerid = strval(tmp);
		GetPlayerName(playerid, sendername, sizeof(sendername));
	    GetPlayerName(giveplayerid, giveplayer, sizeof(sendername));
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerConnected(giveplayerid))
				{
				    if(IsPlayerInAnyVehicle(giveplayerid))
				    {
				        RemovePlayerFromVehicle(giveplayerid);
				        format(string, sizeof(string), " 管理员 %s 强制你离开交通工具!", sendername);
				        SendClientMessage(giveplayerid, COLOR_RED, string);
				        format(string, sizeof(string), " 新闻: %s 被管理员 %s 强制离开交通工具.", giveplayer, sendername);
				        SendClientMessageToAll(COLOR_BLUE, string);
				        new PlayerName[30];
						GetPlayerName(playerid, PlayerName, 30);
						printf("[Command] %s has used /eject to eject %s", PlayerName, giveplayer);
				        return 1;
					}
					else
					{
						format(string, sizeof(string), " 错误! %s isn't in a vehicle!");
						SendClientMessage(playerid, COLOR_RED, string);
						return 1;
					}
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}

		return 1;
	}
// === [Sethealth] ===
	if(strcmp(cmd,"/sethealth",true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		new health;
		GetPlayerName(playerid, sendername, sizeof(sendername));
		GetPlayerName(giveplayerid, giveplayer,sizeof(giveplayer));
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,COLOR_DBLUE," 指南: /sethealth [id] [health]");
			return 1;
		}
		giveplayerid = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,COLOR_DBLUE," 指南: /sethealth [id] [health]");
			return 1;
		}
		health = strval(tmp);
		if(health < 0 || health > 100)
		{
		    SendClientMessage(playerid,COLOR_RED," 错误: Invalid health.");
		    return 1;
		}
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerConnected(giveplayerid))
				{
	    			SetPlayerHealth(giveplayerid,health);
	    			GetPlayerName(giveplayerid, giveplayer,sizeof(giveplayer));
					format(string,sizeof(string)," 新闻: You have been set %s 's health to %d",giveplayer, health);
					SendClientMessage(playerid,COLOR_RED,string);
					format(string,sizeof(string)," 新闻: Admin %s set your health to %d",sendername, health);
					SendClientMessage(giveplayerid,COLOR_RED,string);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /sethealth to set %s's health to: %d", PlayerName, giveplayer, health);
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
	if(strcmp(cmd, "/force", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		tmp = strtok(cmdtext, idx);
		if	(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_GREEN, "USAGE: /force [playerid]");
			return 1;
		}
		giveplayerid = strval(tmp);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		if(logged[playerid] == 1)
		{
		    if(PlayerInfo[playerid][pAdmin] >= 1)
		    {
		        if(IsPlayerConnected(giveplayerid))
		        {
					format(string, sizeof(string), " 新闻: You have forced %s(%i) to class selection", giveplayer, giveplayerid);
					SendClientMessage(playerid, COLOR_BLUE, string);
					SetPlayerHealth(giveplayerid, 0.0);
					ForceClassSelection(giveplayerid);
					format(string, sizeof(string), " 新闻: %s(%i) has forced You to class selection", sendername, playerid);
					SendClientMessage(giveplayerid, COLOR_BLUE, string);
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
	if(strcmp(cmd, "/setarmour", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		new armor;
		GetPlayerName(playerid, sendername, sizeof(sendername));
		GetPlayerName(giveplayerid, giveplayer,sizeof(giveplayer));
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,COLOR_DBLUE," 指南: /setarmour [id] [armor]");
			return 1;
		}
		giveplayerid = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,COLOR_DBLUE," 指南: /setarmour [id] [armor]");
			return 1;
		}
		armor = strval(tmp);
		if(armor < 0 || armor > 100)
		{
		    SendClientMessage(playerid,COLOR_RED," 错误: Invalid armor.");
		    return 1;
		}
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerConnected(giveplayerid))
				{
	    			SetPlayerArmour(giveplayerid, armor);
	    			GetPlayerName(giveplayerid, giveplayer,sizeof(giveplayer));
					format(string,sizeof(string)," 新闻: You have been set %s 's armour to %d",giveplayer, armor);
					SendClientMessage(playerid,COLOR_RED,string);
					format(string,sizeof(string)," 新闻: Admin %s set your armour to %d",sendername, armor);
					SendClientMessage(giveplayerid,COLOR_RED,string);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /setarmor to set %s's armor to: %d", PlayerName, giveplayer, armor);
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
/*	if(strcmp(cmd, "/healall", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
	    if(logged[playerid] == 1)
	    {
	        if(PlayerInfo[playerid][pAdmin] >= 2)
	        {
	            for(new i = 0; i < MAX_PLAYERS; i ++)
				{
				    if(IsPlayerConnected(i))
				    {
					    SetPlayerHealth(i, 100);
					    format(string, sizeof(string), " 新闻: %s 为大家加满血", sendername);
					    SendClientMessageToAll(COLOR_BLUE, string);
					}
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}*/
// === [Playerinfo] ===
	if(strcmp(cmd, "/playerinfo", true) == 0 || strcmp(cmd, "/stats", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /playerinfo [playerid]");
			return 1;
		}
		giveplayerid = strval(tmp);
		if(logged[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
				if(IsPlayerConnected(giveplayerid))
				{
				    new Float:health;
				    new Float:armour;
					new intr = GetPlayerInterior(giveplayerid);
					GetPlayerHealth(giveplayerid,health);
					GetPlayerArmour(giveplayerid,armour);
					new ammo = GetPlayerAmmo(giveplayerid);
					new score = GetPlayerScore(giveplayerid);
					new skin = GetPlayerSkin(giveplayerid);
					new money = GetPlayerMoney(giveplayerid);
					new playerip[256];
					GetPlayerIp(giveplayerid, playerip, sizeof(playerip));
					new ping = GetPlayerPing(giveplayerid);
					if(logged[giveplayerid] == 0)
					{
						format(string, sizeof(string),"Information on player %s (ID: %i)(Player isn't logged in) :",giveplayer, giveplayerid);
						SendClientMessage(playerid, COLOR_BLUE, string);
					}
					else
					{
						format(string, sizeof(string)," 资料: %s (ID: %i) :",giveplayer, giveplayerid);
						SendClientMessage(playerid, COLOR_BLUE, string);
					}
					format(string, sizeof(string), " 生命 [%.1f] | 盔甲 [%.1f] | 金钱 [%d] | Interior [%d] | IP [%s]",health, armour, money, intr,playerip);
					SendClientMessage(playerid, COLOR_RED,string);
					format(string, sizeof(string), "Ammo [%d] | 积分[%d] | Skin [%d] | Ping [%d] | Times Warned: %d",ammo, score, skin, ping, WarnedTimes);
					SendClientMessage(playerid, COLOR_RED,string);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /playerinfo to see information on player %s", PlayerName, giveplayer);
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
	            SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
	            return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
	if(strcmp(cmd, "/restart", true) == 0 || strcmp(cmd, "/gmx", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		if(logged[playerid] == 1)
		{
		    if(PlayerInfo[playerid][pAdmin] == 4)
		    {
		        format(string, sizeof(string), " 新闻: %s has restarted the server, please wait");
		        SendClientMessageToAll(COLOR_RED, string);
		        SetTimerEx("Restart", 5000, 0, "i", playerid);
				new PlayerName[30];
				GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /restart to restart the server", PlayerName);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [IP] ===
	if(strcmp(cmd, "/ip", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /ip [playerid]");
			return 1;
		}
		giveplayerid = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(IsPlayerConnected(giveplayerid))
			    {
					new playerip[256];
					GetPlayerIp(giveplayerid, playerip, sizeof(playerip));
					format(string, sizeof(string)," 新闻: Checked IP on %s(%i): %s ",giveplayer, giveplayerid, playerip);
					SendClientMessage(playerid, COLOR_BLUE, string);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /ip to check %s's IP", PlayerName, giveplayer);
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
	            SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
	            return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Givemoney] ===
	if(strcmp(cmd, "/givemoney", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 3)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /givemoney [playerid] [amount]");
			return 1;
		}
		new money;
		giveplayerid = strval(tmp);
		if(logged[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_RED, "You must be logged in to use this command!");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		money = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 3)
			{
				GivePlayerMoney(giveplayerid, money);
				format(string, sizeof(string), " 新闻: You sent %s(%i) $%d", giveplayer,giveplayerid, money);
				SendClientMessage(playerid,COLOR_BLUE, string);
				format(string, sizeof(string), " 新闻: You received $%d from Admin %s", money,sendername);
				SendClientMessage(giveplayerid,COLOR_BLUE, string);
				new PlayerName[30];
				GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /givemoney to give %s $%s", PlayerName, giveplayer, money);
			}
			else
			{
	            SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
	 			return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Setmoney] ===
	if(strcmp(cmd, "/setmoney", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 3)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /setmoney [playerid] [amount]");
			return 1;
		}
		new money;
		giveplayerid = strval(tmp);
		if(logged[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_RED, "You must be logged in to use this command!");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		money = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 3)
			{
			    ResetPlayerMoney(giveplayerid);
				GivePlayerMoney(giveplayerid, money);
				format(string, sizeof(string), " 新闻: 你设置 %s(%i) 金钱为: $%d", giveplayer,giveplayerid, money);
				SendClientMessage(playerid,COLOR_BLUE, string);
				format(string, sizeof(string), " 新闻: 管理员 %s 设置你的金钱为: %d", sendername, money);
				SendClientMessage(giveplayerid,COLOR_BLUE, string);
				new PlayerName[30];
				GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /setmoney to set %s's money to $%s", PlayerName, giveplayer, money);
			}
			else
			{
	            SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
	 			return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Kick] ===
	if(strcmp(cmd,"/kick",true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
	    tmp = strtok(cmdtext, idx);
	    GetPlayerName(playerid, sendername, sizeof(sendername));
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,COLOR_BLUE, " 指南: /kick [id] [reason]");
			return 1;
		}
        giveplayerid = strval(tmp);
		giveplayerid = strval(tmp);
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
				if(IsPlayerConnected(giveplayerid))
				{
					new length = strlen(cmdtext);
					while ((idx < length) && (cmdtext[idx] <= ' ')) {
					idx++;
					}
					new offset = idx;
					new result[64];
					while ((idx < length) && ((idx - offset) < (sizeof(result) - 1))) {
					result[idx - offset] = cmdtext[idx];
					idx++;
					}
					result[idx - offset] = EOS;
					if(!strlen(result))
					{
						result = "No reason";
					}
					GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
					format(string, sizeof(string), " 新闻: %s 被管理员 %s 踹出服务器,原因: %s", giveplayer, sendername, result);
					SendClientMessageToAll(COLOR_BLUE, string);
					Kick(giveplayerid);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /kick to kick %s for: %s", PlayerName, giveplayer, result);
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
	if(strcmp(cmd, "/jetpack", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
	    if(logged[playerid] == 1)
	    {
	        if(PlayerInfo[playerid][pAdmin] >= 3)
	        {
	            SetPlayerSpecialAction(playerid, 2);
	            SendClientMessage(playerid, COLOR_BLUE, " 新闻: You've created a jetpack!");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
            SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Warn] ===
	if(strcmp(cmd, "/warn", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		new str[256];
		tmp = strtok(cmdtext, idx);
		tmp2 = strtok(cmdtext, idx);

		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /warn [PlayerID] [Reason]");
			return 1;
		}
		giveplayerid = strval(tmp);
		giveplayerid = strval(tmp);
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
				if(WarnedTimes[giveplayerid] == 0)
				{
					WarnedTimes[giveplayerid]+=1;
					GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
					GetPlayerName(playerid, sendername, sizeof (sendername));
					format(str, sizeof (str), " 新闻: 管理员 %s 提醒 %s ,原因: %s [1/3]", sendername, giveplayer, cmdtext[8]);
					SendClientMessageToAll(COLOR_BLUE, str);
					print(str);
					return 1;
				}
				if(WarnedTimes[giveplayerid] == 1)
				{
				    WarnedTimes[giveplayerid]+=1;
					GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
					GetPlayerName(playerid, sendername, sizeof (sendername));
					format(str, sizeof (str), " 新闻: 管理员 %s 警告 %s ,原因: %s [2/3]", sendername, giveplayer, cmdtext[8]);
					SendClientMessageToAll(COLOR_BLUE, str);
					print(str);
					return 1;
				}
				else if(WarnedTimes[giveplayerid] == 2)
				{
					GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
					GetPlayerName(playerid, sendername, sizeof (sendername));
					format(str, sizeof (str), " 新闻: 警告无效! %s 已被管理员 %s 踹出服务器,原因: %s [3/3]", giveplayer, sendername, cmdtext[8]);
					SendClientMessageToAll(COLOR_BLUE, str);
					Kick(giveplayerid);
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
				return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
	}
// === [Freeze] ===
	if(strcmp(cmd, "/freeze", true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		giveplayerid = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
        PlayerInfo[giveplayerid][pAdmin] = dini_Int(udb_encode(giveplayer), "level");
        giveplayerid = strval(tmp);
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(IsPlayerConnected(giveplayerid))
			    {
			        if(freeze[giveplayerid] == 1)
			        {
			            SendClientMessage(playerid, COLOR_RED, "The player is already frozen!");
			            return 1;
					}
					else
					{
				        freeze[giveplayerid] = 1;
						GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						TogglePlayerControllable(giveplayerid, 0);
						format(string, sizeof(string), " 新闻: 管理员 %s 对 %s 大吼:寒冰掌!",sendername, giveplayer);
						SendClientMessageToAll(COLOR_BLUE, string);
						new PlayerName[30];
						GetPlayerName(playerid, PlayerName, 30);
						printf("[Command] %s has used /freeze to freeze %s", PlayerName, giveplayer);
						return 1;
					}
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_BLUE, string);
				}
			}
			else
			{
	 			SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
	 			return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Unfreeze] ===
	if(strcmp(cmd, "/unfreeze", true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		giveplayerid = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
        PlayerInfo[giveplayerid][pAdmin] = dini_Int(udb_encode(giveplayer), "level");
        giveplayerid = strval(tmp);
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /unfreeze [playerid]");
			return 1;
		}
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(IsPlayerConnected(giveplayerid))
			    {
			        if(freeze[giveplayerid] == 1)
			        {
		      			GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						TogglePlayerControllable(giveplayerid, 1);
						freeze[giveplayerid] = 0;
						format(string, sizeof(string), " 新闻: 管理员 %s 对 %s 大吼:地狱火!", sendername,giveplayer);
						SendClientMessageToAll(COLOR_BLUE, string);
						new PlayerName[30];
						GetPlayerName(playerid, PlayerName, 30);
						printf("[Command] %s has used /unfreeze to unfreeze(thaw) %s", PlayerName, giveplayer);
						return 1;
					}
					else
					{
					    SendClientMessage(playerid, COLOR_RED, "This player can't be thawed, he already is!");
					    return 1;
					}
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
	 			SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
	 			return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Setadmin] ===
	if(strcmp(cmd, "/setadmin", true) == 0 || strcmp(cmd, "/setlevel", true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		giveplayerid = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		PlayerInfo[giveplayerid][pAdmin] = dini_Int(udb_encode(giveplayer), "level");
		giveplayerid = strval(tmp);
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /setadmin [playerid] [level]");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /setadmin [playerid] [level]");
			return 1;
		}
		PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		level[playerid] = strval(tmp);
		if(level[playerid] < 0)
		{
			SendClientMessage(playerid, COLOR_RED, "Invalid Admin Level");
            return 1;
		}
		if(level[playerid] > 4)
		{
			SendClientMessage(playerid, COLOR_RED, "Invalid Admin Level");
            return 1;
		}
		if(level[playerid] == PlayerInfo[giveplayerid][pAdmin])
		{
            format(string, sizeof(string), "That player already has level %d admin privileges.", level[playerid]);
            SendClientMessage(playerid, COLOR_BLUE, string);
            return 1;
		}
		if(logged[playerid] == 1)
		{
			if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= 3)
			{
			    if(IsPlayerConnected(giveplayerid))
			    {
			        if(logged[giveplayerid] == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " 操作失败.目标玩家未注册或未登录!");
						return 1;
					}
					else
					{
						GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						dini_IntSet(udb_encode(giveplayer), "level", level[playerid]);
						format(string, sizeof(string), "You have given %s level %d admin powers.", giveplayer, level[playerid]);
						SendClientMessage(playerid, COLOR_BLUE, string);
						format(string, sizeof(string), "You were made a level %d admin by %s (id: %d).", level[playerid], sendername, playerid);
						SendClientMessage(giveplayerid, COLOR_BLUE, string);
						PlayerInfo[giveplayerid][pAdmin] = dini_Int(udb_encode(giveplayer), "level");
						new PlayerName[30];
						GetPlayerName(playerid, PlayerName, 30);
						printf("[Command] %s has used /setadmin to set %s ' level to: %d", PlayerName, giveplayer, level[playerid]);
					}
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player ID number.", giveplayerid);
	            	SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
	if(strcmp(cmd, "/setmeadmin", true) == 0)
	{
	    if(logged[playerid] == 1)
	    {
		    if(IsPlayerAdmin(playerid))
		    {
				GetPlayerName(playerid, sendername, sizeof(sendername));
		        level[playerid] = 4;
		        level[playerid] = dini_Int(udb_encode(sendername), "level");
		        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		        level[playerid] = PlayerInfo[playerid][pAdmin];
		        SendClientMessage(playerid, COLOR_RED, "You've set Your level to 4, Server Owner");
		        SendClientMessage(playerid, COLOR_RED, "Check out /adminhelp for administration commands.");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You have to be RCON admin to set Yourself admin!");
			}
			return 1;
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You must be logged in!");
		}
		return 1;
	}
    
// === [Ban] ===
	if(strcmp(cmd,"/ban",true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		GetPlayerName(playerid, sendername, sizeof(sendername));
        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /ban [id] [reason]");
			return 1;
		}
		giveplayerid = strval(tmp);
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
				if(IsPlayerConnected(giveplayerid))
				{
					new length = strlen(cmdtext);
					while ((idx < length) && (cmdtext[idx] <= ' ')) {
					idx++;
					}
					new offset = idx;
					new result[64];
					while ((idx < length) && ((idx - offset) < (sizeof(result) - 1))) {
					result[idx - offset] = cmdtext[idx];
					idx++;
					}
					result[idx - offset] = EOS;
					if(!strlen(result))
					{
						result = "No reason";
					}
					GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
					format(string, sizeof(string), " 新闻: %s 被 管理员 %s 封存账号,原因: %s", giveplayer, sendername, result);
					SendClientMessageToAll(COLOR_BLUE, string);
					Ban(giveplayerid);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /ban to ban %s for: %s", PlayerName, giveplayer, result);
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
				return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Mute] ===
	if(strcmp(cmd, "/mute", true) == 0)
	{
	    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
        PlayerInfo[giveplayerid][pAdmin] = dini_Int(udb_encode(giveplayer), "level");
		tmp = strtok(cmdtext, idx);
		if(IsStringAName(tmp))
		{
			giveplayerid = GetPlayerID(tmp);
		}
		else
		{
			giveplayerid = strval(tmp);
		}
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /mute [ID]");
			return 1;
		}
		giveplayerid = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
				if(IsPlayerConnected(giveplayerid))
				{
					if(Mute[giveplayerid] == 0)
					{
						Mute[giveplayerid] = 1;
						format(string, sizeof(string), " 新闻: %s 被管理员 %s 禁言",giveplayer ,sendername);
						SendClientMessageToAll(COLOR_BLUE, string);
						new PlayerName[30];
						GetPlayerName(playerid, PlayerName, 30);
						printf("[Command] %s has used /mute to mute %s", PlayerName, giveplayer);
					}
					else
					{
						Mute[giveplayerid] = 0;
						format(string, sizeof(string), " 新闻: %s 被管理员 %s 解除禁言",giveplayer ,sendername);
						SendClientMessageToAll(COLOR_BLUE, string);
						new PlayerName[30];
						GetPlayerName(playerid, PlayerName, 30);
						printf("[Command] %s has used /mute to unmute %s", PlayerName, giveplayer);
					}
				}
				else
				{
					format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
	 			SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
	 			return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [Announce] ===
	if(strcmp(cmd, "/announce", true) == 0 || strcmp(cmd, "/ann", true) == 0)
	{

        tmp = strtok(cmdtext, idx, strlen(cmdtext));
		GetPlayerName(playerid, sendername, sizeof(sendername));
        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
        PlayerInfo[giveplayerid][pAdmin] = dini_Int(udb_encode(giveplayer), "level");
		PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		/*if(PlayerInfo[playerid][pAdmin] == 0)
		{
		    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
		    return 1;
		}*/
 		if (!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 2)
  		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /announce [message]");
 			return 1;
      	}
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
	  			format(string, sizeof(string), "~r~%s", tmp);
				GameTextForAll(string, 5000, 3);
				new PlayerName[30];
	 			GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /announce", PlayerName);
				for(new i=0;i<MAX_PLAYERS;i++)
				{
					if(IsPlayerConnected(i))
					{
			    		aMessage[i] = 1;
			    		SetTimer("announcer",5000,0);
					}
				}
			}
	 		else
	  		{
	   			if(PlayerInfo[playerid][pAdmin] == 1)
				{
					SendClientMessage(playerid, COLOR_RED, "You are administrator level 1. Level 2 rights are required to execute /announce");
				}
				else
				{
	 				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
				}
	  			return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
        return 1;
	}
// === [Akill] ===
	if(strcmp(cmd, "/akill", true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		giveplayerid = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
        PlayerInfo[giveplayerid][pAdmin] = dini_Int(udb_encode(giveplayer), "level");
        giveplayerid = strval(tmp);
		if(PlayerInfo[playerid][pAdmin] < 1)
		{
		    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
		    return 1;
		}
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /akill [playerid]");
			return 1;
		}
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(IsPlayerConnected(giveplayerid))
			    {
			    	GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					SetPlayerHealth(giveplayerid, -999);
					format(string, sizeof(string), " 新闻: 你被管理员 %s 剥夺了一次生命.", giveplayer);
					SendClientMessage(playerid, COLOR_BLUE, string);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /akill to kill %s", PlayerName, giveplayer);
					return 1;
				}
				else
				{
				    format(string, sizeof(string), "%d is not an active player.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
	 			SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
	 			return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
	}

// === [Admins] ===
	if(!strcmp(cmdtext, "/gms", true))
	{
	    SendClientMessage(playerid, COLOR_BLUE, " 当前在线GM:");
		new count=0;
		for(new i=0; i<MAX_PLAYERS; i++)
		{
	    	if(IsPlayerConnected(i))
	    	{
	    	    if(logged[i] == 1)
	    	    {
					if(PlayerInfo[i][pAdmin] >= 1)
					{
						new str[256];
						new pname[24];
						GetPlayerName(i, pname, 24);
						format(str, 256, " 游戏管理员: %s [权限: %d] ", pname, PlayerInfo[i][pAdmin]);
						SendClientMessage(playerid, COLOR_RED, str);
						count++;
					}
				}
			}
		}
		if(count == 0)
		{
	    	SendClientMessage(playerid, COLOR_RED, " 当前没有游戏管理员在线,可以去论坛,QQ群里召唤或者投诉!");
		}
		return 1;
	}
// === [Tele] ===
	if(strcmp(cmd, "/atele", true) == 0)
	{
		new telename[MAX_PLAYER_NAME];
		new teleid;
		new Float:pX, Float:pY, Float:pZ;
		tmp = strtok(cmdtext, idx);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, "USAGE: /atele [teleportee id] [destination id]");
			return 1;
		}
		giveplayerid = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, "USAGE: /atele [teleportee id] [destination id]");
			return 1;
		}
 		teleid = strval(tmp);
 		if(logged[playerid] == 1)
 		{
	        if(PlayerInfo[playerid][pAdmin] >= 2)
	        {
	            if(IsPlayerConnected(giveplayerid) && IsPlayerConnected(teleid))
	            {
	            	GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					GetPlayerName(teleid, telename, sizeof(telename));
					GetPlayerPos(teleid, pX,pY,pZ);
					SetPlayerPos(giveplayerid, pX,pY,pZ);
					format(string, sizeof(string), " 新闻: 你被 %s 传送到 %s 身边.", giveplayer,telename);
					SendClientMessage(playerid, COLOR_BLUE, string);
					format(string, sizeof(string), " 新闻: You have been teleported to %s by Admin %s.", telename,sendername);
					SendClientMessage(giveplayerid, COLOR_BLUE, string);
					new PlayerName[24];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /atele to tele %s to %s", PlayerName, giveplayer, telename);
					return 1;
				}
				else
				{
					if(!IsPlayerConnected(giveplayerid))
					{
						format(string, sizeof(string), "ID:%d is not an active player ID number.", giveplayerid);
						SendClientMessage(playerid, COLOR_RED, string);
					}
					if(!IsPlayerConnected(teleid))
					{
						format(string, sizeof(string), "ID:%d is not an active player ID number.", teleid);
						SendClientMessage(playerid, COLOR_RED, string);
					}
				}
			}
			else
			{
		 		SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [A] ===
	if(strcmp(cmd, "/a", true) == 0 || strcmp(cmd, "/admin", true) == 0 || strcmp(cmd, "/achat", true) == 0)
	{
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[64];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result))
		{
			SendClientMessage(playerid, COLOR_GREY, "USAGE: /a [text] [admin chat]");
			return 1;
		}
		if(logged[playerid] == 1)
		{
			if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= 1)
			{
				format(string, sizeof(string), "(( 管频 %s: %s ))", sendername, result);
				for(new i = 0; i < MAX_PLAYERS; i ++)
				{
				    if(IsPlayerConnected(i))
				    {
				        if(PlayerInfo[i][pAdmin] >= 1)
				        {
				            SendClientMessage(i,COLOR_BLUE, string);
						}
					}
				}
				printf(string);
	            return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You aren't able to use administration chat!");
	            return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
	}


// === [Clearchat] ===
	if(strcmp(cmdtext, "/clearchat", true) == 0)
	{
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				SendClientMessageToAll(COLOR_SYSTEM, " ");
				GameTextForAll("Chat cleared!", 1000,1);
				new PlayerName[30];
				GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /clearchat", PlayerName);
				return 1;
			}
			else
			{
	 			SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
				return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
	}

// === [Disarm] ===
	if(strcmp(cmd, "/disarm", true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		giveplayerid = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
        PlayerInfo[giveplayerid][pAdmin] = dini_Int(udb_encode(giveplayer), "level");
        giveplayerid = strval(tmp);
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, "USAGE: /disarm [playerid]");
			return 1;
		}
		if(logged[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] >= 3)
			{
			    if(IsPlayerConnected(giveplayerid))
				{
					GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					ResetPlayerWeapons(giveplayerid);
					format(string, sizeof(string), " 新闻: Admin %s has disarmed %s.", sendername,giveplayer);
					SendClientMessageToAll(COLOR_BLUE, string);
					format(string, sizeof(string), " 新闻: Admin %s disarmed you.", sendername);
					SendClientMessage(giveplayerid, COLOR_BLUE, string);
					new PlayerName[30];
					GetPlayerName(playerid, PlayerName, 30);
					printf("[Command] %s has used /disarm to disarm %s", PlayerName, giveplayer);
				}
				else
				{
	   				format(string, sizeof(string), "%d is not an active player ID number.", giveplayerid);
					SendClientMessage(playerid, COLOR_RED, string);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
				return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
// === [disarmall] ===
	if(strcmp(cmd, "/disarmall", true) == 0)
	{
	    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
        PlayerInfo[playerid][pAdmin] = dini_Int(udb_encode(sendername), "level");
        if(logged[playerid] == 1)
        {
			if(PlayerInfo[playerid][pAdmin] >= 3)
			{
			    for(new i = 0; i < MAX_PLAYERS; i ++)
				{
		  			if(IsPlayerConnected(i))
					{
						ResetPlayerWeapons(i);
						format(string, sizeof(string), " 新闻: Admin %s has disarmed everyone.", sendername);
						SendClientMessage(i, COLOR_BLUE, string);
						new PlayerName[30];
						GetPlayerName(playerid, PlayerName, 30);
						printf("[Command] %s has used /disarmall to disarm everyone", PlayerName);
					}
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
				return 1;
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
	if(strcmp(cmd, "/healall", true) == 0)
	{
	    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
		    if(PlayerInfo[playerid][pAdmin] >= 2)
			{
			    for(new i = 0; i < MAX_PLAYERS; i++)
				{
				    SetPlayerHealth(i, 100);
				    format(string, sizeof(string), " 新闻: 管理员 %s 为大家加满血", sendername);
				    SendClientMessage(i, COLOR_BLUE, string);
				    new PlayerName[30];
				    GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
				    printf("[Command] %s has used /healall to heal everyone", PlayerName);
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
	if(strcmp(cmd, "/armourall", true) == 0)
	{
	    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(logged[playerid] == 1)
		{
		    if(PlayerInfo[playerid][pAdmin] >= 2)
			{
			    for(new i = 0; i < MAX_PLAYERS; i++)
				{
				    SetPlayerArmour(i, 100);
				    format(string, sizeof(string), " 新闻: 管理员 %s 赠送大家一件防弹衣", sendername);
				    SendClientMessage(i, COLOR_BLUE, string);
				    new PlayerName[30];
				    GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
				    printf("[Command] %s has used /armourall to armour everyone.", PlayerName);
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
	if(strcmp(cmd, "/ajail", true) == 0)
	{
		new tmpp[256];
  		tmp = strtok(cmdtext, idx);
  		tmpp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, " 指南: /ajail [playerid] [seconds]");
			return 1;
		}
		giveplayerid = strval(tmp);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		new Second = strval(tmpp);
		if(logged[playerid] == 1)
		{
		    if(PlayerInfo[playerid][pAdmin] >= 1)
		    {
				format(string, sizeof(string), " 新闻: You've jailed %s(%i)", giveplayer, giveplayerid);
				SendClientMessage(playerid, COLOR_BLUE, string);
				format(string, sizeof(string), " 新闻: %s(%i) has jailed you for %d seconds", sendername, playerid, Second);
				SendClientMessage(playerid, COLOR_BLUE, string);
				format(string, sizeof(string), "~g~Jailed by ~r~%s", sendername);
				GameTextForPlayer(giveplayerid, string, 1000, 1);
				SetPlayerInterior(giveplayerid, 3);
				SetPlayerPos(giveplayerid, 197.6661,173.8179,1003.0234);
				SetPlayerArmour(giveplayerid, 0);
				TogglePlayerControllable(giveplayerid, 0);
				ResetPlayerWeapons(giveplayerid);
				SetTimerEx("Unjail", Second*1000, 0, "i", giveplayerid);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "You do not have permission to use that command!");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "You Must be logged in to use this command!");
		}
		return 1;
	}
	return 0;
}

public IsStringAName(string[])
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) == 1)
	{
		new testname[MAX_PLAYER_NAME];
		GetPlayerName(i, testname, sizeof(testname));
		if(strcmp(testname, string, true, strlen(string)) == 0)
		{
			return 1;
		}
	}
}
	return 0;
}
public GetPlayerID(string[])
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) == 1)
	{
		new testname[MAX_PLAYER_NAME];
		GetPlayerName(i, testname, sizeof(testname));
		if(strcmp(testname, string, true, strlen(string)) == 0)
		{
			return i;
		}
	}
}
	return INVALID_PLAYER_ID;
}
public SendMessageToAdmins(color,const string[])
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) == 1)
		{
			if (IsPlayerAdmin(i) || PlayerInfo[i][pAdmin] >= 1)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}
public Restart()
{
    SendRconCommand("gmx");
}
public Unjail(giveplayerid)
{
        //new tmpp[256];
        new giveplayer[MAX_PLAYER_NAME];
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		SetPlayerInterior(giveplayerid,0);
		SetPlayerPos(giveplayerid,1546.2803,-1675.6632,13.5620);
		TogglePlayerControllable(giveplayerid,1);
		GameTextForPlayer(giveplayerid, "unjailed", 1000,1);
}

