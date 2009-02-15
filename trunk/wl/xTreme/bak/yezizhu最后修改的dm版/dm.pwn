#include <a_samp>


new const bool:FALSE=false;
new const bool:TRUE=true;
#define MAX_STRING					(128)
#define COLOR_DM					(0xFF4F3C)

//==============================================dcmd=========================================//
#define dcmd(%1,%2,%3)            if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
//===========================================================================================//



forward _DM_pPlaying(playerid);


//=====================================================DM====================================//
//==============================DM_MsgSend===================================================//
#define DM_MsgSend(%1,%2,%3)		do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%2),%3);SendClientMessage((%1),COLOR_DM,sendfstring);}while(FALSE)
stock DM_MsgSend(playerid,const sendfstring[]){
	SendClientMessage(playerid,COLOR_DM,sendfstring);
	return TRUE;
}
//============================================================================================//
//==============================DM_MsgSendToAll===============================================//
#define DM_MsgSendToAll(%1,%2)	do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%1),%2);SendClientMessageToAll(COLOR_DM,sendfstring);}while(FALSE)
stock DM_MsgSendToAll(const sendfstring[]){
	SendClientMessageToAll(COLOR_DM,sendfstring);
	return TRUE;
}
//============================================================================================//
#define DM_DEBUG					(true)
#define DM_MENU_SYSTEM				(true)
#define MAX_WEAPON_SLOT				(13)
//#define MAX_WEAPONS					(47)
#define MAX_DM						(10)
#define MAX_DM_SPAWN_POS			(2)
#define INVALID_DM_ID				(-1)

#define WORLD_DM                    (10)
/*
#define DM_AK47     	(0)
#define DM_SNIPER   	(1)
#define DM_TOWN     	(2)
#define DM_BEACH    	(3)
#define DM_RING     	(4)
#define DM_FARM     	(5)
#define DM_SMG     		(6)
#define DM_KATANA     	(7)
#define DM_RPG     		(8)
#define DM_TENNIS       (9)
*/
//================================================================================================

enum _DM_Info{
	Name[MAX_STRING],
	Float:Spawn_Area[4],
	Float:Spawn_Pos_x[MAX_DM_SPAWN_POS],
	Float:Spawn_Pos_y[MAX_DM_SPAWN_POS],
	Float:Spawn_Pos_z[MAX_DM_SPAWN_POS],
	Spawn_Interior,
	Weapon[MAX_WEAPON_SLOT],
	Weapon_Ammo[MAX_WEAPON_SLOT],

	Vote_Times,
	
	End_Time,
	End_Timer,
	
	Player_Spawn_Times,
	Player_Score[MAX_PLAYERS],
	
	bool:Join_Player[MAX_PLAYERS],
	bool:Active,
	bool:Start

}
new DMInfo[MAX_DM][_DM_Info];


new 
	DM_Vote_Timer,
	DM_Vote_Time_ = 1000*10;//1000*60*2;zhu:投票持续时间
	forward DM_Vote_Time();
new 
	DM_Start_Timer,
	DM_Start_Time_ = 1000*10;//zhu:投票结束后多少秒后开始
	forward DM_Start_Time();
//new
//	DM_End_Timer,
//	DM_End_Time_ = 1000*60*15;//none use
	forward DM_End_Time();


new 
	DM_Next_Timer,
	DM_Next_Time_ = 1000*10;//1000*60*10;zhu:DM结束后下一场DM时间
	forward DM_Next_Time();
	
	
	
new Cur_DM;
new
	DM_Player_Vote_For[MAX_PLAYERS],
	DM_Player_In[MAX_PLAYERS];
new DM_Player_Pos_Timer[MAX_PLAYERS];


new
	Menu:DM_Item_I,
	Menu:DM_Item_II,
	Menu:DM_Weapon_I,
	Menu:DM_Weapon_II,
	Menu:DM_Weapon_III,
	Menu:DM_Weapon_IV;
//===============================================================================

//=======================================Gang======================================
#define GANG_DEBUG				(true)
#define COLOR_GANG				COLOR_DM
#define MAX_GANGS				(MAX_PLAYERS)
#define MAX_GANG_MEMBERS		(MAX_PLAYERS)
#define MAX_GANG_NAME			(16)
#define INVALID_GANG_ID			(-1)
//=================Gang_MsgSend=====================================//
#define Gang_MsgSend(%1,%2,%3)		do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%2),%3);SendClientMessage((%1),COLOR_GANG,sendfstring);}while(FALSE)
stock Gang_MsgSend(playerid,const sendfstring[]){
	SendClientMessage(playerid,COLOR_GANG,sendfstring);
	return TRUE;
}
//==================================================================//
//==================Gang_MsgSendToAll===============================//
#define Gang_MsgSendToAll(%1,%2)	do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%1),%2);SendClientMessageToAll(COLOR_GANG,sendfstring);}while(FALSE)
stock Gang_MsgSendToAll(const sendfstring[]){
	SendClientMessageToAll(COLOR_GANG,sendfstring);
	return TRUE;
}
//==================================================================//

enum _Gang_Info{
	Name[MAX_GANG_NAME],
	Member[MAX_GANG_MEMBERS],
	bool:Created,
	Members,
	Color
}
new GangInfo[MAX_GANGS][_Gang_Info];
new

	GangInvite[MAX_PLAYERS];

//=====================================================================//
//===============SendGangMessage==============================-=====//
#define SendGangMessage(%1,%2,%3)\
	do{\
		new sendfstring[MAX_STRING];\
		format(sendfstring,MAX_STRING,(%2),%3);\
		for(new tmptmptmpval = 0;tmptmptmpval < MAX_PLAYERS; tmptmptmpval++){\
			if(IsPlayerConnected(tmptmptmpval) && Gang_GetPlayer(tmptmptmpval) == (%1)){\
				SendClientMessage(tmptmptmpval,GangInfo[(%1)][Color],sendfstring);\
			}\
		}\
	}while(FALSE)

stock SendGangMessage(gangid,const msg[]){
	for(new i;i<MAX_PLAYERS;i++){
		if(IsPlayerConnected(i) && Gang_GetPlayer(i) == gangid){
			SendClientMessage(i,GangInfo[gangid][Color],msg);
		}
	}
	return TRUE;
}
//===================================================================//


//===================both dm%gang============================//
new
	DM_Gang_Score[MAX_GANGS];
//===========================================================//

