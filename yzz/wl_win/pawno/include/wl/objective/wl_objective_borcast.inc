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


//#include <wl\objective\wl_objective_borcast_h>

#define COLOR_BORCAST_WARNNING	(COLOR_WARNING)
#define COLOR_BORCAST_TIP		(COLOR_TIP)
#define COLOR_BORCAST_STUDY		(COLOR_STUDY)


#define BORCAST_TIME			(90)//second(s)


enum {
	e_objective_borcast_warning,
	e_objective_borcast_tip,
	e_objective_borcast_study,
	e_objective_borcast_amount
};

static stock
	wl_s_obj_borcast_type;

wl_objective_borcast_struction(){
	wl_objective_borcast_init();
	SetTimer("wl_objective_borcast_run",1000*BORCAST_TIME,1);
}

wl_objective_borcast_init(){
	new
		wl_borcast_warning_amount,
		wl_borcast_study_amount,
		wl_borcast_tip_amount,
		File:ofile,
		rstr[MAX_MSG_STR],
		hstr[MAX_MSG_STR],
		line;

	if(!fexist("wl/borcast_warning.ini")){
		printf(" ����㲥Warning����,wl/borcast_warning.ini ������");
		return;
	}
	ofile = fopen("wl/borcast_warning.ini",io_read);
	line = 1;
	while(fread(ofile,rstr)){
		if(!sscanf(rstr,"s",hstr)){
			stripNewLine(hstr);
			SetGVarString("wl_borcast_warning",hstr, .id = wl_borcast_warning_amount);
			wl_borcast_warning_amount++;
		} 
		else {
			printf("  �㲥Warning��������ʧ�ܣ�������:%d",line);
		}
	}
	SetGVarInt("wl_borcast_warning_Amount",wl_borcast_warning_amount);
	fclose(ofile);
	printf(" �㲥Warning����ɹ�,����:%d",wl_borcast_warning_amount);

	//

	if(!fexist("wl/borcast_tip.ini")){
		printf(" ����㲥Tip����,wl/borcast_tip.ini ������");
		return;
	}
	ofile = fopen("wl/borcast_tip.ini",io_read);
	line = 1;
	while(fread(ofile,rstr)){
		if(!sscanf(rstr,"s",hstr)){
			stripNewLine(hstr);
			SetGVarString("wl_borcast_tip",hstr, .id = wl_borcast_tip_amount);
			wl_borcast_tip_amount++;
		} 
		else {
			printf("  �㲥Tip��������ʧ�ܣ�������:%d",line);
		}
	}
	SetGVarInt("wl_borcast_tip_Amount",wl_borcast_tip_amount);
	fclose(ofile);
	printf(" �㲥Tip����ɹ�,����:%d",wl_borcast_tip_amount);
	//

	if(!fexist("wl/borcast_study.ini")){
		printf(" ����㲥Study����,wl/borcast_study.ini ������");
		return;
	}
	ofile = fopen("wl/borcast_study.ini",io_read);
	line = 1;
	while(fread(ofile,rstr)){
		if(!sscanf(rstr,"s",hstr)){
			stripNewLine(hstr);
			SetGVarString("wl_borcast_study",hstr, .id = wl_borcast_study_amount);
			wl_borcast_study_amount++;
		} 
		else {
			printf("  �㲥Study��������ʧ�ܣ�������:%d",line);
		}
	}
	SetGVarInt("wl_borcast_study_Amount",wl_borcast_study_amount);
	fclose(ofile);
	printf(" �㲥Study����ɹ�,����:%d",wl_borcast_study_amount);

}

forward wl_objective_borcast_run();
public wl_objective_borcast_run(){
	new
		borcast[MAX_MSG_STR];
	switch((wl_s_obj_borcast_type++)%4){
		case e_objective_borcast_warning:{
			GetGVarString("wl_borcast_warning",borcast, .id = random(GetGVarInt("wl_borcast_warning_Amount")));
			SendClientMessageToAll(COLOR_BORCAST_WARNNING,borcast);
		}
		case e_objective_borcast_tip:{
			GetGVarString("wl_borcast_tip",borcast, .id = random(GetGVarInt("wl_borcast_tip_Amount")));
			SendClientMessageToAll(COLOR_BORCAST_TIP,borcast);
		}
		case e_objective_borcast_study:{
			GetGVarString("wl_borcast_study",borcast, .id = random(GetGVarInt("wl_borcast_study_Amount")));
			SendClientMessageToAll(COLOR_BORCAST_STUDY,borcast);
		}
	}
}