function [MidLine,lftblack,ritblack,black_flag,ML_flag,...
    leftflag,rightflag,ten_roadflag,lostline,blockflag] = ccd_data_process1(PixelAryy)%#codegen
%%��������
position_threshold=20;			%%���������������ĵ���ֵ
MidRange = 15;%% ���ĵ�ɨ�跶Χ
%%��������
blockflag = 0;%%�ϰ����־
ten_roadflag = 0;%%����ʮ��·�ڱ�־
Midlft_value = 0;%%����������������ֵ��
Midrit_value = 0;
leftflag=0;rightflag=0;%%���Һ��߱�־λ   
ML_flag=0;%%�����߱�־��ʼ��
M_rightflag = 0;M_leftflag = 0;%%���������Һ��߱�־λ
M_leftblack=50;M_rightblack=70;%%��ʼ�����������Һ���
left_locate_end = 0;right_locate_end = 0;%%��������ɨ���е�
black_flag = 0;%%�ڿ��־
mid_tmp_car_position = 64.0;%%�������ĵ���ʱ����
ident_tmp_car_position = 64.0;%%����ʶ����ʱ����

%%���嶪�߼�����
persistent lostcount
if isempty(lostcount)
    lostcount = 0;
end

%%�������Ҿ�̬���ص�
persistent LEFTBLACK
if isempty(LEFTBLACK)
    LEFTBLACK = 35;
end

persistent RIGHTBLACK
if isempty(RIGHTBLACK)
    RIGHTBLACK = 95;
end

%%����ʶ���ϰ��������
persistent blockIdentGroup
if isempty(blockIdentGroup)
    blockIdentGroup = zeros(1,3);
end

persistent calwidth_count
if isempty(calwidth_count)
    calwidth_count = 1;%%�����ܵ�����
end
%%���������ߵ�λ�ü��ܵ���ȣ���Ȼ���CCD��ǰհ�����Ա仯��
persistent road_width
if isempty(road_width)
    road_width = 75;
end
%%�������ڲ��ߵ�·��
persistent road_width_using
if isempty(road_width_using)
    road_width_using = 75;
end

%%��ʼ�����Һ���
persistent leftblack;
if isempty(leftblack)
    leftblack = 35;
end

persistent rightblack;
if isempty(rightblack)
    rightblack = 95;
end

persistent old_car_position;			%%�����������ĵ㾲̬����
if isempty(old_car_position)
    old_car_position = 64.0;
end

persistent car_position;
if isempty(car_position)
    car_position = 64.0;
end

mid_tmp_car_position = fix(car_position);
%% ��Χ���� �����п�����С�� ���Զ�ӻ��һ  ��Ҫ�����м���С2
if mid_tmp_car_position < MidRange+15
    mid_tmp_car_position = MidRange+15;
end
if mid_tmp_car_position > 114-MidRange
    mid_tmp_car_position = 114-MidRange;
end
%%Ԥ���ж��Ƿ���������ߣ��������ֱ�ӷ��ؽ��
for i = (mid_tmp_car_position-MidRange):1:(mid_tmp_car_position+MidRange)			
    if PixelAryy(i) - PixelAryy(i+1) >= 4 && PixelAryy(i+1) - PixelAryy(i+2) >= 4 ...
            && PixelAryy(i+2) - PixelAryy(i+3) >= 4 && PixelAryy(i) - PixelAryy(i+3) >= 30
        %%����ֻ���½���
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
%%����ɨ��
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
    Midrit_value - Midlft_value > -30)%%�����������ֿ���
    disp 'midLineEntered'
    
    car_position = (M_leftblack + M_rightblack)/2.0;
    old_car_position = car_position;					%%������ʷ����ֵ
    
    %%�ж��Ƿ���ͻ��
    if car_position - old_car_position > position_threshold...
	|| car_position - old_car_position < -position_threshold	
       %% ���ñ仯��С��ֵ
       car_position = old_car_position;
    end	
    
    leftblack = fix(car_position - road_width_using/2.0);     %%�Զ���������ص�
    rightblack = fix(car_position + road_width_using/2.0);    %%�Զ������ұ��ص�
    %%�������������ֵ
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

