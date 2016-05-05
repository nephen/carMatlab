function [blockflag,left_flag,right_flag,left_edge,...
        right_edge,real_lost_flag,LFT,RIT,bnkflag] = ccd_data_process2(PixelAryy)%#codegen

%%常量定义

%%变量定义
left_edge = 0;          %%定义左边沿
right_edge = 0;         %%定义右边沿
left_flag = 0;          %%左边沿标志
right_flag = 0;         %%右边沿标志
M_left_edge = 0;        %%中心左边沿
M_right_edge = 0;       %%中心右边沿
M_count = 0;            %%中心计数器
blockflag = 0;          %%障碍物标志
bnkflag = 0;            %%看到空白区域
real_lost_flag = 0;     %%真正丢线标志

%%常量定义
persistent lostcount
if isempty(lostcount)
    lostcount = 0;
end

%%定义静态左右边沿位置
persistent staticL
if isempty(staticL)
    staticL = 20;
end
persistent staticR
if isempty(staticR)
    staticR = 100;
end

%%定义静态计数变量
persistent static_cnt
if isempty(static_cnt)
    static_cnt = 0;
end

%%扫描边缘边沿点
for i = 16:1:62			
    if (PixelAryy(i) - PixelAryy(i-1) >= 17 ) && (PixelAryy(i) - PixelAryy(i-2) >= 30)%%只找上升沿
        left_edge = i;
        left_flag = 1;
        break;
    end
end

for i = 112:-1:63			
    if (PixelAryy(i) - PixelAryy(i+1) >= 17 && (PixelAryy(i) - PixelAryy(i+2) >= 30))%%只找上升沿
        right_edge = i;
        right_flag = 1;
        break;
    end
end

%%丢单线
if (right_flag&&~left_flag)||(~right_flag&&left_flag)
	lostcount = lostcount + 1;            %%丢线计数器
    if lostcount > 40
        lostcount = 40;
    end
    if lostcount > 5
        real_lost_flag = 1;
    end
end
%%丢双线
if ~(right_flag||left_flag)
    bnkflag = 1;
end
%%不丢线
if right_flag&&left_flag
    lostcount = 0;          %%计数变量清零
    if static_cnt == 0
        static_cnt = static_cnt + 1;
        staticL = left_edge;
        staticR = right_edge;
    end
end

LFT = staticL;
RIT = staticR;

%%当扫描到左右边时，检查中心是否有跳变沿
if left_flag == 1 && right_flag == 1
    for i = left_edge:1:right_edge
         if (PixelAryy(i) - PixelAryy(i+1) >= 17 && (PixelAryy(i) - PixelAryy(i+2) >= 30))%%只找上升沿
            M_count = M_count + 1;
            M_left_edge = i;
            break;
        end
    end
    
     for i = right_edge:-1:left_edge
        if (PixelAryy(i) - PixelAryy(i-1) >= 17 && (PixelAryy(i) - PixelAryy(i-2) >= 30))%%只找上升沿
            M_count = M_count + 1;
            M_right_edge = i;
            break;
        end
    end
end

%%当看到障碍物的时候，自动切换左右边沿
if M_count == 2
    if M_right_edge - M_left_edge > 10
        blockflag = 1;
        if (right_edge - M_right_edge) < (M_left_edge - left_edge)%%根据边沿的宽度来判断
            right_edge = M_left_edge - 10;%%主动扩大范围
        else
            left_edge = M_right_edge + 10;
        end
    end
end
