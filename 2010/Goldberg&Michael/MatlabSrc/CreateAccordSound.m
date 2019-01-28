%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   CreateAccordSound: provides GUI for AccordSound Class creation
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = CreateAccordSound(varargin)
% CREATEACCORDSOUND M-file for CreateAccordSound.fig
%      CREATEACCORDSOUND, by itself, creates a new CREATEACCORDSOUND or raises the existing
%      singleton*.
%
%      H = CREATEACCORDSOUND returns the handle to a new CREATEACCORDSOUND or the handle to
%      the existing singleton*.
%
%      CREATEACCORDSOUND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATEACCORDSOUND.M with the given input arguments.
%
%      CREATEACCORDSOUND('Property','Value',...) creates a new CREATEACCORDSOUND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CreateAccordSound_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CreateAccordSound_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CreateAccordSound

% Last Modified by GUIDE v2.5 16-Jul-2009 09:35:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CreateAccordSound_OpeningFcn, ...
                   'gui_OutputFcn',  @CreateAccordSound_OutputFcn, ...
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


% --- Executes just before CreateAccordSound is made visible.
function CreateAccordSound_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CreateAccordSound (see VARARGIN)

% Choose default command line output for CreateAccordSound
handles.sound=-1;
duration = findobj('Tag','duration');
intensity = findobj('Tag','intensity');
frequency = findobj('Tag','frequency');
if ~isempty(varargin) && strcmp(class(varargin{1}),'AccordSound') %copying AccordSound parameters
    sound=varargin{1};
    set(duration,'String',sound.duration);
    set(intensity,'String', sound.intensity);
    frequencies='';
    for i=1:length(sound.frequencies)
        frequencies=sprintf('%s %g',frequencies, sound.frequencies{i});
    end
    set(frequency,'String', frequencies);
else
    % default values
    set( duration,'String',1000 ) ;
    set( intensity,'String',0.5 ) 
    set( frequency,'String','1440  1220') ;
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CreateAccordSound wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CreateAccordSound_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.sound;
close(hObject);



function duration_Callback(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration as text
%        str2double(get(hObject,'String')) returns contents of duration as a double


% --- Executes during object creation, after setting all properties.
function duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
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



% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sound=0;
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
duration = findobj('Tag','duration');
intensity = findobj('Tag','intensity');
frequency = findobj('Tag','frequency');
str=get(frequency,'String');
    [token,str] = strtok(str, ' ');
    array=str2double(token);
sound = AccordSound(str2double(get(duration,'String')) , str2double(get(intensity,'String')), array(1) );
while ~isempty(str)
    [token,str] = strtok(str, ' ');
    %array=[array, str2double(token)];
    sound.frequencies=[sound.frequencies, str2double(token)];
end
%str='';
% for i=1:length(array)
%     str=strcat(str,sprintf(', array(%g)',i));
% end
%eval(strcat('sound = AccordSound(str2double(get(duration,''String'')) ,str2double(get(intensity,''String''))',str,');' ) );
handles.sound=sound;
guidata(hObject, handles);% Update handles structure
uiresume(handles.figure1);



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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


