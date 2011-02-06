/*
								The MIT License  
								
	Copyright (c) <2010> <yezizhu>  
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:  

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.  
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.  
	==================================
	��Ȩ(c) <2010> <yezizhu>  

	ʹ�ø�����֤����������������Ȩ�ޣ���ѣ��κ��˿��Եõ����������������ĵ���һ��������
	���Ҿ�Ӫ�����������κ����ƣ����������Ƶ�ʹ�á����ơ��޸ġ��ϲ������桢���С����Ŵ���֤�顢���߳��۸������Ŀ�����Ȩ����
	ͬʱ���������Щ�������û�������ЩȨ����ʹ����������������  
	
	���ϵİ�Ȩ֪ͨ��Ȩ��֪ͨӦ�ð��������и������Ŀ����л�������������������ʵ�����С�
	
	�������������������ṩ��û���κ���ʽ�ĵ�������������ȷ�ػ��߰����ģ�������Щ���ǲ�����ҵ���ʵĵ��������ơ�
	�ʺ�һ���ض�����;���Ҳ����ַ������ߺͰ�Ȩ���������κγ��϶�ʹ�ø������漰���κ�Ҫ���𺦻����������ζ���Ӧ����
	�����������������û���ֻ�Ǻ�ͬ��ʽ��������Ȩ����������ʽ�������������������÷�Χ�ڡ������������ϵ����������ʹ�û�����������������������Ϊ��  
	=====================================   
*/	

#if defined wl_main
	#endinput
#endif
#define wl_main


#include <a_samp>


#include <gvar>
#include <fileExt>






#if defined MAX_STRING
	#undef MAX_STRING
	#define MAX_STRING					(128)
#else
	#define MAX_STRING					(128)
#endif
#if defined MAX_NAME
	#undef MAX_NAME
#endif
#define MAX_NAME						(MAX_PLAYER_NAME)



new const stock bool:FALSE=false;
new const stock bool:TRUE=true;
#define COLOR_GREY				(0xD3D3D3AA)
#define COLOR_LIGHTBLUE			(0x00BFFFAA)
#define COLOR_ULTRARED			(0xFF0606FF)
#define COLOR_PURPLE			(0x9900FFAA)
#define COLOR_GREEN				(0x33AA33AA)
#define COLOR_YELLOW			(0xFFFFE0AA)
#define COLOR_ORANGE			(0xFFA500AA)
#define COLOR_RED				(0xFF0000AA)
#define COLOR_SYSTEM			(0xEFEFF7AA)
#define COLOR_ZONE_DM			(COLOR_LIGHTBLUE)
#define COLOR_WARNING			(COLOR_ULTRARED)
#define COLOR_TIP				(COLOR_LIGHTBLUE)
#define COLOR_STUDY				(COLOR_YELLOW)

//===================System handle==================================
new
	ssstr[MAX_MSG_STR];
#define System_send(%1,%2,%3)	\
do{ \
	format(ssstr,MAX_STRING,(%2),%3); \
	SendClientMessage((%1),COLOR_SYSTEM,ssstr); \
}while(FALSE)
stock System_send(playerid,const sendfstring[]){
	SendClientMessage(playerid,COLOR_SYSTEM,sendfstring);
}

#define System_sendAll(%1,%2)	\
do{ \
	format(ssstr,MAX_STRING,(%1),%2); \
	SendClientMessageToAll(COLOR_SYSTEM,ssstr); \
}while(FALSE)
stock System_sendAll(const sendfstring[]){
	SendClientMessageToAll(COLOR_SYSTEM,sendfstring);
}

//===================================================================================

#include <gcs\gcs_uf>
#include <wl/wl_rulebreak_detect>
#include <gcs/gcs_main>
#include <gcs/gcs_ini_fsload>





//#include <gcs/gcs_ini>
//#include <gcs/ini/gcs_ini_struct>
#include <NPatcher>
#include <zcmd>
#include <streamer>
//#include <Y_Objects>
//#include <F_Streamer>
#include <ecode>
//#include <SII>
//#include <wl/wl_cmd>
//#include <dfile/dini>
//#include <wl/database>


