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





forward wl_tmp_forceSpam(playerid);

static stock
	wl_tmp_fm_Text[MAX_STRING];
	
public wl_tmp_forceSpam(playerid){
	wl_tmp_fm_setPlayerForce(playerid,false);
}

stock wl_tmp_fm_playerForcing(playerid){
	return wl_gPlr_forceSpaming(playerid);
}

stock wl_tmp_fm_setPlayerForce(playerid,bool:force){
	wl_sPlr_forceSpaming(playerid,force);
	return true;
}

fm_sameSentencecheck(playerid,text[]){
	static
		gfm_sameSentenstr1[MAX_PLAYERS][MAX_MSG_STR],
		gfm_sameSentenstr2[MAX_PLAYERS][MAX_MSG_STR];
	gfm_sameSentenstr2[playerid][0] = '\0';
	for(new i,j;text[i];i++){
		if(text[i] >= 32 && text[i] <= 126) continue;
		gfm_sameSentenstr2[playerid][j++] = text[i];
	}
	if(!gfm_sameSentenstr2[playerid][0] || !gfm_sameSentenstr1[playerid][0]){
		format(gfm_sameSentenstr1[playerid],MAX_MSG_STR,gfm_sameSentenstr2[playerid]);
		return true;
	}
	if(!strcmp(gfm_sameSentenstr1[playerid],gfm_sameSentenstr2[playerid])){
		format(gfm_sameSentenstr1[playerid],MAX_MSG_STR,gfm_sameSentenstr2[playerid]);
		return false;
	}
	format(gfm_sameSentenstr1[playerid],MAX_MSG_STR,gfm_sameSentenstr2[playerid]);
	
	return true;
}




	
stock wl_tmp_fm_playerForceCheck(playerid){
	if(wl_tmp_fm_playerForcing(playerid)){
		System_send(playerid,"[ע��] ��ˢ����̫�죬���ء�������");
		return true;
	}
	wl_tmp_fm_setPlayerForce(playerid,true);
	SetTimerEx("wl_tmp_forceSpam",1800,false,"i",playerid);
	return false;
}

stock wl_tmp_fm_formatPrivmsg(playerid,recieverid,text[]){
	if(IsPlayerConnected(recieverid)){
		//if(GetPVarInt(recieverid,"wl_player_msg_ban"))
		remindPlayerText(playerid,"~w~Private message ~r~Sent~w~to %s.",PlayerName(recieverid));
		remindPlayerText(recieverid,"~w~Private message ~r~Recieved~w~from %s.",PlayerName(playerid));
		format(wl_tmp_fm_Text,128,"      �������� %s(%d): %s",PlayerName(playerid),playerid,text);
		SendClientMessage(recieverid,COLOR_SYSTEM,wl_tmp_fm_Text);
		format(wl_tmp_fm_Text,128,"      ���﷢�͵� %s(%d): %s",PlayerName(recieverid),recieverid,text);
		SendClientMessage(playerid,COLOR_SYSTEM,wl_tmp_fm_Text);
		return true;
	}
	return false;
}

stock wl_tmp_fm_formatText(playerid,text[]){
	format(wl_tmp_fm_Text,128,"   %s(%d):%s",PlayerName(playerid),playerid,text);
	//SetPlayerChatBubble(playerid, text, GetPlayerColor(playerid), 40, 20000);
	SendClientMessageToAll(GetPlayerColor(playerid),wl_tmp_fm_Text);
	return true;
}


//=====================Abuse Sentence========================
#define MAX_ABUSE_SENTENCE_LENTH		(32)
fm_abuseCheck_Struct(){
   	new
		fstr[MAX_ABUSE_SENTENCE_LENTH], 
		File:file, 
		SensitiveWords_Amount = 1;
	if((file = fopen("wl/SensitiveWords.ini",io_read)))
	{
		while(fread(file,fstr))
		{
		    for(new i = 0, j = strlen(fstr); i < j; i++) if(fstr[i] == '\n' || fstr[i] == '\r') fstr[i] = '\0';
			SetGVarString("wl_SensitiveWords",fstr,SensitiveWords_Amount-1);
            SensitiveWords_Amount++;
		}
		SetGVarInt("wl_SensitiveWords_Amount",SensitiveWords_Amount);
		fclose(file);
	}
}

