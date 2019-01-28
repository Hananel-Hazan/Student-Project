%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   CreateBlock: provides GUI for Block Class creation
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = CreateBlock(varargin)
% CREATEBLOCK M-file for CreateBlock.fig
%      CREATEBLOCK, by itself, creates a new CREATEBLOCK or raises the existing
%      singleton*.
%
%      H = CREATEBLOCK returns the handle to a new CREATEBLOCK or the handle to
%      the existing singleton*.
%
%      CREATEBLOCK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATEBLOCK.M with the given input arguments.
%
%      CREATEBLOCK('Property','Value',...) creates a new CREATEBLOCK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CreateBlock_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property
%      application
%      stop.  All inputs are passed to CreateBlock_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CreateBlock

% Last Modified by GUIDE v2.5 19-Aug-2009 15:46:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CreateBlock_OpeningFcn, ...
    'gui_OutputFcn',  @CreateBlock_OutputFcn, ...
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


% --- Executes just before CreateBlock is made visible.
function CreateBlock_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CreateBlock (see VARARGIN)

% Choose default command line output for CreateBlock
if ~isempty(varargin) && strcmp(class(varargin{1}),'Block') %copying Block
    block=varargin{1};
    set(handles.name,'String',block.name);
    
    set(handles.reference_sound,'String',block.reference_sound.getType() );
    
    %set(handles.step_mode,'String',block.step_mode) ;
    if strcmp(block.step_mode,'additive')
        set(handles.step_mode,'Value',1);
    else
        set(handles.step_mode,'Value',2);
    end
    
    %set(handles.based_on,'String',block.based_on) ;
    if strcmp(block.based_on,'trials')
        set(handles.based_on,'Value',1);
    else
        set(handles.based_on,'Value',2);
    end
    
    if strcmp(block.theme,'mouse')
        set(handles.theme,'Value',1);
    else % dragon, cat, dog , etc. 
        set(handles.theme,'Value',2);
    end
    
    set(handles.start_at,'String',block.start_at); % start block with parameter
    set(handles.stop_at,'String',block.stop_at); % stop change parameter
    % parameter to change in reference sound
    %duration, intensity, frequency,mod. frequency,mod. depth, gap
    contents=properties(block.reference_sound);
    set(handles.step_on,'String',contents);
    for i=1:length(contents)
        if strcmp(contents{i},block.step_on)
            break;
        end
    end
    set(handles.step_on,'Value',i) ;
    
    set(handles.delta,'String',block.delta); % amount for a parameter's change
    %% Inter Stimulus Interval = ISI
    set(handles.ISI,'String',num2str(block.ISI));
    %% Task
    set(handles.task,'String',block.task); % could be in  AXB, BXXA form , where X - reference sound, A or B - changed sound ( selected random )
    %% Steps
    set(handles.big_step,'String',block.big_step*100);
    
    set(handles.int_step,'String',block.int_step*100);
    
    set(handles.small_step,'String',block.small_step*100);
    %% Thresholds
    set(handles.big2int,'String',block.big2int);
    
    set(handles.int2small,'String',block.int2small);
    
    set(handles.small2end,'String',block.small2end);
    
    set(handles.total2end,'String',block.total2end);
    handles.block=block;
    handles.sound=block.reference_sound;
else
    handles.block = 0;
    handles.sound=0;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CreateBlock wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = CreateBlock_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.block;
close(handles.figure1);


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
name=findobj('Tag','name');% name of the block
name=get(name,'String');

if handles.sound==0
    disp('Please define Reference Sound');
    msgbox('Please define Reference Sound','Warning','modal') ;
    return;
end
reference_sound=handles.sound; % sound to be played as reference

contents = get(handles.theme,'String') ;
theme=contents{get(handles.theme,'Value')} ;

step_mode=findobj('Tag','step_mode'); % { additive, multiplicative }
contents = get(step_mode,'String') ;
step_mode=contents{get(step_mode,'Value')} ;

based_on=findobj('Tag','based_on'); % { reversals, trials }
contents = get(based_on,'String') ;
based_on=contents{get(based_on,'Value')} ;

start_at=findobj('Tag','start_at');
start_at=str2double(get(start_at,'String')); % start block with with parameter

stop_at=findobj('Tag','stop_at');
stop_at=str2double(get(stop_at,'String')); % start block with with parameter
% other_stimulus; % { lower, higher }  no need since start_at shows the direction

