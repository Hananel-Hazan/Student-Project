%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   CreateNoiseSound: provides GUI for NoiseSound Class creation
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = CreateNoiseSound(varargin)
% CREATENOISESOUND M-file for CreateNoiseSound.fig
%      CREATENOISESOUND, by itself, creates a new CREATENOISESOUND or raises the existing
%      singleton*.
%
%      H = CREATENOISESOUND returns the handle to a new CREATENOISESOUND or the handle to
%      the existing singleton*.
%
%      CREATENOISESOUND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATENOISESOUND.M with the given input arguments.
%
%      CREATENOISESOUND('Property','Value',...) creates a new CREATENOISESOUND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CreateNoiseSound_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CreateNoiseSound_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CreateNoiseSound

% Last Modified by GUIDE v2.5 28-Mar-2009 15:03:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CreateNoiseSound_OpeningFcn, ...
                   'gui_OutputFcn',  @CreateNoiseSound_OutputFcn, ...
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


% --- Executes just before CreateNoiseSound is made visible.
function CreateNoiseSound_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CreateNoiseSound (see VARARGIN)

% Choose default command line output for CreateNoiseSound
handles.sound=-1;
duration = findobj('Tag','duration_edit');
intensity = findobj('Tag','intensity_edit');
start_frequency = findobj('Tag','start_frequency');
stop_frequency = findobj('Tag','stop_frequency');
if ~isempty(varargin) && strcmp(class(varargin{1}),'NoiseSound') %copying NoiseSound parameters
    sound=varargin{1};% in the case function got default values in GUI input
    set( duration,'String',sound.duration ) ;
    set( intensity,'String',sound.intensity ) ;
    set( start_frequency,'String',sound.start_frequency) ;
    set( stop_frequency,'String',sound.stop_frequency) ;
else
    % default values
    set( duration,'String',1000 ) ;
    set( intensity,'String',0.5 ) 
    set( start_frequency,'String',0 ) ;
    set( stop_frequency,'String',0 ) ;
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CreateNoiseSound wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CreateNoiseSound_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.sound;
close(hObject);



function duration_edit_Callback(hObject, eventdata, handles)
% hObject    handle to duration_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration_edit as text
%        str2double(get(hObject,'String')) returns contents of duration_edit as a double


% --- Executes during object creation, after setting all properties.
function duration_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function intensity_edit_Callback(hObject, eventdata, handles)
% hObject    handle to intensity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intensity_edit as text
%        str2double(get(hObject,'String')) returns contents of intensity_edit as a double


% --- Executes during object creation, after setting all properties.
function intensity_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intensity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function freq_edit_Callback(hObject, eventdata, handles)
% hObject    handle to freq_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of freq_edit as text
%        str2double(get(hObject,'String')) returns contents of freq_edit as a double


% --- Executes during object creation, after setting all properties.
function freq_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sound=0;
guidata(hObject, handles);
uiresume


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
duration = findobj('Tag','duration_edit');
intensity = findobj('Tag','intensity_edit');
start_frequency = findobj('Tag','start_frequency');
stop_frequency = findobj('Tag','stop_frequency');
sound = NoiseSound(str2double(get(duration,'String')) , str2double(get(intensity,'String')) , str2double(get(start_frequency,'String')), str2double(get(stop_frequency,'String')) );
handles.sound=sound;
guidata(hObject, handles);% Update handles structure
uiresume



function start_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to start_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_frequency as text
%        str2double(get(hObject,'String')) returns contents of start_frequency as a double


% --- Executes during object creation, after setting all properties.
function start_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stop_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to stop_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stop_frequency as text
%        str2double(get(hObject,'String')) returns contents of stop_frequency as a double


% --- Executes during object creation, after setting all properties.
function stop_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stop_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