stock DM_Struction(){//zhu:需要修改的
	#if DM_DEBUG
		print("[DM_DEBUG]DM_Struction called");
	#endif

    DM_SetName(0,"AK47");
    DM_SetSpawn(0,0,2837.5439,-2333.4243,12.0445);
    DM_SetSpawn(0,1,2841.5322,-2487.8589,12.0939);
    DM_SetInterior(0,0);
    DM_SetTime(0,1000*30);//1000*60
    DM_SetPlayer_Spawn_Times(0,0);// <=0 == 无限]
	DM_SetWeapon(0,30,1000);
	
    DM_SetName(1,"SNIPER");
	DM_SetArea(0,2569.7319,2615.8579,2749.7212,2858.7756);
    DM_SetSpawn(1,0,2632.5264,2832.3577,127.5781);
    DM_SetSpawn(1,1,2593.4360,2638.2803,114.0313);
    DM_SetInterior(1,0);
    DM_SetTime(1,1000*30);//1000*60
    DM_SetPlayer_Spawn_Times(1,0);// <=0 == 无限]
	DM_SetWeapon(1,34,200);
	DM_SetWeapon(1,46,1);
	
    DM_SetName(2,"TOWN");
 	DM_SetArea(2,1099.1389,173.8903,1553.8770,392.4679);
    DM_SetSpawn(2,0,1308.8549,272.7297,19.5547);
    DM_SetSpawn(2,1,1301.1141,256.9669,19.5547);
    DM_SetInterior(2,0);
    DM_SetTime(2,1000*30);//1000*60
    DM_SetPlayer_Spawn_Times(2,0);// <=0 == 无限]
	DM_SetWeapon(2,34,50);
	DM_SetWeapon(2,22,300);
	DM_SetWeapon(2,26,300);
	DM_SetWeapon(2,16,5);
	DM_SetWeapon(2,4,1);

    DM_SetName(3,"BEACH");
    DM_SetSpawn(3,0,188.8920,-1820.3704,9.5812);
    DM_SetSpawn(3,1,206.8016,-1834.9736,23.8591);
    DM_SetInterior(3,0);
    DM_SetTime(3,1000*30);//1000*60
    DM_SetPlayer_Spawn_Times(3,0);// <=0 == 无限]
	DM_SetWeapon(3,26,300);
	DM_SetWeapon(3,32,3000);

    DM_SetName(4,"RING");
    DM_SetSpawn(4,0,-1417.0343,89.5161,1032.4113);
    DM_SetSpawn(4,1,-1391.8505,92.0921,1032.2576);
    DM_SetInterior(4,1);
    DM_SetTime(4,1000*30);//1000*60
    DM_SetPlayer_Spawn_Times(4,0);// <=0 == 无限]
	DM_SetWeapon(4,9,1);

    DM_SetName(5,"FARM");
    DM_SetSpawn(5,0,1069.8237,-345.1387,73.9922);
    DM_SetSpawn(5,1,1051.6864,-288.3278,73.9931);
    DM_SetInterior(5,0);
    DM_SetTime(5,1000*30);//1000*60
    DM_SetPlayer_Spawn_Times(5,0);// <=0 == 无限]
	DM_SetWeapon(5,33,50);
	DM_SetWeapon(5,22,300);
	DM_SetWeapon(5,16,2);
	DM_SetWeapon(5,4,1);

    DM_SetName(6,"SMG");
    DM_SetSpawn(6,0,404.4581,2462.7363,16.5000);
    DM_SetSpawn(6,1,397.5336,2456.8210,16.5000);
    DM_SetInterior(6,0);
    DM_SetTime(6,1000*30);//1000*60
    DM_SetPlayer_Spawn_Times(6,0);// <=0 == 无限]
	DM_SetWeapon(6,29,1000);
	DM_SetWeapon(6,16,2);
	
    DM_SetName(7,"KATANA");//8
    DM_SetSpawn(7,0,1586.3121,2397.0823,22.8204);
    DM_SetSpawn(7,1,1587.8431,2385.3740,22.8204);
    DM_SetInterior(7,0);
    DM_SetTime(7,1000*30);//1000*60
    DM_SetPlayer_Spawn_Times(7,0);// <=0 == 无限]
	DM_SetWeapon(7,8,1);

    DM_SetName(8,"RPG");//11
    DM_SetSpawn(8,0,2879.4031,1084.2681,10.8984);
    DM_SetSpawn(8,1,2807.6021,1057.3262,11.3822);
    DM_SetInterior(8,0);
    DM_SetTime(8,1000*30);//1000*60
    DM_SetPlayer_Spawn_Times(8,0);// <=0 == 无限]
	DM_SetWeapon(8,35,20);

    DM_SetName(9,"TENNIS");//unknown
    DM_SetSpawn(9,0,1128.2482,1238.5885,10.8203);
    DM_SetSpawn(9,1,1134.2065,1268.2513,10.8203);
    DM_SetInterior(9,0);
    DM_SetTime(9,1000*30);//1000*60
    DM_SetPlayer_Spawn_Times(9,0);// <=0 == 无限]
	DM_SetWeapon(9,16,100);

	Cur_DM = INVALID_DM_ID;
	
	SetTimer("DM_Next_Time",DM_Next_Time_,false);
	
	for(new i;i<MAX_PLAYERS;i++){
		DM_Player_Vote_For[i] = INVALID_DM_ID;
		DM_Player_In[i] = INVALID_DM_ID;
	}
	
	return true;
}
forward DM_SetPlayerToCurPos(playerid,dmid);
forward DM_SetPlayerToCurPos_End(playerid);
forward DM_SetPlayerToCurPos_Proc(playerid,dmid);
forward DM_SetPlayerWeaponToCur(playerid,dmid);
forward DM_SetPlayerToCurInterior(playerid,dmid);


public DM_SetPlayerToCurPos(playerid,dmid){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_SetPlayerToCurPos called");
	#endif
	if(DM_Player_Vote_For[playerid] != INVALID_DM_ID){
	    if(GetPlayerVehicleID(playerid))RemovePlayerFromVehicle(playerid);
	    SetPlayerVirtualWorld(playerid,WORLD_DM+1);
		new tmpval = random(MAX_DM_SPAWN_POS);
		SetPlayerPos(playerid,DMInfo[dmid][Spawn_Pos_x][tmpval],DMInfo[dmid][Spawn_Pos_y][tmpval],DMInfo[dmid][Spawn_Pos_z][tmpval]);
        SetTimerEx("DM_SetPlayerToCurPos_End",1000*8,false,"i",playerid);
		KillTimer(DM_Player_Pos_Timer[playerid]);
		DM_Player_Pos_Timer[playerid]=SetTimerEx("DM_SetPlayerToCurPos_Proc",1000*5,true,"ii",playerid,dmid);
	}

	return true;
}

public DM_SetPlayerToCurPos_End(playerid){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_SetPlayerToCurPos_End called");
	#endif
	SetPlayerVirtualWorld(playerid,WORLD_DM);
	return true;
}

public DM_SetPlayerToCurPos_Proc(playerid,dmid){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_SetPlayerToCurPos_Proc called");
	#endif
	if(DM_Player_Vote_For[playerid] != INVALID_DM_ID && !Player_InArea(playerid,DMInfo[dmid][Spawn_Area][0],DMInfo[dmid][Spawn_Area][1],DMInfo[dmid][Spawn_Area][2],DMInfo[dmid][Spawn_Area][3])){
        DM_SetPlayerToCurPos(playerid,dmid);
	}
 	return true;
}

