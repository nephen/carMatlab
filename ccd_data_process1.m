function [MidLine,lftblack,ritblack,black_flag,ML_flag,...
    leftflag,rightflag,ten_roadflag,lostline,blockflag] = ccd_data_process1(PixelAryy)%#codegen
%%常量定义
position_threshold=20;			%%定义相邻两次中心点阈值
MidRange = 15;%% 中心点扫描范围
%%变量定义
blockflag = 0;%%障碍物标志
ten_roadflag = 0;%%定义十字路口标志
Midlft_value = 0;%%计算中心线左右阈值和
Midrit_value = 0;
leftflag=0;rightflag=0;%%左右黑线标志位   
ML_flag=0;%%中心线标志初始化
M_rightflag = 0;M_leftflag = 0;%%中心线左右黑线标志位
M_leftblack=50;M_rightblack=70;%%初始化中心线左右黑线
left_locate_end = 0;right_locate_end = 0;%%定义左右扫描中点
black_flag = 0;%%黑块标志
mid_tmp_car_position = 64.0;%%定义中心点临时变量
ident_tmp_car_position = 64.0;%%定义识别临时变量

%%定义丢边计数器
persistent lostcount
if isempty(lostcount)
    lostcount = 0;
end

%%定义左右静态边沿点
persistent LEFTBLACK
if isempty(LEFTBLACK)
    LEFTBLACK = 35;
end

persistent RIGHTBLACK
if isempty(RIGHTBLACK)
    RIGHTBLACK = 95;
end

%%定义识别障碍物计数器
persistent blockIdentGroup
if isempty(blockIdentGroup)
    blockIdentGroup = zeros(1,3);
end

persistent calwidth_count
if isempty(calwidth_count)
    calwidth_count = 1;%%计算跑道次数
end
%%定义中心线的位置及跑道宽度（宽度会随CCD的前瞻呈线性变化）
persistent road_width
if isempty(road_width)
    road_width = 75;
end
%%定义用于补线的路宽
persistent road_width_using
if isempty(road_width_using)
    road_width_using = 75;
end

%%初始化左右黑线
persistent leftblack;
if isempty(leftblack)
    leftblack = 35;
end

persistent rightblack;
if isempty(rightblack)
    rightblack = 95;
end

persistent old_car_position;			%%定义两个中心点静态变量
if isempty(old_car_position)
    old_car_position = 64.0;
end

persistent car_position;
if isempty(car_position)
    car_position = 64.0;
end

mid_tmp_car_position = fix(car_position);
%% 范围限制 这里有可能是小数 所以多加或减一  还要各往中间缩小2
if mid_tmp_car_position < MidRange+15
    mid_tmp_car_position = MidRange+15;
end
if mid_tmp_car_position > 114-MidRange
    mid_tmp_car_position = 114-MidRange;
end
%%预先判断是否存在中心线，如果有则直接返回结果
for i = (mid_tmp_car_position-MidRange):1:(mid_tmp_car_position+MidRange)			
    if PixelAryy(i) - PixelAryy(i+1) >= 4 && PixelAryy(i+1) - PixelAryy(i+2) >= 4 ...
            && PixelAryy(i+2) - PixelAryy(i+3) >= 4 && PixelAryy(i) - PixelAryy(i+3) >= 30
        %%这里只算下降沿
        disp 'midLineFirst'
        M_leftblack = i;
        M_leftflag = 1;
        tmp = i;
        if tmp - 15 < 1
            tmp = 16;
        end
        Midlft_value = PixelAryy(tmp-5);
        break;
    end
end
%%逆向扫描
if M_leftflag
for i = (mid_tmp_car_position+MidRange):-1:(mid_tmp_car_position-MidRange)			
    if PixelAryy(i) - PixelAryy(i-1) >= 4 && PixelAryy(i-1) - PixelAryy(i-2) >= 4 ...
       && PixelAryy(i-2) - PixelAryy(i-3) >= 4 && PixelAryy(i) - PixelAryy(i-3) >= 30
        disp 'midLineSecond'
        M_rightblack = i;
        M_rightflag = 1;
        tmp = i;
        if tmp + 5 > 118
            tmp = 113;
        end
        Midrit_value = PixelAryy(tmp+5);
        break;
    end
