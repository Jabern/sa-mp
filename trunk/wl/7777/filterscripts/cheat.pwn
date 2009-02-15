//==Dev Group:GCS Script Team==//
//==Our Website:www.sa-mp.com.cn==//

//==First start to code this,We think it will be use as an anti-cheat tool.==//
//==But for dev,the reason for going on cuz it should be a rule observer.==//
//==Get duty to complete it,for everyone who still loves sa-mp,for everyone who always loving sa-mp^^==//

//==Temporarily has no license owned because this source is not strong enough.==//


//------------------Anti-LockHealth-------------------//
//Date start:1/22/2009
//Date end:still testing
//Remarks:Only applicable of our server
//----------------------------------------------------//
//------------------Anti-LockAmmo---------------------//
//Date start:1/23/2009
//Date end:still developing
//Remarks:Applicable of all gamemode,i think
//----------------------------------------------------//
//------------------Anti-CarJack----------------------//
//Date start:1/25/2009
//Date end:still developing
//Remarks:Anti all carjack ,doesnt work
//----------------------------------------------------//
//------------------Anti-Teleport---------------------//
//Date start:1/26/2009
//Date end:still developing
//Remarks:Doesnt work.
//----------------------------------------------------//
#include <a_samp>

forward OnPlayerBreakRule(playerid,cheatid);
forward AC_pSetToVw(playerid);
forward AC_pSetOutVw(playerid);

#define COLOR_SYSTEM 				(0xFFFFFF)
#define MAX_STRING					(128)
#define DEBUG						(false)

new const bool:FALSE=false;
new const bool:TRUE=true;
#define SendFormatMessage(%1,%2,%3,%4)		do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%3),%4);SendClientMessage((%1),(%2),sendfstring);}while(FALSE)
stock SendFormatMessage(playerid,color,const sendfstring[]){
	SendClientMessage(playerid,color,sendfstring);
	return TRUE;
}
#define SendFormatMessageToAll(%1,%2,%3)	do{new sendfstring[MAX_STRING];format(sendfstring,MAX_STRING,(%2),%3);SendClientMessageToAll((%1),sendfstring);}while(FALSE)
stock SendFormatMessageToAll(color,const sendfstring[]){
	SendClientMessageToAll(color,sendfstring);
	return TRUE;
}

/*
forward OnPlayerTeleport(playerid,const teleport[]);

#define Teleport_AddStatic(%1,%2,%3,%4,%5,%6)\
do{if(!strcmp(cmdtext,%1,true,strlen(%1))){\
OnPlayerTeleport(playerid,(%1)),SetPlayerInterior(playerid,(%6));if(GetPlayerState(playerid)==2){SetVehiclePos(GetPlayerVehicleID(playerid),(%2),(%3),(%4)),\
SetVehicleZAngle(GetPlayerVehicleID(playerid),(%4));LinkVehicleToInterior(GetPlayerVehicleID(playerid),(%6));\
}else{SetPlayerPos(playerid,(%2),(%3),(%4));SetPlayerFacingAngle(playerid,(%4));}}}while(FALSE)




public OnPlayerTeleport( playerid,const teleport[] );

public OnPlayerCommandText( playerid, cmdtext[] )
{
    Teleport_AddStatic( "/tele-nowhere", 0.0, 0.0, 0.0, 90.0, 0 ); // add one teleport
    return 0;
}
*/
#define PRESSED(%0,%1,%2) ((((%0) & (%2)) == (%2)) && (((%1) & (%2)) != (%2)))// PRESSED(newkeys, oldkeys, keys)
#define RELEASED(%0,%1,%2) ((((%0) & (%2)) != (%2)) && (((%1) & (%2)) == (%2)))// RELEASED(newkeys, oldkeys, keys)




#define AC_PDEFENCE_CHEAT			(true)
#define AC_PAMMOLOCK_CHEAT			(true)
#define AC_PCARJACK_				(false)
#define AC_SPEED_CHEAT				(false)//speed abnormal,like teleport.rapidly flying vec,etc
#define	RULE_LOCKHEALTH 			(0)
#define RULE_LOCKAMMO				(1)
#define RULE_CARJACK				(2)
#define RULE_SPEED_ABNORMAL			(3)


#define PRESSING(%0,%1) (((%0) & (%1)) == (%1))// PRESSING(newkeys, keys)

new 
	AC_pSetToVw_Timer[MAX_PLAYERS],
	AC_pSetOutVw_Timer[MAX_PLAYERS],
	AC_pInVw_Times[MAX_PLAYERS],
	bool:AC_pSetToVw_[MAX_PLAYERS];
	