public DM_SetPlayerToCurInterior(playerid,dmid){
    if(DM_Player_Vote_For[playerid] != INVALID_DM_ID){
        SetPlayerInterior(playerid,DMInfo[dmid][Spawn_Interior]);
	}
	return true;
}

public DM_SetPlayerWeaponToCur(playerid,dmid){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_SetPlayerWeaponToCur called");
	#endif
	ResetPlayerWeapons(playerid);
	for(new i;i<MAX_WEAPON_SLOT;i++){
		GivePlayerWeapon(playerid,DMInfo[dmid][Weapon][i],DMInfo[dmid][Weapon_Ammo][i]);
	}
	return true;
}

stock DM_Help(playerid){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_Help called");
	#endif
	DM_MsgSend(playerid,"[DM]===================帮助==================");
	DM_MsgSend(playerid,"[DM]/dm start 发起DM投票");
	DM_MsgSend(playerid,"[DM]/dm vote 为DM投票");
	DM_MsgSend(playerid,"[DM]=========================================");
	return true;
}

stock bool:DM_IsStart(){
#if DM_DEBUG
	print("[DM_DEBUG]DM_IsStart called");
#endif
	for(new i;i<MAX_DM;i++){
		if(DMInfo[i][Start])
			return true;
	}
	return false;
}	
stock bool:DM_IsActive(){
#if DM_DEBUG
	print("[DM_DEBUG]DM_IsActive called");
#endif
	for(new i;i<MAX_DM;i++){
		if(DMInfo[i][Active])
			return true;
	}
	return false;
}
/*stock DM_PlayerJoined(playerid){
	for(new i;i<MAX_DM;i++){
		if(DMInfo[i][Join_Player][playerid]){
			return i;
		}
	}
	return INVALID_DM_ID;
}*/

stock bool:DM_IsVoteStart(){
#if DM_DEBUG
	print("[DM_DEBUG]DM_IsVoteStart called");
#endif
	for(new i;i<MAX_DM;i++){
		if(DMInfo[i][Vote_Times])
			return true;
	}
	return false;
}
stock bool:IsValidDM(dmid){
#if DM_DEBUG
	print("[DM_DEBUG]IsValidDM called");
#endif
	return (dmid >= 0 && dmid < MAX_DM)?true:false;
}

stock DM_SetName(dmid,const dm_name[]){//zhu:设置DM名称
	#if DM_DEBUG
		print("[DM_DEBUG]DM_SetName called");
	#endif
	if(IsValidDM(dmid)){
		strmid(DMInfo[dmid][Name],dm_name,0,strlen(dm_name),MAX_STRING);
		return true;
	}
	return false;
}

stock DM_SetArea(dmid,Float:minx,Float:miny,Float:maxx,Float:maxy){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_SetArea called");
	#endif
    if(IsValidDM(dmid)){
        DMInfo[dmid][Spawn_Area][0] = minx;
        DMInfo[dmid][Spawn_Area][1] = miny;
        DMInfo[dmid][Spawn_Area][2] = maxx;
        DMInfo[dmid][Spawn_Area][3] = maxy;
        return true;
	}
	return false;
}

stock DM_SetSpawn(dmid,Spawn_id,Float:spawn_x,Float:spawn_y,Float:spawn_z){//zhu:设置出身点,限制量为MAX_DM_SPAWN_POS
#if DM_DEBUG
	print("[DM_DEBUG]DM_SetSpawn called");
#endif
	if(IsValidDM(dmid) && (Spawn_id >= 0 && Spawn_id < MAX_DM_SPAWN_POS)){
		DMInfo[dmid][Spawn_Pos_x][Spawn_id] = spawn_x;
		DMInfo[dmid][Spawn_Pos_y][Spawn_id] = spawn_y;
		DMInfo[dmid][Spawn_Pos_z][Spawn_id] = spawn_z;
		return true;
	}
	return false;
}

stock DM_SetInterior(dmid,interiorid){
	#if DM_DEBUG
	    print("[DM_DEBUG]DM_SetInterior called");
	#endif
	if(IsValidDM(dmid) && (interiorid >= 0)){
	    DMInfo[dmid][Spawn_Interior] = interiorid;
	    return true;
	}
	return false;
}

stock DM_GetWeaponSlotFromID(weaponid){
#if DM_DEBUG
	print("[DM_DEBUG]DM_GetWeaponSlotFromID called");
#endif
	switch(weaponid){
		case WEAPON_COLT45,WEAPON_SILENCED,WEAPON_DEAGLE:{
			return 2;
		}
		case WEAPON_SHOTGUN,WEAPON_SAWEDOFF,WEAPON_SHOTGSPA:{
			return 3;
		}
		case WEAPON_UZI,WEAPON_MP5,WEAPON_TEC9:{
			return 4;
		}
		case WEAPON_AK47,WEAPON_M4:{
			return 5;
		}
		case WEAPON_RIFLE,WEAPON_SNIPER:{
			return 6;
		}
		case WEAPON_ROCKETLAUNCHER,WEAPON_HEATSEEKER,WEAPON_FLAMETHROWER,WEAPON_MINIGUN:{
			return 7;
		}
		case WEAPON_GRENADE,WEAPON_TEARGAS,WEAPON_MOLTOV,WEAPON_SATCHEL:{
			return 8;
		}
		case WEAPON_SPRAYCAN,WEAPON_FIREEXTINGUISHER,WEAPON_CAMERA:{
			return 9;
		}
		case WEAPON_DILDO,WEAPON_DILDO2,WEAPON_VIBRATOR,WEAPON_VIBRATOR2,WEAPON_FLOWER,WEAPON_CANE:{
			return 10;
		}
		case WEAPON_GOLFCLUB,WEAPON_NITESTICK,WEAPON_KNIFE,WEAPON_BAT,WEAPON_SHOVEL,WEAPON_POOLSTICK,WEAPON_KATANA,WEAPON_CHAINSAW:{
			return 1;
		}
		case 44,45/*WEAPON_NIGHTVISION,WEAPON_INFRARED*/:{
			return 11;
		}
		case WEAPON_BOMB:{
			return 12;
		}
	}
	return false;
}



stock DM_SetWeapon(dmid,weaponid,ammo){//zhu:设置武器
#if DM_DEBUG
	print("[DM_DEBUG]DM_SetWeapon called");
#endif
	if(IsValidDM(dmid) && DM_GetWeaponSlotFromID(weaponid)){
		DMInfo[dmid][Weapon][DM_GetWeaponSlotFromID(weaponid)] = weaponid;
		DMInfo[dmid][Weapon_Ammo][DM_GetWeaponSlotFromID(weaponid)] = ammo;
		return true;
	}
	return false;
}
stock DM_SetTime(dmid,time){//zhu:设置时间
#if DM_DEBUG
	print("[DM_DEBUG]DM_SetTime called");
#endif
	if(IsValidDM(dmid)){
		DMInfo[dmid][End_Time] = time;
		return true;
	}
	return false;
}
stock DM_SetPlayer_Spawn_Times(dmid,spawn_times){//zhu:设置出生次数..暂时没用
#if DM_DEBUG
	print("[DM_DEBUG]DM_SetPlayer_Spawn_Times called");
#endif
	if(IsValidDM(dmid)){
		if(spawn_times > 0){
			DMInfo[dmid][Player_Spawn_Times] = spawn_times;
		}else{
			DMInfo[dmid][Player_Spawn_Times] = 0;
		}
		return true;
	}
	return false;
}