#define playerfile				"wl/player/"
#define acc_pName				"playerName"
#define acc_pPass				"playerPassword"
#define acc_pLevel				"playerTeamLevel"

#define acc_pVWLog_tank_times				"pPM_tank_times"
#define acc_pVWLog_tank_score				"pPM_tank_score"
#define acc_pVWLog_spaz_times				"pPM_spaz_times"
#define acc_pVWLog_spaz_score				"pPM_spaz_score"
#define acc_pVWLog_minigun_times			"pPM_minigun_times"
#define acc_pVWLog_minigun_score			"pPM_minigun_score"
#define acc_pVWLog_quanquan_times			"pPM_quanquan_times"
#define acc_pVWLog_quanquan_score			"pPM_quanquan_score"


#define racefile					"wl/race/"
#define raceNamefile				"race.list"
#define data_race_Name				"raceName"
#define data_race_Description		"raceDescription"
#define data_race_Builder			"raceBuilder"
#define data_race_Password			"racePassword"
#define data_race_RaceTimes			"raceRaceTimes"
#define data_race_LastRunDate		"raceLastRunDate"
#define data_race_Interior			"raceInterior"
#define data_race_Distance			"raceDistance"
#define data_race_cp				"racecp"
#define data_race_cpAmount			"racecpAmount"
#define data_race_cpPosX			"racecpPosX"
#define data_race_cpPosY			"racecpPosY"
#define data_race_cpPosZ			"racecpPosZ"
#define data_race_cpSize			"racecpSize"
#define data_race_cpType			"racecpType"
#define data_race_cpAngel			"racecpAngel"
#define data_race_winnerinfo		"racewinnerinfo"


#define MAX_WEAPON_SLOT	(13)


//====//mode_Gang&Group
stock wl_sPlr_Group_Invited(playerid,set){
	SetPVarInt(playerid,"wl_plr_main_Group_Invited",set);
	return true;
}
stock wl_gPlr_Group_Invited(playerid){
	return GetPVarInt(playerid,"wl_plr_main_Group_Invited");
}

stock wl_sPlr_Group_Joined(playerid,set){
	SetPVarInt(playerid,"wl_plr_main_Group_Joined",set);
	return true;
}
stock wl_gPlr_Group_Joined(playerid){
	return GetPVarInt(playerid,"wl_plr_main_Group_Joined");
}

stock wl_sPlr_Group_requestTele(playerid,set){
	SetPVarInt(playerid,"wl_plr_main_Group_requestTele",set);
	return true;
}
stock wl_gPlr_Group_requestTele(playerid){
	return GetPVarInt(playerid,"wl_plr_main_Group_requestTele");
}

stock wl_sPlr_Group_requester(playerid,set){
	SetPVarInt(playerid,"wl_plr_main_Group_requester",set);
	return true;
}
stock wl_gPlr_Group_requester(playerid){
	return GetPVarInt(playerid,"wl_plr_main_Group_requester");
}
//============================
	/*
	//mode_GunDM
	GunDM_PlayerIn,
	GunDM_PlayerSwitchWeapon[MAX_WEAPON_SLOT],
	//mode_TDM
	TDM_Package,
	TDM_VoteFor,
	TDM_In,
	TDM_Spawn_Time,
	TDM_Score,
	*/
//mode_DM
stock wl_sPlr_DM_PlayerIn(playerid,set){
	SetPVarInt(playerid,"wl_plr_main_DM_PlayerIn",set);
	return true;
}
stock wl_gPlr_DM_PlayerIn(playerid){
	return GetPVarInt(playerid,"wl_plr_main_DM_PlayerIn");
}

stock wl_sPlr_PDM_PlayerKill(playerid,set){
	SetPVarInt(playerid,"wl_plr_main_PDM_PlayerKill",set);
	return true;
}
stock wl_gPlr_PDM_PlayerKill(playerid){
	return GetPVarInt(playerid,"wl_plr_main_PDM_PlayerKill");
}

