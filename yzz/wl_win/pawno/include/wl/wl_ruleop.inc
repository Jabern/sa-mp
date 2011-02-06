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



/*=====================Player Variable Table================================================
	wl_ruleop_player_possible_rulebreak					integer	-
	wl_ruleop_player_rulebreak_info						string	-
	wl_ruleop_player_BreakRule							integer	-
	wl_ruleop_player_JailTimer							integer	-
	wl_ruleop_player_BreakTimes							integer	-
  ==========================================================================================*/


#define WORLD_JAIL				(1)
#define RP_CHECK_ITTER			(801)
#define MAX_ALLOR_BREAK_TIMES	(5)

enum {
	erule_none,
	erule_breakjail,
	erule_breakworld,
	erule_driveby,//dbk
	erule_disallowedTele,//teleport unusable vehicle
	erule_navCheck, //cannot use nav(ҹ��)
	erule_pdmweapon,//use disallowed weapon in pdm
	erule_pdmweaponout,//bring pdm weapon out
	erule_weapon,//invliad weapon
	erule_carjacknpc, //carjack npc
	erule_possiblecheat
}



//static stock
//	g_wl_ruleop_pBreakRule[MAX_PLAYERS],
//	g_wl_ruleop_pJailTimer[MAX_PLAYERS],
//	g_wl_ruleop_pBreakTimes[MAX_PLAYERS];


				
forward wl_ruleop_pBreakRule(playerid);
public wl_ruleop_pBreakRule(playerid){
	return GetPVarInt(playerid,"wl_ruleop_player_BreakRule");
}

stock wl_ruleop_gpBreakRule(playerid){
	return GetPVarInt(playerid,"wl_ruleop_player_BreakRule");
}

stock wl_ruleop_spBreakRule(playerid,set){
	SetPVarInt(playerid,"wl_ruleop_player_BreakRule",set);
	return true;
}

stock rp_gpBreakTimes(playerid){
	return GetPVarInt(playerid,"wl_ruleop_player_BreakTimes");
}

stock rp_spBreakTimes(playerid,set){
	SetPVarInt(playerid,"wl_ruleop_player_BreakTimes",set);
	return true;
}

wl_ruleop_struction(){
	SetTimer("wl_ruleop_Check",RP_CHECK_ITTER,true);
}

rp_playerDisconnect(playerid){
	rp_spBreakTimes(playerid,0);
	wl_ruleop_spBreakRule(playerid,false);
	KillTimer(GetPVarInt(playerid,"wl_ruleop_player_JailTimer"));
}

rp_playerConnect(playerid){
	rp_spBreakTimes(playerid,0);
	wl_ruleop_spBreakRule(playerid,false);
	KillTimer(GetPVarInt(playerid,"wl_ruleop_player_JailTimer"));
}

rp_playerUpdate(playerid){
#define holdingEx1(%0) ((keys & (%0)) == (%0))
	new
		keys, updown, leftright;
	GetPlayerKeys(playerid,keys,updown,leftright);
	if(GetPlayerWeapon(playerid) == 44 || GetPlayerWeapon(playerid) == 45){
		ResetPlayerWeapons(playerid);
		return false;
	}
	if(!GetPlayerVirtualWorld(playerid)){
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT){
			switch(GetPlayerWeapon(playerid)){
				case WEAPON_GRENADE,WEAPON_TEARGAS,WEAPON_MOLTOV,WEAPON_ROCKETLAUNCHER,WEAPON_HEATSEEKER,WEAPON_FLAMETHROWER,WEAPON_MINIGUN,WEAPON_SATCHEL,WEAPON_SPRAYCAN,WEAPON_FIREEXTINGUISHER:{

					if(holdingEx1(KEY_FIRE) || holdingEx1(KEY_ACTION)){
						return false;
					}			
				}
			}
		}
		else if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
			switch(GetVehicleModel(GetPlayerVehicleID(playerid))){
				case 520,425,447,407,432,601:{
					if(holdingEx1(KEY_FIRE) || holdingEx1(KEY_ACTION) || holdingEx1(KEY_SECONDARY_ATTACK)){
						return false;
					}
				}
			}
		}
		else if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER){
			switch(GetPlayerWeapon(playerid)){
				case WEAPON_MINIGUN,WEAPON_SHOTGSPA,WEAPON_SAWEDOFF,WEAPON_DEAGLE,WEAPON_SILENCED,WEAPON_COLT45:{
					if(holdingEx1(KEY_FIRE) || holdingEx1(KEY_ACTION) || holdingEx1(KEY_SECONDARY_ATTACK)){
						return false;
					}
				}
			}
		}	
	}
	return true;
}
	