stock bool:DM_pAbleJoin(playerid){
#if DM_DEBUG
	print("[DM_DEBUG]DM_pAbleJoin called");
#endif
	return (Gang_GetPlayer(playerid) != INVALID_GANG_ID)?true:false;
}
stock bool:DM_pVoted(playerid){
#if DM_DEBUG
	print("[DM_DEBUG]DM_pVoted called");
#endif
	/*if(DM_Player_Vote_For[playerid] == INVALID_DM_ID)
		return false;
	return true;*/
	return (DM_Player_Vote_For[playerid] == INVALID_DM_ID)?false:true;
}
stock DM_pVoteFor(playerid,dmid){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_pVoteFor called");
	#endif
	if(DM_IsVoteStart()){
		if(!DM_pVoted(playerid)){
			DMInfo[dmid][Vote_Times]++;
			DMInfo[dmid][Join_Player][playerid]=true;
			DM_Player_Vote_For[playerid] = dmid;
			DM_MsgSendToAll("[DM]%s把神圣的DM一票投給了%sDM,现在该DM票数%d!",RetpName(playerid),DMInfo[dmid][Name],DMInfo[dmid][Vote_Times]);
			return true;
		}else{
			DM_MsgSend(playerid,"[DN]你已经投过票了");
		}
	}else{
		DM_MsgSend(playerid,"[DM]现在不能投票");
	}
	return false;
}


public DM_Vote_Time(){
	new tmpVote;
	for(new i;i<MAX_DM;i++){
		if(DMInfo[i][Vote_Times] > DMInfo[tmpVote][Vote_Times]){
			tmpVote = i;
		}
	}
	Cur_DM = tmpVote;
	KillTimer(DM_Start_Timer);
	DM_Start_Timer = SetTimer("DM_Start_Time",DM_Start_Time_,false);
	DM_MsgSendToAll("[DM]投票结束!%sDM获得票数最多(%d票),%d秒后举行!",DMInfo[tmpVote][Name],DMInfo[tmpVote][Vote_Times],DM_Start_Time_/1000);
	for(new i;i<MAX_DM;i++){
		DMInfo[i][Vote_Times]=0;
	}
	for(new i;i<MAX_PLAYERS;i++){
		if(IsPlayerConnected(i) && DM_Player_Vote_For[i] != INVALID_DM_ID){
			DM_Player_Vote_For[i] = Cur_DM;
		}
	}
	/*
	for(new i;i<MAX_PLAYERS;i++){
		if(DM_PlayerJoined(i) != INVALID_DM_ID){
			DM_Player_Vote_For[i] == Cur_DM;
			DMInfo[DM_PlayerJoined(i)][Join_Player][i] = false;
			DMInfo[Cur_DM][Join_Player][i] = true;
		}
	}*/
	#if DM_DEBUG
		printf("[DM_Debug]DM_Vote_Time called,most vote %d,Times:%d",tmpVote,DMInfo[tmpVote][Vote_Times]);
	#endif
	return true;
}

public DM_Start_Time(){
#if DM_DEBUG
	print("[DM_DEBUG]DM_Start_Time called");
#endif
	for(new i;i<MAX_PLAYERS;i++){
		if(DMInfo[Cur_DM][Join_Player][i]){
			DM_SetPlayerToCurPos(i,Cur_DM);
			DM_SetPlayerWeaponToCur(i,Cur_DM);
			DM_SetPlayerToCurInterior(i,Cur_DM);
			DM_Player_In[i]=Cur_DM;
			DM_MsgSend(i,"[DM]死亡竞技开始,请和你的队友配合好!!!!!");
		}
	}
	DMInfo[Cur_DM][Start] = true;
	KillTimer(DMInfo[Cur_DM][End_Timer]);
	SetTimer("DM_End_Time",DMInfo[Cur_DM][End_Time],false);
	return true;
}
	
public DM_End_Time(){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_End_Time called");
	#endif
	new
		DM_Score_Pos[MAX_GANGS];
	DM_Count_GangScore(DM_Score_Pos);
	
	for(new i;i<MAX_GANGS;i++){
		if(GangInfo[i][Created]){
			SendGangMessage(i,"[帮频]================================================================");
			SendGangMessage(i,"[帮频]帮派分数前三:");
			SendGangMessage(i,"[帮频]第一名'%s'(id:%d),分数:%d",GangInfo[DM_Score_Pos[0]][Name],DM_Score_Pos[0],DM_Gang_Score[0]);
			SendGangMessage(i,"[帮频]第二名'%s'(id:%d),分数:%d",GangInfo[DM_Score_Pos[1]][Name],DM_Score_Pos[1],DM_Gang_Score[1]);
			SendGangMessage(i,"[帮频]第三名'%s'(id:%d),分数:%d",GangInfo[DM_Score_Pos[2]][Name],DM_Score_Pos[2],DM_Gang_Score[2]);
			SendGangMessage(i,"[帮频]我帮分数%d,位于第%d名!",DM_Gang_Score[DM_Score_Pos[i]],DM_Score_Pos[i]+1);
			SendGangMessage(i,"[帮频]================================================================");
		}
	}
	DM_MsgSendToAll("[DM]DM结束,优胜的帮派是'%s'(id:%d)!!",GangInfo[DM_Score_Pos[0]][Name],DM_Score_Pos[0]);
	DM_MsgSendToAll("[DM]玩家可在%d秒后发起投票,请玩家等待下一场",DM_Next_Time_/1000);
	
	//===================clear=======================
	for(new i;i<MAX_DM;i++){
		DMInfo[i][Vote_Times]=0;
		for(new j;j<MAX_PLAYERS;j++){
			DMInfo[i][Player_Score][j]=0;
			DMInfo[i][Join_Player][j]=false;
		}
		DMInfo[i][Active]=false;
		DMInfo[i][Start]=false;
		KillTimer(DMInfo[i][End_Timer]);
	}
	KillTimer(DM_Vote_Timer);
	KillTimer(DM_Start_Timer);
	Cur_DM = INVALID_DM_ID;
	for(new i;i<MAX_PLAYERS;i++){
	    KillTimer(DM_Player_Pos_Timer[i]);
		DM_Player_Vote_For[i] = INVALID_DM_ID;
		DM_Player_In[i] = INVALID_DM_ID;
		if(IsPlayerConnected(i))SetPlayerVirtualWorld(i,0);
	}
	
	//================next dm vote================
	
	KillTimer(DM_Next_Timer);
	SetTimer("DM_Next_Time",DM_Next_Time_,false);
	return true;
}

