%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   ChooseSound: provides the GUI that allows user to choose a sound type 
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = ChooseSound(varargin)
% CHOOSESOUND M-file for ChooseSound.fig
%      CHOOSESOUND, by itself, creates a new CHOOSESOUND or raises the existing
%      singleton*.
%
%      H = CHOOSESOUND returns the handle to a new CHOOSESOUND or the handle to
%      the existing singleton*.
%
%      CHOOSESOUND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHOOSESOUND.M with the given input arguments.
%
%      CHOOSESOUND('Property','Value',...) creates a new CHOOSESOUND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChooseSound_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChooseSound_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChooseSound

% Last Modified by GUIDE v2.5 29-Mar-2009 12:01:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0; %% TODO: to remove ?
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ChooseSound_OpeningFcn, ...
    'gui_OutputFcn',  @ChooseSound_OutputFcn, ...
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


% --- Executes just before ChooseSound is made visible.
function ChooseSound_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChooseSound (see VARARGIN)

% Choose default command line output for ChooseSound
if ~isempty(varargin) % Sound object expected
    handles.sound=varargin{1};
    str = class(handles.sound);
    if strcmp(str,'PureSound')
        handles.sound=CreatePureSound(handles.sound);
    end
    if strcmp(str,'NoiseSound')
        handles.sound=CreateNoiseSound(handles.sound);
    end
    if strcmp(str,'AccordSound')
        handles.sound=CreateAccordSound(handles.sound);
    end
    if strcmp(str,'ModulatedSound')
        handles.sound=CreateModulatedSound(handles.sound);
    end
    if strcmp(str,'GapSound')
        handles.sound=CreateGapSound(handles.sound);
    end
    guidata(hObject, handles);
    % close( handles.figure);
else
    handles.sound=0;
    % set( handles.type,'Value',1);
    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes ChooseSound wait for user response (see UIRESUME)
    uiwait(handles.figure);
    
end


% --- Outputs from this function are returned to the command line.
function varargout = ChooseSound_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.sound;
close(hObject);

% --- Executes on button press in choose_cancel.
function choose_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to choose_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sound=0;
guidata(hObject, handles);
uiresume(handles.figure);


% --- Executes on button press in choose_ok.
function choose_ok_Callback(hObject, eventdata, handles)
% hObject    handle to choose_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.sound==0 % no initialization
    handles.sound=CreatePureSound();
    guidata(hObject, handles);
end
uiresume(handles.figure);


% --- Executes on selection change in type.
function type_Callback(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from type
contents = get(hObject,'String') ;
str=contents{get(hObject,'Value')} ;
if strcmp(str,'Pure Sound')
    handles.sound=CreatePureSound();
end
if strcmp(str,'Noise Sound')
    handles.sound=CreateNoiseSound();
end
if strcmp(str,'Accord Sound')
    handles.sound=CreateAccordSound();
end
if strcmp(str,'Modulated Sound')
    handles.sound=CreateModulatedSound();
end
if strcmp(str,'Gap Sound')
    handles.sound=CreateGapSound();
end
guidata(handles.figure, handles);% Update handles structure
uiresume(handles.figure);


% --- Executes during object creation, after setting all properties.
function type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