wl_ruleop_playerSpawn(playerid){
	if(wl_ruleop_gpBreakRule(playerid)){
		SetPlayerVirtualWorld(playerid,WORLD_JAIL);
		SetPlayerPos(playerid,1271.1410,-1254.5160,14.1928);
		SetPlayerWorldBounds(playerid,1292.6895,1285.0641,-1213.2524,-1252.3297);
		
		ResetPlayerWeapons(playerid);
		SetPlayerArmour(playerid,100);
		SetPlayerHealth(playerid,100);
		GivePlayerWeapon(playerid,WEAPON_KATANA,1);
		GivePlayerWeapon(playerid,WEAPON_DEAGLE,9999);
		GivePlayerWeapon(playerid,WEAPON_SHOTGSPA,9999);
		GivePlayerWeapon(playerid,WEAPON_MP5,9999);
		GivePlayerWeapon(playerid,WEAPON_M4,9999);
		GivePlayerWeapon(playerid,WEAPON_SNIPER,9999);
		GivePlayerWeapon(playerid,WEAPON_GRENADE,9999);
		GivePlayerWeapon(playerid,WEAPON_FIREEXTINGUISHER,9999);
		GivePlayerWeapon(playerid,WEAPON_FLOWER,1);
		GivePlayerWeapon(playerid,WEAPON_PARACHUTE,1);
	}
	return true;

}

//===�Ը�ҹ��=======
forward wl_ruleop_Check();
public wl_ruleop_Check(){
	loopPlayer(playerid){
		if(wl_ruleop_gpBreakRule(playerid)){
			if(GetPlayerVirtualWorld(playerid) != WORLD_JAIL){
				OnPlayerBreakRule(playerid,erule_breakjail);
			}
			continue;
		}
		if(GetPlayerVirtualWorld(playerid)){
			loopPlayer(i){
				if(!vw_gpAbleWorld(playerid,i)){
					if(vw_isplayerInplayerWorld(playerid,i)){
						OnPlayerBreakRule(playerid,erule_breakworld,i);
						continue;
					}
				}
			}
		}
		/*
		if((GetPlayerWeapon(playerid) == 44 || GetPlayerWeapon(playerid) == 45) && (!GetPlayerVirtualWorld(playerid) || dmw:getPlayer(playerid))){
			OnPlayerBreakRule(playerid,erule_navCheck);
			continue;
		}
		*/
		{
			new
				vecid = Vec_getPlayerVecID(playerid),
				vecmodel = GetVehicleModel(vecid);
				
			
			if(vecmodel){
				if((!GetVehicleVirtualWorld(vecid) && !Vec_usableinNormalWorld(vecmodel))){
					//loopPlayer(i){
					//	if(GetPlayerVehicleID(i) == vecid){
							Vec_DestroyPlayer(playerid);
							OnPlayerBreakRule(playerid,erule_disallowedTele,GetPlayerVehicleID(playerid));
					//		break;
					//	}
					//}
					continue;
				}
				if(GetVehicleVirtualWorld(vecid) == DMWorld_ID){
					Vec_DestroyPlayer(playerid);
					OnPlayerBreakRule(playerid,erule_disallowedTele,GetPlayerVehicleID(playerid));
					continue;
				}
			}
		}
		if(PDM_getPlayerDM(playerid) != INVALID_PDM_ID){
			if(PDM_isPlayeruseInvalidPDMWeapon(playerid,PDM_getPlayerDM(playerid))){
				OnPlayerBreakRule(playerid,erule_pdmweapon);
				continue;
			}
			if(GetPlayerWeapon(playerid) && GetPVarInt(playerid,"wl_pdm_dming") && !PDM_isPlayerInPDMAreaEx(playerid,PDM_getPlayerDM(playerid))){
				OnPlayerBreakRule(playerid,erule_pdmweaponout);
				continue;
			}
		}
		/*
		new
			pweapon = GetPlayerWeapon(playerid),
			invalidweapon = ( \
				pweapon == WEAPON_SATCHEL || pweapon == WEAPON_MINIGUN || pweapon == WEAPON_HEATSEEKER || pweapon == WEAPON_BOMB || 
				pweapon == WEAPON_ROCKETLAUNCHER || pweapon == WEAPON_GRENADE || pweapon == WEAPON_TEARGAS || pweapon == WEAPON_MOLTOV  || 
				pweapon == WEAPON_CHAINSAW || pweapon == WEAPON_FLAMETHROWER || pweapon == WEAPON_SPRAYCAN || pweapon == WEAPON_FIREEXTINGUISHER
			);
		if(PDM_getPlayerDM(playerid) == INVALID_PDM_ID && !GetPlayerVirtualWorld(playerid) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && invalidweapon){
			OnPlayerBreakRule(playerid,erule_weapon);
			continue;
		}
		*/
	}
}
//==================
//===�Ը���ɱ=======
wl_ruleop_PlayerDeath(playerid, killerid, reason){
	#pragma unused playerid,killerid,reason
	/*
	if(!GetPlayerVirtualWorld(playerid) && GetPlayerState(killerid) == PLAYER_STATE_DRIVER && !IsPlayerInAnyVehicle(playerid) && (reason == WEAPON_UZI || reason == WEAPON_MP5 || reason == WEAPON_TEC9)){
		OnPlayerBreakRule(killerid,erule_driveby);
	}
	*/
}
//=================