public DM_Next_Time(){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_Next_Time called");
	#endif
	for(new i;i<MAX_DM;i++){
		DMInfo[i][Active] = true;
	}
	DM_MsgSendToAll("[DM]下一场DM开始发起投票!请玩家输入/dm start 发动投票!");
	return true;
}

	

stock DM_Menu_Create(){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_Menu_Create called");
	#endif
	
	DM_Item_I = CreateMenu("DM_I",1,25,170,220,25);
	AddMenuItem(DM_Item_I,0,DMInfo[0][Name]);//0
	AddMenuItem(DM_Item_I,0,DMInfo[1][Name]);//1
	AddMenuItem(DM_Item_I,0,DMInfo[2][Name]);//2
	AddMenuItem(DM_Item_I,0,DMInfo[3][Name]);//3
	AddMenuItem(DM_Item_I,0,DMInfo[4][Name]);//4
	AddMenuItem(DM_Item_I,0,DMInfo[5][Name]);//5
	AddMenuItem(DM_Item_I,0,DMInfo[6][Name]);//6
	AddMenuItem(DM_Item_I,0,DMInfo[7][Name]);//7
	AddMenuItem(DM_Item_I,0,DMInfo[8][Name]);//8
	AddMenuItem(DM_Item_I,0,DMInfo[9][Name]);//9
//	AddMenuItem(DM_Item_I,0,"Next page");
//	DM_Item_II = CreateMenu("DM_II",1,25,170,220,25);
//	AddMenuItem(DM_Item_II,0,DMInfo[10][Name]);
//	AddMenuItem(DM_Item_II,0,DMInfo[11][Name]);
//	AddMenuItem(DM_Item_II,0,DMInfo[12][Name]);
//	AddMenuItem(DM_Item_II,0,"Previous page");
	/*
	*zhu:need to develop
	DM_Weapon_I = CreateMenu("DM_WEAPON_I",1,25,170,220,25);
	AddMenuItem(DM_Weapon_I,0,"Ak47");
	*/
	/*
	new tmpstr[MAX_STRING];	
	for(new i;i<11;i++){
		if(i>MAX_DM){
			break;
		}else if(i == 11){
			AddMenuItem(DM_Item_I,0,"Next page");
			break;
		}
		format(tmpstr,sizeof(tmpstr),"[DM] %s",DMInfo[i][Name]);
		AddMenuItem(DM_Item_I,0,tmpstr);
	}
	DM_Item_II = CreateMenu("DM",1,25,170,220,25);
	for(new i;i<21;i++)
		if(i>MAX_DM-10){
			AddMenuItem(DM_Item_II,0,"Previous page");
			break;
		}
		format(tmpstr,siezoe(tmpstr),"[DM] %s",DMInfo[i][Name]);
		AddMenuItem(DM_Item_II,0,tmpstr);
	}
	*/
	return true;
	
}

stock DM_Menu_Destroy(){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_Menu_Create called");
	#endif
	
	DestroyMenu(DM_Item_I);
	DestroyMenu(DM_Item_II);
	DestroyMenu(DM_Weapon_I);
	DestroyMenu(DM_Weapon_II);
	DestroyMenu(DM_Weapon_III);
	DestroyMenu(DM_Weapon_IV);
	
	return true;
}


stock DM_ShowScore(playerid){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_ShowScore called");
	#endif
	if(DM_IsStart()){
		if(Gang_GetPlayer(playerid) != INVALID_PLAYER_ID){
			DM_MsgSend(playerid,"[DM]我帮分数:%d,你的个人分数:%d",DM_Gang_Score[Gang_GetPlayer(playerid)],DMInfo[Cur_DM][Player_Score][playerid]);
		}else{
			DM_MsgSend(playerid,"[DM]你不是帮派成员,无法查看分数");
		}
	}else{
		DM_MsgSend(playerid,"[DM]现在无法查看分数");
	}
	return true;
}

stock DM_Count_GangScore(ScoreSort[MAX_GANGS]){
	#if DM_DEBUG
		print("[DM_DEBUG]DM_Count_GangScore called");
	#endif
	for(new i;i<MAX_GANGS;i++){
		ScoreSort[i] = i;
	}
	for(new j;j<MAX_GANGS;j++){
		for(new i;i<MAX_GANGS-1;i++){
			if(DM_Gang_Score[i] < DM_Gang_Score[i+1]){
			//==================交换记录====================//
				new tmpval = DM_Gang_Score[i+1];
				DM_Gang_Score[i+1] = DM_Gang_Score[i];
				DM_Gang_Score[i] = tmpval;
			//==================交换记录的位置==============//
				tmpval = ScoreSort[i+1];
				ScoreSort[i+1] = ScoreSort[i];
				ScoreSort[i] = tmpval;
			}
		}
	}
	return true;
}



/*
*创建DM投票(玩家叫)玩家不叫自动创建
*计算票数,玩家不投自动启动
*

*/
//used for dm,dont remove
/*


forward GetPlayerOrginalColor(playerid);
public GetPlayerOrginalColor(playerid){
	new
		tmpval = playerColors[playerid];
	return tmpval;
}*/










stock Gang_PlayerOrignalColor(playerid){
	#if GANG_DEBUG
		print("[GANG_DEBUG]Gang_PlayerOrignalColor called");
	#endif
	return CallRemoteFunction("GetPlayerOrginalColor","i",playerid);
}



stock Gang_Help(playerid){
	#if GANG_DEBUG
		print("[GANG_DEBUG]Gang_Help called");
	#endif
	
    Gang_MsgSend(playerid, "帮派帮助:");
	Gang_MsgSend(playerid, "/gang create [名称]---创建帮派名称");
	Gang_MsgSend(playerid, "/gang join ---加入帮派");
	Gang_MsgSend(playerid, "/gang invite [玩家ID] ---邀请玩家加入帮派");
	Gang_MsgSend(playerid, "/gang refuse  ---拒绝当前帮派的邀请");
	Gang_MsgSend(playerid, "/gang leave ---退出当前帮派");
	Gang_MsgSend(playerid, "/gang info [号码] (没有号码显示您的帮派的信息)");
	Gang_MsgSend(playerid, "! (输入内容可以帮派聊天)");	
	
	return true;
}



stock Gang_GetPlayer(playerid){
	#if GANG_DEBUG
		print("[GANG_DEBUG]Gang_GetPlayer called");
	#endif
	
	for(new i;i<MAX_GANGS;i++){
		if(GangInfo[i][Created]){
			for(new j;j<GangInfo[i][Members];j++){
				if(GangInfo[i][Member][j] == playerid)
					return i;
			}
		}
	}
	return INVALID_GANG_ID;
}