stock bool:PointToPoint(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, Float:dist){
        x1 -= x2;
        y1 -= y2;
        z1 -= z2;
        return ((x1 * x1) + (y1 * y1) + (z1 * z1) <= dist * dist);
}


#if AC_SPEED_CHEAT
new
	AC_pTeleport_prePos[MAX_PLAYERS][3],
	AC_pTeleport_Timer[MAX_PLAYERS],
	bool:AC_pTeleporting[MAX_PLAYERS];

forward AC_OnPlayerTeleport(playerid,Float:x,Float:y,Float:z);
forward AC_SetPlayerPos(playerid,Float:x,Float:y,Float:z);
public AC_SetPlayerPos(playerid,Float:x,Float:y,Float:z){
	AC_pTeleporting[playerid]=true;
	SetPlayerPos(playerid,x,y,z);
	AC_pTeleport_Timer[playerid]=SetTimerEx("AC_OnPlayerTeleport",GetPlayerPing(playerid)*2+500,false,"ifff",playerid,x,y,z);
	return true;
}
public AC_OnPlayerTeleport(playerid,Float:x,Float:y,Float:z)


#endif


#if AC_PCARJACK_

forward AC_pCarJack_Check(vehicleid);
new
	AC_pCarJack_curVec[MAX_PLAYERS],
	AC_pCarJack_Timer[MAX_PLAYERS],
	AC_pCarJack_Times[MAX_PLAYERS];
public AC_pCarJack_Check(vehicleid){
	for(new i;i<MAX_PLAYERS;i++){
		if(
		AC_pProcessing(i) && 
		IsPlayerInVehicle(i, vehicleid)){ 
			#if DEBUG
				SendFormatMessageToAll(COLOR_SYSTEM,"pid:%d car jack vid:%d",i,vehicleid);
			#endif
			if(AC_pCarJack_Times[i]++ >= 5){
				OnPlayerBreakRule(i,RULE_CARJACK);
				AC_pCarJack_Times[i]=0;
				break;
			}else{
				SendFormatMessage(i,COLOR_SYSTEM," 莫抢车,抢车遭雷劈^^");
				break;
			}
		}
	}
	return true;
}
#endif	
#if AC_PAMMOLOCK_CHEAT



forward AC_pAmmoLock_Check(playerid);
#define MAX_ABLELOCK_WEAPON			(22)
#define MAX_AMMOLOCK_CHECK_TIMES	(6)

new
	AC_pAmmoLock_Weapon[MAX_PLAYERS],
	AC_pAmmoLock_Ammo[MAX_PLAYERS],
	AC_pAmmoLock_Lock_Times[MAX_PLAYERS],
	AC_pAmmoLock_Check_CalledTimes[MAX_PLAYERS],
	AC_pAmmoLock_Timer[MAX_PLAYERS],
	AC_pAmmoLock_Timer_used[MAX_PLAYERS];

new
	AC_pAmmoLock_AbleToLock[MAX_ABLELOCK_WEAPON][1]={
		{16},{17},{18},{22},
		{23},{24},{25},{26},
		{27},{28},{29},{30},
		{31},{32},{33},{34},
		{35},{36},{37},{38},
		{41},{42}
	};


stock AC_IsWeaponAbleLock(weaponid){
	for(new i;i<MAX_ABLELOCK_WEAPON;i++){
		if(weaponid==AC_pAmmoLock_AbleToLock[i][0])return true;
	}
	return false;
}

