%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   Launches the PSS tools
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = tools(varargin)
%
% TOOLS M-file for tools.fig
%      TOOLS, by itself, creates a test TOOLS or raises the existing
%      singleton*.
%
%      H = TOOLS returns the handle to a test TOOLS or the handle to
%      the existing singleton*.
%
%      TOOLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOOLS.M with the given input arguments.
%
%      TOOLS('Property','Value',...) creates a test TOOLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tools_OpeningFcn gets called.  An
%      unrecognized property filename or invalid value makes property application
%      stop.  All inputs are passed to tools_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tools

% Last Modified by GUIDE v2.5 05-May-2009 16:13:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tools_OpeningFcn, ...
                   'gui_OutputFcn',  @tools_OutputFcn, ...
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


% --- Executes just before tools is made visible.
function tools_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tools (see VARARGIN)

% Choose default command line output for tools
handles.output = hObject;
handles.test=0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tools wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tools_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CreateTest();
% Update handles structure
% set(handles.filename,'String',handles.test.name);
% guidata(hObject, handles);


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.test==0
    try
        [filename,pathname]= uigetfile('*.test','Open the Test-file');
        mat=load( fullfile(pathname,filename),'-mat' );
        handles.test=mat.test;
    catch error
        msgbox(error.message,'Unable to open a file','modal') ;
        return;
    end
    set(handles.filename,'String',handles.test.name);
    handles.test.play();
end


% --- Executes on button press in analysis.
function analysis_Callback(hObject, eventdata, handles)
% hObject    handle to analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AnalysisTool();