stock wl_sPlr_PDM_PlayerDeath(playerid,set){
	SetPVarInt(playerid,"wl_plr_main_PDM_PlayerDeath",set);
	return true;
}
stock wl_gPlr_PDM_PlayerDeath(playerid){
	return GetPVarInt(playerid,"wl_plr_main_PDM_PlayerDeath");
}

//====================
//template_forcespam
stock wl_sPlr_forceSpaming(playerid,set){
	SetPVarInt(playerid,"wl_plr_main_forceSpaming",set);
	return true;
}
stock wl_gPlr_forceSpaming(playerid){
	return GetPVarInt(playerid,"wl_plr_main_forceSpaming");
}
//=============
/*
	//template_lang_system
	lang_Player,
*/
//template_other
stock wl_sPlr_Player_Skin(playerid,set){
	SetPVarInt(playerid,"wl_plr_main_Player_Skin",set);
	return true;
}
stock wl_gPlr_Player_Skin(playerid){
	return GetPVarInt(playerid,"wl_plr_main_Player_Skin");
}
//===================
//other
stock wl_sPlr_ppos_x(playerid,Float:set){
	SetPVarFloat(playerid,"wl_plr_main_ppos_x",set);
	return true;
}
stock Float:wl_gPlr_ppos_x(playerid){
	return GetPVarFloat(playerid,"wl_plr_main_ppos_x");
}

stock wl_sPlr_ppos_y(playerid,Float:set){
	SetPVarFloat(playerid,"wl_plr_main_ppos_y",set);
	return true;
}
stock Float:wl_gPlr_ppos_y(playerid){
	return GetPVarFloat(playerid,"wl_plr_main_ppos_y");
}

stock wl_sPlr_ppos_z(playerid,Float:set){
	SetPVarFloat(playerid,"wl_plr_main_ppos_z",set);
	return true;
}
stock Float:wl_gPlr_ppos_z(playerid){
	return GetPVarFloat(playerid,"wl_plr_main_ppos_z");
}

stock wl_sPlr_ppos_angle(playerid,Float:set){
	SetPVarFloat(playerid,"wl_plr_main_ppos_angle",set);
	return true;
}
stock Float:wl_gPlr_ppos_angle(playerid){
	return GetPVarFloat(playerid,"wl_plr_main_ppos_angle");
}




//=========================


	

//DEBUG
new
	const logname[] = "wl/debug_log";
#define writetolog(%0,%1) \
do{ \
	new \ 
		logstring[128]; \
	format(logstring,sizeof(logstring),(%0),%1); \
	new \
		File:append_Log = fopen(logname,io_append); \
	fwrite(append_Log,logstring); \
	fwrite(append_Log,"\r\n"); \
	fclose(append_Log); \
}while(FALSE)
stock writetolog(const logstring[]){
	new
		File:append_Log = fopen(logname,io_append);
	fwrite(append_Log,logstring);
	fwrite(append_Log,"\r\n");
	fclose(append_Log);
}
//=====================================================================================================
stock GetPlayerAdminLevel(playerid){
	return CallRemoteFunction("GetPlayerAdminLevel","i",playerid);
}










#include <wl\wl_lang>

//#include <wl\wl_subaccount>
#include <wl\wl_account>
#include <wl\wl_objective>
#include <wl\wl_template>
#include <wl\wl_mode>
#include <wl\wl_ruleop>






wl_GameModeInit(){
	AntiDeAMX();
//	mode_protection();
//	Srm_OnGameModeInit();
	//mode_introduction();
	gcs_GameModeInit();
	wl_lang_OnGameModeInit();
	acc_OnGameModeInit();
	wl_objective_GameModeInit();
	wl_tmp_GameModeInit();
	wl_mode_Struction();
	wl_ruleop_struction();
	return true;
}

wl_GameModeExit(){
	wl_mode_UnStruction();
	return true;
}

