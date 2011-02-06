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


/*
#if defined gcs_main
	#endinput
#endif
#define gcs_main
*/
#include <a_samp>

//#include <gcs_debug>
#include <gcs/gcs_bugfix>
#include <gcs/gcs_uf>
#include <gcs/gcs_pVaradvanced>
//#include <gcs/gcs_sqladvanced>
//#include <gcs/gcs_ini>
//#include <gcs/gcs_gcmd>
#include <gcs/gcs_gcmd_tele>



#define COLOR_WHITE			(0xFFFFFFAA)
#define MAX_STRING			(128)	



gcs_GameModeInit(){
	gcs_bf_OnGameModeInit();
	//gini_struction();
	//gcmd_struction();
	return true;
}

gcs_PlayerConnect(playerid){
	gcs_bf_OnPlayerConnect(playerid);
	gcs_uf_OnPlayerConnect(playerid);
	return true;
}

gcs_PlayerDisconnect(playerid,reason){
	//gcs_bf_OnPlayerDisconnect(playerid);
	//PVadv_OnPlayerDisconnect(playerid);
	gcs_uf_OnPlayerDisconnect(playerid,reason);	
	return true;
}

gcs_PlayerDeath(playerid,killerid,reason){
	#pragma unused killerid,reason
	gcs_bf_OnPlayerDeath(playerid);
	return true;
}
/*
gcs_CommandText(playerid,cmdtext[]){
	#pragma unused playerid,cmdtext
	//gcmd_tele_insert();
	//gcmd_process();
	return true;
}
*/
gcs_PlayerSelectedMenu(playerid){
	#pragma unused playerid
	//gcs_bf_OnPlayerSelectedMenuRow(playerid);
	return true;
}

gcs_PlayerExitedMenu(playerid){
	#pragma unused playerid
	//gcs_bf_OnPlayerExitedMenu(playerid);
	return true;
}