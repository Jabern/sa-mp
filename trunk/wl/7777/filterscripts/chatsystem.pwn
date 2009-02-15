#include <a_samp>
#define NO_NUMB_IN_NAME true
#define C_R 0xF02020FF
#define C_G 0x18F413FF
#define C_AD 0x0D62EEFF
#define C_W 0xFFFFFFFF
#define C_Y 0xDEEE20FF
#define C_P 0xEA26CCFF
#define LEAVE 0
#define JOIN 1
#define MSG 2
forward ad();
new chan[MAX_PLAYERS], admin[MAX_PLAYERS], failedlogins[MAX_PLAYERS], muted[MAX_PLAYERS];
new build, version[256], password[256] = "changemeh", maxfailedlogins = 3;
public OnFilterScriptInit()
{
	if(equal(password,"changemeh")) {
		print("Please change the password from changemeh.");
		SendRconCommand("unloadfs chatsystem");
	}
	print("\n--------------------------------------");
	print(" Chatsystem filterscript by Michael loaded");
	print("--------------------------------------\n");
	build = 39;
	format(version, sizeof(version), "v0.1");
	ad();
	SetTimer("ad",900000,1);
	for(new i = 0; i <= MAX_PLAYERS; i++) chan[i] = 0;
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	#if NO_NUMB_IN_NAME == true
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof(pname));
	if(IsNumber(pname)) {
	    SendClientMessage(playerid, C_R, " 输入<@join 数字(1-50)> 加入单独聊天频道!");
	    Kick(playerid);
	}
	#endif
	chan[playerid] = 0;
	admin[playerid] = 0;
	failedlogins[playerid] = 0;
	muted[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	chan[playerid] = 0;
	admin[playerid] = 0;
	failedlogins[playerid] = 0;
	muted[playerid] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[]) {
	new firstchr[256], textfirst5[256], textfirst6[256], string[256];
	strmid(firstchr, text, 0, 1);
	strmid(textfirst5, text, 0, 5);
	strmid(textfirst6, text, 0, 6);
	if(muted[playerid] == 1) {
	    SendClientMessage(playerid, C_R, " 您由于影响其他玩家被禁言.");
	    return 0;
	}
	if(equal(firstchr,"@")) {
		if(equal(textfirst5, "@join")) {
		    if(chan[playerid] == 0) {
		    	new chantojoin;
		        strdel(text, 0, strlen("@join")+1);
				if(!strlen(text)) {
				    SendClientMessage(playerid, C_R, " 使用方法: <@join 数字(1-50)>");
				    return 0;
				}
				chantojoin = strval(text);
		        if(0 < chantojoin < 51) {
					chan[playerid] = strval(text);
					format(string, sizeof(string), " 您已成功加入频道: %i.", chan[playerid]);
					SendClientMessage(playerid, C_G, string);
					format(string, sizeof(string), "%s 进入(%i) 频道.", PlayerName(playerid), chan[playerid]);
		        	SendClientMessageToChannel(LEAVE, C_W, string, playerid);
				} else {
				    format(string, sizeof(string), " 服务器共已开设50个私有聊天频道. (您已加入 %i)", chantojoin);
					SendClientMessage(playerid, C_R, string);
				}
			} else {
				format(string, sizeof(string), " 您已经加入 %i 频道.", chan[playerid]);
				SendClientMessage(playerid, C_R, string);
			}
			print("Detected @join...");
		} else if(equal(textfirst6, "@leave")) {
		    if(chan[playerid] != 0) {
		        format(string, sizeof(string), "%s 退出 (%i) 频道.", PlayerName(playerid), chan[playerid]);
		        SendClientMessageToChannel(LEAVE, C_W, string, playerid);
				format(string, sizeof(string), " 您已成功退出频道: %i.", chan[playerid]);
				SendClientMessage(playerid, C_G, string);
				chan[playerid] = 0;
			} else {
				SendClientMessage(playerid, C_R, " 您没有加入任何一个频道.输入 <@join 数字(1-50)> 加入.");
			}
			print("Detected @leave...");
		} else {
		    if(chan[playerid] != 0) {
    			strdel(text, 0, 1);
		        if(!strlen(text) || strlen(text) == 0) {
		            SendClientMessage(playerid, C_R, " 使用方法: < @ 信息>");
		            return 0;
				}
				format(string, sizeof(string), "[频道%i] [%s(%i)]: %s", chan[playerid], PlayerName(playerid), playerid, text);
			    SendClientMessageToChannel(MSG, C_G, string, playerid);
			} else {
			    SendClientMessage(playerid, C_R, " 您没有加入任何一个频道.输入 <@join 数字(1-50)> 加入.");
			}
		}
	} else if(equal(firstchr, "@") && admin[playerid] == 1) {
		strdel(text, 0, 1);
		if(!strlen(text)) {
		    SendClientMessage(playerid, C_R, " 使用方法: < @ 信息>");
		    return 0;
		}
		format(string, sizeof(string), "[管理] [%s(%i)]: %s", PlayerName(playerid), playerid, text);
		SendAdminChannelMessage(C_P, string);
	} else
	{
	    format(string, sizeof(string), "%s(%i): %s", PlayerName(playerid), playerid, text);
	    //SendClientMessageToAll(C_W, string);
	    SetPlayerColor(playerid,GetPlayerColor(playerid));
	    SendClientMessageToAll(GetPlayerColor(playerid), string);

	}
	return 0;
}