stock Gang_PlayerInvitePlayer(playerid,inviteid){
	#if GANG_DEBUG
		print("[GANG_DEBUG]Gang_PlayerInvitePlayer called");
	#endif
	if(IsPlayerConnected(inviteid)){
		if(GangInvite[inviteid] == INVALID_GANG_ID){
			if(Gang_GetPlayer(inviteid) == INVALID_GANG_ID){
				GangInvite[inviteid] = Gang_GetPlayer(playerid);
				Gang_MsgSend(inviteid,"[帮派]您被邀请加入帮派'%s'(id:%d),邀请者 %s(%d)",GangInfo[Gang_GetPlayer(playerid)][Name],Gang_GetPlayer(playerid),RetpName(playerid),playerid);
				SendGangMessage(Gang_GetPlayer(playerid),"[帮频]%s(%d)邀请 %s(%d)加入我帮",RetpName(playerid),playerid,RetpName(inviteid),inviteid);
			}else{
				Gang_MsgSend(playerid,"[帮派]%s(%d)已经有帮派了,不能邀请",RetpName(inviteid),inviteid);
			}
		}else{
			Gang_MsgSend(playerid,"[帮派]%s(%d)已经被邀请了,不能邀请",RetpName(inviteid),inviteid);
		}
	}else{
		Gang_MsgSend(playerid,"[帮派]对方不在线");
	}
	return true;
}



stock Gang_PlayerCreate(playerid,gang_name[]){
	#if GANG_DEBUG
		print("[GANG_DEBUG]Gang_PlayerCreate called");
	#endif
	if(Gang_GetPlayer(playerid) == INVALID_GANG_ID){
		new create_gangid;
		for(new i;i<MAX_GANGS;i++){
			if(!GangInfo[i][Created]){
				create_gangid = i;
				break;
			}
		}
		format(GangInfo[create_gangid][Name],MAX_GANG_NAME,"%s",gang_name);
		GangInfo[create_gangid][Member][0] = playerid;
		GangInfo[create_gangid][Created] = true;
		GangInfo[create_gangid][Members]++;
		GangInfo[create_gangid][Color] = GetPlayerColor(playerid);
		Gang_MsgSend(create_gangid,"[帮派]你创建了帮派'%s'(id:%d)",GangInfo[create_gangid][Name],create_gangid);
	}else{
		Gang_MsgSend(playerid,"[帮派]你已经在帮派了,不能创建");
	}
	return true;
}



stock Gang_PlayerCheckInfo(playerid,gangid){
	#if GANG_DEBUG
		print("[GANG_DEBUG]Gang_PlayerCheckInfo called");
	#endif
	Gang_MsgSend(playerid,"[帮派]=============================================================");
	if(gangid != INVALID_GANG_ID && GangInfo[gangid][Created]){
		Gang_MsgSend(playerid,"[帮派]帮派'%s'(id:%d) 帮派成员",GangInfo[gangid][Name],gangid);
		for(new i;i<GangInfo[gangid][Members];i++){
			Gang_MsgSend(playerid,"[帮派]成员 %s(%d)",RetpName(GangInfo[gangid][Member][i]),GangInfo[gangid][Member]);
		}
		Gang_MsgSend(playerid,"[帮派]=============================================================");
	}else{
		Gang_MsgSend(playerid,"[帮派]你没有加入帮派.");
	}
	return true;
}



stock Gang_PlayerJoin(playerid){
	#if GANG_DEBUG
		print("[GANG_DEBUG]Gang_PlayerJoin called");
	#endif
	if(GangInfo[GangInvite[playerid]][Created]){
		if(GangInvite[playerid] != INVALID_GANG_ID){
			if(Gang_GetPlayer(playerid) == INVALID_GANG_ID){
				new
					invite_gangid = GangInvite[playerid];
				GangInvite[playerid] = INVALID_GANG_ID;
				GangInfo[invite_gangid][Member][GangInfo[invite_gangid][Members]++] = playerid;
				SetPlayerColor(playerid,GangInfo[invite_gangid][Color]);
				SendGangMessage(invite_gangid,"[帮频]欢迎 %s(%d)加入我帮'%s'(id:%d)^^",RetpName(playerid),playerid,GangInfo[invite_gangid][Name],invite_gangid);
			}else{
				Gang_MsgSend(playerid,"[帮派]你已经有帮派了,先退出帮派(/gang leave)再去其它帮派吧");
			}
		}else{
			Gang_MsgSend(playerid,"[帮派]你没被邀请,怎么去别的帮派?");
		}
	}else{
		Gang_MsgSend(playerid,"[帮派]邀请你的帮派不存在了");
	}
	return true;
}


stock Gang_PlayerRefuse(playerid){
	#if GANG_DEBUG
		print("[GANG_DEBUG]Gang_PlayerRefuse called");
	#endif
	if(Gang_GetPlayer(playerid) != INVALID_GANG_ID){
		if(GangInvite[playerid] == INVALID_GANG_ID){
			if(GangInfo[GangInvite[playerid]][Created]){
				SendGangMessage(GangInvite[playerid],"[帮频]%s拒绝加入我帮",RetpName(playerid));
				Gang_MsgSend(playerid,"[帮派]你拒绝加入帮派%s(id:%d)",GangInfo[GangInvite[playerid]][Name],GangInvite[playerid]);
				GangInvite[playerid] = INVALID_GANG_ID;
			}
		}else{
			Gang_MsgSend(playerid,"[帮派]都没帮派邀请你,怎么拒绝?");
		}
	}else{
		Gang_MsgSend(playerid,"[帮派]你已经有帮派了");
	}
	return true;
}

stock Gang_PlayerLeave(playerid){
	#if GANG_DEBUG
		print("[GANG_DEBUG]Gang_PlayerLeave called");
	#endif
	new
		gangid = Gang_GetPlayer(playerid);
	if(gangid != INVALID_GANG_ID){
		new
			Gang_PlayerPos;
		for(new i;i<GangInfo[gangid][Members];i++){
			if(GangInfo[gangid][Member][i] == playerid){
				Gang_PlayerPos = i;
				break;
			}
		}
		for(new i = Gang_PlayerPos;i < GangInfo[gangid][Members];i++){
			GangInfo[gangid][Member][i] = GangInfo[gangid][Member][i+1];
		}
		GangInfo[gangid][Member][GangInfo[gangid][Members]] = INVALID_PLAYER_ID;
		GangInfo[gangid][Members]--;
		if(GangInfo[gangid][Members] <= 0){
			GangInfo[gangid][Created] = false;
			GangInfo[gangid][Color] = false;
		}else{
			if(!IsPlayerConnected(playerid)){
				SendGangMessage(gangid,"[帮频]id为%d的玩家离开了帮派(原因:下线或掉线)",playerid);
			}else{
				SendGangMessage(gangid,"[帮频]%s(%d)离开了帮派(原因:问本人吧)",RetpName(playerid),playerid);
				SetPlayerColor(playerid,Gang_PlayerOrignalColor(playerid));
			}
		}
	}
	if(IsPlayerConnected(playerid)){
		Gang_MsgSend(playerid,"[帮派]你离开了帮派");
	}
	return true;
}











