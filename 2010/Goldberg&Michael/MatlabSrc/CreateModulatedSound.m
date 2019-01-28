%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   CreateModulatedSound: provides GUI for ModulatedSound Class creation
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = CreateModulatedSound(varargin)
% CREATEMODULATEDSOUND M-file for CreateModulatedSound.fig
%      CREATEMODULATEDSOUND, by itself, creates a new CREATEMODULATEDSOUND or raises the existing
%      singleton*.
%
%      H = CREATEMODULATEDSOUND returns the handle to a new CREATEMODULATEDSOUND or the handle to
%      the existing singleton*.
%
%      CREATEMODULATEDSOUND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATEMODULATEDSOUND.M with the given input arguments.
%
%      CREATEMODULATEDSOUND('Property','Value',...) creates a new CREATEMODULATEDSOUND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CreateModulatedSound_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CreateModulatedSound_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CreateModulatedSound

% Last Modified by GUIDE v2.5 11-Aug-2009 14:51:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CreateModulatedSound_OpeningFcn, ...
                   'gui_OutputFcn',  @CreateModulatedSound_OutputFcn, ...
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


% --- Executes just before CreateModulatedSound is made visible.
function CreateModulatedSound_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CreateModulatedSound (see VARARGIN)

% Choose default command line output for CreateModulatedSound

if ~isempty(varargin) && strcmp(class(varargin{1}),'ModulatedSound') %copying ModulatedSound parameters
    % in the case function got default values in GUI input
    handles.sound=varargin{1};
    handles.carrier_sound=handles.sound.sound;
    set( handles.carrier_sound_button,'String',handles.carrier_sound.getType() ) ;
    set( handles.mod_frequency,'String',handles.sound.mod_frequency ) ;
    set( handles.mod_depth,'String',handles.sound.mod_depth ) ;
    set( handles.mod_type,'String',handles.sound.mod_type ) ;
else
    % default values
    handles.sound=0;
    handles.carrier_sound=0;
    set( handles.mod_frequency,'String',5000 ) ;
    set( handles.mod_depth,'String',2 ) ;
    set( handles.mod_type,'String','AM' ) ;
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CreateModulatedSound wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CreateModulatedSound_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.sound;
close(hObject);



function carrier_sound_button_Callback(hObject, eventdata, handles)
% hObject    handle to carrier_sound_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of carrier_sound_button as text
%        str2double(get(hObject,'String')) returns contents of carrier_sound_button as a double

if handles.carrier_sound==0
    handles.carrier_sound=ChooseSound();
else
    handles.carrier_sound=ChooseSound(handles.carrier_sound);
end
if handles.carrier_sound==0
    set(hObject,'String','Click To Define');
else
    set(hObject,'String',handles.carrier_sound.getType());
end
guidata(hObject, handles);% Update handles structure


% --- Executes during object creation, after setting all properties.
function carrier_sound_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to carrier_sound_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function intensity_Callback(hObject, eventdata, handles)
% hObject    handle to intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intensity as text
%        str2double(get(hObject,'String')) returns contents of intensity as a double


% --- Executes during object creation, after setting all properties.
function intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intensity (see GCBO)
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
if handles.carrier_sound==0
     msgbox('Sound is not defined, please define it','Warning','modal') ;
     return;
end
mod_frequency = findobj('Tag','mod_frequency');
mod_depth = findobj('Tag','mod_depth');
mod_type = findobj('Tag','mod_type');
sound = ModulatedSound(handles.carrier_sound, str2double(get(mod_frequency,'String')), str2double(get(mod_depth,'String')), get(mod_type,'String') );
handles.sound=sound;
guidata(hObject, handles);% Update handles structure
uiresume



function frequency_Callback(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frequency as text
%        str2double(get(hObject,'String')) returns contents of frequency as a double


% --- Executes during object creation, after setting all properties.
function frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mod_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to mod_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mod_frequency as text
%        str2double(get(hObject,'String')) returns contents of mod_frequency as a double


% --- Executes during object creation, after setting all properties.
function mod_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mod_depth_Callback(hObject, eventdata, handles)
% hObject    handle to mod_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mod_depth as text
%        str2double(get(hObject,'String')) returns contents of mod_depth as a double


% --- Executes during object creation, after setting all properties.
function mod_depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mod_type_Callback(hObject, eventdata, handles)
% hObject    handle to mod_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mod_type as text
%        str2double(get(hObject,'String')) returns contents of mod_type as a double


% --- Executes during object creation, after setting all properties.
function mod_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mod_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


