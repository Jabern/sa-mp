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



enum {
	vw_playmode_base_start_none,
	vw_playmode_base_start_making,
	vw_playmode_base_start_started,
	vw_playmode_base_start_amount
}

enum {
	vw_base_end_none,
	vw_base_end_attackwin,
	vw_base_end_defencewin,
	vw_base_end_accident,
	vw_base_end_exit,
	vw_base_end_amount
}


static const stock
	gvw_base_time = 60 * 5;



//disconnect:
vw_base_playerDisconnect(playerid){
	if(GetPVarInt(playerid,"i_wl_vw_base_start")){
		vw_endBase(playerid,vw_base_end_accident);
	}
}


vw_base_playerDeath(playerid,killerid,reason){
	#pragma unused killerid,reason
	if(GetPVarInt(playerid,"i_wl_vw_base_id")){
		//if(!strcmp(GetPVarInt(playerid,"s_wl_vw_base_team"),"attack")){
		//if(GetPVarInt(playerid,"i_wl_vw_base_id") == vw_getFromstr(pName(playerid))){
			DisablePlayerCheckpoint(playerid);
			ResetPlayerWeapons(playerid);
			loopPlayer(j){
				ShowPlayer(playerid,j);
			}
			pVar_delete(playerid,"i_wl_vw_base_id");
			//SetPVarInt(playerid,"i_wl_vw_base_id",0);
			pVar_delete(playerid,"s_wl_vw_base_team");
			//SetPVarString(playerid,"s_wl_vw_base_team","null");
		//}
	}
}

vw_base_playerEnterCheckpoint(playerid){
	if(!strcmp(GetPVarFloat(playerid,"s_wl_vw_base_team"),"attack")){//attacker enter cp
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT){//onfoot
			if(!GetPVarInt(vw_getPlayerfromvwid(GetPVarInt(playerid,"i_wl_vw_base_id")),"i_wl_vw_base_cptimeleft")){//countdown hasn't actived
				SetPVarInt(vw_getPlayerfromvwid(GetPVarInt(playerid,"i_wl_vw_base_id")),"i_wl_vw_base_cptimeleft",1);
				SetTimerEx("vw_attackerEnterbasecp",1000*1,false,"ii",GetPlayerVirtualWorld(playerid),playerid);
			}else VW_send(playerid,"[����-base]��Ķ������ڶ���");
		}else VW_send(playerid,"[����-base]���ں���϶���!");
	}
	else if(!strcmp(GetPVarFloat(playerid,"s_wl_vw_base_team"),"attack")){//defencer enter cp
		VW_send(playerid,"[����-base]����������õ���Զ����!");
	}
}	
	













forward vw_attackerEnterbasecp(baseid,enterplayerid);
public vw_attackerEnterbasecp(baseid,enterplayerid){
	if(!IsPlayerInCheckpoint(enterplayerid) || GetPlayerState(enterplayerid) != PLAYER_STATE_ONFOOT){
		vw_attackerLeavebasecp(baseid,enterplayerid);
		return;
	}
	new
		vwhostid = vw_getPlayerfromvwid(baseid),
		timeleft = GetPVarInt(vwhostid,"i_wl_vw_base_cptimeleft");
	if(timeleft > 30){
		vw_endBase(vwhostid,enterplayerid);
	}else{
		new
			tmpstr1[MAX_MSG_STR],
			tmpstr2[MAX_MSG_STR];
		format(tmpstr1,sizeof(tmpstr1),"[����-base]���������ڶ���,��ʣ��%d��!",30-timeleft);
		format(tmpstr2,sizeof(tmpstr2),"[����-base]�������ڶ���,��ʣ��%d��!",30-timeleft);
		loopPlayer(i){
			if(GetPVarInt(i,"i_wl_vw_base_id") == baseid){
				if(!strcmp(GetPVarFloat(i,"s_wl_vw_base_team"),"defence")){
					VW_send(i,tmpstr1);
				}else if(!strcmp(GetPVarFloat(i,"s_wl_vw_base_team"),"attack")){
					VW_send(i,tmpstr2);
				}
			}
		}
	}
	SetPVarInt(vwhostid,"i_wl_vw_base_cptimeleft",GetPVarInt(vwhostid,"i_wl_vw_base_cptimeleft")+1);
	SetTimerEx("vw_attackerEnterbasecp",1000*1,false,"i",baseid);
}