//forward OnPlayerBreakRule(playerid,ruleid,other);
stock OnPlayerBreakRule(playerid,ruleid,other = -1){
	switch(ruleid){
		case erule_breakjail:{
			if(rp_gpBreakTimes(playerid) < MAX_ALLOR_BREAK_TIMES){
				rp_spBreakTimes(playerid,rp_gpBreakTimes(playerid)+1);
				wl_ruleop_setPlayerJail(playerid,true,30);
				System_send(playerid,"[ϵͳ]�벻Ҫ����Խ��,�ۼ�5�ν��ᱻ�߳�������!(����:%d)",rp_gpBreakTimes(playerid));
			}else{
				System_sendAll("[ϵͳ]%s(%d)����Խ�����߳�������",pName(playerid),playerid);
				Kick(playerid);
			}
		}
		case erule_breakworld:{
			SetPlayerVirtualWorld(playerid,0);
			System_send(playerid,"[ϵͳ]�㲻��������'%s'(%d)������",pName(other),other);
		}
		case erule_navCheck:{
			ResetPlayerWeapons(playerid);
			wl_ruleop_setPlayerJail(playerid,true,30);
			System_sendAll("[ϵͳ]%s(%d)�ڴ�����ӵ�зǷ�����(ҹ�Ӿ�),��ץȥ�װ෿",pName(playerid),playerid);
		}
		case erule_disallowedTele:{
			System_send(playerid,"[ϵͳ]�������ѷǳ��潻ͨ���ߴ��͵�������");
			//if(Vec_getOrginalVW(other)) SetVehicleVirtualWorld(other,Vec_getOrginalVW(other));
			//else SetVehicleVirtualWorld(other,random(500)+1000);
			//wl_ruleop_setPlayerJail(playerid,true,30);
			//System_sendAll("[ϵͳ]%s(%d)�ѷǳ��潻ͨ���ߴ��͵�������,��ץȥ�װ෿",pName(playerid),playerid);
		}
		case erule_driveby:{
			SetPlayerHealth(playerid,0);
			wl_ruleop_setPlayerJail(playerid,true,30);
			System_sendAll("[ϵͳ]%s(%d)��ɱ,��ץȥ�װ෿",pName(playerid),playerid);
		}
		case erule_pdmweapon:{
			PDM_outdm_start(playerid);
			wl_ruleop_setPlayerJail(playerid,true,30);
			System_sendAll("[ϵͳ]%s(%d)ӵ�з�dm����,��ץȥ�װ෿",pName(playerid),playerid);
		}
		case erule_pdmweaponout:{
			//PDM_outdm_start(playerid);
			//wl_ruleop_setPlayerJail(playerid,true,30);
			PDM_setPlayerToDMArea(playerid,PDM_getPlayerDM(playerid));
			System_send(playerid,"[ϵͳ]�벻Ҫ���԰�dm��������ȥ!");
		}
		case erule_weapon:{
			wl_ruleop_setPlayerJail(playerid,true,30);
			System_send(playerid,"[ϵͳ]�ڴ����粻�����г�����������.");
			System_sendAll("[ϵͳ]%s(%d)�ڴ�����ӵ�зǷ�����,��ץȥ�װ෿",pName(playerid),playerid);
		}
		case erule_possiblecheat:{
			loopPlayer(i){
				if(GetPlayerAdminLevel(playerid) >= 1){
					System_send(i,"[ϵͳ]%s(%d)���ھ����淨�����׵�����(beta).",pName(playerid),playerid);
				}
			}
			//wl_ruleop_setPlayerJail(playerid,true,30);
		}
	}
	return true;
}