public AC_pAmmoLock_Check(playerid){
	AC_pAmmoLock_Check_CalledTimes[playerid]++;
	if(AC_pProcessing(playerid)){
		new
			keys,
			tmpval,
			tmpweaponid,
			tmpammo;
		GetPlayerKeys(playerid,keys,tmpval,tmpval);
		tmpweaponid=GetPlayerWeapon(playerid);
		tmpammo=GetPlayerAmmo(playerid);
		if(
		(keys & KEY_FIRE) &&
		(!GetPlayerVehicleID(playerid)) &&
		(tmpweaponid == AC_pAmmoLock_Weapon[playerid])
		){
			#if DEBUG
				SendFormatMessageToAll(COLOR_SYSTEM," weapon same");
			#endif
			if(
			(tmpammo == AC_pAmmoLock_Ammo[playerid]) ||
			(tmpammo+1 == AC_pAmmoLock_Ammo[playerid]) ||
			(tmpammo-1 == AC_pAmmoLock_Ammo[playerid])
			){
				#if DEBUG
					SendFormatMessageToAll(COLOR_SYSTEM," ammo same");
				#endif
				if(
				(AC_pAmmoLock_Lock_Times[playerid] >= MAX_AMMOLOCK_CHECK_TIMES-1)
				){
					AC_pAmmoLock_Lock_Times[playerid]=0;
					OnPlayerBreakRule(playerid,RULE_LOCKAMMO);
				}else{
					#if	DEBUG
						SendFormatMessageToAll(COLOR_SYSTEM," pre same time %d,cur same time %d",AC_pAmmoLock_Lock_Times[playerid],AC_pAmmoLock_Lock_Times[playerid]+1);
					#endif
					AC_pAmmoLock_Lock_Times[playerid]++;
				}
			}
		}
	}else{
		KillTimer(AC_pAmmoLock_Timer[playerid]);
		AC_pAmmoLock_Timer_used[playerid]=false;
		AC_pAmmoLock_Lock_Times[playerid]=0;
	}
	if(AC_pAmmoLock_Check_CalledTimes[playerid] == MAX_AMMOLOCK_CHECK_TIMES){
		AC_pAmmoLock_Lock_Times[playerid]=0;
	}
	return true;
}


#endif



#if AC_PDEFENCE_CHEAT
forward AC_pDefence_Check(playerid);
forward AC_pDefence_Check_tmpStep1(playerid,pcurCoord,Float:pPosx,Float:pPosy,Float:pPosz,Float:pHealth,Float:pArmour);
forward AC_pDefence_Check_tmpStep2(playerid,pcurCoord,Float:pPosx,Float:pPosy,Float:pPosz,Float:pHealth,Float:pArmour);
forward AC_pDefence_Check_tmpStep3(playerid,pcurCoord,Float:pPosx,Float:pPosy,Float:pPosz,Float:pHealth,Float:pArmour);
#define MAX_PDEFENCE_CHECK_AREA		(14)
new
	Float:AC_pDefence_Check_Coords[MAX_PDEFENCE_CHECK_AREA][3] = {
		{-1585.6317,-2798.4741,-33.4134},
		{-1615.9137,-2813.2771,-38.4403},
		{-1601.1459,-2834.5420,-37.8943},
		{-1574.2616,-2820.8660,-33.2878},
		{-1552.6801,-2843.0305,-32.7406},
		{-1577.6783,-2895.0657,-39.9791},
		{-1544.7091,-2915.6401,-37.1277},
		{-1509.8516,-2894.5308,-32.7740},
		{-1473.8984,-2921.4543,-32.7757},
		{-1513.1573,-2952.8892,-38.4831},
		{-1482.8728,-2966.6758,-52.6838},
		{-1439.9854,-2943.9128,-37.3187},
		{-1421.9447,-2984.1047,-53.0326},
		{-1378.0261,-2958.5950,-35.7521}
	};
new
	bool:AC_pDefence_Area_Used[MAX_PDEFENCE_CHECK_AREA],
	Float:AC_pDefence_preHealth[MAX_PLAYERS],
	AC_pDefence_preKill_Time[MAX_PLAYERS],
	AC_pDefence_tmp1_Timer[MAX_PLAYERS],
	AC_pDefence_tmp2_Timer[MAX_PLAYERS],
	AC_pDefence_tmp3_Timer[MAX_PLAYERS],
	AC_pDefence_Kill_Times[MAX_PLAYERS];



stock AC_pDefence_Area(){
	for(new i;i<MAX_PDEFENCE_CHECK_AREA;i++){
		if(!AC_pDefence_Area_Used[i]){
			AC_pDefence_Area_Use(i,true);
			return i;
		}
	}
	return 0;
}
stock AC_pDefence_Area_Use(Coordid,bool:used){
	AC_pDefence_Area_Used[Coordid]=used;
	return used;
}
public AC_pDefence_Check(playerid){
	if(AC_pProcessing(playerid)){
		new 
		curCoord,
		Float:ftmp[5];
		curCoord=AC_pDefence_Area();
		GetPlayerPos(playerid,ftmp[0],ftmp[1],ftmp[2]);
		GetPlayerHealth(playerid,ftmp[3]);
		GetPlayerArmour(playerid,ftmp[4]);
		TogglePlayerControllable(playerid,false);
		SetPlayerPos(playerid,AC_pDefence_Check_Coords[curCoord][0],AC_pDefence_Check_Coords[curCoord][1],AC_pDefence_Check_Coords[curCoord][2]);
		AC_pDefence_tmp1_Timer[playerid]=SetTimerEx("AC_pDefence_Check_tmpStep1",GetPlayerPing(playerid)*2,false,"iifffff",playerid,curCoord,ftmp[0],ftmp[1],ftmp[2],ftmp[3],ftmp[4]);
	}else return false;
	return true;
}
public AC_pDefence_Check_tmpStep1(playerid,pcurCoord,Float:pPosx,Float:pPosy,Float:pPosz,Float:pHealth,Float:pArmour){
	if(AC_pProcessing(playerid)){
		SetPlayerHealth(playerid,100);
		SetPlayerArmour(playerid,0);
		TogglePlayerControllable(playerid,true);
		ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1);
		ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1);
		ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1);
		AC_pDefence_tmp2_Timer[playerid]=SetTimerEx("AC_pDefence_Check_tmpStep2",GetPlayerPing(playerid)*2,false,"iifffff",playerid,pcurCoord,pPosx,pPosy,pPosz,pHealth,pArmour);
	}else{
		return AC_pDefence_Area_Use(pcurCoord,false);
	}
	return true;
}

