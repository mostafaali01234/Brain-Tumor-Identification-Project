function varargout = GUI_Project(varargin)
% GUI_PROJECT MATLAB code for GUI_Project.fig
%      GUI_PROJECT, by itself, creates a new GUI_PROJECT or raises the existing
%      singleton*.
%
%      H = GUI_PROJECT returns the handle to a new GUI_PROJECT or the handle to
%      the existing singleton*.
%
%      GUI_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PROJECT.M with the given input arguments.
%
%      GUI_PROJECT('Property','Value',...) creates a new GUI_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Project

% Last Modified by GUIDE v2.5 09-Aug-2020 03:29:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Project_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Project_OutputFcn, ...
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


% --- Executes just before GUI_Project is made visible.
function GUI_Project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Project (see VARARGIN)
movegui(handles.figure1,'center');
background = imread('background.jpg');
axes(handles.axesBackground);
imshow(background, []); 

% Choose default command line output for GUI_Project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in uploadImage.
function uploadImage_Callback(hObject, eventdata, handles)
try
    [MY_IMAGE MY_PATH] = uigetfile({'*.jpg;*.png'});    % only jpg && png
    path = strcat(MY_PATH,MY_IMAGE);       %% full directory of your file
    img = imread(path);                    %% read the selected image 
    axes(handles.axesInput);
    imshow(img);                           %% Show the Image on axes
    set(handles.axesInput , 'visible' ,'off');
    set(handles.txt1,'string','Brain MR Image');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% To remove any data ,When you want to choose another photo %%%%%%
    axes(handles.axesOutput);
    imshow('');
    axes(handles.axesOutput2);
    imshow('');
    set(handles.txt2,'string','');
    set(handles.txt3,'string','');
    
    set(handles.txtContrast,'string','');
    set(handles.txtCorrelation,'string','');
    set(handles.txtHomogeneity,'string','');
    set(handles.txtEnergy,'string','');
    set(handles.txtMean,'string','');
    set(handles.txtVariance,'string','');
    set(handles.txtStandard,'string','');
    set(handles.txtEntropy,'string','');
    set(handles.txtDissimilarity,'string','');
    set(handles.txtTumor,'string','');    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%To store image in handles
    handles.ImgData = img;
    guidata(hObject,handles);
catch
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Filter_Button.
function Filter_Button_Callback(hObject, eventdata, handles)
try
    if isfield(handles,'ImgData')      %% get the saved image 
        I = handles.ImgData;
    end
    
    FilteredImage = MedianFilter(I);         %% Call The MedianFilter Function
    axes(handles.axesOutput);
    imshow(FilteredImage);                   %% Show Filtered Image on the axes
    set(handles.axesOutput , 'visible' ,'off');
    set(handles.txt2,'string','Filtered Image');
 
catch
    GUI_Error('Please Choose an Image');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in fuzzy_Button.
function fuzzy_Button_Callback(hObject, eventdata, handles)

try 
    I = getimage(handles.axesOutput);         %% get the image from the axes 

    segmentedImage = fuzzySegmentation(I,handles);    %% Call The Function
    axes(handles.axesOutput2);
    imshow(segmentedImage);                   %% Show Segmented Image on the next axes
    set(handles.axesOutput2 , 'visible' ,'off'); 
    set(handles.txt3,'string','Segmented Image');

    %%%%% Call the glcm Function
    [contrast,correlation,homogeneity,energy,dissimilarity,entropyy,mean,variance,standardDev] = glcm();   
    
    %%%% set the returned data from glcm function into texts(GUI)
    set(handles.txtContrast,'string',contrast);
    set(handles.txtCorrelation,'string',correlation);
    set(handles.txtHomogeneity,'string',homogeneity);
    set(handles.txtEnergy,'string',energy);
    set(handles.txtMean,'string',mean);
    set(handles.txtVariance,'string',variance);
    set(handles.txtStandard,'string',standardDev);
    set(handles.txtEntropy,'string',entropyy);
    set(handles.txtDissimilarity,'string',dissimilarity);