wl_PlayerRequestClass(playerid,classid){
	wl_objective_RequestClass(playerid, classid);
	return true;
}

wl_PlayerConnect(playerid){
//	Srm_OnPlayerConnect(playerid);
	gcs_PlayerConnect(playerid);
	wl_lang_OnPlayerConnect(playerid);
	acc_OnPlayerConnect(playerid);
	//sb_playerConnect(playerid);
	wl_tmp_PlayerConnect(playerid);
	wl_mode_PlayerConnect(playerid);
	//account_playerConnect(playerid);
	rp_playerConnect(playerid);
	return true;
}

wl_PlayerDisconnect(playerid,reason){
//	Srm_OnPlayerDisconnect(playerid,reason);
	gcs_PlayerDisconnect(playerid,reason);
	acc_OnPlayerDisconnect(playerid);
	//Object_OnPlayerDisconnect(playerid,reason);
	//sb_playerDisconnect(playerid);
	wl_tmp_PlayerDisconnect(playerid);
	wl_mode_PlayerDisconnect(playerid,reason);
	//account_playerDisconnect(playerid);
	rp_playerDisconnect(playerid);
	return true;
}

wl_PlayerRequestSpawn(playerid){
	wl_tmp_PlayerRequestSpawn(playerid);
	return true;
}

wl_PlayerSpawn(playerid){
	detect_playerSpawn(playerid);
	//sb_playerSpawn(playerid);
	wl_tmp_PlayerSpawn(playerid);
	wl_ruleop_playerSpawn(playerid);
	if(PDM_getPlayerDM(playerid) != INVALID_PDM_ID){
		wl_mode_PlayerSpawn(playerid);
	}
	dmw:playerSpawn(playerid);
	if(PDM_getPlayerDM(playerid) == INVALID_PDM_ID && GetPlayerVirtualWorld(playerid) == 0){
		GivePlayerWeapon(playerid,23,17 * 100);
		GivePlayerWeapon(playerid,43,9999);
		GivePlayerWeapon(playerid,WEAPON_KATANA,1);
		SetPlayerHealth(playerid,99999);
		wl_objective_SpawnPlayer(playerid);
	}
}

wl_PlayerDeath(playerid,killerid,reason){
	gcs_PlayerDeath(playerid,killerid,reason);
	wl_ruleop_PlayerDeath(playerid, killerid, reason);
	wl_tmp_PlayerDeath(playerid,killerid);
	wl_mode_PlayerDeath(playerid,killerid,reason);
	return true;
}

wl_PlayerPrivmsg(playerid,recieverid,text[]){
	if(wl_tmp_PlayerPrivmsg(playerid,recieverid,text))return true;
	return false;
}

wl_PlayerText(playerid,text[]){
	wl_tmp_playerText(playerid);
	if(!wl_mode_PlayerText(playerid,text)) return true;
	if(wl_tmp_PlayerText(playerid,text))return true;
	return false;
}

wl_CommandText(playerid,cmdtext[]){
	
	//gcs_CommandText(playerid,cmdtext);
	wl_tmp_playerCommandText(playerid);
	if(/*wl_objective_CommandText(playerid,cmdtext) || */wl_mode_CommandText(playerid,cmdtext)) return true;
	return false;
}

wl_PlayerSelectedMenuRow(playerid,row){
	gcs_PlayerSelectedMenu(playerid);
	if(wl_mode_PlayerSelectedMenuRow(playerid,row))return true;
	return false;
}

wl_PlayerExitedMenu(playerid){
	gcs_PlayerExitedMenu(playerid);
	wl_mode_PlayerExitedMenu(playerid);
	return true;
}

wl_PlayerStateChange(playerid,newstate,oldstate){
	wl_tmp_playerStateChange(playerid);
	wl_mode_PlayerStateChange(playerid,newstate,oldstate);
	return true;
}

wl_KeyStateChange(playerid,newkeys,oldkeys){
	wl_tmp_playerKeyStateChange(playerid);
	wl_mode_KeyStateChange(playerid,newkeys,oldkeys);
	wl_mode_PlayerKeyStateChange(playerid,newkeys,oldkeys);
	return true;
}