forward wl_ruleop_PossibleCheat(playerid,info[]);
public wl_ruleop_PossibleCheat(playerid,info[]){
	if(CallLocalFunction("dmw_getPlayer","i",playerid)){
		if(!strcmp(info,"Weapon Hack in DMworld")){
			System_send(playerid,"[ϵͳ]������������Υ������Ϸ����(ԭ��:%s),��������,�뵽wl.gtabbs.com��������������Ͷ��",info);
			ResetPlayerWeapons(playerid);
			SetPlayerHealth(playerid,0);
			SetPlayerPos(playerid,pX(playerid),pY(playerid),pZ(playerid)+5);
			CallLocalFunction("dmw_getPlayer","i",playerid);
			Kick(playerid);
		}
		else if(!strcmp(info,"Possible Speed Hack in DMworld")){
			SetPlayerHealth(playerid,0);
			SetPlayerPos(playerid,pX(playerid),pY(playerid),pZ(playerid)+5);
			System_send(playerid,"[ϵͳ]������������Υ������Ϸ����(ԭ��:%s),��������,�뵽wl.gtabbs.com��������������Ͷ��",info);
		}
		else if(!strcmp(info,"Armour Hack")){
			SetPlayerHealth(playerid,0);
			SetPlayerPos(playerid,pX(playerid),pY(playerid),pZ(playerid)+5);
			System_send(playerid,"[ϵͳ]������������Υ������Ϸ����(ԭ��:%s),��������,�뵽wl.gtabbs.com��������������Ͷ��",info);
		}
		else if(!strcmp(info,"Health Hack")){
			SetPlayerHealth(playerid,0);
			SetPlayerPos(playerid,pX(playerid),pY(playerid),pZ(playerid)+5);
			System_send(playerid,"[ϵͳ]������������Υ������Ϸ����(ԭ��:%s),��������,�뵽wl.gtabbs.com��������������Ͷ��",info);
		}
		else if(!strcmp(info,"Teleport Hack")){
			if(!CallLocalFunction("Spec_isPlayerSpecing","i",playerid)){
				SetPlayerHealth(playerid,0);
				SetPlayerPos(playerid,pX(playerid),pY(playerid),pZ(playerid)+5);
				System_send(playerid,"[ϵͳ]������������Υ������Ϸ����(ԭ��:%s),��������,�뵽wl.gtabbs.com��������������Ͷ��",info);
			}
		}
	}
	/*
	else {
		System_sendAll("%s(%d) cheat (%s)",pName(playerid),playerid,info);
	}
	*/
	/*
	if(dmw:getPlayer(playerid)){
		System_send(playerid,"[ϵͳ]����������������,��ץȥ�װ෿(ԭ��:%s),������ץ,�뵽wl.gtabbs.com��������������Ͷ��",info);
		if(GetPlayerAdminLevel(playerid) <= 0){
			OnPlayerBreakRule(playerid,erule_possiblecheat);
		}
		else {
			System_send(playerid,"[ϵͳ]����,GM������!");
		}
		//todo
		SetPVarInt(playerid,"wl_ruleop_player_possible_rulebreak",true);
		SetPVarString(playerid,"wl_ruleop_player_rulebreak_info",info);
	}
	*/
	return true;
}