%%����ؼ����
for i = ident_tmp_car_position : -1 :left_locate_end
    if (PixelAryy(i) - PixelAryy(i-1) >= 4) && (PixelAryy(i-1) - PixelAryy(i-2) >= 4) && ...
       (PixelAryy(i-2) - PixelAryy(i-3) >= 4) && (PixelAryy(i) - PixelAryy(i-3) >= 30)     
        leftblack = i;
        leftflag = 1;			%%�ҵ������ߣ���־λ��1
        break;
    end
end
%%�ұ��ؼ����
for i = ident_tmp_car_position : 1 :right_locate_end
    if (PixelAryy(i) - PixelAryy(i+1) >= 4) && (PixelAryy(i+1) - PixelAryy(i+2) >= 4) &&...
        (PixelAryy(i+2) - PixelAryy(i+3) >= 4) && (PixelAryy(i) - PixelAryy(i+3) >= 30)    
        rightblack = i;
        rightflag = 1;			%%�ҵ������ߣ���־λ��1
        break;
    end
end

if leftflag||rightflag
    %%����������
    if 1 == leftflag && 1 == rightflag				%%���ݲ�ͬ��ǰհ�����ܵ��Ŀ�ȼ���
		road_width = rightblack - leftblack;			%%�����ܵ����
        if calwidth_count > 0%%ֻ����һ���ܵ�������ڲ���
            calwidth_count = calwidth_count - 1;
            road_width_using = road_width;
            LEFTBLACK = leftblack;
            RIGHTBLACK = rightblack;
        end
        
        %%��·��仯��ʱ
        if road_width < road_width_using*0.75
            %%�ϰ��ﴦ��
            blockIdentGroup(1) = blockIdentGroup(2);         %%��¼��ʷֵ
            blockIdentGroup(2) = blockIdentGroup(3);
            blockIdentGroup(3) = road_width;
            if(blockIdentGroup(3) - blockIdentGroup(1) < 5 || blockIdentGroup(3) - blockIdentGroup(1) > -5)
                blockflag = 1;
            end
        end

        lostcount = 0;
    else
        lostcount = lostcount + 1;            %%���߼���
        if lostcount > 20           %%�޷�����
            lostcount = 20;
        end
    end
    
    %%ֻ�������ұ�
    if 0 == leftflag && 1 == rightflag
        if old_car_position < 60 || old_car_position > 68           %%����ֱ�߲Ų���
            leftblack = rightblack - road_width_using;			%%��������Զ������
        end
    end
    
    %%ֻ���������
    if 0 == rightflag && 1 == leftflag
        if old_car_position < 60 || old_car_position > 68          %%����ֱ�߲Ų���
            rightblack = leftblack + road_width_using;			%%�����ұ��Զ����ұ�
        end
    end

    %%�������ĵ�
    old_car_position = car_position;					%%������ʷ����ֵ
    car_position = (leftblack + rightblack)/2;			%%�������ĵ�
    
    %%���ϰ���
    if blockflag
        if leftblack - LEFTBLACK > RIGHTBLACK - rightblack
            car_position = rightblack - 10;
        else
            car_position = leftblack + 10;
        end
    end
    
    %%�ж��Ƿ���ͻ��
    if car_position - old_car_position > position_threshold...
	|| car_position - old_car_position < -position_threshold	
       %% ���ñ仯��С��ֵ
       car_position = old_car_position;
    end	
    
else
    %%��������߶�ʧ�����п����Ǽ�⵽��ʮ��·�ڣ������Ƿǳ����Ĺ�������
    old_car_position = car_position;					%%������ʷ����ֵ
    car_position = old_car_position;			%%������������߶���ʧ��ֱ�Ӳ�����һ�ε����ĵ�ֵ 
    if PixelAryy(64)>150
        ten_roadflag = 1;%%��⵽��ʮ��·��
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