% parameter to change in reference sound
%duration, intensity, frequency,mod. frequency,mod. depth, gap
step_on = findobj('Tag','step_on');
contents = get(step_on,'String') ;
str=contents{get(step_on,'Value')} ;
if isempty(str)
    step_on='duration';
else
    step_on=str;
end

delta=findobj('Tag','delta');
delta=str2double(get(delta,'String')); % amount for a parameter's change
%% Inter Stimulus Interval = ISI
ISI=findobj('Tag','ISI');
ISI=str2num(get(ISI,'String')); % Inter Stimulus Interval can be in modes {fixed, random}, 2 values - random

%% Task
task=findobj('Tag','task');
task=get(task,'String'); % could be in  AXB, XXA form , where X - reference sound, A or B - changed sound ( selected random )
%% Steps
big_step=findobj('Tag','big_step'); % percent of delta for big steps
big_step=str2double(get(big_step,'String'));

int_step=findobj('Tag','int_step'); % percent of delta for intermediate steps
int_step=str2double(get(int_step,'String'));

small_step=findobj('Tag','small_step');  % percent of delta for small steps
small_step=str2double(get(small_step,'String'));
%% Thresholds
big2int=findobj('Tag','big2int'); % number of events to switch from big steps mode to intermediate
big2int=str2double(get(big2int,'String'));

int2small=findobj('Tag','int2small'); % number of events to switch from int. steps mode to small
int2small=str2double(get(int2small,'String'));

small2end=findobj('Tag','small2end'); % number of events to switch from small steps mode to finish of the Block
small2end=str2double(get(small2end,'String'));

total2end=findobj('Tag','total2end'); % number of total events to finish
total2end=str2double(get(total2end,'String'));

tmp=0;
if handles.block~=0
    tmp=handles.block.test; % breaking OOP :)
end
handles.block=Block( name, theme, reference_sound, step_mode, based_on, start_at, stop_at, step_on, delta,  ISI, task, big_step, int_step, small_step, big2int, int2small,  small2end, total2end ) ;
if tmp~=0
    handles.block.setTest( tmp );
end
guidata(hObject, handles);% Update handles structure
uiresume

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.block = 0;
guidata(hObject, handles);% Update handles structure
uiresume

function big2int_Callback(hObject, eventdata, handles)
% hObject    handle to big2int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of big2int as text
%        str2double(get(hObject,'String')) returns contents of big2int as a
%        double