/*public OnPlayerPrivmsg(playerid, recieverid, text[])
{
	SendClientMessage(playerid, C_G, " 快速回复, 输入 < /qr 信息 >");
	return 1;
}*/

public OnPlayerCommandText(playerid, cmdtext[])
{
	printf("OnPlayerCommandText(%i, %s)",playerid, cmdtext);
	new cmd[256], idx;
	cmd = strtok(cmdtext,idx);
	if(equal(cmd, "/chatadmin")) {
		new param1[128], param2[256], string[256];
		param1 = strtok(cmdtext,idx);
		param2 = strtok(cmdtext,idx);
		printf("param1: %s param2: %s",param1,param2);
		printf("param1: %i param2: %i",param1,param2);
		if(admin[playerid] == 0) {
		    if(!strlen(param1)) {
		    	SendClientMessage(playerid, C_R, " 未知管理员命令.");
				SendClientMessage(playerid, C_R, " 只有管理员次可以使用,如果您是管理员请登录.");
				return 1;
			}
			if(equal(param1, "login")) {
			    if(!strlen(param2)) {
			        SendClientMessage(playerid, C_R, " 使用方法: < /chatadmin login 密码 >");
			        return 1;
				}
		        if(equal(param2, password)) {
		            admin[playerid] = 1;
		            SendClientMessage(playerid, C_G, " 已经成功登录拥有管理权限.");
		            failedlogins[playerid] = 0;
		            return 1;
				} else {
					failedlogins[playerid]++;
					if(failedlogins[playerid] == maxfailedlogins) {
					    new pname[MAX_PLAYER_NAME];
					    pname = PlayerName(playerid);
					    SendClientMessage(playerid, C_R, "You are being kicked for too many failed logins.");
						TogglePlayerControllable(playerid,false);
						Kick(playerid);
						format(string, sizeof(string), "%s(%i) has been kicked for too many failed admin logins.", pname, playerid);
						SendClientMessageToAll(C_R, string);
					} else {
					    SendClientMessage(playerid, C_R, "Login attempt failed.");
						format(string, sizeof(string), "Failed login attempts left: %i", maxfailedlogins-failedlogins[playerid]);
						SendClientMessage(playerid, C_R, string);
					}
				}
			} else {
				    SendClientMessage(playerid, C_R, "Unknown admin command.");
				    SendClientMessage(playerid, C_R, "Your only admin command is currently: login");
				    return 1;
			}
		} else if(admin[playerid] == 1) {
		    if(!strlen(param1)) {
		    	SendClientMessage(playerid, C_R, "Unknown admin command.");
			    return 1;
			}
		    if(equal(param1, "mute")) {
		        if(!strlen(param2)) {
		            SendClientMessage(playerid, C_R, "USAGE: /chatadmin mute [name-id]");
		            return 1;
				}
				if(!IsNumber(param2)) {
					new id = ReturnPlayerID(param2);
					if(id != INVALID_PLAYER_ID) {
					    if(id != playerid) {
					        if(muted[id] == 1) {
								muted[playerid] = 1;
								format(string, sizeof(string), "You have unmuted %s(%i)", PlayerName(id), id);
					        	SendClientMessage(playerid, C_G, string);
					        	format(string, sizeof(string), "You have been unmuted.");
					        	SendClientMessage(id, C_G, string);
								format(string, sizeof(string), "%s(%i) has unmuted %s(%i)", PlayerName(playerid), playerid, PlayerName(id), id);
								SendChatAdminCommandMessage(string);
							} else {
								muted[playerid] = 1;
								format(string, sizeof(string), "You have muted %s(%i)", PlayerName(id), id);
					        	SendClientMessage(playerid, C_G, string);
					        	format(string, sizeof(string), "You have been muted.");
					        	SendClientMessage(id, C_G, string);
								format(string, sizeof(string), "%s(%i) has muted %s(%i)", PlayerName(playerid), playerid, PlayerName(id), id);
								SendChatAdminCommandMessage(string);
							}
						} else {
						    SendClientMessage(playerid, C_R, "You cannot mute yourself.");
						}
					} else {
					    SendClientMessage(playerid, C_R, "Couldn't find target.");
					}
				} else {
				    new id = strval(param2);
				    if(id != playerid) {
				        if(muted[id] == 1) {
							muted[playerid] = 1;
							format(string, sizeof(string), "You have unmuted %s(%i)", PlayerName(id), id);
				        	SendClientMessage(playerid, C_G, string);
				        	format(string, sizeof(string), "You have been unmuted.");
				        	SendClientMessage(id, C_G, string);
							format(string, sizeof(string), "%s(%i) has unmuted %s(%i)", PlayerName(playerid), playerid, PlayerName(id), id);
							SendChatAdminCommandMessage(string);
						} else {
							muted[playerid] = 1;
							format(string, sizeof(string), "You have muted %s(%i)", PlayerName(id), id);
				        	SendClientMessage(playerid, C_G, string);
				        	format(string, sizeof(string), "You have been muted.");
				        	SendClientMessage(id, C_G, string);
							format(string, sizeof(string), "%s(%i) has muted %s(%i)", PlayerName(playerid), playerid, PlayerName(id), id);
							SendChatAdminCommandMessage(string);
						}
					} else {
					    SendClientMessage(playerid, C_R, "You cannot mute yourself.");
					}
					return 1;
				}
			} else if(equal(param1, "id")) {
			    if(!IsNumber(param2)) {
					new id = ReturnPlayerID(param2);
					format(string,sizeof(string), "ID for %s: %i", PlayerName(id), id);
					SendClientMessage(playerid, C_Y, string);
				} else {
					new id = strval(param2);
					format(string,sizeof(string), "ID for %s: %i", PlayerName(id), id);
					SendClientMessage(playerid, C_Y, string);
				}
			} else if(equal(param1, "commands")) {
			    SendClientMessage(playerid, C_Y, "Commands:");
			    SendClientMessage(playerid, C_G, "/chatadmin mute [name-id]");
			    SendClientMessage(playerid, C_G, "/chatadmin id [name-id]");
			    return 1;
			} else {
			    SendClientMessage(playerid, C_R, "Unknown admin command.");
			    SendClientMessage(playerid, C_R, "Type /chatadmin commands for commands.");
			    return 1;
			}
		}
		return 1;
	}
	return 0;
}