//===============================dcmd================================//
dcmd_dm(playerid,params[]){
#if DM_DEBUG
	printf("[DM_DEBUG]/dm %s",params);
#endif
	if(!DM_pAbleJoin(playerid)){
		DM_MsgSend(playerid,"[DM]你无权使用DM命令,请先加入任何一个帮派(查看/gang)");
	}else if(!strlen(params)){
		DM_MsgSend(playerid,"[DM]你输入的命令无效");
		DM_Help(playerid);
	}else if(!strcmp(params,"start",false,5)){
		if(DM_IsActive()){
			if(!DM_IsVoteStart()){
				if(!DM_pVoted(playerid)){
					for(new i;i<MAX_DM;i++){
						DMInfo[i][Vote_Times]++;
					}
					ShowMenuForPlayer(DM_Item_I,playerid);
					KillTimer(DM_Vote_Timer);
					DM_Vote_Timer = SetTimer("DM_Vote_Time",DM_Vote_Time_,false);
					DM_MsgSend(playerid,"[DM]你发动了DM投票!");
					DM_MsgSendToAll("[DM]%s发动了DM投票,大家输入/dm vote",RetpName(playerid));
					GameTextForAll("~n~~n~~n~~n~~n~~n~~n~~n~~w~[DM]Death match is allowed.Type ~r~/dm vote~w~ for your lovest dm",3000,3);
				}else{
					DM_MsgSend(playerid,"[DM]你已经投票了");
				}
			}else{
				DM_MsgSend(playerid,"[DM]已经发动投票了,输入/dm vote选择DM");
			}
		}else{
			DM_MsgSend(playerid,"[DM]系统还没有激活DM");
		}
	}else if(!strcmp(params,"vote",false,4)){
		if(DM_IsVoteStart()){
			if(!DM_pVoted(playerid)){	
				ShowMenuForPlayer(DM_Item_I,playerid);
				DM_MsgSend(playerid,"[DM]请投票");
			}else{
				DM_MsgSend(playerid,"[DM]你已经投过票了");
			}
		}else{
			DM_MsgSend(playerid,"[DM]没有投票进行中");
		}
	}else if(!strcmp(params,"score",false,5)){
		DM_ShowScore(playerid);
	}else{
		DM_MsgSend(playerid,"[DM]你输入的命令/dm %s 无效",params);
		DM_Help(playerid);
		return true;
	}
	return true;
}


dcmd_gang(playerid,params[]){
	#if GANG_DEBUG
		printf("[GANG_DEBUG]/gang %s",params);
	#endif
	new 
		main_cmd[MAX_STRING],
		sub_cmd[MAX_STRING];
	sscanf(params,"ss",main_cmd,sub_cmd);
	if(!main_cmd[0]){
		Gang_Help(playerid);
	}else if(!strcmp(main_cmd,"info",false,4)){
		if(!sub_cmd[0]){
			Gang_PlayerCheckInfo(playerid,Gang_GetPlayer(playerid));
		}else{
			if(IsNumeric(sub_cmd)){
				Gang_PlayerCheckInfo(playerid,strval(sub_cmd));
			}else{
				Gang_MsgSend(playerid,"[帮派]帮派ID输入错误");
			}
		}
	}else if(!strcmp(main_cmd,"create",false,6)){
		if(!sub_cmd[0]){
			Gang_MsgSend(playerid,"[帮派]请输入你要创建的帮派名称");
		}else{
			Gang_PlayerCreate(playerid,sub_cmd);
		}
	}else if(!strcmp(main_cmd,"invite",false,6)){
		if(Gang_GetPlayer(playerid) != INVALID_GANG_ID){
			if(sub_cmd[0]){
				if(IsNumeric(sub_cmd)){
					Gang_PlayerInvitePlayer(playerid,strval(sub_cmd));
				}else{
					Gang_MsgSend(playerid,"[帮派]玩家ID输入错误");
				}
			}else{
				Gang_MsgSend(playerid,"[帮派]请输入要邀请的玩家ID");
			}
		}else{
			Gang_MsgSend(playerid,"[帮派]你没有帮派,怎么邀请别人?");
		}
	}else if(!strcmp(main_cmd,"join",false,4)){
		Gang_PlayerJoin(playerid);
	}else if(!strcmp(main_cmd,"refuse",false,6)){
		Gang_PlayerRefuse(playerid);
	}else if(!strcmp(main_cmd,"leave",false,4)){
		if(Gang_GetPlayer(playerid) != INVALID_GANG_ID){
			Gang_PlayerLeave(playerid);
		}else{
			Gang_MsgSend(playerid,"[帮派]你没有帮派,怎么离开?");
		}
	}else{
		Gang_MsgSend(playerid,"[帮派]你输入的命令/gang %s 无效,输入/gang help查看帮助",params);
	}
	printf("%s ,%s",main_cmd,sub_cmd);
	return true;
}

//=========================samp callback================================//
public OnFilterScriptInit(){
	print("//---------------------------------------//");
	print("//----------->DM&&Gang System<-----------//");
	print("//----------->GCS Script Team<-----------//");
	print("//---------------------------------------//");
	DM_Struction();
	DM_Menu_Create();
	for(new i;i<MAX_PLAYERS;i++){
		GangInvite[i] = INVALID_GANG_ID;
	}
	for(new i;i < MAX_GANGS;i++){
		for(new j;j < MAX_GANG_MEMBERS;j++){
			GangInfo[i][Member][j] = INVALID_PLAYER_ID;
		}
	}
	return true;
}


public OnFilterScriptExit(){
	DM_Menu_Destroy();
	return true;
}

public OnPlayerSpawn(playerid){
	if(DM_IsStart()){
		SetTimerEx("DM_SetPlayerToCurPos",1000*3,false,"ii",playerid,Cur_DM);
		SetTimerEx("DM_SetPlayerWeaponToCur",1000*3,false,"ii",playerid,Cur_DM);
		SetTimerEx("DM_SetPlayerToCurInterior",1000*3,false,"ii",playerid,Cur_DM);
	}
	return true;
}

public OnPlayerDeath(playerid,killerid,reason){
	if(DM_IsStart() && Gang_GetPlayer(playerid) != INVALID_GANG_ID){
		DMInfo[Cur_DM][Player_Score][playerid]--;
		DM_Gang_Score[Gang_GetPlayer(playerid)]--;
		if(killerid != INVALID_PLAYER_ID && Gang_GetPlayer(playerid) != INVALID_GANG_ID){
			DMInfo[Cur_DM][Player_Score][killerid]++;
			DM_Gang_Score[Gang_GetPlayer(killerid)]++;
		}
	}
	if(killerid != INVALID_PLAYER_ID){
		if(Gang_GetPlayer(playerid) == Gang_GetPlayer(killerid) && Gang_GetPlayer(playerid) != INVALID_GANG_ID){
			SendGangMessage(Gang_GetPlayer(playerid),"[帮频]我帮成员%s杀死我帮成员%s!",RetpName(killerid),RetpName(playerid));
		}
		if(Gang_GetPlayer(playerid) != INVALID_GANG_ID && Gang_GetPlayer(killerid) != INVALID_GANG_ID){
			SendGangMessage(Gang_GetPlayer(playerid),"[帮频]%s被'%s'帮派成员%s杀死!",RetpName(playerid),GangInfo[Gang_GetPlayer(killerid)][Name],RetpName(killerid));
			SendGangMessage(Gang_GetPlayer(killerid),"[帮频]我帮成员%s杀死'%s'帮派成员%s",RetpName(killerid),GangInfo[Gang_GetPlayer(playerid)][Name],RetpName(playerid));
		}
	}
	return true;
}