wl_DialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	wl_mode_DialogResponse(playerid, dialogid, response, listitem, inputtext);
	wl_tmp_DialogResponse(playerid, dialogid, response, listitem, inputtext);
}

wl_EnterCheckpoint(playerid){
	wl_mode_EnterCheckpoint(playerid);
}

wl_EnterRaceCheckpoint(playerid){
	wl_mode_EnterRaceCheckpoint(playerid);
	return true;
}

wl_PlayerUpdate(playerid){
	
	detect_PlayerUpdate(playerid);
	wl_tmp_PlayerUpdate(playerid);
	return true;
}
	
wl_PlayerClickPlayer(playerid, clickedplayerid, source){
	#pragma unused playerid,clickedplayerid,source
	//account_PlayerClickPlayer(playerid, clickedplayerid, source);
	return true;
}






//=========================================================================================



























		




Marker_struct(){
	SetTimer("Marker_itter",2046,true);
	
}
forward Marker_itter();
public Marker_itter(){ //todo: high bandwidth use
	new
		tranprancy[32];
	loopPlayer(playerid){
		loopPlayer(showplayerid){
			if(showplayerid < playerid){	
				continue;
			}
			#if WL_DMWorld
			if(dmw:getPlayer(playerid) && dmw:getPlayer(showplayerid)){
				dmw:MarkerProcess(playerid,showplayerid); 
			}
			#endif
			else { 
				//if(getDisBetweenPlayer(playerid,showplayerid) < 350){
					format(tranprancy,sizeof(tranprancy),"%.f",255-getDisBetweenPlayer(playerid,showplayerid) * 0.35);
					p_setMarkerTransparency(showplayerid,playerid,strval(tranprancy));
					p_setMarkerTransparency(playerid,showplayerid,strval(tranprancy));
				//}
			}
		}
	}
}


public OnGameModeInit(){

	
	{
		//temp set
		if(!fexist("wl/do_not_delete.wl")){ //clean database
			fcreate("wl/do_not_delete.wl");
			fremove("wl/DMWorld/dmworld.db");
			fremove("wl/user.db");
			/*
			{
				db_processstart("DELETE TABLE gang_stat;DELETE TABLE zone;DELETE TABLE dmw_blacklist;DELETE TABLE dmw_admin");
				db_processthenfree(db_dmworld);
			}
			{
				db_processstart("DELETE TABLE player_account");
				db_processthenfree(db_user);			
			}
			*/
		}
	}

	//SendRconCommand("loadfs gcs_ini");
	
	wl_GameModeInit();
	SetGameModeText("0.3����/����/�ؼ�/DM");
	UsePlayerPedAnims();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	Marker_struct();
	//LimitPlayerMarkerRadius(440);
	SetNameTagDrawDistance(40);
	
	
	SendRconCommand("loadfs tele");
	SendRconCommand("loadfs spectate");
	SendRconCommand("loadfs Seifanims");
	SendRconCommand("loadfs drift");
	SendRconCommand("loadfs tunecar");
	
	SetTimer("autoRestart",1111*45,true);
	return true;
}
public OnGameModeExit(){
	
	SendRconCommand("unloadfs gcs_ini");
	SendRconCommand("unloadfs tele");
	SendRconCommand("unloadfs spectate");
	SendRconCommand("unloadfs Seifanims");
	SendRconCommand("unloadfs drift");
	SendRconCommand("unloadfs tunecar");
	wl_GameModeExit();
	
	return true;
}
public OnFilterScriptInit(){
//	Srm_OnFilterScriptInit();
	return true;
}
public OnFilterScriptExit(){
	return true;
}
public OnPlayerConnect(playerid){
	System_sendAll("[ϵͳ]��ӭ���%s(%d)���������^^ ",pName(playerid),playerid);

	GivePlayerMoney(playerid,999999);
	wl_PlayerConnect(playerid);
	System_send(playerid,"[ϵͳ]��ӭ����δ�����磬�ڱ��������������� - /c - ˢ��, - /tunecar - �ĳ��� - /r s - ����");
	System_send(playerid,"[ϵͳ]��ӭ����δ�����磬�ڱ��������������� - /wuqi - ��������, /dm [id] - ����DM��");
	System_send(playerid,"[ϵͳ]��ս�� ����/dmw enter�����ս��,/dmw attack������� - ����ʱ��:19:00 - 22:00");
	System_send(playerid,"[ϵͳ]����������/help���½help.gtaip.com �鿴(��Ȩ��Ϣ - /wl)");	
	return true;
}



