function varargout = Myccd(varargin)
% MYCCD MATLAB code for Myccd.fig
%      MYCCD, by itself, creates a new MYCCD or raises the existing
%      singleton*.
%
%      H = MYCCD returns the handle to a new MYCCD or the handle to
%      the existing singleton*.
%
%      MYCCD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYCCD.M with the given input arguments.
%
%      MYCCD('Property','Value',...) creates a new MYCCD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Myccd_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Myccd_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Myccd

% Last Modified by GUIDE v2.5 23-Apr-2015 19:41:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Myccd_OpeningFcn, ...
                   'gui_OutputFcn',  @Myccd_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Myccd is made visible.
function Myccd_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Myccd (see VARARGIN)

% Choose default command line output for Myccd
handles.output = hObject;

%%初始化串口数据接收数组
global HRtmp;
HRtmp = zeros(1, 128);
global strRecN;
strRecN = 0;            %表征接收到的字符串个数
global ccdflag;
ccdflag = 0;

global lostside1;
lostside1 = 0;
global angleCnt;
angleCnt = 0;

global tenrd_flag1;
tenrd_flag1 = 0;
global ML_flag1;
ML_flag1 = 0;
global leftblack1;
leftblack1 = 0;
global rightblack1;
rightblack1 = 0;
global lefblk1;
lefblk1 = 0;
global ritblk1;
ritblk1 = 0;
global bankflag;
bankflag = 0;
global blockflag;
blockflag = 0;
global blockflag1;
blockflag1 = 0;
global LEFT;
LEFT = 0;
global RIGHT;
RIGHT = 0;
global left_edge;
left_edge = 0;
global right_edge;
right_edge = 0;
global MidLine1;
MidLine1 = 0;
global blockflag2;
blockflag2 = 0;
global left_flag;
left_flag = 0;
global right_flag;
right_flag = 0;
global Nangle;
Nangle = 0;
global lostside2;
lostside2 = 0;
global LEFT2;
LEFT2 = 0;
global RIGHT2;
RIGHT2 = 0;


%% 初始化参数
hasData = false;        %表征串口是否接收到数据
isShow = false;         %表征是否正在进行数据显示，即是否正在执行函数dataDisp
isStopDisp = false;     %表征是否按下了【停止显示】按钮

%% 将上述参数做为应用数据，存入窗口对象内
setappdata (hObject, 'hasData', hasData);
setappdata (handles.figure1, 'isShow', isShow);
setappdata (handles.figure1, 'isStopDisp', isStopDisp);
%% 设置界面名称
set(gcf,'Name','云豹助手V1.0')
%% 设置关闭窗口请求函数
set(gcf,'CloseRequestFcn',@figure1_CloseRequestFcn);

% Update handles structure
guidata(hObject, handles);
%% 图像1初始化
plot(handles.axes1,0,0,0,0)
set(handles.axes1,'XTick',-50:5:180,'YTick',0:20:280);
axis(handles.axes1,[-50 180 0 280])

ylabel(handles.axes1,'Pixel1')
hleg1=legend(handles.axes1,'Pixel1','MidLine1');
set(hleg1,'Location','NorthEast')
%% 图像2初始化
plot(handles.axes2,0,0,0,0)
set(handles.axes2,'XTick',-50:5:180,'YTick',0:20:280);
axis(handles.axes2,[-50 180 0 280])

ylabel(handles.axes2,'Pixel2')
hleg2=legend(handles.axes2,'Pixel2','MidLine2');
set(hleg2,'Location','NorthEast')
% UIWAIT makes Myccd wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Myccd_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in edit_resv.
function edit_resv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_resv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns edit_resv contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit_resv


% --- Executes during object creation, after setting all properties.
function edit_resv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_resv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_com.
function pop_com_Callback(hObject, eventdata, handles)
% hObject    handle to pop_com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_com contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_com


% --- Executes during object creation, after setting all properties.
function pop_com_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in pop_baud.
function pop_baud_Callback(hObject, eventdata, handles)
% hObject    handle to pop_baud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_baud contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_baud


% --- Executes during object creation, after setting all properties.
function pop_baud_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_baud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% 若按下【打开串口】按钮，打开串口，初始化相关参数
% --- Executes on button press in opencom.
function opencom_Callback(hObject, eventdata, handles)
% hObject    handle to opencom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if  get(hObject, 'value')

    %% 获取串口的端口号
    com_num = sprintf ('com%d', get (handles.pop_com, 'value'));
    %% 获取波特率
    rates = [110 300 600 1200 2400 4800 9600 19200 14400 38400 56000 57600 115200];
    baudrate = rates(get(handles.pop_baud, 'value'));
    %% 创建串口对象
    scom = serial(com_num);
    %% 配置串口属性，指定其回调函数
    set(scom, 'BaudRate', baudrate, 'Parity', 'none', 'DataBits', 8, ...
        'StopBits', 1,'BytesAvailableFcnMode', 'terminator','BytesAvailableFcnCount',400, ...
        'terminator',13,'BytesAvailableFcn', {@bytes, handles});
    %% 将串口对象的句柄做为用户数据，存入窗口对象
    set (handles.figure1, 'UserData', scom);
    %% 尝试打开串口
    try
        fopen(scom);    %打开串口
    catch    %若串口打开失败，提示“串口不可获得！”
        msgbox ('串口不可获得！');
        set (hObject, 'value', 0);  %弹起本按钮
        return;
    end
    %% 打开串口后，允许串口发送数据，清空接收显示区
    %% 将串口选择变为不可选，并更改本按钮文本为“关闭串口”
    set (handles.pop_com, 'Enable', 'off');  % 禁止更改串口号
    set (handles.pop_baud, 'Enable', 'off');  % 禁止更改波特率
    set (hObject, 'String', '关闭串口');      % 设置本按钮文本为“关闭串口”