public AC_pDefence_Check_tmpStep2(playerid,pcurCoord,Float:pPosx,Float:pPosy,Float:pPosz,Float:pHealth,Float:pArmour){
	if(AC_pProcessing(playerid)){
		ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1);
		ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1);
		ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1);
		CreateExplosion(AC_pDefence_Check_Coords[pcurCoord][0],AC_pDefence_Check_Coords[pcurCoord][1],AC_pDefence_Check_Coords[pcurCoord][2],7,10);
		AC_pDefence_tmp3_Timer[playerid]=SetTimerEx("AC_pDefence_Check_tmpStep3",GetPlayerPing(playerid)*2+1000,false,"iifffff",playerid,pcurCoord,pPosx,pPosy,pPosz,pHealth,pArmour);
	}else{
		return AC_pDefence_Area_Use(pcurCoord,false);
	}
	return true;
}

public AC_pDefence_Check_tmpStep3(playerid,pcurCoord,Float:pPosx,Float:pPosy,Float:pPosz,Float:pHealth,Float:pArmour){

	if(AC_pProcessing(playerid)){
		new
			Float:ftmp;
		GetPlayerHealth(playerid,ftmp);
		
		#if DEBUG
			new string[128];
			format(string,sizeof(string),"cuHP:%f",ftmp);
			SendClientMessageToAll(COLOR_SYSTEM,string);
		#endif
		if(ftmp > 18){
			#if DEBUG
				SendClientMessageToAll(COLOR_SYSTEM,"cheater...");
			#endif
			OnPlayerBreakRule(playerid,RULE_LOCKHEALTH);
		}else{
			SendFormatMessage(playerid,COLOR_SYSTEM," 杀人别杀得太疯狂了^^");
			#if DEBUG
				SendClientMessageToAll(COLOR_SYSTEM,"gamer...");
			#endif
		}
		AC_pDefence_Area_Use(pcurCoord,false);
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		SetPlayerHealth(playerid,pHealth);
		SetPlayerArmour(playerid,pArmour);
		SetPlayerPos(playerid,pPosx,pPosy,pPosz+1);
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		
	}else{
		return AC_pDefence_Area_Use(pcurCoord,false);
	}
	return true;
}


#endif




public OnFilterScriptInit(){
	print("//---------------------------------------//");
	print("//------------>Rule-observer<------------//");
	print("//----------->GCS Script Team<-----------//");
	print("//---------------------------------------//");
	#if DEBUG
		//SetTimer("test",1000*1,true);
	#endif
	for(new i;i<MAX_PLAYERS;i++){
		AC_pSetToVw_[i]=false;
	}
	return true;
}

public OnFilterScriptExit(){
	for(new i;i<MAX_PLAYERS;i++){
		KillTimer(AC_pSetToVw_Timer[i]);
		KillTimer(AC_pSetOutVw_Timer[i]);
		#if AC_SPEED_CHEAT
			KillTimer(AC_pTeleport_Timer[i]);
		#endif
		#if AC_PCARJACK_
			KillTimer(AC_pCarJack_Timer[i]);
		#endif
		#if AC_PAMMOLOCK_CHEAT
			KillTimer(AC_pAmmoLock_Timer[i]);
		#endif
		#if AC_PDEFENCE_CHEAT
			KillTimer(AC_pDefence_tmp1_Timer[i]);
			KillTimer(AC_pDefence_tmp2_Timer[i]);
			KillTimer(AC_pDefence_tmp3_Timer[i]);
		#endif
	}
	return true;
}