public OnPlayerDisconnect(playerid, reason){
	switch(reason){
		case 0:System_sendAll("[ϵͳ]���%s(%d)������",pName(playerid),playerid);
		case 1:System_sendAll("[ϵͳ]���%s(%d)������",pName(playerid),playerid);
		case 2:System_sendAll("[ϵͳ]���%s(%d)���ϳ��˷�����",pName(playerid),playerid);
	}
	wl_PlayerDisconnect(playerid,reason);

	return true;
}

public OnPlayerSpawn(playerid){
	
	//GivePlayerWeapon(playerid,WEAPON_PARACHUTE,1);
	//sb_useGodmode(playerid);
	wl_PlayerSpawn(playerid);

	return true;
}

public OnPlayerDeath(playerid, killerid, reason){
	SendDeathMessage(killerid,playerid,reason);
	wl_PlayerDeath(playerid,killerid,reason);
	return true;
}
public OnVehicleSpawn(vehicleid){
	return true;
}
public OnVehicleDeath(vehicleid, killerid){
	wl_mode_VehicleDeath(vehicleid);
	return true;
}

public OnPlayerText(playerid, text[]){
	if(wl_PlayerText(playerid,text)){
		return false;
	}
	return true;
}


public OnPlayerRequestClass(playerid, classid){
	wl_PlayerRequestClass(playerid,classid);
	//objective_RequestClass(playerid,classid);
	return true;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
	return true;
}
public OnPlayerExitVehicle(playerid, vehicleid){
	wl_mode_PlayerExitVehicle(playerid);
	return true;
}
public OnPlayerStateChange(playerid, newstate, oldstate){
	wl_PlayerStateChange(playerid,newstate,oldstate);
	return true;
}
public OnPlayerEnterCheckpoint(playerid){
	wl_EnterCheckpoint(playerid);
	return true;
}
public OnPlayerLeaveCheckpoint(playerid){
	return true;
}
public OnPlayerEnterRaceCheckpoint(playerid){
	wl_EnterRaceCheckpoint(playerid);
	return true;
}
public OnPlayerLeaveRaceCheckpoint(playerid){
	return true;
}
public OnRconCommand(cmd[]){
	return true;
}


public OnPlayerRequestSpawn(playerid){
	wl_PlayerRequestSpawn(playerid);
	return true;
}
public OnObjectMoved(objectid){
	return true;
}
public OnPlayerObjectMoved(playerid, objectid){
	return true;
}
public OnPlayerPickUpPickup(playerid, pickupid){
	return true;
}
public OnVehicleMod(playerid, vehicleid, componentid){
	return true;
}
public OnVehiclePaintjob(playerid, vehicleid, paintjobid){
	return true;
}
public OnVehicleRespray(playerid, vehicleid, color1, color2){
	return true;
}
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid){
	return true;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys){
	wl_KeyStateChange(playerid,newkeys,oldkeys);
	return true;
}
public OnPlayerSelectedMenuRow(playerid,row){
	TogglePlayerControllable(playerid, true);
	if(wl_PlayerSelectedMenuRow(playerid,row))return true;
	return true;
}
public OnPlayerExitedMenu(playerid){
	TogglePlayerControllable(playerid, true);
	wl_PlayerExitedMenu(playerid);
	return true;
}

