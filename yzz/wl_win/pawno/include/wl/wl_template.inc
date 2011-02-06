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



#include <wl\template\weathertime>
#include <wl\template\score>
//#include <wl\template\punishKill>
#include <wl\template\forcespam>
#include <wl\template\armedbody>
#include <wl\template\weaponset>
#include <wl\template\others>



wl_tmp_GameModeInit(){
	wl_tmp_wt_Struction();
	wl_tmp_fm_Struct();
	Pause_struction();
	score_Sturction();
	return true;
}

wl_tmp_PlayerConnect(playerid){
	wl_tmp_wt_PlayerConnect(playerid);
	score_PlayerConnect(playerid);
	return true;
}

wl_tmp_PlayerDisconnect(playerid){
	wl_tmp_o_PlayerDisconnect(playerid);
	return true;
}

wl_tmp_PlayerSpawn(playerid){
	wl_tmp_wt_PlayerSpawn(playerid);
	wl_tmp_o_PlayerSpawn(playerid);
	weaponset_playerSpawn(playerid);
	return true;
}

wl_tmp_PlayerDeath(playerid,killerid){
	score_PlayerDeath(playerid,killerid);
	return true;
}

wl_tmp_PlayerText(playerid,text[]){
	if(wl_tmp_fm_PlayerText(playerid,text))return true;
	return false;
}

wl_tmp_PlayerPrivmsg(playerid,recieverid,text[]){
	if(wl_tmp_fm_PlayerPrivmsg(playerid,recieverid,text))return true;
	return false;
}

wl_tmp_PlayerRequestSpawn(playerid){
	wl_tmp_o_PlayerRequestSpawn(playerid);
	return true;
}



wl_tmp_DialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	#pragma unused inputtext
	Fightsytle_DialogResponse(playerid, dialogid, response, listitem);
	weaponset_DialogResponse(playerid, dialogid, response, listitem);
}

wl_tmp_PlayerUpdate(playerid){
	Pause_OnPlayerUpdate(playerid);
	armedbody_playerUpdate(playerid);
}

wl_tmp_playerText(playerid){
	Pause_OnPlayerText(playerid);
}

wl_tmp_playerCommandText(playerid){
	Pause_OnPlayerCommandText(playerid);
}

wl_tmp_playerStateChange(playerid){
	Pause_OnPlayerStateChange(playerid);
}
wl_tmp_playerKeyStateChange(playerid){
	Pause_OnPlayerKeyStateChange(playerid);
}





