% --- Executes during object creation, after setting all properties.
function big2int_CreateFcn(hObject, eventdata, handles)
% hObject    handle to big2int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function int2small_Callback(hObject, eventdata, handles)
% hObject    handle to int2small (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of int2small as text
%        str2double(get(hObject,'String')) returns contents of int2small as a double


% --- Executes during object creation, after setting all properties.
function int2small_CreateFcn(hObject, eventdata, handles)
% hObject    handle to int2small (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function small2end_Callback(hObject, eventdata, handles)
% hObject    handle to small2end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of small2end as text
%        str2double(get(hObject,'String')) returns contents of small2end as a double


% --- Executes during object creation, after setting all properties.
function small2end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to small2end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function total2end_Callback(hObject, eventdata, handles)
% hObject    handle to total2end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of total2end as text
%        str2double(get(hObject,'String')) returns contents of total2end as a double


% --- Executes during object creation, after setting all properties.
function total2end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to total2end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in step_mode.
function step_mode_Callback(hObject, eventdata, handles)
% hObject    handle to step_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns step_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from step_mode


% --- Executes during object creation, after setting all properties.
function step_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in based_on.
function based_on_Callback(hObject, eventdata, handles)
% hObject    handle to based_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns based_on contents as cell array
%        contents{get(hObject,'Value')} returns selected item from based_on


% --- Executes during object creation, after setting all properties.
function based_on_CreateFcn(hObject, eventdata, handles)
% hObject    handle to based_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_Callback(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta as text
%        str2double(get(hObject,'String')) returns contents of delta as a double
delta=str2double(get(hObject,'String'));%  returns contents of start_at as a double
if (handles.sound == 0 )
    return;
end
% properties=get(handles.step_on,'String');
% property=properties{get(handles.step_on,'Value')} ;
% reference=get(handles.sound,property);
% 
% properties=get(handles.step_mode,'String');
% step_mode=properties{get(handles.step_mode,'Value')} ;
% 
% if strcmp(step_mode,'additive')
%     set(handles.start_at,'String',abs(delta+reference));
% else % multiplicative
%     if delta>1
%         set(handles.start_at,'String',abs(delta*reference));
%     else
%         set(handles.start_at,'String',abs(reference/delta));
%     end
% end

% --- Executes during object creation, after setting all properties.
function delta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function big_step_Callback(hObject, eventdata, handles)
% hObject    handle to big_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of big_step as text
%        str2double(get(hObject,'String')) returns contents of big_step as a double


% --- Executes during object creation, after setting all properties.
function big_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to big_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function int_step_Callback(hObject, eventdata, handles)
% hObject    handle to int_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of int_step as text
%        str2double(get(hObject,'String')) returns contents of int_step as a double


% --- Executes during object creation, after setting all properties.
function int_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to int_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function small_step_Callback(hObject, eventdata, handles)
% hObject    handle to small_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of small_step as text
%        str2double(get(hObject,'String')) returns contents of small_step as a double


% --- Executes during object creation, after setting all properties.
function small_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to small_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function name_Callback(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name as text
%        str2double(get(hObject,'String')) returns contents of name as a double


% --- Executes during object creation, after setting all properties.
function name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function task_Callback(hObject, eventdata, handles)
% hObject    handle to task (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of task as text
%        str2double(get(hObject,'String')) returns contents of task as a double


% --- Executes during object creation, after setting all properties.
function task_CreateFcn(hObject, eventdata, handles)
% hObject    handle to task (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reference_sound.
function reference_sound_Callback(hObject, eventdata, handles)
% hObject    handle to reference_sound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.sound == 0 ) % no sound set so far
    handles.sound=ChooseSound();
else
    handles.sound=ChooseSound(handles.sound);
end
if (handles.sound == 0 )
    set(hObject,'String','Click To Define');
    set(handles.step_on,'String',{'duration','intensity'});
else
    % Update handles structure
    set(hObject,'String',handles.sound.getType());
    set(handles.step_on,'String',properties(handles.sound));
end
 guidata(hObject, handles);

function ISI_Callback(hObject, eventdata, handles)
% hObject    handle to ISI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ISI as text
%        str2double(get(hObject,'String')) returns contents of ISI as a double


% --- Executes during object creation, after setting all properties.
function ISI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ISI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in step_on.
function step_on_Callback(hObject, eventdata, handles)
% hObject    handle to step_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns step_on contents as cell array
%        contents{get(hObject,'Value')} returns selected item from step_on


% --- Executes during object creation, after setting all properties.
function step_on_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_at_Callback(hObject, eventdata, handles)
% hObject    handle to start_at (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_at as text
value=str2double(get(hObject,'String'));%  returns contents of start_at as a double
if (handles.sound == 0 )
    return;
end
% properties=get(handles.step_on,'String');
% property=properties{get(handles.step_on,'Value')} ;
% reference=get(handles.sound,property);
% 
% properties=get(handles.step_mode,'String');
% step_mode=properties{get(handles.step_mode,'Value')} ;
% 
% if strcmp(step_mode,'additive')
%     set(handles.delta,'String',value-reference);
% else % multiplicative
%     if value>reference
%         set(handles.delta,'String',abs(value/reference));
%     else
%         set(handles.delta,'String',abs(reference/value));
%     end
% end


% --- Executes during object creation, after setting all properties.
function start_at_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_at (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text10.
function text10_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=CalculateDelta(str2double(get(handles.delta,'String')),str2double(get(handles.big_step,'String')));
if value~=0
    set(handles.big_step,'String',value);
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text13.
function text13_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=CalculateDelta(str2double(get(handles.delta,'String')),str2double(get(handles.int_step,'String')));
if value~=0
    set(handles.int_step,'String',value);
end
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text14.
function text14_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=CalculateDelta(str2double(get(handles.delta,'String')),str2double(get(handles.small_step,'String')));
if value~=0
set(handles.small_step,'String',value);
end



function stop_at_Callback(hObject, eventdata, handles)
% hObject    handle to stop_at (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stop_at as text
%        str2double(get(hObject,'String')) returns contents of stop_at as a double


% --- Executes during object creation, after setting all properties.
function stop_at_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stop_at (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in theme.
function theme_Callback(hObject, eventdata, handles)
% hObject    handle to theme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns theme contents as cell array
%        contents{get(hObject,'Value')} returns selected item from theme


% --- Executes during object creation, after setting all properties.
function theme_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cancel.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