public OnPlayerText(playerid,text[]){
	if(text[0] == '!'&& text[1]){
		if(Gang_GetPlayer(playerid) != INVALID_GANG_ID){
			new
				tmpstr[MAX_STRING],
				tmpval = Gang_GetPlayer(playerid);
			format(tmpstr,sizeof(tmpstr)," [帮频]%s(%d):%s",RetpName(playerid),playerid,text[1]);
			for(new i;i < MAX_PLAYERS;i++){
				if(IsPlayerConnected(i) && Gang_GetPlayer(i) == tmpval){
					SendClientMessage(i,GangInfo[tmpval][Color],tmpstr);
				}
			}
		}else{
			Gang_MsgSend(playerid,"[帮派]你没有帮派,怎么用帮派聊天频道?");
		}
		return false;
	}
	return true;
}


public _DM_pPlaying(playerid){
	if(DM_Player_In[playerid] == INVALID_DM_ID)return false;
	return true;
}

public OnPlayerCommandText(playerid,cmdtext[]){
	dcmd(dm,2,cmdtext);
	dcmd(gang,4,cmdtext);
	return true;
}

public OnPlayerDisconnect(playerid,reason){
	Gang_PlayerLeave(playerid);
	for(new i;i<MAX_DM;i++){
		DMInfo[i][Join_Player][playerid] = false;
		DMInfo[i][Player_Score][playerid] = 0;
	}
	DM_Player_Vote_For[playerid] = INVALID_DM_ID;
	DM_Player_In[playerid] = INVALID_DM_ID;
	KillTimer(DM_Player_Pos_Timer[playerid]);
	return true;
}


public OnPlayerSelectedMenuRow(playerid,row){
	printf("shit");
	new
		Menu:CurMenu = GetPlayerMenu(playerid);
	if(!IsValidMenu(CurMenu)){
		return true;
	}else if(CurMenu == DM_Item_I){
		switch(row){
			case 0,1,2,3,4,5,6,7,8,9:{
				DM_pVoteFor(playerid,row);
			}
			case 10:{
				HideMenuForPlayer(CurMenu,playerid);
			//	ShowMenuForPlayer(DM_Item_II,playerid);
			}
		}
	}else if(CurMenu == DM_Item_II){
		switch(row){
			case 0,1,2:{
				DM_pVoteFor(playerid,row+10);
			}
			case 4:{
				HideMenuForPlayer(CurMenu,playerid);
				ShowMenuForPlayer(DM_Item_I,playerid);
			}
		}
	}
	printf("bh");
	return true;
}
//=========================================================================//




/*----------------------------------------------------------------------------*-
written by y_less^^
Function:
sscanf
Params:
string[] - String to extract parameters from.
format[] - Parameter types to get.
{Float,_}:... - Data return variables.
Return:
0 - Successful, not 0 - fail.
Notes:
A fail is either insufficient variables to store the data or insufficient
data for the format string - excess data is disgarded.
 
A string in the middle of the input data is extracted as a single word, a
string at the end of the data collects all remaining text.
 
The format codes are:
 
c - A character.
d, i - An integer.
h, x - A hex number (e.g. a colour).
f - A float.
s - A string.
z - An optional string.
pX - An additional delimiter where X is another character.
'' - Encloses a litteral string to locate.
u - User, takes a name, part of a name or an id and returns the id if they're connected.
 
Now has IsNumeric integrated into the code.
 
Added additional delimiters in the form of all whitespace and an
optioanlly specified one in the format string.
-*----------------------------------------------------------------------------*/
stock sscanf(string[], format[], {Float,_}:...){
#if defined isnull
	if (isnull(string))
#else
	if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
#endif
	{
		return format[0];
	}
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' '){
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos]){
		switch (format[formatPos++]){
			case '\0':{
				return 0;
			}
			case 'i', 'd':{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-'){
					neg = -1;
					ch = string[++stringPos];
				}
				do{
					stringPos++;
					if ('0' <= ch <= '9'){
						num = (num * 10) + (ch - '0');
					}else{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':{
				setarg(paramPos, 0, _:floatstr(string[stringPos]));
			}
			case 'p':{
				delim = format[formatPos++];
				continue;
			}
			case '\'':{
			new
				end = formatPos - 1,
				ch;
			while ((ch = format[++end]) && ch != '\''){}
			if (!ch){
				return -1;
			}
			format[end] = '\0';
			if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1){
				if (format[end + 1]){
					return -1;
				}
				return 0;
			}
			format[end] = '\'';
			stringPos = ch + (end - formatPos);
			formatPos = end + 1;
			}
			case 'u':{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim){
					if (num){
						if ('0' <= ch <= '9'){
							id = (id * 10) + (ch - '0');
						}else{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id)){
					setarg(paramPos, 0, id);
				}else{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid){
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id)){
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num){
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
						#endif
				}
				stringPos = end;
			}
			case 's', 'z':{
				new
					i = 0,
					ch;
				if (format[formatPos]){
					while ((ch = string[stringPos++]) && ch != delim){
						setarg(paramPos, i++, ch);
					}
					if (!i){
						return -1;
					}
				}else{
					while ((ch = string[stringPos++])){
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' '){
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' ')){
			stringPos++;
		}
		paramPos++;
	}
	do{
		if ((delim = format[formatPos++]) > ' '){
			if (delim == '\''){
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}else if (delim != 'z'){
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}


stock IsNumeric(const string[]){
	for (new i = 0, j = strlen(string); i < j; i++){
		if (string[i] > '9' || string[i] < '0'){
			return false;
		}
	}
	return true;
}

stock RetpName(playerid){
	new
		name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	if(!name[0])format(name,sizeof(name)," none");
	return name;
}


stock Player_InArea(playerid,Float:minx, Float:miny, Float:maxx, Float:maxy){
	new
		Float:ftmp[3];
	GetPlayerPos(playerid,ftmp[0],ftmp[1],ftmp[2]);
	if(
		(ftmp[0]*ftmp[0] > minx*minx) &&
		(ftmp[1]*ftmp[1] > miny*miny) &&
		(ftmp[0]*ftmp[0] < maxx*maxx) &&
		(ftmp[1]*ftmp[1] < maxy*maxy)
	)return true;
	return false;
}