catch
    GUI_Error('The First, Click on median filter button');
end

try
    %%%%%% To call python code %%%%%%%%%%
    val = [contrast,correlation,homogeneity,energy,dissimilarity,entropyy,mean,variance,standardDev];
    value = py.svm.predict(val);
    if value.char == '1'
        set(handles.txtTumor,'string','Yes');  
    else
        set(handles.txtTumor,'string','No');        
    end
catch
    GUI_Error('Error in Call Python Code');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in linear Accuracy.
function linearAcc_Callback(hObject, eventdata, handles)
try    
    oldAccuracy = 0;
    hWaitBar = waitbar(0,'Evaluating Maximum Accuracy with 100 iterations');     %% Create wait bar
    for i=1:100
        %%%%%% Call python code for (linear) kernel %%%%%%%%%%
        newAccuracy = py.svm_accuracy.kerFun('linear');
        if newAccuracy > oldAccuracy
            oldAccuracy = newAccuracy;
        end
        waitbar(i/100);  %% update
    end
    
    delete(hWaitBar);  %% delete wait bar
    
    %%% set the accuracy value into the text(GUI) 
    set(handles.txtLinear,'string',strcat(int2str(round(oldAccuracy*100)),' %'));
catch
    GUI_Error('Error in Call Python Code');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in rbf Accuracy.
function rbfAcc_Callback(hObject, eventdata, handles)
try
    oldAccuracy = 0;
    hWaitBar = waitbar(0,'Evaluating Maximum Accuracy with 100 iterations');    %% Create wait bar
    for i=1:100
        %%%%%% Call python code for (rbf) kernel %%%%%%%%%%
        newAccuracy = py.svm_accuracy.kerFun('rbf');
        if newAccuracy > oldAccuracy
            oldAccuracy = newAccuracy;
        end
        waitbar(i/100);   %% update
    end
    
    delete(hWaitBar);    %% delete wait bar
    
    %%% set the accuracy value into the text(GUI) 
    set(handles.txtRBF,'string',strcat(int2str(round(oldAccuracy*100)),' %'));
catch
    GUI_Error('Error in Call Python Code');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in polynomial Accuracy.
function polynomialAcc_Callback(hObject, eventdata, handles)
try
    oldAccuracy = 0;
    hWaitBar = waitbar(0,'Evaluating Maximum Accuracy with 100 iterations');    %% Create wait bar
    for i=1:100
        %%%%%% Call python code for (polynomial) kernel %%%%%%%%%%
        newAccuracy = py.svm_accuracy.kerFun('poly');
        if newAccuracy > oldAccuracy
            oldAccuracy = newAccuracy;
        end
        waitbar(i/100);    %% update
    end
    
    delete(hWaitBar);    %% delete wait bar
    
    %%% set the accuracy value into the text(GUI) 
    set(handles.txtPolynomial,'string',strcat(int2str(round(oldAccuracy*100)),' %'));
catch
    GUI_Error('Error in Call Python Code');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in sigmoid Accuracy.
function sigmoidAcc_Callback(hObject, eventdata, handles)
try
    oldAccuracy = 0;
    hWaitBar = waitbar(0,'Evaluating Maximum Accuracy with 100 iterations');    %% Create wait bar
    for i=1:100
        %%%%%% Call python code for (sigmoid) kernel %%%%%%%%%%
        newAccuracy = py.svm_accuracy.kerFun('sigmoid');
        if newAccuracy > oldAccuracy
            oldAccuracy = newAccuracy;
        end
        waitbar(i/100);    %% update
    end
    
    delete(hWaitBar);    %% delete wait bar
    
    %%% set the accuracy value into the text(GUI) 
    set(handles.txtSigmoid,'string',strcat(int2str(round(oldAccuracy*100)),' %'));
catch
    GUI_Error('Error in Call Python Code');
end


