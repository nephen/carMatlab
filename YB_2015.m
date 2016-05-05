% clear all
% clc
% close all
% load('car.mat');%%导入变量
%%真机测试部分开始
global HRtmp;
global ccdflag;
%%x轴定义
x = 1:1:128;
%%标志位定义
tenrd_flag = 0;%%到达十字路
ML_flag = 0;%%中心线标志
blackFlag = 0;%%黑块标志

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

%% 第一个图片处理函数用于主偱迹CCD
%% 第二个图片处理函数用于跑道类型识别
%% 图片处理部分
if ccdflag == 0
    %%第一个CCD
    [MidLine1,leftblack1,rightblack1,blackFlag,ML_flag1,lefblk1,ritblk1,...
        tenrd_flag1,lostside1,blockflag] = ccd_data_process1(HRtmp);
    y1=MidLine1;
    y2=HRtmp(x);
    y3=leftblack1;
    y4=rightblack1;
else
    %%第二个CCD
    [blockflag2,left_flag,right_flag,left_edge,right_edge,lostside2,LEFT2,RIGHT2,bankflag] = ccd_data_process2(HRtmp);
    y5=HRtmp(x);
    y6=left_edge;
    y7=right_edge;
end
%%标志处理部分
%%90度弯
if lostside2%%CCD2丢单线且单线不发生突变
    
end
%%十字路
if tenrd_flag1
    tenrd_flag = 1;
end

%%数字显示部分/根据按钮的状态显示
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
    set (handles.Mid, 'BackgroundColor',[0.94,0.94,0.94]);%%显示灰色
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
    set (handles.blablock, 'BackgroundColor',[0.94,0.94,0.94]);%%显示灰色
end
%%不分情况共同处理部分
if Nangle == 1%%九十度标志
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
%% 图像显示部分
if ccdflag == 0
%%第一个CCD
    plot(handles.axes1,y1,x,'*',x,y2,'--',y3,x,'.',y4,x,'.','LineWidth',8);
else
%%第二个CCD
    plot(handles.axes2,x,y5,'--',y6,x,'.',y7,x,'.','LineWidth',8);
end