fm_abusedSentence(text[]){
	new
		SensitiveWords_Amount = GetGVarInt("wl_SensitiveWords_Amount"),
		SensitiveWords[MAX_ABUSE_SENTENCE_LENTH],
		SensitiveWords_pos,
		filterSentence[MAX_MSG_STR],
        filterSentence2[MAX_MSG_STR];
	for(new i,j;text[i];i++){
        if(text[i] == ' ') continue;
        filterSentence2[j++] = text[i];
    }
	format(filterSentence,sizeof(filterSentence),"%s",fm_filterSentenceUseless(text));
	//format(filterSentence,sizeof(filterSentence),"%s",fm_filterSentenceUseless(filterSentence));
	while(SensitiveWords_pos < SensitiveWords_Amount){
		GetGVarString("wl_SensitiveWords",SensitiveWords, .id = SensitiveWords_pos);
		if((strfind(filterSentence2,SensitiveWords) != -1) || (strfind(filterSentence,SensitiveWords) != -1)){
            return true;
        }
		SensitiveWords_pos++;
	}
	return false;
}
fm_filterSentenceUseless(text[]){
	new
		filterSentence[MAX_MSG_STR+10],
		filterSentence2[MAX_MSG_STR+10];
	//format(filterSentence,sizeof(filterSentence),"%s",text);
	for(new i,j;text[i];i++){
		if(text[i] < 32 || text[i] > 126){
			filterSentence[j++] = text[i];
		}
	}

	for(new i,j;filterSentence[i];i++){ // �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� ��
		if(filterSentence[i] == 163){
			switch(filterSentence[i+1]){
				case 172,187,191,186,161,164,168,169:{ i++;}
				default:{
					filterSentence2[j++] = filterSentence[i++];
					filterSentence2[j++] = filterSentence[i];
				}
			}
			
		}
		else if(filterSentence[i] == 161){
			switch(filterSentence[i+1]){
				case 163,162,182,183,175,174,177,176,164,173,170:{ i++;}
				default:{
					filterSentence2[j++] = filterSentence[i++];
					filterSentence2[j++] = filterSentence[i];
				}
			}
			
		}
		
		else if(filterSentence[i] >= 127){
			filterSentence2[j++] = filterSentence[i++];
			filterSentence2[j++] = filterSentence[i];
		}
		
		else {
			filterSentence2[j++] = filterSentence[i];
		}
	}
	return filterSentence2;
}


wl_tmp_fm_Struct(){
	fm_abuseCheck_Struct();
}

wl_tmp_fm_PlayerText(playerid,text[],other = false){
	if(fm_abusedSentence(text)){
		new
			randomstudy[MAX_MSG_STR];
		GetGVarString("wl_borcast_study",randomstudy, .id = random(GetGVarInt("wl_borcast_study_Amount")));
		SendClientMessage(playerid,COLOR_YELLOW,randomstudy);
		return true;
	}
	if(wl_tmp_fm_playerForceCheck(playerid))return true;
	if(!fm_sameSentencecheck(playerid,text)){
		System_send(playerid,"[ע��]�벻Ҫ���������Ƶ�����");
		return true;
	}
	if(other){
		format(wl_tmp_fm_Text,128,"   %s(%d):%s",pName(playerid),playerid,text);
		SendClientMessageToAll(GetPlayerColor(playerid),wl_tmp_fm_Text);
		return true;
	}
	if(!GetPlayerVirtualWorld(playerid)){
		format(wl_tmp_fm_Text,128,"   %s(%d):%s",pName(playerid),playerid,text);
		loopPlayer(i){
			//if(!GetPVarInt(i,"wl_mode_dmWorld_inworld")){
				SendClientMessage(i,GetPlayerColor(playerid),wl_tmp_fm_Text);
			//}
		}
	}
	else if(GetPVarInt(playerid,"wl_mode_dmWorld_inworld") || CallLocalFunction("dmw_isPlayerSpecDMW","i",playerid)){
		format(wl_tmp_fm_Text,128,"   [��ս��]%s(%d):%s",pName(playerid),playerid,text);
		loopPlayer(i){
			if(GetPVarInt(i,"wl_mode_dmWorld_inworld")){
				SendClientMessage(i,COLOR_WHITE,wl_tmp_fm_Text);
			}
		}
	}
	else {
		new
			vwid = GetPlayerVirtualWorld(playerid);
		format(wl_tmp_fm_Text,128,"   [��ǰ����]%s(%d):%s",pName(playerid),playerid,text);
		loopPlayer(i){
			if(GetPlayerVirtualWorld(i) == vwid){
				SendClientMessage(i,GetPlayerColor(playerid),wl_tmp_fm_Text);
			}
		}
	}
	return true;
	//if(wl_tmp_fm_formatText(playerid,text))return true;
	//return false;
}

wl_tmp_fm_PlayerPrivmsg(playerid,recieverid,text[]){
	if(wl_tmp_fm_formatPrivmsg(playerid,recieverid,text))return true;
	return false;
}