forward vw_attackerLeavebasecp(baseid,enterplayerid);
public vw_attackerLeavebasecp(baseid,enterplayerid){
	#pragma unused enterplayerid
	new
		vwhostid = vw_getPlayerfromvwid(baseid);
	SetPVarInt(vwhostid,"i_wl_vw_base_cptimeleft",0);
	loopPlayer(i){
		if(GetPVarInt(i,"i_wl_vw_base_id") == baseid){
			VW_send(i,"[����-base]�������������ж���������");
		}
	}
}


forward vw_loopBase(playerid);
public vw_loopBase(playerid){
	SetPVarInt(playerid,"i_wl_vw_base_timeCrack",GetPVarInt(playerid,"i_wl_vw_base_timeCrack")+1);
	if(gvw_base_time-GetPVarInt(playerid,"i_wl_vw_base_timeCrack") <= 0) vw_endBase(playerid,vw_base_end_defencewin);
	//VW_sendAll("[time]crack:%d left:%d a:",GetPVarInt(playerid,"i_wl_vw_base_timeCrack"),gvw_base_time-GetPVarInt(playerid,"i_wl_vw_base_timeCrack"),gvw_base_time);
}

forward vw_startBase(playerid);
public vw_startBase(playerid){
	SetPVarInt(playerid,"i_wl_vw_base_looptimer",SetTimerEx("vw_loopBase",1000,gvw_base_time,"ii",playerid,vw_base_end_defencewin));
	SetPVarInt(playerid,"i_wl_vw_base_timeCrack",0);
	loopPlayer(i){
		if(GetPVarInt(playerid,"i_wl_vw_base_id") == vw_getFromstr(pName(playerid))){
		//if(vw_isplayerInplayerWorld(i,playerid)){
			if(!strcmp(GetPVarFloat(i,"s_wl_vw_base_team"),"defence")){
				SetPlayerCheckpoint(i,GetPVarFloat(playerid,"f_wl_vw_base_cpx"),GetPVarFloat(playerid,"f_wl_vw_base_cpy"),GetPVarFloat(playerid,"f_wl_vw_base_cpz"),2);
				TeleportPlayer(i,GetPVarFloat(playerid,"f_wl_vw_base_defencex")+random(5),GetPVarFloat(playerid,"f_wl_vw_base_defencey")+random(5),GetPVarFloat(playerid,"f_wl_vw_base_defencez")+2,random(65535),.ignoreVec = true);
				OnPlayerCommandText(i,"/ww getweapon");
				SetPlayerHealth(i,100);
				SetPlayerArmour(i,100);
				loopPlayer(j){
					if(!strcmp(GetPVarFloat(j,"s_wl_vw_base_team"),"defence")){
						ShowPlayer(i,j);
					}
					else if(!strcmp(GetPVarFloat(j,"s_wl_vw_base_team"),"attack")){
						HidePlayer(i,j);
					}
					else{
						HidePlayer(i,j);
					}
					//if(strcmp(GetPVarFloat(i,"s_wl_vw_base_team"),"defence")) HidePlayer(i,j);
					//else ShowPlayer(i,j);
				}
				VW_send(i,"[����-base]ȫ���ػ����5���ӣ�");
				VW_send(i,"[����-base]������վ�ں�㳬��30s,���Ǿ�ʧ����!");
			}else if(!strcmp(GetPVarFloat(i,"s_wl_vw_base_team"),"attack")){
				SetPlayerCheckpoint(i,GetPVarFloat(playerid,"f_wl_vw_base_cpx"),GetPVarFloat(playerid,"f_wl_vw_base_cpy"),GetPVarFloat(playerid,"f_wl_vw_base_cpz"),2);
				TeleportPlayer(i,GetPVarFloat(playerid,"f_wl_vw_base_attackx")+random(5),GetPVarFloat(playerid,"f_wl_vw_base_attacky")+random(5),GetPVarFloat(playerid,"f_wl_vw_base_attackz")+2,random(65535),.ignoreVec = true);
				OnPlayerCommandText(i,"/ww getweapon");
				SetPlayerHealth(i,100);
				SetPlayerArmour(i,100);
				loopPlayer(j){
					if(!strcmp(GetPVarFloat(j,"s_wl_vw_base_team"),"attack")){
						ShowPlayer(i,j);
					}
					else if(!strcmp(GetPVarFloat(j,"s_wl_vw_base_team"),"defence")){
						HidePlayer(i,j);
					}
					else{
						HidePlayer(i,j);
					}
				}
				VW_send(i,"[����-base]ȫ���������!");
				VW_send(i,"[����-base]����վ�ں�㳬��30s��ʤ����!");
			}
		}
	}
}