public OnPlayerDeath(playerid,killerid,reason){
	new
		string[128],
		Float:kHealth;
	#if AC_PDEFENCE_CHEAT
	if(AC_pDefence_Kill_Times[playerid]>=1){
		AC_pDefence_Kill_Times[playerid]=0;
	}
	if(killerid != INVALID_PLAYER_ID){
		GetPlayerHealth(killerid,kHealth);
		//AC_pDefence_Kill_Times[killerid]=0;
	}
	#if DEBUG
		format(string,sizeof(string),"curHP:%f preHP:%f",kHealth,AC_pDefence_preHealth[killerid]);
		SendClientMessageToAll(COLOR_SYSTEM,string);
	#endif
	if(
	killerid != INVALID_PLAYER_ID && 
	AC_pProcessing(killerid) && 
	!GetPlayerVehicleID(killerid) &&
	kHealth == AC_pDefence_preHealth[killerid]){
		new
			tmpval = gettime_minute();
		if(tmpval-2 <= AC_pDefence_preKill_Time[killerid])AC_pDefence_Kill_Times[killerid]++;
		else AC_pDefence_Kill_Times[killerid]=0;
		if(AC_pDefence_Kill_Times[killerid] >= 2){
			AC_pDefence_Kill_Times[killerid]=0;
			AC_pDefence_Check(killerid);
		}
		AC_pDefence_preKill_Time[killerid]=tmpval;
		AC_pDefence_preHealth[killerid] = kHealth;
		/*#if DEBUG
			format(string,sizeof(string),"playervecid:%d %d pretime:%d curtime:%d curtimes:%d",INVALID_VEHICLE_ID,GetPlayerVehicleID(killerid),AC_pDefence_preKill_Time[killerid],tmpval,AC_pDefence_Kill_Times[killerid]);
			SendClientMessageToAll(COLOR_SYSTEM,string);
		#endif*/
	}
	/*if(killerid != INVALID_PLAYER_ID){
		GetPlayerHealth(killerid,AC_pDefence_preHealth[killerid]);
	}*/	
	#endif
	
	return true;
}




public OnPlayerSpawn(playerid){
	return true;
}

