%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   CalculateDelta: assists CreateBlock GUI in delta parameter calculation
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = CalculateDelta(varargin)
% CALCULATEDELTA M-file for CalculateDelta.fig
%      CALCULATEDELTA, by itself, creates a new CALCULATEDELTA or raises the existing
%      singleton*.
%
%      H = CALCULATEDELTA returns the handle to a new CALCULATEDELTA or the handle to
%      the existing singleton*.
%
%      CALCULATEDELTA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCULATEDELTA.M with the given input arguments.
%
%      CALCULATEDELTA('Property','Value',...) creates a new CALCULATEDELTA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalculateDelta_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalculateDelta_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalculateDelta

% Last Modified by GUIDE v2.5 10-May-2009 15:02:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalculateDelta_OpeningFcn, ...
                   'gui_OutputFcn',  @CalculateDelta_OutputFcn, ...
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


% --- Executes just before CalculateDelta is made visible.
function CalculateDelta_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalculateDelta (see VARARGIN)

% Choose default command line output for CalculateDelta
handles.output = 0;
if length(varargin)==2
    set(handles.delta,'String',varargin{1});
    set(handles.value,'String',varargin{2});
    value_Callback(handles.value, eventdata, handles);
end
% Update handles structure
set( handles.figure1,'Name','Delta Calculation');
guidata(hObject, handles);

% UIWAIT makes CalculateDelta wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CalculateDelta_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
close(handles.figure1);
varargout{1} = handles.output;




function delta_Callback(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta as text
delta=str2double(get(hObject,'String')); % returns contents of delta as a double
value=str2double(get(handles.value,'String'));
value_units=value*(delta/100);
set(handles.value_units,'String',value_units);
value=value_units/(delta/100);
set(handles.value,'String',value);

% --- Executes during object creation, after setting all properties.
function delta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','gray');
end



function value_units_Callback(hObject, eventdata, handles)
% hObject    handle to value_units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_units as text
value_units=str2double(get(hObject,'String')); % returns contents of value_units as a double
delta=str2double(get(handles.delta,'String'));
value=value_units/(delta/100);
set(handles.value,'String',value);
handles.output=value;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function value_units_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function value_Callback(hObject, eventdata, handles)
% hObject    handle to value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value as text
value=str2double(get(hObject,'String')) ;% returns contents of value as a double
delta=str2double(get(handles.delta,'String'));
value_units=value*(delta/100);
set(handles.value_units,'String',value_units);
handles.output=value;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output=0;
uiresume(handles.figure1);