forward OnPlayerPrivmsg(playerid, recieverid, text[]);
public OnPlayerPrivmsg(playerid, recieverid, text[]){
	if(wl_PlayerPrivmsg(playerid,recieverid,text))return false;
	return true;
}

public OnPlayerCommandText(playerid,cmdtext[]){
	if(ZCMD_ProcessCommand(playerid, cmdtext)) return true;
	if(wl_CommandText(playerid,cmdtext)) return true;
	System_send(playerid,"[ϵͳ]�����������'%s'���������� /help ���½help.gtaip.com �鿴����",cmdtext);
	return true;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source){
	wl_PlayerClickPlayer(playerid, clickedplayerid, source);
	return true;
}

public OnPlayerUpdate(playerid){
	if(!rp_playerUpdate(playerid))return false;
	wl_PlayerUpdate(playerid);
	return true;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	wl_DialogResponse(playerid, dialogid, response, listitem, inputtext);
	return false;
}



zcmd(banpm,playerid,params[]){
	new
		recevierid;
	if(!sscanf(params,"i",recevierid)){
		if(IsPlayerConnected(recevierid)){
			if(GetGVarInt("wl_plr_banpm",getDoubleRelationList(playerid,recevierid))){
				SetGVarInt("wl_plr_banpm",false,getDoubleRelationList(playerid,recevierid));
				System_send(playerid,"[PM]��ر�������%s(%d)��PM��Ϣ�Ĺ��ܣ������ù������ٴ����� - /banpm %d",pName(recevierid),recevierid,recevierid);
			}
			else {
				SetGVarInt("wl_plr_banpm",true,getDoubleRelationList(playerid,recevierid));
				System_send(playerid,"[PM]�㿪��������%s(%d)��PM��Ϣ�Ĺ��ܣ��رոù������ٴ����� - /banpm %d",pName(recevierid),recevierid,recevierid);
			}
		}
		else {
			System_send(playerid,"IDΪ%d����Ҳ�����",recevierid);
		}
	}
	else {
		System_send(playerid,"ʹ�÷��� - /banpm [���ID] - ����/�ر��������PM��Ϣ�Ĺ���");
	}
	return true;
}

	
zcmd(pm,playerid,params[]){
	// PM Command
	#define ADMINFS_MESSAGE_COLOR 0xFF444499
	#define PM_INCOMING_COLOR     0xFFFF22AA
	#define PM_OUTGOING_COLOR     0xFFCC2299
	new
		pmee,
		Msg[128];
	if(!sscanf(params,"is",pmee,Msg)){
		//printf("%d,%d,%s",playerid,pmee,Msg);
		if(IsPlayerConnected(pmee)){
			if(playerid != pmee){
				if(!GetGVarInt("wl_plr_banpm",getDoubleRelationList(pmee,playerid))){
					OnPlayerPrivmsg(playerid,pmee,Msg);
					printf("PM: %d to %d:%s",playerid,pmee,Msg);
				}
				else {
					System_send(playerid,"[PM]���%s(%d)���������PM��Ϣ������ʧ��",pName(pmee),pmee);
				}
			} 
			else {
				SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"You cannot PM yourself");
			}
		}
		else {
			SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"/pm : Bad player ID");
		}
	}
	else {
		SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"Usage: /pm (id) (message)");
	}
	return 1;
	#undef ADMINFS_MESSAGE_COLOR
	#undef PM_INCOMING_COLOR
	#undef PM_OUTGOING_COLOR
}