public OnPlayerDisconnect(playerid,reason){
	#if AC_SPEED_CHEAT
		KillTimer(AC_pTeleport_Timer[playerid]);
		AC_pTeleporting[playerid]=false;
	#endif
	#if AC_PDEFENCE_CHEAT
		AC_pDefence_Kill_Times[playerid]=0;
		AC_pDefence_preKill_Time[playerid]=0;
		AC_pDefence_preHealth[playerid]=80;
		KillTimer(AC_pDefence_tmp1_Timer[playerid]);
		KillTimer(AC_pDefence_tmp2_Timer[playerid]);
		KillTimer(AC_pDefence_tmp3_Timer[playerid]);
	#endif
	#if AC_PAMMOLOCK_CHEAT
		KillTimer(AC_pAmmoLock_Timer[playerid]);
		AC_pAmmoLock_Timer_used[playerid]=false;
		AC_pAmmoLock_Lock_Times[playerid]=0;
		AC_pAmmoLock_Weapon[playerid]=0;
		AC_pAmmoLock_Ammo[playerid]=0;
	#endif
	#if AC_PCARJACK_
		KillTimer(AC_pCarJack_Timer[playerid]);
		AC_pCarJack_Times[playerid]=0;
		AC_pCarJack_curVec[playerid]=GetPlayerVehicleID(INVALID_PLAYER_ID);
	#endif
	KillTimer(AC_pSetToVw_Timer[playerid]);
	KillTimer(AC_pSetOutVw_Timer[playerid]);
	AC_pInVw_Times[playerid]=0;
	AC_pSetToVw_[playerid]=false;
	return true;
}
public OnPlayerCommandText(playerid,cmdtext[]){
    new cmd[128];
	new tmp[128];
	new idx;
	new giveplayerid;
	new string[128];
	cmd = strtok(cmdtext,idx);
	
	#if DEBUG
	if((AC_pGetAdminLevel(playerid)>=4 || IsPlayerAdmin(playerid))){
		if(!strcmp(cmd,"/crashserver",true))SendClientMessageToAll(0,string);	
		if(!strcmp(cmd,"/killme",true))OnPlayerDeath(playerid,playerid,38);
	}
	#endif
	if(!strcmp(cmd, "/zuobi",true) || !strcmp(cmd, "/ac_look", true)){
		SendFormatMessage(playerid,COLOR_SYSTEM," 在惩戒之星的玩家:");
		for(new i;i<MAX_PLAYERS;i++){
			if(IsPlayerConnected(i) && (AC_pSetToVw_[i]==true)){
				new
					Float:ftmp[2];
				GetPlayerHealth(i,ftmp[0]);
				GetPlayerArmour(i,ftmp[1]);
				SendFormatMessage(playerid,COLOR_SYSTEM," 昵称: %s (id:%d) 血:%f 甲:%f 被抓次数:%d",RetpName(i),i,ftmp[0],ftmp[1],AC_pInVw_Times[i]);
			}
		}
		return true;
	}
	if(!strcmp(cmd, "/zhuaren", true) || !strcmp(cmd, "/ac_catch", true)){
		if (AC_pGetAdminLevel(playerid)>=1 || IsPlayerAdmin(playerid)){
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp) || !IsNumeric(tmp) || !IsPlayerConnected(strval(tmp))){
				SendClientMessage(playerid,COLOR_SYSTEM," 使用方法:/zhuaren [id] 或 /ac_catch [id]");
				SendClientMessage(playerid,COLOR_SYSTEM," 效果:将玩家收入惩戒之星");
				return true;
			}
			giveplayerid=strval(tmp);
			KillTimer(AC_pSetToVw_Timer[giveplayerid]);
			AC_pSetToVw_[giveplayerid]=true;
			AC_pSetToVw_Timer[giveplayerid] = SetTimerEx("AC_pSetToVw",1000*5,true,"i",giveplayerid);
			SendFormatMessage(giveplayerid,COLOR_SYSTEM," 你被送进惩戒之星,有意见联系GM,或者思过5分钟^^");
			SendFormatMessageToAll(COLOR_SYSTEM," 玩家 %s(id:%d)被管理员(id:%d)送进惩戒之星^^",RetpName(giveplayerid),giveplayerid,playerid);
			for(new i;i<MAX_PLAYERS;i++){
				if(IsPlayerConnected(i) && (IsPlayerAdmin(i) || AC_pGetAdminLevel(i)>=1)){
					GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Someone has been  ~r~JAILED~w~.", 3000, 3);
				}
			}
			return true;
		}else return SendClientMessage(playerid,COLOR_SYSTEM," 你不是管理员");
	}
	if(!strcmp(cmd, "/fangren", true) || !strcmp(cmd, "/ac_leave", true)){
		if (AC_pGetAdminLevel(playerid)>=1 || IsPlayerAdmin(playerid)){
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp) || !IsNumeric(tmp) || !IsPlayerConnected(strval(tmp))){
				SendClientMessage(playerid,COLOR_SYSTEM," 使用方法:/fangren [id] 或 /ac_leave [id]");
				SendClientMessage(playerid,COLOR_SYSTEM," 效果:将玩家从惩戒之星放出来");
				return true;
			}
			giveplayerid=strval(tmp);
			KillTimer(AC_pSetToVw_Timer[giveplayerid]);
			AC_pSetToVw_Timer[giveplayerid]=false;
			KillTimer(AC_pSetOutVw_Timer[giveplayerid]);
			AC_pSetOutVw_Timer[giveplayerid]=false;
			SetPlayerVirtualWorld(giveplayerid,0);
			SetPlayerHealth(giveplayerid,0);
			SendFormatMessage(giveplayerid,COLOR_SYSTEM," 你回到地球了,请好好做人^^");
			SendFormatMessageToAll(COLOR_SYSTEM," 玩家 %s (id:%d)被管理员送回地球,请各位玩家珍惜地球,不破坏环境^^",RetpName(giveplayerid),giveplayerid);
			return true;
		}else return SendClientMessage(playerid,COLOR_SYSTEM," 你不是管理员");
	}
	#if AC_PDEFENCE_CHEAT
	if(!strcmp(cmd, "/suoxue", true) || !strcmp(cmd, "/ac_cph", true)){
		if (AC_pGetAdminLevel(playerid)>0 || IsPlayerAdmin(playerid)){
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp) || !IsNumeric(tmp) || !IsPlayerConnected(strval(tmp)))
				return SendClientMessage(playerid,COLOR_SYSTEM," 使用方法:/suoxue [id] 或 /ac_cph [id]");
			giveplayerid=strval(tmp);
			AC_pDefence_Check(giveplayerid);
			format(string,sizeof(string)," 玩家 %s (id:%d)被你送去锁血检测",RetpName(giveplayerid),giveplayerid);
			SendClientMessage(playerid,COLOR_SYSTEM,string);
			return true;
		}else return SendClientMessage(playerid,COLOR_SYSTEM," 你不是管理员");
	}
	#endif
	#if AC_PAMMOLOCK_CHEAT
	if(!strcmp(cmd, "/suozidan", true) || !strcmp(cmd, "/ac_cpa", true)){
		if (AC_pGetAdminLevel(playerid)>0 || IsPlayerAdmin(playerid)){
			SendClientMessage(playerid,COLOR_SYSTEM," 服务器自动检测是否锁子弹^^,不用劳驾管理员大人.");
		}
		return true;
	}
	#endif
	return false;
}


