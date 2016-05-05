% clear all
% clc
% close all
% load('car.mat');%%�������
%%������Բ��ֿ�ʼ
global HRtmp;
global ccdflag;
%%x�ᶨ��
x = 1:1:128;
%%��־λ����
tenrd_flag = 0;%%����ʮ��·
ML_flag = 0;%%�����߱�־
blackFlag = 0;%%�ڿ��־

global lostside1;
global lostside2;
global tenrd_flag1;
global ML_flag1;
global leftblack1;
global rightblack1;
global lefblk1;
global ritblk1;
global bankflag;
global blockflag;
global blockflag1;
global blockflag2;
global LEFT1;
global RIGHT1;
global LEFT2;
global RIGHT2;
global left_edge;
global right_edge;
global MidLine1;
global Nangle;
global left_flag;
global right_flag;

%% ��һ��ͼƬ�������������ż�CCD
%% �ڶ���ͼƬ�����������ܵ�����ʶ��
%% ͼƬ������
if ccdflag == 0
    %%��һ��CCD
    [MidLine1,leftblack1,rightblack1,blackFlag,ML_flag1,lefblk1,ritblk1,...
        tenrd_flag1,lostside1,blockflag] = ccd_data_process1(HRtmp);
    y1=MidLine1;
    y2=HRtmp(x);
    y3=leftblack1;
    y4=rightblack1;
else
    %%�ڶ���CCD
    [blockflag2,left_flag,right_flag,left_edge,right_edge,lostside2,LEFT2,RIGHT2,bankflag] = ccd_data_process2(HRtmp);
    y5=HRtmp(x);
    y6=left_edge;
    y7=right_edge;
end
%%��־������
%%90����
if lostside2%%CCD2�������ҵ��߲�����ͻ��
    
end
%%ʮ��·
if tenrd_flag1
    tenrd_flag = 1;
end

%%������ʾ����/���ݰ�ť��״̬��ʾ
str = get(handles.switchccd,'String');
if strcmp(str,'CCD1') && ccdflag == 0
    set (handles.Mid,'string',MidLine1,'BackgroundColor',[0.68,0.92,1]);
    if lefblk1 == 0
        set (handles.Left,'string',leftblack1,'BackgroundColor','yellow');
    else
        set (handles.Left,'string',leftblack1,'BackgroundColor',[0.68,0.92,1]);
    end
    if ritblk1 == 0
        set (handles.Right,'string',rightblack1,'BackgroundColor','yellow');
    else
        set (handles.Right,'string',rightblack1,'BackgroundColor',[0.68,0.92,1]);
    end
    if blackFlag==1
        set (handles.blablock,'string',blackFlag,'BackgroundColor','red');
    else
        set (handles.blablock,'string',blackFlag,'BackgroundColor',[0.68,0.92,1]);
    end
elseif strcmp(str,'CCD2') && ccdflag == 1
    set (handles.Mid, 'BackgroundColor',[0.94,0.94,0.94]);%%��ʾ��ɫ
    if left_flag == 0
        set (handles.Left,'string',left_edge,'BackgroundColor','yellow');
    else
        set (handles.Left,'string',left_edge,'BackgroundColor',[0.68,0.92,1]);
    end
    if right_flag == 0
        set (handles.Right,'string',right_edge,'BackgroundColor','yellow');
    else
        set (handles.Right,'string',right_edge,'BackgroundColor',[0.68,0.92,1]);
    end
    set (handles.blablock, 'BackgroundColor',[0.94,0.94,0.94]);%%��ʾ��ɫ
end
%%���������ͬ������
if Nangle == 1%%��ʮ�ȱ�־
    set (handles.ninty,'string',Nangle,'BackgroundColor','red');
else
    set (handles.ninty,'string',Nangle,'BackgroundColor',[0.68,0.92,1]);
end

if tenrd_flag == 1
    set (handles.tenrd,'string',tenrd_flag,'BackgroundColor','red');
else
    set (handles.tenrd,'string',tenrd_flag,'BackgroundColor',[0.68,0.92,1]);
end

if ML_flag1==1
    set (handles.midline,'string',ML_flag1,'BackgroundColor','red');
else
    set (handles.midline,'string',ML_flag1,'BackgroundColor',[0.68,0.92,1]);
end

if blockflag>0
    set (handles.block,'string',blockflag,'BackgroundColor','red');
else
    set (handles.block,'string',blockflag,'BackgroundColor',[0.68,0.92,1]);
end
%% ͼ����ʾ����
if ccdflag == 0
%%��һ��CCD
    plot(handles.axes1,y1,x,'*',x,y2,'--',y3,x,'.',y4,x,'.','LineWidth',8);
else
%%�ڶ���CCD
    plot(handles.axes2,x,y5,'--',y6,x,'.',y7,x,'.','LineWidth',8);
end
