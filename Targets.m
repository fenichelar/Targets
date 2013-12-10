% Alec Fenichel
% Section E

function varargout = Targets(varargin)
% TARGETS MATLAB code for Targets.fig
%      TARGETS, by itself, creates a new TARGETS or raises the existing
%      singleton*.
%
%      H = TARGETS returns the handle to a new TARGETS or the handle to
%      the existing singleton*.
%
%      TARGETS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TARGETS.M with the given input arguments.
%
%      TARGETS('Property','Value',...) creates a new TARGETS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Targets_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Targets_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Targets

% Last Modified by GUIDE v2.5 28-Aug-2013 13:55:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Targets_OpeningFcn, ...
                   'gui_OutputFcn',  @Targets_OutputFcn, ...
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


% --- Executes just before Targets is made visible.
function Targets_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Targets (see VARARGIN)

% Choose default command line output for Targets
handles.output = hObject;

set(handles.drawPoints,'Enable','off')
setupAxes(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Targets wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Targets_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function points_Callback(hObject, eventdata, handles)
% hObject    handle to points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of points as text
%        str2double(get(hObject,'String')) returns contents of points as a double

points = str2double(get(hObject,'String'));

if isempty(points) || ~isnumeric(points) || ~isreal(points) || ~isfinite(points) || ~(points == fix(points)) || (points < 1)
    set(handles.points,'String','1');
end

% --- Executes during object creation, after setting all properties.
function points_CreateFcn(hObject, eventdata, handles)
% hObject    handle to points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in drawTarget.
function drawTarget_Callback(hObject, eventdata, handles)
% hObject    handle to drawTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes,'reset');
set(handles.drawPoints,'Enable','on')

handles.coordinates = .1 + (.8).*rand(1,2);
maximumRadius = min(min(abs(handles.coordinates)),min(abs(handles.coordinates-1)));
handles.r = .1 + (maximumRadius-.1).*rand(1);

handles.actualProbability = pi*handles.r*handles.r;

set(handles.radius,'String',num2str(handles.r,12));
set(handles.actual,'String',num2str(handles.actualProbability,12));
set(handles.observed,'String',' ');
set(handles.error,'String',' ');

setupAxes(hObject, eventdata, handles)
drawTarget(hObject, eventdata, handles)

guidata(hObject, handles);

% --- Executes on button press in drawPoints.
function drawPoints_Callback(hObject, eventdata, handles)
% hObject    handle to drawPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes,'reset');

setupAxes(hObject, eventdata, handles)
drawTarget(hObject, eventdata, handles)

points = str2double(get(handles.points,'String'));
pointCordinates = rand(2,points);
inside = (pointCordinates(1,1:end) - handles.coordinates(1)).^2 + (pointCordinates(2,1:end) - handles.coordinates(2)).^2 <= handles.r.^2;
observed = sum(inside(:))/points;
error = abs(observed-handles.actualProbability)/handles.actualProbability;

set(handles.observed,'String',num2str(observed,12));
set(handles.error,'String',num2str(error,12));

hold on;
plot(pointCordinates(1,1:end),pointCordinates(2,1:end),'.','MarkerSize',1,'Color','white');

guidata(hObject, handles);


function setupAxes(hObject, eventdata, handles)
hold on;
axis(handles.axes,[0 1 0 1]);
axis(handles.axes,'manual');
set(handles.axes,'color','black');
set(handles.axes,'XTick',0:.1:1);
set(handles.axes,'YTick',0:.1:1);

function drawTarget(hObject, eventdata, handles)
th = 0:pi/50:2*pi;
xunit = handles.r * cos(th) + handles.coordinates(1);
yunit = handles.r * sin(th) + handles.coordinates(2);
plot(xunit, yunit,'red');