public OnPlayerUpdate(playerid){
	#if AC_SPEED_CHEAT
		GetPlayerPos(playerid,AC_pTeleport_prePos[playerid][0],AC_pTeleport_prePos[playerid][1],AC_pTeleport_prePos[playerid][2]);
	#endif
	return true;
}


public OnPlayerKeyStateChange(playerid,newkeys,oldkeys){
	#if AC_PAMMOLOCK_CHEAT
	if(
	PRESSING(newkeys,KEY_FIRE) && 
	AC_pProcessing(playerid) && 
	!GetPlayerVehicleID(playerid) && 
	AC_IsWeaponAbleLock(GetPlayerWeapon(playerid))
	){
		if(!AC_pAmmoLock_Timer_used[playerid]){
			AC_pAmmoLock_Ammo[playerid]=GetPlayerAmmo(playerid);	
			AC_pAmmoLock_Weapon[playerid]=GetPlayerWeapon(playerid);
			AC_pAmmoLock_Timer[playerid]=SetTimerEx("AC_pAmmoLock_Check",1000,MAX_AMMOLOCK_CHECK_TIMES,"i",playerid);
			AC_pAmmoLock_Timer_used[playerid]=true;
		}
	}
	if(RELEASED(newkeys,oldkeys,KEY_FIRE)){
		new
			tmpammo=GetPlayerAmmo(playerid);
		if(
		(AC_IsWeaponAbleLock(GetPlayerWeapon(playerid))) && 
		(tmpammo != AC_pAmmoLock_Ammo[playerid]) && 
		((tmpammo+1) != AC_pAmmoLock_Ammo[playerid]) && 
		((tmpammo-1) != AC_pAmmoLock_Ammo[playerid])
		){
			#if DEBUG
				SendFormatMessageToAll(COLOR_SYSTEM,"player no cheat curammo:%d preammo:%d",tmpammo,AC_pAmmoLock_Ammo[playerid]);
			#endif
			KillTimer(AC_pAmmoLock_Timer[playerid]);
			AC_pAmmoLock_Timer_used[playerid]=false;
			AC_pAmmoLock_Lock_Times[playerid]=0;
		}
	}
	#endif

	return true;
}



public OnPlayerStateChange(playerid, newstate, oldstate){
	#if AC_PCARJACK_
		if((oldstate == PLAYER_STATE_DRIVER) && (newstate == PLAYER_STATE_ONFOOT)){
			if(AC_pCarJack_curVec[playerid])
			AC_pCarJack_Timer[playerid]=SetTimerEx("AC_pCarJack_Check",1000,false,"i",AC_pCarJack_curVec[playerid]);
		}
		if(newstate == PLAYER_STATE_DRIVER){
			AC_pCarJack_curVec[playerid]=GetPlayerVehicleID(playerid);
		}
	#endif
	return true;
}
public OnPlayerEnterVehicle(playerid,vehicleid){
	return true;
}

public OnPlayerExitVehicle(playerid, vehicleid){

	return true;
}



stock strtok(const string[], &index,seperator=' '){
	new length = strlen(string);
	new offset = index;
	new result[128];
	while ((index < length) && (string[index] != seperator) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}

	result[index - offset] = EOS;
	if ((index < length) && (string[index] == seperator))
	{
		index++;
	}
	return result;
}
stock IsNumeric(const string[]){
	for (new i = 0, j = strlen(string); i < j; i++)
	if (string[i] > '9' || string[i] < '0')
    return 0;
	return 1;
}
stock RetpName(playerid){
	new
		name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	return name;
}

stock gettime_minute(){
	new
		tmp1,
		tmp2;
	gettime(tmp1,tmp2,tmp1);
	return tmp2;
}
	



stock AC_pGetAdminLevel(playerid){
	return CallRemoteFunction("GetPlayerAdminLevel","i",playerid);
}






stock AC_pProcessing(playerid){
	return (
	IsPlayerConnected(playerid) &&
	GetPlayerState(playerid) != PLAYER_STATE_SPAWNED && 
	GetPlayerState(playerid) != PLAYER_STATE_WASTED && 
	GetPlayerState(playerid) != PLAYER_STATE_SPECTATING
	)?true:false;
}