else
    %% 停止并删除串口对象
    scoms = instrfind;
    stopasync (scoms);
    fclose (scoms);
    delete (scoms);
    %% 使能端口号选择
    set (handles.pop_com, 'Enable', 'on');  % 启用端口号选择
    set (handles.pop_baud, 'Enable', 'on');  % 启用波特率选择
    set (hObject, 'String', '打开串口');            % 设置本按钮文本为“打开串口”
    %% 清除全局变量
    clear global;
    %% 清除静态变量
    clear persistent;
end
    

%%   串口的BytesAvailableFcn回调函数
function bytes(hObject, eventdata, handles)

global HRtmp;
global strRecN;
global ccdflag;
%   串口接收数据
%% 获取参数
isStopDisp = getappdata (handles.figure1, 'isStopDisp'); %是否按下了【停止显示】按钮
isShow = getappdata (handles.figure1, 'isShow');  %是否正在执行显示数据操作
%% 获取串口可获取的数据个数
n = get(hObject, 'BytesAvailable');
%% 若串口有数据，接收所有数据
if n
    %% 更新hasData参数，表明串口有数据需要显示
    setappdata(handles.figure1, 'hasData', true);
    %% 读取串口数据
    a = fread(hObject, n,'uchar');
    L = length(a);
    c = char(a);%将ASCII转化为16进制

    if L == 260
        if (a(1)=='Y'||a(1)=='Z') && a(2)=='B'
            for i=3:2:257
                HRtmp((i-1)/2) = hex2dec(c(i))*16 + hex2dec(c(i+1));%将16进制转化为10进制
            end
            if a(1)=='Y'
                ccdflag = 0;
            else
                ccdflag = 1;
            end
            
            strRecN = strRecN + 1;
            if get (handles.cnt,'Value')==0
                %%更新字符串个数
                if rem(strRecN,2) == 0
                    set (handles.count,'string',strRecN,'ForegroundColor','black')
                else
                    set (handles.count,'string',strRecN','ForegroundColor','red')
                end
                 %%显示数据
                set (handles.edit_resv,'string',num2str(HRtmp))
            end
           
            %%YB2015 CCD路径测试算法
            YB_2015
        end
    end
end


function figure1_CloseRequestFcn (hObject, eventdata, handles)
%   关闭窗口时，检查串口是否已经关闭，若没关闭，则先关闭
%% 查找串口对象
scoms = instrfind;
%% 尝试停止关闭删除串口对象
try
    stopasync(scoms);
    fclose (scoms);
    delete (scoms);
end
%% 清除全局变量
clear global;
%% 清除静态变量
clear persistent;
%% 关闭窗口
delete (hObject);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to Mid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mid as text
%        str2double(get(hObject,'String')) returns contents of Mid as a double


% --- Executes during object creation, after setting all properties.
function Mid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Left as text
%        str2double(get(hObject,'String')) returns contents of Left as a double


% --- Executes during object creation, after setting all properties.
function Left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Right as text
%        str2double(get(hObject,'String')) returns contents of Right as a double


% --- Executes during object creation, after setting all properties.
function Right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function blablock_Callback(hObject, eventdata, handles)
% hObject    handle to blablock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blablock as text
%        str2double(get(hObject,'String')) returns contents of blablock as a double


% --- Executes during object creation, after setting all properties.
function blablock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blablock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function midline_Callback(hObject, eventdata, handles)
% hObject    handle to midline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of midline as text
%        str2double(get(hObject,'String')) returns contents of midline as a double


% --- Executes during object creation, after setting all properties.
function midline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to midline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tenrd_Callback(hObject, eventdata, handles)
% hObject    handle to tenrd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tenrd as text
%        str2double(get(hObject,'String')) returns contents of tenrd as a double


% --- Executes during object creation, after setting all properties.
function tenrd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tenrd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ninty_Callback(hObject, eventdata, handles)
% hObject    handle to ninty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ninty as text
%        str2double(get(hObject,'String')) returns contents of ninty as a double


% --- Executes during object creation, after setting all properties.
function ninty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ninty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function block_Callback(hObject, eventdata, handles)
% hObject    handle to block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of block as text
%        str2double(get(hObject,'String')) returns contents of block as a double


% --- Executes during object creation, after setting all properties.
function block_CreateFcn(hObject, eventdata, handles)
% hObject    handle to block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function count_Callback(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of count as text
%        str2double(get(hObject,'String')) returns contents of count as a double


% --- Executes during object creation, after setting all properties.
function count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in attm.
function attm_Callback(hObject, eventdata, handles)
% hObject    handle to attm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({'1、上面为CCD1波形，下面为CCD2波形。' '2、左下角的CCD按钮可切换显示CCD数据。' '3、蓝色文本框中变为黄色表示丢边，红色表示找到标志位。'...
    '4、右侧包括两路CCD图像处理信息，下侧为串口接收到的实际CCD数值。' '5、左下角的帧计数按钮可以暂停显示。'},'使用说明');


% --- Executes on button press in switchccd.
function switchccd_Callback(hObject, eventdata, handles)
% hObject    handle to switchccd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject, 'value')
    set(hObject,'String','CCD2')
else
    set(hObject,'String','CCD1')
end


% --- Executes on button press in cnt.
function cnt_Callback(hObject, eventdata, handles)
% hObject    handle to cnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
