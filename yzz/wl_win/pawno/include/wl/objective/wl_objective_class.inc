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











wl_objective_class_struction(){
	if(!fexist("wl/classmodel.ini")){
		printf(" Class model loaded failed, 'wl/classmodel.ini' does not exist.");
		return false;
	}
	new
		File:ofile = fopen("wl/classmodel.ini",io_read),
		rstr[MAX_FILE_STR],
		classmodelamount,line;
	while(fread(ofile,rstr)){
		new
			modelid,Float:x,Float:y,Float:z,Float:angle,interior;
		line++;
		if(!sscanf(rstr,"p,iffffi",modelid,x,y,z,angle,interior)){
			AddPlayerClass(modelid,x,y,z,angle,0,0,0,0,0,0);
			classmodelamount++;
		}
		else {
		}
	}
	fclose(ofile);
	printf(" Class model loaded successfully, amount: %d",classmodelamount);
	return true;
	/*
	for(new i,j = sizeof(wl_s_obj_classInfo);i < j;i++){
		AddPlayerClass(
			wl_s_obj_classInfo[i][e_wl_obj_class_id],
			wl_s_obj_classInfo[i][e_wl_obj_class_x],
			wl_s_obj_classInfo[i][e_wl_obj_class_y],
			wl_s_obj_classInfo[i][e_wl_obj_class_z],
			wl_s_obj_classInfo[i][e_wl_obj_class_angle],
			0,0,0,0,0,0
		);
	}
	*/
}


wl_objective_class_RequestClass(playerid,classid){
	#pragma unused classid
	SetPlayerCameraLookAt(playerid,403.8559,2441.9685,16.5000);
	SetPlayerCameraPos(playerid,407.7084,2437.0693,16.5229);
	SetPlayerPos(playerid,403.8559,2441.9685,16.5000);
	//SetCameraBehindPlayer(playerid);
	//SetPlayerFacingAngle(playerid,180);
	
	
	/*
	new
		Float:tmpx = wl_s_obj_classInfo[classid][e_wl_obj_class_x],
		Float:tmpy = wl_s_obj_classInfo[classid][e_wl_obj_class_y],
		Float:tmpz = wl_s_obj_classInfo[classid][e_wl_obj_class_z],
		Float:tmpa = wl_s_obj_classInfo[classid][e_wl_obj_class_angle];
	SetPlayerInterior(playerid,wl_s_obj_classInfo[classid][e_wl_obj_class_interior]);
	SetPlayerPos(
		playerid,
		wl_s_obj_classInfo[classid][e_wl_obj_class_x],
		wl_s_obj_classInfo[classid][e_wl_obj_class_y],
		wl_s_obj_classInfo[classid][e_wl_obj_class_z]
	);
	SetPlayerFacingAngle(playerid,180-tmpa);
	SetPlayerCameraLookAt(playerid,tmpx,tmpy,tmpz);
	getBackfrontXY(tmpx,tmpy,tmpa,4.0);
	SetPlayerCameraPos(playerid,tmpx,tmpy,tmpz);
	*/
}







































