end
if 1 == M_rightflag && (Midrit_value - Midlft_value < 30 &&...
    Midrit_value - Midlft_value > -30)%%跟边沿线区分开来
    disp 'midLineEntered'
    
    car_position = (M_leftblack + M_rightblack)/2.0;
    old_car_position = car_position;					%%保存历史中心值
    
    %%判断是否有突变
    if car_position - old_car_position > position_threshold...
	|| car_position - old_car_position < -position_threshold	
       %% 采用变化较小的值
       car_position = old_car_position;
    end	
    
    leftblack = fix(car_position - road_width_using/2.0);     %%自动计算左边沿点
    rightblack = fix(car_position + road_width_using/2.0);    %%自动计算右边沿点
    %%函数输出变量赋值
    MidLine = car_position;
    black_flag = 0;
    ML_flag=1;
    leftflag=1;rightflag=1;
    lftblack = leftblack;
    ritblack = rightblack;
    lostline = lostcount;
    lostcount = 0;
    return;
end
end

ident_tmp_car_position = fix(car_position);
if ident_tmp_car_position < 10
    ident_tmp_car_position = 10;
end
if ident_tmp_car_position > 118
    ident_tmp_car_position = 118;
end
left_locate_end = leftblack - 20;
right_locate_end = rightblack + 20;
if left_locate_end < 14
    left_locate_end =14;
end
if right_locate_end > 115
    right_locate_end = 115;
end

%%左边沿检测区
for i = ident_tmp_car_position : -1 :left_locate_end
    if (PixelAryy(i) - PixelAryy(i-1) >= 4) && (PixelAryy(i-1) - PixelAryy(i-2) >= 4) && ...
       (PixelAryy(i-2) - PixelAryy(i-3) >= 4) && (PixelAryy(i) - PixelAryy(i-3) >= 30)     
        leftblack = i;
        leftflag = 1;			%%找到边沿线，标志位置1
        break;
    end
end
%%右边沿检测区
for i = ident_tmp_car_position : 1 :right_locate_end
    if (PixelAryy(i) - PixelAryy(i+1) >= 4) && (PixelAryy(i+1) - PixelAryy(i+2) >= 4) &&...
        (PixelAryy(i+2) - PixelAryy(i+3) >= 4) && (PixelAryy(i) - PixelAryy(i+3) >= 30)    
        rightblack = i;
        rightflag = 1;			%%找到边沿线，标志位置1
        break;
    end
end

if leftflag||rightflag
    %%看到了两边
    if 1 == leftflag && 1 == rightflag				%%根据不同的前瞻计算跑道的宽度即可
		road_width = rightblack - leftblack;			%%计算跑道宽度
        if calwidth_count > 0%%只计算一次跑道宽度用于补线
            calwidth_count = calwidth_count - 1;
            road_width_using = road_width;
            LEFTBLACK = leftblack;
            RIGHTBLACK = rightblack;
        end
        
        %%当路宽变化大时
        if road_width < road_width_using*0.75
            %%障碍物处理
            blockIdentGroup(1) = blockIdentGroup(2);         %%记录历史值
            blockIdentGroup(2) = blockIdentGroup(3);
            blockIdentGroup(3) = road_width;
            if(blockIdentGroup(3) - blockIdentGroup(1) < 5 || blockIdentGroup(3) - blockIdentGroup(1) > -5)
                blockflag = 1;
            end
        end

        lostcount = 0;
    else
        lostcount = lostcount + 1;            %%丢边计数
        if lostcount > 20           %%限幅处理
            lostcount = 20;
        end
    end
    
    %%只看到了右边
    if 0 == leftflag && 1 == rightflag
        if old_car_position < 60 || old_car_position > 68           %%不是直线才补边
            leftblack = rightblack - road_width_using;			%%丢了左边自动补左边
        end
    end
    
    %%只看到了左边
    if 0 == rightflag && 1 == leftflag
        if old_car_position < 60 || old_car_position > 68          %%不是直线才补边
            rightblack = leftblack + road_width_using;			%%丢了右边自动补右边
        end
    end

    %%计算中心点
    old_car_position = car_position;					%%保存历史中心值
    car_position = (leftblack + rightblack)/2;			%%计算中心点
    
    %%锐化障碍物
    if blockflag
        if leftblack - LEFTBLACK > RIGHTBLACK - rightblack
            car_position = rightblack - 10;
        else
            car_position = leftblack + 10;
        end
    end
    
    %%判断是否有突变
    if car_position - old_car_position > position_threshold...
	|| car_position - old_car_position < -position_threshold	
       %% 采用变化较小的值
       car_position = old_car_position;
    end	
    
else
    %%如果两条边丢失，则有可能是检测到了十字路口，或者是非常正的过中心线
    old_car_position = car_position;					%%保存历史中心值
    car_position = old_car_position;			%%如果两条边沿线都丢失，直接采用上一次的中心点值 
    if PixelAryy(64)>150
        ten_roadflag = 1;%%检测到了十字路口
    end
    if PixelAryy(64)<120
        black_flag = 1;
    end
end
lftblack = leftblack;
ritblack = rightblack;
MidLine = car_position; 
lostline = lostcount;

end