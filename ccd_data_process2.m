function [blockflag,left_flag,right_flag,left_edge,...
        right_edge,real_lost_flag,LFT,RIT,bnkflag] = ccd_data_process2(PixelAryy)%#codegen

%%��������

%%��������
left_edge = 0;          %%���������
right_edge = 0;         %%�����ұ���
left_flag = 0;          %%����ر�־
right_flag = 0;         %%�ұ��ر�־
M_left_edge = 0;        %%���������
M_right_edge = 0;       %%�����ұ���
M_count = 0;            %%���ļ�����
blockflag = 0;          %%�ϰ����־
bnkflag = 0;            %%�����հ�����
real_lost_flag = 0;     %%�������߱�־

%%��������
persistent lostcount
if isempty(lostcount)
    lostcount = 0;
end

%%���徲̬���ұ���λ��
persistent staticL
if isempty(staticL)
    staticL = 20;
end
persistent staticR
if isempty(staticR)
    staticR = 100;
end

%%���徲̬��������
persistent static_cnt
if isempty(static_cnt)
    static_cnt = 0;
end

%%ɨ���Ե���ص�
for i = 16:1:62			
    if (PixelAryy(i) - PixelAryy(i-1) >= 17 ) && (PixelAryy(i) - PixelAryy(i-2) >= 30)%%ֻ��������
        left_edge = i;
        left_flag = 1;
        break;
    end
end

for i = 112:-1:63			
    if (PixelAryy(i) - PixelAryy(i+1) >= 17 && (PixelAryy(i) - PixelAryy(i+2) >= 30))%%ֻ��������
        right_edge = i;
        right_flag = 1;
        break;
    end
end

%%������
if (right_flag&&~left_flag)||(~right_flag&&left_flag)
	lostcount = lostcount + 1;            %%���߼�����
    if lostcount > 40
        lostcount = 40;
    end
    if lostcount > 5
        real_lost_flag = 1;
    end
end
%%��˫��
if ~(right_flag||left_flag)
    bnkflag = 1;
end
%%������
if right_flag&&left_flag
    lostcount = 0;          %%������������
    if static_cnt == 0
        static_cnt = static_cnt + 1;
        staticL = left_edge;
        staticR = right_edge;
    end
end

LFT = staticL;
RIT = staticR;

%%��ɨ�赽���ұ�ʱ����������Ƿ���������
if left_flag == 1 && right_flag == 1
    for i = left_edge:1:right_edge
         if (PixelAryy(i) - PixelAryy(i+1) >= 17 && (PixelAryy(i) - PixelAryy(i+2) >= 30))%%ֻ��������
            M_count = M_count + 1;
            M_left_edge = i;
            break;
        end
    end
    
     for i = right_edge:-1:left_edge
        if (PixelAryy(i) - PixelAryy(i-1) >= 17 && (PixelAryy(i) - PixelAryy(i-2) >= 30))%%ֻ��������
            M_count = M_count + 1;
            M_right_edge = i;
            break;
        end
    end
end

%%�������ϰ����ʱ���Զ��л����ұ���
if M_count == 2
    if M_right_edge - M_left_edge > 10
        blockflag = 1;
        if (right_edge - M_right_edge) < (M_left_edge - left_edge)%%���ݱ��صĿ�����ж�
            right_edge = M_left_edge - 10;%%��������Χ
        else
            left_edge = M_right_edge + 10;
        end
    end
end
