%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   CreateGapSound: provides GUI for GapSound Class creation
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = CreateGapSound(varargin)
% CREATEGAPSOUND M-file for CreateGapSound.fig
%      CREATEGAPSOUND, by itself, creates a new CREATEGAPSOUND or raises the existing
%      singleton*.
%
%      H = CREATEGAPSOUND returns the handle to a new CREATEGAPSOUND or the handle to
%      the existing singleton*.
%
%      CREATEGAPSOUND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATEGAPSOUND.M with the given input arguments.
%
%      CREATEGAPSOUND('Property','Value',...) creates a new CREATEGAPSOUND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CreateGapSound_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CreateGapSound_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CreateGapSound

% Last Modified by GUIDE v2.5 11-Aug-2009 12:13:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CreateGapSound_OpeningFcn, ...
    'gui_OutputFcn',  @CreateGapSound_OutputFcn, ...
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


% --- Executes just before CreateGapSound is made visible.
function CreateGapSound_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CreateGapSound (see VARARGIN)

% Choose default command line output for CreateGapSound
%mainFigureHandle  = ChooseSound;

if ~isempty(varargin) && strcmp(class(varargin{1}),'GapSound') %copying GapSound parameters
    handles.sound=varargin{1};
    handles.sound1=handles.sound.sound1;
    handles.sound2=handles.sound.sound2;
    guidata(hObject, handles);% Update handles structure
    set(handles.sound1_button,'String',handles.sound1.getType());
    set(handles.sound2_button,'String',handles.sound2.getType());
    set(handles.gap,'String', handles.sound.gap);
else
    % default values
    handles.sound=0;
    handles.sound1=0;
    handles.sound2=0;
    set( handles.gap,'String',1000 ) ;
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CreateGapSound wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CreateGapSound_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.sound;
close(hObject);


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sound=0;
guidata(hObject, handles);
uiresume( handles.figure1);


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gap = findobj('Tag','gap');
if handles.sound1==0 || handles.sound2==0
    msgbox('Sounds are not defined, please define them','Warning','modal') ;
else
    sound =GapSound(handles.sound1, handles.sound2 , str2double(get(gap,'String')) );
    handles.sound=sound;
    guidata(hObject, handles);% Update handles structure
    uiresume(handles.figure1);
end


% --- Executes on button press in sound1_button.
function sound1_button_Callback(hObject, eventdata, handles)
% hObject    handle to sound1_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.sound1==0
    handles.sound1=ChooseSound();
else
    handles.sound1=ChooseSound(handles.sound1);
end
if handles.sound1==0
    set(hObject,'String','Click To Define');
else
    set(hObject,'String',handles.sound1.getType());
end
guidata(hObject, handles);% Update handles structure
% --- Executes on button press in sound2_button.
function sound2_button_Callback(hObject, eventdata, handles)
% hObject    handle to sound2_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if  handles.sound2==0
    sound2=ChooseSound();
else
    sound2=ChooseSound(handles.sound2);
end
if sound2==0
    set(hObject,'String','Click To Define');
else
    handles.sound2=sound2;
    set(hObject,'String',handles.sound2.getType());
end
guidata(hObject, handles);% Update handles structure



function gap_Callback(hObject, eventdata, handles)
% hObject    handle to gap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gap as text
%        str2double(get(hObject,'String')) returns contents of gap as a double


% --- Executes during object creation, after setting all properties.
function gap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