forward wl_ruleop_setPlayerJail(playerid,set,second);
public wl_ruleop_setPlayerJail(playerid,set,second){
	if(set){
		KillTimer(GetPVarInt(playerid,"wl_ruleop_player_JailTimer"));
		SetPVarInt(playerid,"wl_ruleop_player_JailTimer",SetTimerEx("wl_ruleop_setPlayerJail",second*1000,false,"iii",playerid,false,false));
		wl_ruleop_spBreakRule(playerid,true);
		SetPlayerVirtualWorld(playerid,WORLD_JAIL);
		SetPlayerPos(playerid,1271.1410,-1254.5160,14.1928);
		SetPlayerWorldBounds(playerid,1292.6895,1285.0641,-1213.2524,-1252.3297);
		
		ResetPlayerWeapons(playerid);
		SetPlayerArmour(playerid,100);
		SetPlayerHealth(playerid,100);
		GivePlayerWeapon(playerid,WEAPON_KATANA,1);
		GivePlayerWeapon(playerid,WEAPON_DEAGLE,9999);
		GivePlayerWeapon(playerid,WEAPON_SHOTGSPA,9999);
		GivePlayerWeapon(playerid,WEAPON_MP5,9999);
		GivePlayerWeapon(playerid,WEAPON_M4,9999);
		GivePlayerWeapon(playerid,WEAPON_SNIPER,9999);
		GivePlayerWeapon(playerid,WEAPON_GRENADE,9999);
		GivePlayerWeapon(playerid,WEAPON_FIREEXTINGUISHER,9999);
		GivePlayerWeapon(playerid,WEAPON_FLOWER,1);
		GivePlayerWeapon(playerid,WEAPON_PARACHUTE,1);
		
		System_send(playerid,"[ϵͳ]�㱻ץ������,%d����Զ��ų�",second);
	}else{
		KillTimer(GetPVarInt(playerid,"wl_ruleop_player_JailTimer"));
		wl_ruleop_spBreakRule(playerid,false);
		SetPlayerHealth(playerid,0);
		SetPlayerVirtualWorld(playerid,0);
		SetPlayerWorldBounds(playerid,9999,-9999,9999,-9999);
		System_send(playerid,"[ϵͳ]�������!�������ϸ�����",second);
	}
}

/*
new stock
	g_splitcmd[5][MAX_MSG_STR];
#define cmd_(%1) g_splitcmd[(%1)-1]
#define compare(%1,%2) !strcmp(%1,g_splitcmd[(%2)-1],true)
#define zcmd_advused() sscanf(params,"sssss",g_splitcmd[0],g_splitcmd[1],g_splitcmd[2],g_splitcmd[3],g_splitcmd[4]);
*/
zcmd(jail,playerid,params[]){
	if(GetPlayerAdminLevel(playerid) < 2){
		System_send(playerid,"[ϵͳ]����Ȩʹ�ø�����!");
		return true;
	}
	zcmd_advused();
	new
		jailee = IsNumeric(cmd_(1))?strval(cmd_(1)):INVALID_PLAYER_ID,
		second = strval(cmd_(2));
	if(!IsPlayerConnected(jailee) || IsPlayerNPC(jailee)){
		System_send(playerid,"[ϵͳ]���������Ҳ��Ϸ�!");
		return true;
	}
	if(!second){
		System_send(playerid,"[ϵͳ]�������ʱ�䲻�Ϸ�!");
		return true;
	}
	if(isnull(cmd_(3))){
		System_send(playerid,"[ϵͳ]ʹ�÷���:/jail [���id] [ʱ��:��] [ԭ��]!");
		return true;
	}
	if(wl_ruleop_gpBreakRule(jailee)){
		System_send(playerid,"[ϵͳ]������Ѿ��ڼ�����");
		return true;
	}
	wl_ruleop_setPlayerJail(jailee,true,second);
	System_send(playerid,"[ϵͳ]��ץ%s(%d)������,%d����Զ��ų�",pName(jailee),jailee,second);
	System_send(jailee,"[ϵͳ]�㱻%s(%d)ץ������,%d����Զ��ų�",pName(playerid),playerid,second);
	
	return true;
}

















