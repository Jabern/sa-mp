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



dmw:textdraw_playerConnect(playerid){
	pGangZoneInfo[playerid] = TextDrawCreate(497.000000, 97.000000, "Gang - Zone");
	//TextDrawBackgroundColor(pGangZoneInfo[playerid], 65535);
	TextDrawFont(pGangZoneInfo[playerid], 1);
	TextDrawLetterSize(pGangZoneInfo[playerid], 0.200000, 1.900000);
	TextDrawColor(pGangZoneInfo[playerid], 16777215);
	TextDrawSetOutline(pGangZoneInfo[playerid], 0);
	TextDrawSetProportional(pGangZoneInfo[playerid], 1);
	TextDrawSetShadow(pGangZoneInfo[playerid], 1);
}
dmw:textdraw_playerDisconnect(playerid){
	TextDrawDestroy(pGangZoneInfo[playerid]);
}
dmw:textdraw_enterZone(playerid,zoneid){
	new
		outputstr[MAX_MSG_STR];
	format(outputstr,sizeof(outputstr),"%s - %s",gang:getGangName(zone:getZoneOwner(zoneid)),zone:getZoneName(zoneid));
	TextDrawColor(pGangZoneInfo[playerid],CallLocalFunction("dmw_getGangZoneColorByPlrGang","ii",playerid,zone:getOwnedGang(zoneid)));
	TextDrawSetString(pGangZoneInfo[playerid],outputstr);
	TextDrawShowForPlayer(playerid,pGangZoneInfo[playerid]);
}
dmw:textdraw_leaveZone(playerid){
	TextDrawHideForPlayer(playerid,pGangZoneInfo[playerid]);
}