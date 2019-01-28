%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Psychophysics Software Suite ( PSS )
%   
%   CreateTest: provides GUI for Test Class creation
%  
%   Coded by: Goldberg Stanislav and Michael Lvovsky as a part of Haifa
%   University project for Dr. Karen Banai (Department of Communication
%   Disorders)
%
%   Licence: GPL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = CreateTest(varargin)
% CREATETEST M-file for CreateTest.fig
%      CREATETEST, by itself, creates a new CREATETEST or raises the existing
%      singleton*.
%
%      H = CREATETEST returns the handle to a new CREATETEST or the handle to
%      the existing singleton*.
%
%      CREATETEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATETEST.M with the given input arguments.
%
%      CREATETEST('Property','Value',...) creates a new CREATETEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CreateTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CreateTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CreateTest

% Last Modified by GUIDE v2.5 19-Aug-2009 15:54:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CreateTest_OpeningFcn, ...
                   'gui_OutputFcn',  @CreateTest_OutputFcn, ...
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


% --- Executes just before CreateTest is made visible.
function CreateTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CreateTest (see VARARGIN)

% Choose default command line output for CreateTest
handles.output = hObject;
handles.ver='Experimentator Tool'; % ver. 1 alpha';
handles.filename='Untitled.test';
handles.test=Test('Untitled.test');
set(handles.listbox,'String',[]);
set(handles.figure1,'Name',handles.filename);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CreateTest wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CreateTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.test;
close(handles.figure1);


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox


% --- Executes during object creation, after setting all properties.
function listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Block_Callback(hObject, eventdata, handles)
% hObject    handle to Block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Add_Block_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
block=CreateBlock();
if block==0
    return;
end
array=get( handles.listbox,'String'); 
if isempty(array)
    array={  block.name };
else
    for i=1:length(array)
        if strcmp(array{i},block.name)==1
            msgbox('Could not add two Blocks with the same name','Warning','modal') ;
            return;
        end
    end
    array=[ array ;  block.name ];
end
handles.test.addBlock(block);
%array=[ array, sprintf('%s [%s]', block.name,block.reference_sound.getType()) ];
set( handles.listbox,'Value',1); 
set( handles.listbox,'String',array); 


% --------------------------------------------------------------------
function Edit_Block_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.listbox,'String');
if isempty(contents)
    return;
end
number=get(handles.listbox,'Value');
block=CreateBlock(handles.test.blocks(number));
if block==0
    return;
else
    contents{number}=block.name;
    set(handles.listbox,'String',contents);
    handles.test.blocks(number)=block;
end

% --------------------------------------------------------------------
function Remove_Block_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_Block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.listbox,'String');
if isempty(contents)
    return;
end
number=get(handles.listbox,'Value');
handles.test.removeBlock(number);
contents(number)=[];
if number>1
set(handles.listbox,'Value',number-1);
else
    set(handles.listbox,'Value',1);
end
set(handles.listbox,'String',contents);


% --------------------------------------------------------------------
function New_Callback(hObject, eventdata, handles)
% hObject    handle to New (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CreateTest_OpeningFcn(hObject, eventdata, handles, []);

% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,FilterIndex]=uiputfile('*.test','Open the Test-file');
filename=fullfile(PathName,FileName);
try
    mat=load( filename,'-mat' );
    handles.test=mat.test;
catch error
    msgbox(error.message,'Unable to open a file','modal') ;
end
handles.filename=filename;
guidata(hObject, handles);
set(handles.figure1,'Name',filename);
for i=1: length(mat.test.blocks)
    if i==1
        contents={mat.test.blocks(1).name};
    else
        contents=[ contents; mat.test.blocks(i).name];
    end
end
set(handles.listbox,'Value',1);
set(handles.listbox,'String',contents);



% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [FileName,PathName,FilterIndex]=uiputfile(handles.filename,'Save the Test-file');
    filename=fullfile(PathName,FileName);
catch error
     msgbox(error.message,'Unable to save a file','modal') ;
end
test=handles.test;
save( filename, 'test' );
handles.filename=filename;
set(handles.figure1,'Name',filename);
guidata(hObject, handles);
% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Are you sure you want to exit?', ...
	'Exit ', ...
	'Exit','Cancel','Cancel');
if strcmp(choice,'Exit')==1
uiresume(handles.figure1); 
end
% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox({handles.ver, ' ','Programmed by Goldberg Stas and Michael Lvovsky for Karen Banai'},handles.filename,'modal') ;


% --- Executes on button press in Move_Up.
function Move_Up_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.listbox,'String');
number=get(handles.listbox,'Value');
if number<=1
    return;
end
prev=number-1;
value=contents{prev};
contents(prev)=contents(number);
contents(number)={value};
set(handles.listbox,'String',contents);
set(handles.listbox,'Value',prev);
handles.test.up(number);

% --- Executes on button press in Move_Down.
function Move_Down_Callback(hObject, eventdata, handles)
% hObject    handle to Move_Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.listbox,'String');
number=get(handles.listbox,'Value');
if number>=length(contents);
    return;
end
next=number+1;
value=contents{next};
contents(next)=contents(number);
contents(number)={value};
set(handles.listbox,'String',contents);
set(handles.listbox,'Value',next);
handles.test.down(number);


% % --- Executes on button press in Add_Block.
% function Add_Block_Callback(hObject, eventdata, handles)
% % hObject    handle to Add_Block (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% % --- Executes on button press in Edit_Block.
% function Edit_Block_Callback(hObject, eventdata, handles)
% % hObject    handle to Edit_Block (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% % --- Executes on button press in Remove_Block.
% function Remove_Block_Callback(hObject, eventdata, handles)
% % hObject    handle to Remove_Block (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)