forward vw_endBase(playerid,endmode);
public vw_endBase(playerid,endmode){
	//SendClientMessageToAll(COLOR_WHITE,"test");
	if(endmode == vw_base_end_defencewin) VW_sendAll("[����-base]��%s(%d)���е�base,���ط����ʤ��!",pName(playerid),playerid);
	else if(endmode == vw_base_end_attackwin) VW_sendAll("[����-base]��%s(%d)���е�base,���������ʤ��!",pName(playerid),playerid);
	else if(endmode == vw_base_end_accident){
		loopPlayer(i){
			if(GetPVarInt(playerid,"i_wl_vw_base_id") == vw_getFromstr(pName(playerid))){
				VW_send(i,"[����-base]��ٰ��˵��ߣ�base����ȡ����...");
			}
		}
	}
	else if(endmode == vw_base_end_exit){
		loopPlayer(i){
			if(GetPVarInt(playerid,"i_wl_vw_base_id") == vw_getFromstr(pName(playerid))){
				VW_send(i,"[����-base]�ٰ���ǿ�ƽ�����base...");
			}
		}
	}
	loopPlayer(i){
		if(GetPVarInt(i,"i_wl_vw_base_id") == vw_getFromstr(pName(playerid))){
			ResetPlayerWeapons(i);
			DisablePlayerCheckpoint(i);
			loopPlayer(j){
				ShowPlayer(i,j);
				//SetPlayerMarkerForPlayer(i,j,GetPlayerColor(j));
				//ShowPlayerNameTagForPlayer(i, j, true);
			}
			//SetPVarInt(playerid,"i_wl_vw_base_id",false);
			pVar_delete(playerid,"i_wl_vw_base_id");
			pVar_delete(playerid,"s_wl_vw_base_team")
			//SetPVarString(playerid,"s_wl_vw_base_team","null");
			//if(!strcmp(GetPVarFloat(i,"s_wl_vw_base_team"),"defence"){
		}
	}
	KillTimer(GetPVarInt(playerid,"i_wl_vw_base_looptimer"));
	KillTimer(GetPVarInt(playerid,"i_wl_vw_base_endtimer"));
	/*
	SetPVarInt(playerid,"i_wl_vw_base_timeCrack",0);
	SetPVarInt(playerid,"i_wl_vw_base_endtimer",false);
	SetPVarInt(playerid,"i_wl_vw_base_start",false);
	//pVar_delete(playerid,"s_wl_vw_base_startmode")
	SetPVarString(playerid,"s_wl_vw_base_startmode","null");
	SetPVarFloat(playerid,"f_wl_vw_base_cpx",0);
	SetPVarFloat(playerid,"f_wl_vw_base_cpy",0);
	SetPVarFloat(playerid,"f_wl_vw_base_cpz",0);
	SetPVarFloat(playerid,"f_wl_vw_base_defencex",0);
	SetPVarFloat(playerid,"f_wl_vw_base_defencey",0);
	SetPVarFloat(playerid,"f_wl_vw_base_defencez",0);
	SetPVarFloat(playerid,"f_wl_vw_base_attackx",0);
	SetPVarFloat(playerid,"f_wl_vw_base_attacky",0);
	SetPVarFloat(playerid,"f_wl_vw_base_attackz",0);
	SetPVarInt(playerid,"i_wl_vw_base_cptimeleft",0);	
	*/
	
	pVar_delete(playerid,"i_wl_vw_base_timeCrack");
	pVar_delete(playerid,"i_wl_vw_base_endtimer");
	pVar_delete(playerid,"i_wl_vw_base_start");
	pVar_delete(playerid,"s_wl_vw_base_startmode");
	pVar_delete(playerid,"f_wl_vw_base_cpx");
	pVar_delete(playerid,"f_wl_vw_base_cpy");
	pVar_delete(playerid,"f_wl_vw_base_cpz");
	pVar_delete(playerid,"f_wl_vw_base_defencex");
	pVar_delete(playerid,"f_wl_vw_base_defencey");
	pVar_delete(playerid,"f_wl_vw_base_defencez");
	pVar_delete(playerid,"f_wl_vw_base_attackx");
	pVar_delete(playerid,"f_wl_vw_base_attacky");
	pVar_delete(playerid,"f_wl_vw_base_attackz");
	pVar_delete(playerid,"i_wl_vw_base_cptimeleft");
	//SendClientMessageToAll(COLOR_WHITE,"test");
	return true;
}