public OnPlayerInfoChange(playerid)
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

// Equal function by Shield42
stock equal(param1[], param2[])
{
	new isit;
	if (strcmp(param1, param2, true)==0) { isit=1; }
	return isit;
}

// AD to show every 900000 miliseconds. Please do not remove this.
public ad() {
	new msg[256];
	format(msg, sizeof(msg), " 让你的聊天只有朋友能看到! < 加入私聊频道 @join 数值(1-50) > < 退出频道 @leave >", version, build);
	SendClientMessageToAll(C_AD, msg);
	return 1;
}

// Return the player's name
stock PlayerName(playerid) {
	new pname[MAX_PLAYER_NAME];
	if(IsPlayerConnected(playerid)) {
		GetPlayerName(playerid, pname, sizeof(pname));
	} else {
		format(pname, sizeof(pname), "Invalid_Name");
	}
	return pname;
}

// Send a message to a channel
stock SendClientMessageToChannel(type, color, const msg[], playerid = INVALID_PLAYER_ID) {
	if(type == LEAVE) {
		for(new i = 0; i <= MAX_PLAYERS; i++) {
		    if(IsPlayerConnected(i)) {
		        if(chan[i] == chan[playerid] && i != playerid) {
		            SendClientMessage(i, color, msg);
				}
			}
		}
	} else if(type == JOIN) {
		for(new i = 0; i <= MAX_PLAYERS; i++) {
		    if(IsPlayerConnected(i)) {
		        if(chan[i] == chan[playerid] && i != playerid) {
		            SendClientMessage(i, color, msg);
				}
			}
		}
	} else if(type == MSG) {
        for(new i = 0; i <= MAX_PLAYERS; i++) {
		    if(IsPlayerConnected(i)) {
		        if(chan[i] == chan[playerid]) {
		            SendClientMessage(i, color, msg);
				}
			}
		}
	}
}

// Check if a string is a number
stock IsNumber(const string[])
{
	new length=strlen(string);
	if (length==0) return false;
	for (new i = 0; i < length; i++) {
		if ((string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') || (string[i]=='-' && i!=0) || (string[i]=='+' && i!=0)) return false;
	}
	if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
	return true;
}

// Get a player's ID from their name (From XtremeAdmin)
stock ReturnPlayerID(PlayerName[]) {
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) { new name[24]; GetPlayerName(i,name,24); if(strfind(name,PlayerName,true)!=-1) return i; }
	return INVALID_PLAYER_ID;
}

// strtok
strtok(const string[], &index)
{
	printf("strtok(%s, %s)",string, index);
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

// Send a message to admins about another admin's command
stock SendChatAdminCommandMessage(const string[]) {
	for(new i = 0; i <= MAX_PLAYERS; i++) {
	    if(IsPlayerConnected(i)) {
	        if(admin[i] == 1) {
				SendClientMessage(i, C_P, string);
			}
		}
	}
}

// Send admin channel message
stock SendAdminChannelMessage(color, const msg[]) {
	for(new i = 0; i <= MAX_PLAYERS; i++) {
	    if(IsPlayerConnected(i)) {
	        if(admin[i] == 1) {
	            SendClientMessage(i, color, msg);
			}
		}
	}
}
