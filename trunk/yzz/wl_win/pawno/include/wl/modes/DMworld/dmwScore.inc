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



dmwscore:struct(){
	{	
		db_processstart("ALTER TABLE gang_stat ADD COLUMN dmw_score INTEGER NOT NULL DEFAULT 0;");
		db_processthenfree(db_dmworld);
	}
	{
		db_processstart("SELECT id,dmw_score FROM gang_stat;");
		db_processthengetresult(db_dmworld);
		for(new i, j = db_num_rows(dbr), id[11], score[11]; i < j; i++){
			db_get_field_assoc(dbr,"id",id,sizeof(id));
			db_get_field_assoc(dbr,"dmw_score",score,sizeof(score));
			SetGVarInt("wl_gang_dmw_score",strval(score),strval(id));
			db_next_row(dbr);
		}
		db_processend();
	}
}
dmwscore:setGang(gangid,score){
	CallLocalFunction("OnGangdmwScoreChange","iii",gangid,GetGVarInt("wl_gang_dmw_score",gangid),score);
	SetGVarInt("wl_gang_dmw_score",score,gangid);
	db_processstart("UPDATE gang_stat SET dmw_score = %d WHERE id = %d",score,gangid);
	db_processthenfree(db_dmworld);	
	
}
dmwscore:getGang(gangid){
	return GetGVarInt("wl_gang_dmw_score",gangid);
}
dmwscore:setPlayerGang(playerid,score){
	if(gang:getPlayerGang(playerid) != INVALID_GANG_ID){
		dmwscore:setGang(gang:getPlayerGang(playerid),score);
	}
}
dmwscore:getPlayerGang(playerid){
	if(gang:getPlayerGang(playerid) != INVALID_GANG_ID){
		return dmwscore:getGang(gang:getPlayerGang(playerid));
	}
	return 0;
}
dmwscore:amountedPlayerGang(playerid,amounted){
	if(gang:getPlayerGang(playerid) != INVALID_GANG_ID){
		dmwscore:setGang(gang:getPlayerGang(playerid),dmwscore:getGang(gang:getPlayerGang(playerid))+amounted);
	}
}
dmwscore:playerDeath(playerid,killerid){
	if(dmw:getPlayer(playerid)){
		if(killerid != INVALID_PLAYER_ID && (gang:getPlayerGang(killerid) != gang:getPlayerGang(playerid)))dmwscore:amountedPlayerGang(playerid,1);
		if(gang:getPlayerGang(playerid) == INVALID_GANG_ID)return;
		if(killerid != INVALID_PLAYER_ID && (gang:getPlayerGang(playerid) != gang:getPlayerGang(killerid))) dmwscore:amountedPlayerGang(playerid,5);
		if(killerid != INVALID_PLAYER_ID){
			gang:sendgang(gang:getPlayerGang(playerid),"dmw_playerdeath_playergang",pName(playerid),pName(killerid));
			gang:sendgang(gang:getPlayerGang(playerid),"dmw_playerdeath_killergang",pName(killerid),pName(playerid));
		}
		else {
			gang:sendgang(gang:getPlayerGang(playerid),"dmw_playerdeath_plyaergang_nonekiller",pName(playerid));
		}
	}
}
dmwscore:playerLogin(playerid){
	if(gang:getPlayerGang(playerid) != INVALID_GANG_ID){
		SetPlayerScore(playerid,dmwscore:getPlayerGang(playerid));
		GivePlayerMoney(playerid,(0-GetPlayerMoney(playerid))+(0-dmwscore:getPlayerGang(playerid)));
	}
}
dmwscore:OnGangdmwScoreChange(gangid,oldscore,newscore){
	#pragma unused oldscore
	loopPlayer(playerid){
		if(gang:getPlayerGang(playerid) == gangid){
			SetPlayerScore(playerid,newscore);
			GivePlayerMoney(playerid,(0 - GetPlayerMoney(playerid)) + (0 - newscore));
		}
	}
}