zcmd(wl_vw_base,playerid,params[]){
	zcmd_advused();
	if(isnull(cmd_(1))){
		VW_send(playerid,"[����-base]����/b set ����base");
		VW_send(playerid,"[����-base]����/b join �μ�base");
		VW_send(playerid,"[����-base]����/b time �鿴baseʣ��ʱ��");
		VW_send(playerid,"[����-base]����/b end ǿ�ƽ���base");
	}
	else if(compare("end",1)){
		if(GetPVarInt(playerid,"i_wl_vw_base_start")){
			if(GetPVarInt(playerid,"i_wl_vw_base_id") == vw_getFromstr(pName(playerid))){
				VW_send(playerid,"[����-base]��ǿ�ƽ�����base");
				vw_endBase(playerid,vw_base_end_exit);
			}else{
				VW_send(playerid,"[����-base]��ֻ�ܽ���ר�������base");
			}
		}else{
			VW_send(playerid,"[����-base]�㲢û�о���base");
		}
	}
	else if(compare("time",1)){
		if(GetPVarInt(playerid,"i_wl_vw_base_id")){
			new
				hostid = vw_getPlayerfromvwid(GetPVarInt(playerid,"i_wl_vw_base_id"));
			VW_send(playerid,"[����-base]baseʣ��ʱ��:%d��",gvw_base_time-GetPVarInt(hostid,"i_wl_vw_base_timeCrack"));
		}else{
			VW_send(playerid,"[����-base]�㲻��base��");
		}
	}
	else if(compare("set",1)){
		if(!vw_isplayerInplayerWorld(playerid,playerid)){
			VW_send(playerid,"[����-base]�뵽ר�����翪��base(����/ww���ɵ���ר������)");
			return true;
		}
		if(GetPVarInt(playerid,"i_wl_vw_base_start")){
			VW_send(playerid,"[����-base]���Ѿ�����base��");
			return true;
		}
		if(!pVar_exist(playerid,"s_wl_vw_base_startmode")){
			SetPVarString(playerid,"s_wl_vw_base_startmode","vw_playmode_base_start_setcp");
			VW_send(playerid,"[����-base]�㿪ʼ����һ����ʱbase");
			VW_send(playerid,"[����-base]�������ػ���(�ߵ��ػ���λ��,����/b set ���趨��λ��Ϊ�ػ���)");
			new
				tmpstr[MAX_MSG_STR];
			format(tmpstr,MAX_MSG_STR,"[��ǰ����]%s(%d)��ʼ����һ����ʱbase",pName(playerid),playerid);
			loopPlayer(i){
				if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)){
					VW_send(i,tmpstr);
				}
			}
			//VW_sendIn(playerid,"[��ǰ����]%s(%d)��ʼ����һ����ʱbase",pName(playerid),playerid);
		}
		else if(!strcmp(GetPVarFloat(playerid,"s_wl_vw_base_startmode"),"vw_playmode_base_start_setcp")){
			SetPVarString(playerid,"s_wl_vw_base_startmode","vw_playmode_base_start_setdefence");
			SetPVarFloat(playerid,"f_wl_vw_base_cpx",pX(playerid));
			SetPVarFloat(playerid,"f_wl_vw_base_cpy",pY(playerid));
			SetPVarFloat(playerid,"f_wl_vw_base_cpz",pZ(playerid));
			VW_send(playerid,"[����-base]���������ػ���");
			VW_send(playerid,"[����-base]�����÷��ط�������(�ߵ����ط�������λ�ã�����/b set ����)");
			VW_send(playerid,"[����-base]ע���������ΧҪ�ȽϿտ�");
		}
		else if(!strcmp(GetPVarFloat(playerid,"s_wl_vw_base_startmode"),"vw_playmode_base_start_setdefence")){
			SetPVarString(playerid,"s_wl_vw_base_startmode","vw_playmode_base_start_setattack");
			SetPVarFloat(playerid,"f_wl_vw_base_defencex",pX(playerid));
			SetPVarFloat(playerid,"f_wl_vw_base_defencey",pY(playerid));
			SetPVarFloat(playerid,"f_wl_vw_base_defencez",pZ(playerid));
			VW_send(playerid,"[����-base]�������˷��ط�������");
			VW_send(playerid,"[����-base]�����ý�����������(�ߵ�������������λ�ã�����/b set ����)");
			VW_send(playerid,"[����-base]ע���������ΧҪ�ȽϿտ�");
		}
		else if(!strcmp(GetPVarFloat(playerid,"s_wl_vw_base_startmode"),"vw_playmode_base_start_setattack")){
			SetPVarInt(playerid,"i_wl_vw_base_start",true);
			pVar_delete(playerid,"s_wl_vw_base_startmode");
			//SetPVarString(playerid,"s_wl_vw_base_startmode","null");
			SetPVarFloat(playerid,"f_wl_vw_base_attackx",pX(playerid));
			SetPVarFloat(playerid,"f_wl_vw_base_attacky",pY(playerid));
			SetPVarFloat(playerid,"f_wl_vw_base_attackz",pZ(playerid));
			SetTimerEx("vw_startBase",1000*30,false,"i",playerid);
			VW_send(playerid,"[����-base]�������˽�����������");
			new
				tmpstr[MAX_MSG_STR];
			format(tmpstr,MAX_MSG_STR,"[��ǰ����]%s(%d)������ʱbase���,��ѡ�����,30����Զ���ʼ!",pName(playerid),playerid);
			loopPlayer(i){
				if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)){
					VW_send(i,tmpstr);
					VW_send(i,"[����-base]����/b join attack ���빥����");
					VW_send(i,"[����-base]����/b join defence ������ط�");
				}
			}
			//VW_sendIn(playerid,"[��ǰ����]%s(%d)������ʱbase���,30����Զ���ʼ!",pName(playerid),playerid);
		}
	}
	else if(compare("help",1)){
		VW_send(playerid,"[����-base]����/b set ����base");
		VW_send(playerid,"[����-base]����/b join �μ�base");
		VW_send(playerid,"[����-base]����/b time �鿴baseʣ��ʱ��");
		VW_send(playerid,"[����-base]����/b end ǿ�ƽ���base");
	}
	else if(compare("join",1)){
		new
			starterid = vw_getPlayerfromvwid(GetPlayerVirtualWorld(playerid));
		if(IsPlayerConnected(starterid) && GetPVarInt(starterid,"i_wl_vw_base_start")){
			if(compare("attack",2)){
				SetPVarInt(playerid,"i_wl_vw_base_id",GetPlayerVirtualWorld(playerid));
				SetPVarString(playerid,"s_wl_vw_base_team","attack");
				VW_send(playerid,"[����-base]������˹�����");
				new
					tmpstr[MAX_MSG_STR];
				format(tmpstr,MAX_MSG_STR,"[����-base]%s(%d)�����˹�����,!",pName(playerid),playerid);
				loopPlayer(i){
					if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)){
						VW_send(i,tmpstr);
					}
				}
			}
			else if(compare("defence",2)){
				SetPVarInt(playerid,"i_wl_vw_base_id",GetPlayerVirtualWorld(playerid));
				SetPVarString(playerid,"s_wl_vw_base_team","defence");
				VW_send(playerid,"[����-base]������˷��ط�");
				new
					tmpstr[MAX_MSG_STR];
				format(tmpstr,MAX_MSG_STR,"[����-base]%s(%d)�����˷��ط�,!",pName(playerid),playerid);
				loopPlayer(i){
					if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)){
						VW_send(i,tmpstr);
					}
				}
			}
			else{
				VW_send(playerid,"[����-base]������Ķ��鲻����");
				VW_send(playerid,"[����-base]����/b join attack ���빥����");
				VW_send(playerid,"[����-base]����/b join defence ������ط�");
				
			}
		}
		else{
			VW_send(playerid,"[����-base]������û����ʱbase");
		}
	}
	else{
		VW_send(playerid,"[����-base]��������������");
		VW_send(playerid,"[����-base]����/b set ����base");
		VW_send(playerid,"[����-base]����/b join �μ�base");
		VW_send(playerid,"[����-base]����/b time �鿴baseʣ��ʱ��");
		VW_send(playerid,"[����-base]����/b end ǿ�ƽ���base");
	}
	return true;
}

zcmd(base,playerid,params[]){return zcmd_wl_vw_base(playerid,params);}
zcmd(b,playerid,params[]){return zcmd_wl_vw_base(playerid,params);}