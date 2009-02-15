
/*
	Amit's Teleports Manager filterscript
	------------------------------
	Programmer: Amit Barami "Amit_B"
	Creation Data: 19/1/2008
	Version: 1.0
	Compatibility: SanAndreas:MultiPlayer 0.2.2
*/

//=[IncludeFiles]===============================================================
#include "a_samp.inc"
//=[Defines]====================================================================
// TP:
#define TELEPORT_MANAGER_FS_STATE true							// TM Filterscript is ON?
#define FILE_NAME "tele.cfg"										// Name of file to write the teleports
#define MINIUMUM_HEALTH 30.0									// Minimum health to teleport, 0 to disable
#define SETTELEPORT_CMD_FOR_ADMINS false							// /setteleport is only for admins?
// Messages:
#define ALLOW_TM_MESSAGES false									// Allow messages?
#define DRIVER_MESSAGE "[传送]: 连人带车传送成功."	// Message for player driver
#define PASSENGER_MESSAGE "TP: Only the driver can teleport."	// Message for player passenger
#define ONFOOT_MESSAGE "[传送]: 传送成功."					// Message for player onfoot
#define ERROR_MESSAGE "TP: ERROR."								// Error message
#define HEALTH_MESSAGE "TP: You need more health to teleport."  // Health message
#define ALREADY_MESSAGE "TP: This teleport already exists."     // Already have teleport message
//=[Variables]==================================================================
new showmsg[MAX_PLAYERS];
//=[Forwards]===================================================================
forward ShowPlayerTMMessage(playerid);
//=[OnFilterScriptInit]=========================================================
public OnFilterScriptInit()
{
	print("\n\n====== [ Teleports Manager filterscript v0.2 ]  ======\n");
	print("  Programmer: Amit Barami \"Amit_B\"");
	print("  Creation Date: 19/1/2008");
	print("  Version: 1.0");
	print("  Compatibility: SanAndreas:MultiPlayer 0.2.2");
	if(!fexist(FILE_NAME))
	{
		new File:tm;
		tm = fopen(FILE_NAME,io_write);
		fclose(tm);
	}
	print("  Teleports Manager filterscript *Loaded*!");
	print("\n======================================================\n");
	return 1;
}
//=[OnFilterScriptExit]=========================================================
public OnFilterScriptExit()
{
	print("\n\n====== [ Teleports Manager filterscript v0.2 ]  ======\n");
	print("  Programmer: Amit Barami \"Amit_B\"");
	print("  Creation Date: 19/1/2008");
	print("  Version: 1.0");
	print("  Compatibility: SanAndreas:MultiPlayer 0.2.2");

	print("  Teleports Manager filterscript *UnLoaded*!");
	print("\n======================================================\n");
	return 1;
}
//=[OnPlayerConnect]============================================================
/*public OnPlayerConnect(playerid)
{
	showmsg[playerid] = SetTimerEx("ShowPlayerTMMessage",2000,1,"i",playerid);
	return 1;
}*/
//=[OnPlayerCommandText]========================================================
public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmdtexts[256], idx;
	cmdtexts = strtok(cmdtext,idx);

	if(!strcmp(cmdtext,"/helptele",true))
	{
		SendClientMessage(playerid,0xFFFF00FF," > 查看所有传送命令输入 /teles 召唤车输入/che /car /v");
	}

	if(!strcmp(cmdtext,"/tm11111",true))
	{
		SendClientMessage(playerid,0x993300AA,"Teleports Manager help:");
		SendClientMessage(playerid,0x00EEADDF,"Programmer: Amit Barami \"Amit_B\"");
		SendClientMessage(playerid,0x00EEADDF,"Creation Date: 19/1/2008");
		SendClientMessage(playerid,0x00EEADDF,"Version: 1.0");
		SendClientMessage(playerid,0x00EEADDF,"Compatibility: SanAndreas:MultiPlayer 0.2.2");
		SendClientMessage(playerid,0x00EEADDF,"Commands: /tm /setteleport /rteleports");
		return 1;
	}

	if(!strcmp(cmdtexts,"/vmake",true) || !strcmp(cmdtexts,"/maketele",true) || !strcmp(cmdtexts,"/chuansongtianjia",true) || !strcmp(cmdtexts,"/cstj",true))
	{
		new telecmd[256], File:tmfile, Float:Pos[MAX_PLAYERS][4], wstring[256], string[256], tmp[256], already[256];
		#if SETTELEPORT_CMD_FOR_ADMINS == true
		    if(!IsPlayerAdmin(playerid))
		    {
		        return 1;
		    }
		#endif
		if(!fexist(FILE_NAME))
		{
			tmfile = fopen(FILE_NAME,io_write);
			fclose(tmfile);
		}
		telecmd = strtok(cmdtext,idx);
		if(!strlen(telecmd))
		{
			SendClientMessage(playerid,0xFFFFFFAA,"USAGE: /setteleport [teleport cmd without '/']");
			return 1;
		}
		tmfile = fopen(FILE_NAME,io_read);
		while(fread(tmfile,tmp))
		{
		    idx = 0;
			already = strtok(tmp,idx);
			if(!strcmp(already,telecmd,true))
			{
	    		SendClientMessage(playerid,0xAA3333AA,ALREADY_MESSAGE);
			    return 1;
			}
		}
		fclose(tmfile);
		GetPlayerPos(playerid,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
		GetPlayerFacingAngle(playerid,Pos[playerid][3]);
		tmfile = fopen(FILE_NAME,io_append);
		//format(wstring,sizeof(wstring),"/%s %f %f %f %f %d %d\r\n",telecmd,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2],Pos[playerid][3],GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid));
		format(wstring,sizeof(wstring),"//%s %f %f %f %f %d %d\r\n",telecmd,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2],Pos[playerid][3]);
		fwrite(tmfile,wstring);
		fclose(tmfile);
		format(string,sizeof(string),"[传送] '//%s' 传送命令创建成功.坐标: %f %f %f.",telecmd,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
		SendClientMessage(playerid,0xFF0000FF,string);
		return 1;
	}

	if(!strcmp(cmdtext,"/vvgtele",true))
	{
	    new File:rf;
	    fremove(FILE_NAME);
	    rf = fopen(FILE_NAME,io_write);
	    fclose(rf);
		SendClientMessage(playerid,0x33AA33AA,"TM: Teleports has been reseted.");
		return 1;
	}

	new File:tm = fopen(FILE_NAME,io_read), str[256], found[256], gt[256], Float:h[MAX_PLAYERS];
	while(fread(tm,str))
	{
		idx = 0;
		found = strtok(str,idx);
		if(!strcmp(cmdtext,found,true))
		{
			new Float:tpos[4];
			for(new i=0;i<4;i++)
			{
				found = strtok(str,idx);
				tpos[i] = floatstr(found);
			}
			new interior = strval(strtok(str,idx)), world = strval(strtok(str,idx));
			fclose(tm);
			GetPlayerHealth(playerid,h[playerid]);
		    if(h[playerid] <= MINIUMUM_HEALTH && MINIUMUM_HEALTH != 0)
		    {
		        SendClientMessage(playerid,0xAA3333AA,HEALTH_MESSAGE);
		        return 1;
		    }
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				SetVehiclePos(GetPlayerVehicleID(playerid),tpos[0],tpos[1],tpos[2]);
				SetVehicleZAngle(GetPlayerVehicleID(playerid),tpos[3]);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid),interior);
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),world);
				format(gt,sizeof(gt),"~>~~y~%s~<~",cmdtext[1]);
				GameTextForPlayer(playerid,gt,3000,4);
				#if ALLOW_TM_MESSAGES == true
					SendClientMessage(playerid,0xFFFF00FF,DRIVER_MESSAGE);
				#endif
			}
			else if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
			{
				#if ALLOW_TM_MESSAGES == true
					SendClientMessage(playerid,0xFFFF00FF,PASSENGER_MESSAGE);
				#endif
			}
			else if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
			{
				SetPlayerPos(playerid,tpos[0],tpos[1],tpos[2]);
				SetPlayerFacingAngle(playerid,tpos[3]);
				SetPlayerInterior(playerid,interior);
				SetPlayerVirtualWorld(playerid,world);
				format(gt,sizeof(gt),"~>~~y~%s~<~",cmdtext[1]);
				GameTextForPlayer(playerid,gt,3000,4);
				#if ALLOW_TM_MESSAGES == true
					SendClientMessage(playerid,0xFFFF00FF,ONFOOT_MESSAGE);
				#endif
			}
			else
			{
				#if ALLOW_TM_MESSAGES == true
					SendClientMessage(playerid,0xFFFF00FF,ERROR_MESSAGE);
				#endif
			}
			return 1;
		}
	}
	return 0;
}
//=[ShowPlayerTMMessage]========================================================
public ShowPlayerTMMessage(playerid)
{
	SendClientMessage(playerid,0xFFFF00FF,"查看所有传送命令输入 /teles.");
	KillTimer(showmsg[playerid]);
	return 1;
}
//=[strtok]=====================================================================
stock strtok(const string[], &index)
{
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