zcmd(help,playerid,params[]){
	#define DIALOG_CMD_HELP_CAPTION	"����(help.gtaip.com)"
	#define DIALOG_CMD_HELP_INFO	"\
	���Ի�����ϵͳ:/s help    �ʺŰ���:/a help\
	����ϵͳ:/c help    ��̥:/c tune     Ư�ƼƷ�ϵͳ:/d help\n\
	����ϵͳ: ��ʾ����/joinʱ,����/join ���ɲμ�    ѧϰ����������lxd\n\
	Ⱥ��ϵͳ:/g help\n�Ŷ�ϵͳ:/t help\n�������DM����:/gdm   ������ͨDM:/dm [id]\n\
	����ϵͳ:/tv\n����ϵͳ:/animlist\n21��ϵͳ:/bj help\n���ƴ��͵�/vmake\n \n��������:/cmds"
	#define DIALOG_CMD_HELP_BUTTON1	"ȷ��"
	#define DIALOG_CMD_HELP_BUTTON2	"ȡ��"
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_LIST,DIALOG_CMD_HELP_CAPTION,DIALOG_CMD_HELP_INFO,DIALOG_CMD_HELP_BUTTON1,DIALOG_CMD_HELP_BUTTON2);
	return 1;
}
zcmd(cmds,playerid,params[]){
	#define DIALOG_CMD_CMDS_CAPTION	"�������(help.gtaip.com)"
		#define DIALOG_CMD_CMDS_INFO   "\
		/sp �����㵱ǰ����    /lp ���͵������������괦\n/w [id]���� /world [id]�����л����磬���� /w ���ɻص�����\
		/afk [ԭ��] �һ�    /back ����\n/ff �л��񶷷��\n\
		/skin [Ƥ��id] �����л�Ƥ��\n/kill ��ɱ /zican �Բ�\n/id [��Ҳ�������] �����\n\
		/jetpack �и�����������    /jls �и�����ɡ     /dive ԭ�ظ߿���ɡ\n/count ����ʱ\n \
		/shang /xia /zuo /you /qian /hou ΢�����λ��\n��������:/help\n"
	#define DIALOG_CMD_CMDS_BUTTON1 "ȷ��"
	#define DIALOG_CMD_CMDS_BUTTON2 "ȡ��"
ShowPlayerDialog(playerid,1,DIALOG_STYLE_LIST,DIALOG_CMD_CMDS_CAPTION,DIALOG_CMD_CMDS_INFO,DIALOG_CMD_CMDS_BUTTON1,DIALOG_CMD_CMDS_BUTTON2);
	return 1;
}
zcmd(thanks,playerid,params[]){
	#define DIALOG_CMD_THX_CAPTION	"�ر���л(help.gtaip.com)"
	#define DIALOG_CMD_THX_INFO	"������©�뱨�������Ա(���������Ⱥ�) \n\n����Ⱥ\n   vvg,yezizhu,Cn_Shindo,Sean.X,MK124,fangye\n \
								GM\n   LXD,JL3517,TaiZi,KTS,CHY,luck,Devil_ggggg\n \
								���\nowen,Leon,TaiZi,Heise,TY,Ak47,hand,TCWTQS...\n \
								��վ\n   gtabbs.com sa-mp.com.cn gtaip.com gta.qq.topzj.com\n"
	#define DIALOG_CMD_THX_BUTTON1	"ȷ��"
	#define DIALOG_CMD_THX_BUTTON2	"ȡ��"
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_LIST,DIALOG_CMD_THX_CAPTION,DIALOG_CMD_THX_INFO,DIALOG_CMD_THX_BUTTON1,DIALOG_CMD_THX_BUTTON2);
	return 1;
}




zcmd(subaccount,playerid,params[]){
	System_send(playerid,"[�ʺ�]��������ʱȡ�����Ի����ù���");
	return true;
}
pzcmd(s) 			rzcmd(subaccount);		

	/*
zcmd(acc_register,playerid,params[]){
	System_send(playerid,"[�ʺ�]��������ʱȡ��ע�Ṧ��");
	return true;
}
//pzcmd(register)		rzcmd(acc_register); 

zcmd(acc_login,playerid,params[]){
	System_send(playerid,"[�ʺ�]��������ʱȡ����½����");
	return true;
}
pzcmd(register)		rzcmd(acc_register);

zcmd(acc_account,playerid,params[]){
	System_send(playerid,"[�ʺ�]��������ʱע��ϵͳ����");
	return true;
}
pzcmd(account)		rzcmd(acc_account);
pzcmd(a)			rzcmd(acc_account);
	*/
	