stock AC_pSetInVw(playerid){
	if(IsPlayerConnected(playerid)){
		if(AC_pSetToVw_[playerid])return true;
		AC_pInVw_Times[playerid]++;
		AC_pSetToVw_[playerid]=true;
		KillTimer(AC_pSetToVw_Timer[playerid]);
		AC_pSetToVw_Timer[playerid] = SetTimerEx("AC_pSetToVw",1000*5,true,"i",playerid);
		KillTimer(AC_pSetOutVw_Timer[playerid]);
		AC_pSetOutVw_Timer[playerid] = SetTimerEx("AC_pSetOutVw",1000*60*5,false,"i",playerid);
		SendFormatMessage(playerid,COLOR_SYSTEM," 你因违反未来世界的游戏规则被送到惩戒之星,输入/zuobi 察看^^");
		SendFormatMessage(playerid,COLOR_SYSTEM," 想出去吗?做回好公民,联系GM,或者思过5分钟^^");
		for(new i;i<MAX_PLAYERS;i++){
			if(IsPlayerConnected(i) && (IsPlayerAdmin(i) || AC_pGetAdminLevel(i)>=1)){
				GameTextForPlayer(i, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Someone has been  ~r~JAILED~w~.", 3000, 3);
			}
		}
	}else{
		AC_pSetToVw_[playerid]=false;
		KillTimer(AC_pSetToVw_Timer[playerid]);
		KillTimer(AC_pSetOutVw_Timer[playerid]);
	}
	return true;
}

public AC_pSetOutVw(playerid){
	if(IsPlayerConnected(playerid)){
		AC_pSetToVw_[playerid]=false;
		KillTimer(AC_pSetToVw_Timer[playerid]);
		KillTimer(AC_pSetOutVw_Timer[playerid]);
		SetPlayerVirtualWorld(playerid,0);
		SetPlayerHealth(playerid,0);
		SendFormatMessage(playerid,COLOR_SYSTEM," 你回到地球了,请好好做人^^");
		SendFormatMessageToAll(COLOR_SYSTEM," 玩家(id:%d)被遣送回地球,请各位玩家珍惜地球,不破坏环境^^",playerid);
	}else{
		AC_pSetToVw_[playerid]=false;
		KillTimer(AC_pSetToVw_Timer[playerid]);
		KillTimer(AC_pSetOutVw_Timer[playerid]);
	}
	return true;
}

public AC_pSetToVw(playerid){
	if(!IsPlayerConnected(playerid)){
		KillTimer(AC_pSetToVw_Timer[playerid]);
		AC_pSetToVw_[playerid]=false;
	}
	new Float:ftmp[3];
	GetPlayerPos(playerid,ftmp[0],ftmp[1],ftmp[2]);
	if(ftmp[0]<1586.0916 || ftmp[0]> 1632.5790 || ftmp[1] < 1645.6013 || ftmp[1] > 1697.7134 || ftmp[2] < 9 || ftmp[2] > 20)
		SetPlayerPos(playerid,1605.5560+random(5),1673.0929+random(5),11.8203+random(10));
	SetPlayerVirtualWorld(playerid,255);
	return true;
}


public OnPlayerBreakRule(playerid,cheatid){
	switch(cheatid){
		case RULE_LOCKHEALTH:{
			if(IsPlayerConnected(playerid) && !AC_pSetToVw_[playerid]){
				SendFormatMessageToAll(COLOR_SYSTEM," 玩家 %s(%d)因违反游戏规则被放进惩戒之星(锁血拉)", RetpName(playerid),playerid);
			}
			AC_pSetInVw(playerid);

		}
		case RULE_LOCKAMMO:{
			if(IsPlayerConnected(playerid) && !AC_pSetToVw_[playerid]){
				SendFormatMessageToAll(COLOR_SYSTEM," 玩家 %s(%d)因违反游戏规则被放进惩戒之星(锁子弹拉)", RetpName(playerid),playerid);
			}
			AC_pSetInVw(playerid);

		}
		case RULE_CARJACK:{
			if(IsPlayerConnected(playerid) && !AC_pSetToVw_[playerid]){
				SendFormatMessageToAll(COLOR_SYSTEM," 玩家 %s(%d)因违反游戏规则被放进惩戒之星(抢车次数太多拉)", RetpName(playerid),playerid);
			}
			AC_pSetInVw(playerid);
		}
	}
	return true;
}
