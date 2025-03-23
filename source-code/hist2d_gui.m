function varargout = hist2d_gui(varargin)
% HIST2D_GUI M-file for hist2d_gui.fig
%      HIST2D_GUI, by itself, creates a new HIST2D_GUI or raises the existing
%      singleton*.
%
%      H = HIST2D_GUI returns the handle to a new HIST2D_GUI or the handle to
%      the existing singleton*.
%
%      HIST2D_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HIST2D_GUI.M with the given input arguments.
%
%      HIST2D_GUI('Property','Value',...) creates a new HIST2D_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hist2d_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hist2d_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hist2d_gui

% Last Modified by GUIDE v2.5 06-Dec-2015 19:17:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hist2d_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @hist2d_gui_OutputFcn, ...
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

% --- Executes just before hist2d_gui is made visible.
function hist2d_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hist2d_gui (see VARARGIN)

set(gcf,'Name','hist2d_gui  ---  Unsaved Session  ---  (no file)')

% Choose default command line output for hist2d_gui
handles.output = hObject;
handles.filename=[];
handles.axfntsz=14;
handles.prev_bin=250;
handles.pxy=[0,0];
handles.ax_x=[];
handles.ax_y=[];
handles.all_thresh_lists(1).thresh_list={};
handles.thresh_lists_idx=1;
handles.genfig_hist_hands=[];
handles.genfig_scat_hands=[];
handles.genfig_hist_names={};
handles.curdir=pwd;
handles.scat2d_quadtxt_on_out=true;
handles.bardata_y=[];
handles.bardata_err=[];

%file = uigetfile('*.mat');
file=0;
if ~isequal(file, 0)
    curdata=open(file);
    if isfield(curdata,'proc_data') && isfield(curdata,'datapts') && isfield(curdata,'grps') && isfield(curdata,'samp_list')
        curdata.workinggroup={};
        handles.curdata=curdata;
        app_chan_list={};
        for n=1:length(handles.curdata.proc_data)
            for m=1:length(handles.curdata.proc_data(n).data)
                app_chan_list=[app_chan_list,handles.curdata.proc_data(n).data(m).channel_list];
            end
        end
        objlist=unique(app_chan_list);
        set(handles.popupmenu1,'String',objlist)
        handles.obj_list=objlist;
        
        guidata(hObject,handles);
        
        set(handles.listbox1,'String',handles.curdata.samp_list)
        
        chanlist=fields(handles.curdata.proc_data(1).data(1).chan_dat(1));
        set(handles.popupmenu4,'String',chanlist)
        set(handles.popupmenu3,'String',chanlist)
    else
        errordlg('File Contents not compatible')
    end
end

set(handles.radiobutton_2d,'Value',1)
set(handles.radiobutton_1d,'Value',0)
set(handles.edit_bins_1d,'Enable','inactive')


% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using hist2d_gui.
if strcmp(get(hObject,'Visible'),'off')
    plot(0,0);
    xlim([0 4100])
    ylim([0 4100])
    set(gca,'FontName','Arial','Fontsize',handles.axfntsz)
end

% UIWAIT makes hist2d_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hist2d_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

refresh_graph(hObject,handles)

[handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
update_bargtable(hObject,handles);

guidata(hObject,handles);



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,temppath] = uigetfile('*.mat');

if ~isequal(file, 0)
    handles.curdir=temppath;
    guidata(hObject,handles);
    cd(handles.curdir)
    
    curdata=open([handles.curdir,file]);
    if isfield(curdata,'proc_data') && isfield(curdata,'datapts') && isfield(curdata,'grps') && isfield(curdata,'samp_list')
        handles.filename=file;
        
        newgrps=curdata.grps; %cell row 2 = selconds_b indices 
        for k=1:length(curdata.grps) %cell row 3 = names
            workinggroup{3,k}=num2str(k);
        end      
        for m=1:length(newgrps)
            cur_sel_conds = newgrps{m};
            grps=curdata.grps;
            selconds_a={};selconds_b={};
            for n=1:length(cur_sel_conds)
                for a=1:length(grps)
                    b=find(grps{a}==cur_sel_conds(n));
                    if ~isempty(b)
                        workinggroup{1,m}(n)=a;
                        workinggroup{2,m}(n)=b;
                        break
                    end
                end
            end
        end
        curdata.workinggroup=workinggroup;
        
        handles.curdata=curdata;
        handles.pxy=[0,0];
        handles.all_thresh_lists(1).thresh_list={};
        handles.thresh_lists_idx=1;
                
        app_chan_list={};
        for n=1:length(handles.curdata.proc_data)
            for m=1:length(handles.curdata.proc_data(n).data)
                app_chan_list=[app_chan_list,handles.curdata.proc_data(n).data(m).channel_list];
            end
        end
        objlist=unique(app_chan_list);
        set(handles.popupmenu1,'String',objlist)
        set(handles.popupmenu1,'Value',1)
        handles.obj_list=objlist;
        
        guidata(hObject,handles);
        
        set(handles.listbox1,'String',handles.curdata.samp_list)
        set(handles.listbox1,'Value',1)
        
        chanlist=fields(handles.curdata.proc_data(1).data(1).chan_dat(1));
        set(handles.popupmenu4,'String',chanlist)
        set(handles.popupmenu4,'Value',1)
        set(handles.popupmenu3,'String',chanlist)
        set(handles.popupmenu3,'Value',1)
        
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        guidata(hObject,handles);
        
        set(gcf,'Name',['hist2d_gui  ---  Unsaved Session  ---  (',handles.filename,')'])
    else
        errordlg('File Contents not compatible')
    end
end


% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
refresh_graph(hObject,handles)
%if isfield(handles.curdata,'workinggroup')
[handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
update_bargtable(hObject,handles);
%end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
refresh_graph(hObject,handles)
[handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
update_bargtable(hObject,handles);

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
refresh_graph(hObject,handles)
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.all_thresh_lists=handles.all_thresh_lists(1);
handles.thresh_lists_idx=1;
guidata(hObject,handles);
refresh_graph(hObject,handles);

[handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
update_bargtable(hObject,handles);

guidata(hObject,handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton6,'Enable','off')
try
    if handles.thresh_lists_idx>1
        handles.thresh_lists_idx=handles.thresh_lists_idx-1;
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    end
    set(handles.pushbutton6,'Enable','on')
catch
    set(handles.pushbutton6,'Enable','on')
end


% --- Executes on button press in pushbutton_genfig.
function pushbutton_genfig_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_genfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'curdata')
popup_sel_index = get(handles.popupmenu1, 'Value'); %to keep running until switch over
sel_conds = get(handles.listbox1,'Value');
%mapping
grps=handles.curdata.grps;
selconds_a=[];
for z=1:length(sel_conds)
    for n=1:length(grps)
        m=find(grps{n}==sel_conds(z));
        if ~isempty(m)
            selconds_a(z)=n;
            selconds_b(z)=m;
            break
        end
    end
end
sel_obj = get(handles.popupmenu1, 'Value');
sel_chanX = get(handles.popupmenu3,'Value');
name_chanX = get(handles.popupmenu3,'String');
sel_chanY = get(handles.popupmenu4,'Value');
name_chanY = get(handles.popupmenu4,'String');

px = str2double(get(handles.edit5, 'String'));
if isnan(px)
    px=0;
    set(handles.edit5, 'String', px);
end
py = str2double(get(handles.edit6, 'String'));
if isnan(py)
    py=0;
    set(handles.edit6, 'String', py);
end
handles.pxy=[px,py];


if ~isempty(selconds_a)
    bin=str2double(get(handles.edit_bins_1d,'String'));
    if get(handles.radiobutton_1d,'Value')>0
        
        fighands_ln=length(handles.genfig_hist_hands);
        idx2addfig=get(handles.popupmenu_add2plot,'Value')-1;
        if idx2addfig<1
            handles.genfig_hist_hands(fighands_ln+1)=figure;
            figname=['hist #' num2str(fighands_ln+1)];
            set(handles.genfig_hist_hands(fighands_ln+1),'Name',figname)
            handles.genfig_hist_names{fighands_ln+1,1}=figname;
            handles.genfig_hist_names{fighands_ln+1,2}=1;
            set(handles.popupmenu_add2plot,'String',{'Add to Figure... (new)',handles.genfig_hist_names{:,1}})
            idx2addfig=fighands_ln+1;
        else
            figure(handles.genfig_hist_hands(idx2addfig));
            handles.genfig_hist_names{idx2addfig,2}=handles.genfig_hist_names{idx2addfig,2}+1;
        end
                 
        fig_prop.fontsize=handles.axfntsz;
        fig_prop.isnew=true;
        fig_prop.plot_num=handles.genfig_hist_names{idx2addfig,2};
        [stats]=hist1d_4gui_NIS_objdata(handles.genfig_hist_hands(idx2addfig),handles.pxy,bin,handles.curdata,handles.obj_list{sel_obj},[sel_chanX],selconds_a,selconds_b,handles.all_thresh_lists(handles.thresh_lists_idx).thresh_list,fig_prop);
        set(gca,'FontName','Arial','Fontsize',handles.axfntsz)
        ylabel('Number of Cells')
        set(handles.text10,'String','')
        set(handles.text11,'String','')
        set(handles.text12,'String','')
        set(handles.text13,'String','')
    else
        fighands_ln=length(handles.genfig_scat_hands);
        handles.genfig_scat_hands(fighands_ln+1)=figure;
        figname=['scatter #' num2str(fighands_ln+1)];
        set(handles.genfig_scat_hands(fighands_ln+1),'Name',figname)
        idx2addfig=fighands_ln+1;
        
        fig_prop.fontsize=handles.axfntsz;
        fig_prop.isnew=true;
        fig_prop.xylabel={name_chanX{sel_chanX},name_chanY{sel_chanY}};
        fig_prop.addperc=handles.scat2d_quadtxt_on_out;
        [hax,pxy,stats]=hist2d_4gui_NIS_objdata(handles.genfig_scat_hands(idx2addfig),handles.pxy,bin,handles.curdata,handles.obj_list{sel_obj},[sel_chanX,sel_chanY],selconds_a,selconds_b,handles.all_thresh_lists(handles.thresh_lists_idx).thresh_list,fig_prop);
        other=hax;
        set(other,'FontName','Arial','Fontsize',handles.axfntsz)
        %{
        txt_ll=sprintf('%.2f%s +/- %.2f%s',stats.perc_mean(2,1,1)*100,'%',stats.perc_std(2,1,1)*100,'%');
        txt_lr=sprintf('%.2f%s +/- %.2f%s',stats.perc_mean(2,2,1)*100,'%',stats.perc_std(2,2,1)*100,'%');%[num2str(stats.perc_mean{k}(2,2)*100,3) '% +/- ' num2str(stats.perc_sd{k}(2,2)*100,2) '%'];
        txt_ul=sprintf('%.2f%s +/- %.2f%s',stats.perc_mean(1,1,1)*100,'%',stats.perc_std(1,1,1)*100,'%');
        txt_ur=sprintf('%.2f%s +/- %.2f%s',stats.perc_mean(1,2,1)*100,'%',stats.perc_std(1,2,1)*100,'%');
        set(handles.text10,'String',txt_ul)
        set(handles.text11,'String',txt_ur)
        set(handles.text12,'String',txt_ll)
        set(handles.text13,'String',txt_lr)
        %}
    end
    
    if ~isempty(handles.ax_x)
        xlim(handles.ax_x)
    end
    if ~isempty(handles.ax_y)
        ylim(handles.ax_y)
    end
end
guidata(hObject,handles)
end



% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
if get(handles.radiobutton_1d,'Value')==0
    refresh_graph(hObject,handles)
    
    [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
    update_bargtable(hObject,handles);
    
    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
px = str2double(get(handles.edit5, 'String'));
if isnan(px)
    px=handles.pxy(1);
    set(handles.edit5, 'String', px);
end

refresh_graph(hObject,handles)

[handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
update_bargtable(hObject,handles);

handles.pxy(1)=px;
guidata(hObject,handles);


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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
py = str2double(get(handles.edit6, 'String'));
if isnan(py)
    py=handles.pxy(2);
    set(handles.edit6, 'String', py);
end

refresh_graph(hObject,handles)

[handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
update_bargtable(hObject,handles);

handles.pxy(2)=py;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_gate_L.
function pushbutton_gate_L_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gate_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'curdata')
    ln_list=length(handles.all_thresh_lists);
    if ln_list>handles.thresh_lists_idx
        ln_list=handles.thresh_lists_idx;
        handles.all_thresh_lists=handles.all_thresh_lists(1:ln_list);
    end
    handles.thresh_lists_idx=ln_list+1;
    
    cur_list=handles.all_thresh_lists(end).thresh_list;
    ln_list_ln=size(cur_list,1);
    chan_idx=get(handles.popupmenu3,'Value');
    chan_name_list=get(handles.popupmenu3,'String');
    
    minmax=[-Inf,str2double(get(handles.edit5, 'String'))];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx},minmax},cur_list)
        cur_list{ln_list_ln+1,1}=chan_name_list{chan_idx};
        cur_list{ln_list_ln+1,2}=minmax;
        
        ln_list=length(handles.all_thresh_lists);
        handles.all_thresh_lists(ln_list+1).thresh_list=cur_list;
        
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    end
end


% --- Executes on button press in pushbutton_gate_R.
function pushbutton_gate_R_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gate_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'curdata')
    ln_list=length(handles.all_thresh_lists);
    if ln_list>handles.thresh_lists_idx
        ln_list=handles.thresh_lists_idx;
        handles.all_thresh_lists=handles.all_thresh_lists(1:ln_list);
    end
    handles.thresh_lists_idx=ln_list+1;
    
    cur_list=handles.all_thresh_lists(end).thresh_list;
    ln_list_ln=size(cur_list,1);
    chan_idx=get(handles.popupmenu3,'Value');
    chan_name_list=get(handles.popupmenu3,'String');
    
    minmax=[str2double(get(handles.edit5, 'String')),Inf];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx},minmax},cur_list)
        cur_list{ln_list_ln+1,1}=chan_name_list{chan_idx};
        cur_list{ln_list_ln+1,2}=minmax;
        
        ln_list=length(handles.all_thresh_lists);
        handles.all_thresh_lists(ln_list+1).thresh_list=cur_list;
        
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    end
end

% --- Executes on button press in pushbutton_gate_D.
function pushbutton_gate_D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gate_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'curdata')
    ln_list=length(handles.all_thresh_lists);
    if ln_list>handles.thresh_lists_idx
        ln_list=handles.thresh_lists_idx;
        handles.all_thresh_lists=handles.all_thresh_lists(1:ln_list);
    end
    handles.thresh_lists_idx=ln_list+1;
    
    cur_list=handles.all_thresh_lists(end).thresh_list;
    ln_list_ln=size(cur_list,1);
    chan_idx=get(handles.popupmenu4,'Value');
    chan_name_list=get(handles.popupmenu4,'String');
    
    minmax=[-Inf,str2double(get(handles.edit6, 'String'))];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx},minmax},cur_list)
        cur_list{ln_list_ln+1,1}=chan_name_list{chan_idx};
        cur_list{ln_list_ln+1,2}=minmax;
        
        ln_list=length(handles.all_thresh_lists);
        handles.all_thresh_lists(ln_list+1).thresh_list=cur_list;
        
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    end
end

% --- Executes on button press in pushbutton_gate_U.
function pushbutton_gate_U_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gate_U (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'curdata')
    ln_list=length(handles.all_thresh_lists);
    if ln_list>handles.thresh_lists_idx
        ln_list=handles.thresh_lists_idx;
        handles.all_thresh_lists=handles.all_thresh_lists(1:ln_list);
    end
    handles.thresh_lists_idx=ln_list+1;
    
    cur_list=handles.all_thresh_lists(end).thresh_list;
    ln_list_ln=size(cur_list,1);
    chan_idx=get(handles.popupmenu4,'Value');
    chan_name_list=get(handles.popupmenu4,'String');

    minmax=[str2double(get(handles.edit6, 'String')),Inf];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx},minmax},cur_list)
        cur_list{ln_list_ln+1,1}=chan_name_list{chan_idx};
        cur_list{ln_list_ln+1,2}=minmax;
        
        ln_list=length(handles.all_thresh_lists);
        handles.all_thresh_lists(ln_list+1).thresh_list=cur_list;
        
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    end
end

% --- Executes on button press in pushbutton_gate_UL.
function pushbutton_gate_UL_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gate_UL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'curdata')
    ln_list=length(handles.all_thresh_lists);
    if ln_list>handles.thresh_lists_idx
        ln_list=handles.thresh_lists_idx;
        handles.all_thresh_lists=handles.all_thresh_lists(1:ln_list);
    end
    handles.thresh_lists_idx=ln_list+1;
    
    cur_list=handles.all_thresh_lists(end).thresh_list;
    ln_list_ln=size(cur_list,1);
    chan_idx_x=get(handles.popupmenu3,'Value');
    chan_idx_y=get(handles.popupmenu4,'Value');
    chan_name_list=get(handles.popupmenu3,'String');
    
    added=false;
    minmax=[-Inf,str2double(get(handles.edit5, 'String'))];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx_x},minmax},cur_list)
        cur_list{ln_list_ln+1,1}=chan_name_list{chan_idx_x};
        cur_list{ln_list_ln+1,2}=minmax;
        added=true;
    end
    minmax=[str2double(get(handles.edit6, 'String')),Inf];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx_y},minmax},cur_list)
        cur_list{ln_list_ln+1+added,1}=chan_name_list{chan_idx_y};
        cur_list{ln_list_ln+1+added,2}=minmax;
        added=true;
    end
    if added
        ln_list=length(handles.all_thresh_lists);
        handles.all_thresh_lists(ln_list+1).thresh_list=cur_list;
        
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    end
end

% --- Executes on button press in pushbutton_gate_UR.
function pushbutton_gate_UR_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gate_UR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'curdata')
    ln_list=length(handles.all_thresh_lists);
    if ln_list>handles.thresh_lists_idx
        ln_list=handles.thresh_lists_idx;
        handles.all_thresh_lists=handles.all_thresh_lists(1:ln_list);
    end
    handles.thresh_lists_idx=ln_list+1;
    
    cur_list=handles.all_thresh_lists(end).thresh_list;
    ln_list_ln=size(cur_list,1);
    chan_idx_x=get(handles.popupmenu3,'Value');
    chan_idx_y=get(handles.popupmenu4,'Value');
    chan_name_list=get(handles.popupmenu3,'String');
    
    added=false;
    minmax=[str2double(get(handles.edit5, 'String')),Inf];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx_x},minmax},cur_list)
        cur_list{ln_list_ln+1,1}=chan_name_list{chan_idx_x};
        cur_list{ln_list_ln+1,2}=minmax;
        added=true;
    end
    minmax=[str2double(get(handles.edit6, 'String')),Inf];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx_y},minmax},cur_list)
        cur_list{ln_list_ln+1+added,1}=chan_name_list{chan_idx_y};
        cur_list{ln_list_ln+1+added,2}=minmax;
        added=true;
    end
    if added
        ln_list=length(handles.all_thresh_lists);
        handles.all_thresh_lists(ln_list+1).thresh_list=cur_list;
        
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    end
end

% --- Executes on button press in pushbutton_gate_LR.
function pushbutton_gate_LR_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gate_LR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'curdata')
    ln_list=length(handles.all_thresh_lists);
    if ln_list>handles.thresh_lists_idx
        ln_list=handles.thresh_lists_idx;
        handles.all_thresh_lists=handles.all_thresh_lists(1:ln_list);
    end
    handles.thresh_lists_idx=ln_list+1;
    
    cur_list=handles.all_thresh_lists(end).thresh_list;
    ln_list_ln=size(cur_list,1);
    chan_idx_x=get(handles.popupmenu3,'Value');
    chan_idx_y=get(handles.popupmenu4,'Value');
    chan_name_list=get(handles.popupmenu3,'String');
    
    added=false;
    minmax=[str2double(get(handles.edit5, 'String')),Inf];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx_x},minmax},cur_list)
        cur_list{ln_list_ln+1,1}=chan_name_list{chan_idx_x};
        cur_list{ln_list_ln+1,2}=minmax;
        added=true;
    end
    minmax=[-Inf,str2double(get(handles.edit6, 'String'))];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx_y},minmax},cur_list)
        cur_list{ln_list_ln+1+added,1}=chan_name_list{chan_idx_y};
        cur_list{ln_list_ln+1+added,2}=minmax;
        added=true;
    end
    if added
        ln_list=length(handles.all_thresh_lists);
        handles.all_thresh_lists(ln_list+1).thresh_list=cur_list;
        
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    end
end

% --- Executes on button press in pushbutton_gate_LL.
function pushbutton_gate_LL_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gate_LL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'curdata')
    ln_list=length(handles.all_thresh_lists);
    if ln_list>handles.thresh_lists_idx
        ln_list=handles.thresh_lists_idx;
        handles.all_thresh_lists=handles.all_thresh_lists(1:ln_list);
    end
    handles.thresh_lists_idx=ln_list+1;
    
    cur_list=handles.all_thresh_lists(end).thresh_list;
    ln_list_ln=size(cur_list,1);
    chan_idx_x=get(handles.popupmenu3,'Value');
    chan_idx_y=get(handles.popupmenu4,'Value');
    chan_name_list=get(handles.popupmenu3,'String');
    
    added=false;
    minmax=[-Inf,str2double(get(handles.edit5, 'String'))];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx_x},minmax},cur_list)
        cur_list{ln_list_ln+1,1}=chan_name_list{chan_idx_x};
        cur_list{ln_list_ln+1,2}=minmax;
        added=true;
    end
    minmax=[-Inf,str2double(get(handles.edit6, 'String'))];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx_y},minmax},cur_list)
        cur_list{ln_list_ln+1+added,1}=chan_name_list{chan_idx_y};
        cur_list{ln_list_ln+1+added,2}=[-Inf,str2double(get(handles.edit6, 'String'))];
        added=true;
    end
    if added
        ln_list=length(handles.all_thresh_lists);
        handles.all_thresh_lists(ln_list+1).thresh_list=cur_list;
        
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    end
end

% --- Executes on button press in pushbutton_redo_gating.
function pushbutton_redo_gating_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_redo_gating (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_redo_gating,'Enable','off')
try
    ln_list=length(handles.all_thresh_lists);
    if ln_list>handles.thresh_lists_idx
        handles.thresh_lists_idx=handles.thresh_lists_idx+1;
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    end
    set(handles.pushbutton_redo_gating,'Enable','on')
catch
    set(handles.pushbutton_redo_gating,'Enable','on')
end

% --- Executes on button press in radiobutton_2d.
function radiobutton_2d_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_2d
if get(handles.radiobutton_2d,'Value')~=0
    set(handles.radiobutton_1d,'Value',0)
    set(handles.edit_bins_1d,'Enable','inactive')
    
    set(handles.pushbutton_gate_LR,'Enable','on')
    set(handles.pushbutton_gate_UL,'Enable','on')
    set(handles.pushbutton_gate_UR,'Enable','on')
    set(handles.pushbutton_gate_D,'Enable','on')
    set(handles.pushbutton_gate_U,'Enable','on')
    set(handles.edit6,'Enable','on')
    
    refresh_graph(hObject,handles);
    
    [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
    update_bargtable(hObject,handles);
    
    guidata(hObject,handles);
else
    set(handles.radiobutton_2d,'Value',1)
end


% --- Executes on button press in radiobutton_1d.
function radiobutton_1d_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_1d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_1d
if get(handles.radiobutton_1d,'Value')~=0
    set(handles.radiobutton_2d,'Value',0)
    set(handles.edit_bins_1d,'Enable','on')
    
    set(handles.pushbutton_gate_LL,'Enable','inactive')
    set(handles.pushbutton_gate_LR,'Enable','inactive')
    set(handles.pushbutton_gate_UL,'Enable','inactive')
    set(handles.pushbutton_gate_UR,'Enable','inactive')
    set(handles.pushbutton_gate_D,'Enable','inactive')
    set(handles.pushbutton_gate_U,'Enable','inactive')
    set(handles.edit6,'Enable','inactive')
    
    refresh_graph(hObject,handles);
    
    [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
    update_bargtable(hObject,handles);
    
    guidata(hObject,handles);
else
    set(handles.radiobutton_1d,'Value',1)
end



function edit_bins_1d_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bins_1d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bins_1d as text
%        str2double(get(hObject,'String')) returns contents of edit_bins_1d as a double
bins = round(str2double(get(handles.edit_bins_1d,'String')));
if isnan(bins) || bins<1
    set(handles.edit_bins_1d,'String',num2str(round(handles.prev_bin)))
else
    set(handles.edit_bins_1d,'String',num2str(bins))
    handles.prev_bin=bins;
    guidata(hObject,handles)
    refresh_graph(hObject,handles)
    
    [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
    update_bargtable(hObject,handles);
    
    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function edit_bins_1d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bins_1d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_add2plot.
function popupmenu_add2plot_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_add2plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_add2plot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_add2plot


% --- Executes during object creation, after setting all properties.
function popupmenu_add2plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_add2plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_view_Callback(hObject, eventdata, handles)
% hObject    handle to menu_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function set_xlim_Callback(hObject, eventdata, handles)
% hObject    handle to set_xlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resp=inputdlg(['Set X Axis [low high]:  '],'X Axis Label');
if ~isempty(resp)
    numresp=str2num(resp{1});
    if ~isempty(numresp)
        if length(numresp)==2
            if numresp(2)>numresp(1)
                axes(handles.axes1);
                xlim(numresp)
                
                handles.ax_x=numresp;
                set(handles.restore_axlims,'Enable','on')
                guidata(hObject,handles)
            end
        end
    end
end

% --------------------------------------------------------------------
function set_ylim_Callback(hObject, eventdata, handles)
% hObject    handle to set_ylim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resp=inputdlg(['Set Y Axis [low high]:  '],'Y Axis Label');
if ~isempty(resp)
    numresp=str2num(resp{1});
    if ~isempty(numresp)
        if length(numresp)==2
            if numresp(2)>numresp(1)
                axes(handles.axes1);
                ylim(numresp)
                
                handles.ax_y=numresp;
                set(handles.restore_axlims,'Enable','on')
                guidata(hObject,handles)
            end
        end
    end
end

% --------------------------------------------------------------------
function open_raw_Callback(hObject, eventdata, handles)
% hObject    handle to open_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [dump1,dump2,dump3,file,temppath]=read_NIS_objdata;
    handles.curdir=temppath;
    guidata(hObject,handles);
    cd(handles.curdir)
    
    curdata=open([file,'.mat']);
    if ~isequal(file, 0)
        newgrps=curdata.grps; %cell row 2 = selconds_b indices 
        for k=1:length(curdata.grps) %cell row 3 = names
            workinggroup{3,k}=num2str(k);
        end      
        for m=1:length(newgrps)
            cur_sel_conds = newgrps{m};
            grps=curdata.grps;
            selconds_a={};selconds_b={};
            for n=1:length(cur_sel_conds)
                for a=1:length(grps)
                    b=find(grps{a}==cur_sel_conds(n));
                    if ~isempty(b)
                        workinggroup{1,m}(n)=a;
                        workinggroup{2,m}(n)=b;
                        break
                    end
                end
            end
        end
        curdata.workinggroup=workinggroup;
        
        handles.curdata=curdata;
        handles.pxy=[0,0];
        handles.all_thresh_lists(1).thresh_list={};
        handles.thresh_lists_idx=1;
        
        app_chan_list={};
        for n=1:length(handles.curdata.proc_data)
            for m=1:length(handles.curdata.proc_data(n).data)
                app_chan_list=[app_chan_list,handles.curdata.proc_data(n).data(m).channel_list];
            end
        end
        objlist=unique(app_chan_list);
        set(handles.popupmenu1,'String',objlist)
        handles.obj_list=objlist;
        
        guidata(hObject,handles);
        
        set(handles.listbox1,'String',handles.curdata.samp_list)
        
        chanlist=fields(handles.curdata.proc_data(1).data(1).chan_dat(1));
        set(handles.popupmenu4,'String',chanlist)
        set(handles.popupmenu3,'String',chanlist)
        
        
        set(gcf,'Name',['hist2d_gui  ---  Unsaved Session  ---  (',handles.filename,')'])
    end
catch
end


% --------------------------------------------------------------------
function set_font_size_Callback(hObject, eventdata, handles)
% hObject    handle to set_font_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    oldtemp=num2str(handles.axfntsz);
    tempcell=inputdlg('New Font Size:','Font Size',1,{oldtemp});
    temp=str2num(tempcell{1});
    if ~isempty(temp)
        handles.axfntsz=temp;
        guidata(hObject,handles);
        %axes(handles.axes1)
        set(handles.axes1,'Fontsize',handles.axfntsz)
    end
catch
end


% --------------------------------------------------------------------
function save_gating_Callback(hObject, eventdata, handles)
% hObject    handle to save_gating (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,path]=uiputfile('*.txtg', 'Save Gating Scheme');
if ~isequal(filename,0)
    fid=fopen([path,filename],'w');
    try
        curthreshlist=handles.all_thresh_lists(handles.thresh_lists_idx).thresh_list;
        
        for n=1:size(curthreshlist,1)
            if n==size(curthreshlist,1)
                c=fprintf(fid,[curthreshlist{n,1},'\t',num2str(curthreshlist{n,2}(1)),'\t',num2str(curthreshlist{n,2}(2))]);
            else
                c=fprintf(fid,[curthreshlist{n,1},'\t',num2str(curthreshlist{n,2}(1)),'\t',num2str(curthreshlist{n,2}(2)),'\n']);
            end
        end
    catch
    end
    fclose(fid)
end


% --------------------------------------------------------------------
function load_gating_Callback(hObject, eventdata, handles)
% hObject    handle to load_gating (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,path]=uigetfile('*.txtg', 'Save Gating Scheme');
if filename~=0
    fid=fopen([path,filename],'r');
    try
        curthreshlist=handles.all_thresh_lists(handles.thresh_lists_idx).thresh_list;
        ct=1;
        while true
            tline=fgetl(fid);
            if ~ischar(tline)
                break
            end
            templist=string_parser(tline,sprintf('\t'));
            curthreshlist{ct,1}=templist{1};
            curthreshlist{ct,2}(1)=str2num(templist{2});
            curthreshlist{ct,2}(2)=str2num(templist{3});
            ct=ct+1;
        end
        ln_list=length(handles.all_thresh_lists);
        if ln_list>handles.thresh_lists_idx
            ln_list=handles.thresh_lists_idx;
            handles.all_thresh_lists=handles.all_thresh_lists(1:ln_list);
        end
        handles.thresh_lists_idx=ln_list+1;
        handles.all_thresh_lists(ln_list+1).thresh_list=curthreshlist;
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    catch
    end
    fclose(fid)
end

% --------------------------------------------------------------------
function restore_axlims_Callback(hObject, eventdata, handles)
% hObject    handle to restore_axlims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ax_x=[];
handles.ax_y=[];
set(handles.restore_axlims,'Enable','off')
guidata(hObject,handles)
refresh_graph(hObject,handles)


% --------------------------------------------------------------------
function more_menu_Callback(hObject, eventdata, handles)
% hObject    handle to more_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function gate_square_Callback(hObject, eventdata, handles)
% hObject    handle to gate_square (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'curdata')
    hold on
    axes(handles.axes1)
    curxlim=xlim;
    curylim=ylim;
    [x1,y1]=ginput(1);
    plot([x1 x1],curylim,'k')
    plot(curxlim,[y1 y1],'k')
    [x2,y2]=ginput(1);
    x=sort([x1,x2]);
    y=sort([y1,y2]);
    
    ln_list=length(handles.all_thresh_lists);
    if ln_list>handles.thresh_lists_idx
        ln_list=handles.thresh_lists_idx;
        handles.all_thresh_lists=handles.all_thresh_lists(1:ln_list);
    end
    handles.thresh_lists_idx=ln_list+1;
    
    cur_list=handles.all_thresh_lists(end).thresh_list;
    ln_list_ln=size(cur_list,1);
    chan_idx_x=get(handles.popupmenu3,'Value');
    chan_idx_y=get(handles.popupmenu4,'Value');
    chan_name_list=get(handles.popupmenu3,'String');
    
    added=false;
    minmax=[x(1),x(2)];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx_x},minmax},cur_list)
        cur_list{ln_list_ln+1,1}=chan_name_list{chan_idx_x};
        cur_list{ln_list_ln+1,2}=minmax;
        added=true;
    end
    minmax=[y(1),y(2)];
    if search_thresh_list_for_repeats({chan_name_list{chan_idx_y},minmax},cur_list) 
        cur_list{ln_list_ln+2,1}=chan_name_list{chan_idx_y};
        cur_list{ln_list_ln+2,2}=minmax;
        added=true;
    end
    if added
        ln_list=length(handles.all_thresh_lists);
        handles.all_thresh_lists(ln_list+1).thresh_list=cur_list;
        
        guidata(hObject,handles);
        refresh_graph(hObject,handles);
        
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);
        
        guidata(hObject,handles);
    end
end



% --------------------------------------------------------------------
function help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function about_menu_Callback(hObject, eventdata, handles)
% hObject    handle to about_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox(sprintf('hist2d_gui \nv2.0 (11/20/2015) \n\nUsed to plot histograms of NIS object data in excel files. \n\nMade by Stephen Trisno.\nNeed help? Contact me at trisno.stephen@yahoo.com.'),'About hist2d_gui','modal')



% --------------------------------------------------------------------
function menu_grp_set_Callback(hObject, eventdata, handles)
% hObject    handle to menu_grp_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'curdata')
newgrps={};
ct=1;
running=[];

sel_conds_names = get(handles.listbox1,'String');
while true
    out=select_ctrl_GUI(['Select group ' num2str(ct)],sel_conds_names,['Select group ' num2str(ct)]);
    if out(1)==-1
        if ct<2
            aborting=true;
        else
            aborting=false;
        end
        break
    else
        temp=inputdlg('Group Name:');
        if isempty(temp)
            newgrpsname{ct}=num2str(ct);
        else
            newgrpsname{ct}=temp{1};
        end
        newgrps{ct}=out;
        ct=ct+1;
        running=[running,out];
    end
end

if ~aborting
    for m=1:length(newgrps)
        cur_sel_conds = newgrps{m};
        grps=handles.curdata.grps;
        selconds_a={};selconds_b={};
        for n=1:length(cur_sel_conds)
            for a=1:length(grps)
                b=find(grps{a}==cur_sel_conds(n));
                if ~isempty(b)
                    workinggroup{1,m}(n)=a;
                    workinggroup{2,m}(n)=b;
                    break
                end
            end
        end
    end
    handles.curdata.workinggroup=workinggroup;
    handles.curdata.workinggroup(3,:)=newgrpsname;
    
    [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
    update_bargtable(hObject,handles);

    guidata(hObject,handles);
end
end

% --------------------------------------------------------------------
function menu_grp_reset_Callback(hObject, eventdata, handles)
% hObject    handle to menu_grp_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

qans=questdlg('Are you sure?','Careful...','Yes','No','Yes');
switch qans
    case 'Yes'
        curdata=handles.curdata;
        newgrps=curdata.grps;
        for k=1:length(curdata.grps) %cell row 3 = names
            workinggroup{3,k}=num2str(k);
        end
        
        for m=1:length(newgrps)
            cur_sel_conds = newgrps{m};
            grps=handles.curdata.grps;
            selconds_a={};selconds_b={};
            for n=1:length(cur_sel_conds)
                for a=1:length(grps)
                    b=find(grps{a}==cur_sel_conds(n));
                    if ~isempty(b)
                        workinggroup{1,m}(n)=a;
                        workinggroup{2,m}(n)=b;
                        break
                    end
                end
            end
        end
        handles.curdata.workinggroup=workinggroup;
        [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
        update_bargtable(hObject,handles);

        guidata(hObject,handles);
    case 'No'
end

% --------------------------------------------------------------------
function menu_bargraph_Callback(hObject, eventdata, handles)
% hObject    handle to menu_bargraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'curdata')
listquad={'Left','Right'};
if get(handles.radiobutton_1d,'Value')==0 %(that means 2d scatter chosen)
    listquad{3}='Top';
    listquad{4}='Bottom';
    listquad{5}='Top Left';
    listquad{6}='Top Right';
    listquad{7}='Bottom Left';
    listquad{8}='Bottom Right';
    qphrase='Quadrant';
else
    qphrase='Side';
end
selquad=listdlg('PromptString',['Select ',qphrase,' to Count'],'ListString',listquad);
if ~isempty(selquad)
%collect data
curgrps=handles.curdata.workinggroup;
[coldata_y,coldata_err]=get_all_bardata(hObject,handles);

bardata_y=coldata_y(selquad,:);
bardata_err=coldata_err(selquad,:);

update_bargtable(hObject,handles);
guidata(hObject,handles);

%plot data
f=figure;
[hBar,hErr]=barwitherr(bardata_err,bardata_y);colormap('gray')

oldylim=ylim;
ylim([0 oldylim(2)])
set(hBar,'BarWidth',0.7)
lnwdth=2;
set(f,'color',[1,1,1])
ln_sq=length(selquad);
set(f,'Position',[300 300 400+(ln_sq*(20*size(curgrps,2))) 600])
set(hBar,'LineWidth',lnwdth)
set(hErr,'LineWidth',lnwdth)
figure(f)
set(gca,'LineWidth',lnwdth,'FontName','Arial','Fontsize',handles.axfntsz)
set(gca,'box','off')
if length(selquad)<2
    set(gca,'XTickLabel',curgrps(3,:))
else
    legend(curgrps(3,:));legend boxoff
    for k=1:length(selquad)
        temp=inputdlg(['Set Xlabel for ',listquad{selquad(k)},':']);
        if isempty(temp)
            xlabnames{k}=listquad{selquad(k)};
        else
            xlabnames{k}=temp{1};
        end
    end
    set(gca,'XTickLabel',xlabnames)
end
end
end

% --------------------------------------------------------------------
function out_quad_info_Callback(hObject, eventdata, handles)
% hObject    handle to out_quad_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.scat2d_quadtxt_on_out
    handles.scat2d_quadtxt_on_out=false;
    set(handles.out_quad_info,'Checked','off')
else
    handles.scat2d_quadtxt_on_out=true;
    set(handles.out_quad_info,'Checked','on')
end
guidata(hObject,handles)


% --------------------------------------------------------------------
function menu_sav_grp_Callback(hObject, eventdata, handles)
% hObject    handle to menu_ld_grp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,temppath] = uiputfile('*.mat','Save User-Defined Groups');
if ~isequal(file,0)
    if ~isempty(handles.curdata.workinggroup)
        bargroupinfo.filename=handles.filename;
        bargroupinfo.groups=handles.curdata.workinggroup;
        save([temppath,file],'bargroupinfo')
    else
        errordlg('Save unsuccessful.')
    end
end


% --------------------------------------------------------------------
function menu_ld_grp_Callback(hObject, eventdata, handles)
% hObject    handle to menu_sav_grp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,temppath] = uigetfile('*.mat','Load User-Defined Groups');

if ~isequal(file, 0)
    load([temppath,file])
    if exist('bargroupinfo','var')
        if strcmpi(bargroupinfo.filename,handles.filename)
            handles.curdata.workinggroup=bargroupinfo.groups;
            guidata(hObject,handles)
            
            [handles.bardata_y,handles.bardata_err]=get_all_bardata(hObject,handles);
            update_bargtable(hObject,handles);
            
            guidata(hObject,handles);
        else
            errordlg('Cannot load groups from different file')
        end
    else
        errordlg('File is not appropriate')
    end
end





% --- Executes when entered data in editable cell(s) in bargtable.
function bargtable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to bargtable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
sz=size(handles.curdata.workinggroup,2);
temptabledata=get(handles.bargtable,'Data');
newgrpsname=temptabledata(1:sz,1);
handles.curdata.workinggroup(3,:)=newgrpsname';

guidata(hObject,handles)
update_bargtable(hObject,handles);



% --------------------------------------------------------------------
function menu_load_ses_Callback(hObject, eventdata, handles)
% hObject    handle to menu_load_ses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,temppath] = uigetfile('*.mat','Load Previously Saved Session');
if ~isequal(file,0)
    cd(temppath)
    load(file)
    if exist('oldhandles','var')
        handles.filename=oldhandles.filename;
        handles.axfntsz=oldhandles.axfntsz;
        handles.prev_bin=oldhandles.prev_bin;
        handles.pxy=oldhandles.pxy;
        handles.ax_x=oldhandles.ax_x;
        handles.ax_y=oldhandles.ax_y;
        handles.all_thresh_lists=oldhandles.all_thresh_lists;
        handles.thresh_lists_idx=oldhandles.thresh_lists_idx;
        handles.genfig_hist_hands=oldhandles.genfig_hist_hands;
        handles.genfig_scat_hands=oldhandles.genfig_scat_hands;
        handles.genfig_hist_names=oldhandles.genfig_hist_names;
        handles.scat2d_quadtxt_on_out=oldhandles.scat2d_quadtxt_on_out;
        handles.bardata_y=oldhandles.bardata_y;
        handles.bardata_err=oldhandles.bardata_err;
        handles.curdata=oldhandles.curdata;
        handles.obj_list=oldhandles.obj_list;

        guidata(hObject,handles)
        
        refresh_all_input_objects(hObject,handles,others);
        
        refresh_graph(hObject,handles)
        update_bargtable(hObject,handles)
        
        set(gcf,'Name',['hist2d_gui  ---  ',file,'  ---  (',handles.filename,')'])
    else
        errordlg('Loading failed')
    end
end

% --------------------------------------------------------------------
function menu_sav_ses_Callback(hObject, eventdata, handles)
% hObject    handle to menu_sav_ses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,temppath] = uiputfile('*.mat','Save Current Session');

if ~isequal(file,0)
    
    oldhandles=handles;
    others.list1=get(handles.listbox1,'Value');
    others.popup1=get(handles.popupmenu1,'Value');
    others.popup4=get(handles.popupmenu4,'Value');
    others.popup3=get(handles.popupmenu3,'Value');
    
    save(file,'oldhandles','others')
    set(gcf,'Name',['hist2d_gui  ---  ',file,'  ---  (',handles.filename,')'])
end




% --- Executes on selection change in list_selgrps.
function list_selgrps_Callback(hObject, eventdata, handles)
% hObject    handle to list_selgrps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns list_selgrps contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_selgrps


% --- Executes during object creation, after setting all properties.
function list_selgrps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_selgrps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_genbar.
function push_genbar_Callback(hObject, eventdata, handles)
% hObject    handle to push_genbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'curdata')
listquad={'Left','Right'};
if get(handles.radiobutton_1d,'Value')==0 %(that means 2d scatter chosen)
    listquad{3}='Top';
    listquad{4}='Bottom';
    listquad{5}='Top Left';
    listquad{6}='Top Right';
    listquad{7}='Bottom Left';
    listquad{8}='Bottom Right';
    qphrase='Quadrant';
else
    qphrase='Side';
end
selquad=listdlg('PromptString',['Select ',qphrase,' to Count'],'ListString',listquad);
if ~isempty(selquad)
%collect data
curgrps=handles.curdata.workinggroup;
[coldata_y,coldata_err]=get_all_bardata(hObject,handles);


idx2plot=get(handles.list_selgrps,'Value');
bardata_y=coldata_y(selquad,idx2plot);
bardata_err=coldata_err(selquad,idx2plot);

update_bargtable(hObject,handles);
guidata(hObject,handles);

%plot data
f=figure;
[hBar,hErr]=barwitherr(bardata_err,bardata_y);colormap('gray')

oldylim=ylim;
ylim([0 oldylim(2)])
set(hBar,'BarWidth',0.7)
lnwdth=2;
set(f,'color',[1,1,1])
ln_sq=length(selquad);
set(f,'Position',[300 300 400+(ln_sq*(20*size(curgrps,2))) 600])
set(hBar,'LineWidth',lnwdth)
set(hErr,'LineWidth',lnwdth)
figure(f)
set(gca,'LineWidth',lnwdth,'FontName','Arial','Fontsize',handles.axfntsz)
set(gca,'box','off')
if length(selquad)<2
    set(gca,'XTickLabel',curgrps(3,idx2plot))
else
    legend(curgrps(3,idx2plot));legend boxoff
    for k=1:length(selquad)
        temp=inputdlg(['Set Xlabel for ',listquad{selquad(k)},':']);
        if isempty(temp)
            xlabnames{k}=listquad{selquad(k)};
        else
            xlabnames{k}=temp{1};
        end
    end
    set(gca,'XTickLabel',xlabnames)
end
end
end



% --- Executes on button press in push_copyx.
function push_copyx_Callback(hObject, eventdata, handles)
% hObject    handle to push_copyx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sel_chanX = get(handles.popupmenu3,'Value');
wh=waitbar(0,'Please do not touch primary GUI while copying data...');
data=get_col_dat(hObject,handles,sel_chanX,wh);
waitbar(0.9,wh);
cptxt=dat1D_to_str(data);
waitbar(0.95,wh);
clipboard('copy',cptxt)
waitbar(0.999,wh);
close(wh)

% --- Executes on button press in push_copyy.
function push_copyy_Callback(hObject, eventdata, handles)
% hObject    handle to push_copyy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sel_chanY = get(handles.popupmenu4,'Value');
wh=waitbar(0,'Please do not touch primary GUI while copying data...');
data=get_col_dat(hObject,handles,sel_chanY,wh);
waitbar(0.9,wh);
cptxt=dat1D_to_str(data);
waitbar(0.95,wh);
clipboard('copy',cptxt)
waitbar(0.999,wh);
close(wh)

%%
% Other Code not directly linked to a button/callback
function data=get_col_dat(hObject,handles,datapt,wh)
if isfield(handles,'curdata')
    waitbar(0.1,wh);
        
    popup_sel_index = get(handles.popupmenu1, 'Value'); %to keep running until switch over
    sel_conds = get(handles.listbox1,'Value');
    %mapping
    grps=handles.curdata.grps;
    selconds_a=[];
    for z=1:length(sel_conds)
        for n=1:length(grps)
            m=find(grps{n}==sel_conds(z));
            if ~isempty(m)
                selconds_a(z)=n;
                selconds_b(z)=m;
                break
            end
        end
    end
    sel_obj = get(handles.popupmenu1, 'Value');
   
    sel_cond_outer=selconds_a;
    sel_cond_inner=selconds_b;
    obj_names=get(handles.popupmenu1,'String');
    channel_name=obj_names{sel_obj};
    alldata=handles.curdata.proc_data;
    head=handles.curdata.datapts;
    data=[];
    thresh_list=handles.all_thresh_lists(handles.thresh_lists_idx).thresh_list;
    num_thresh=0;
    multi_thresh=size(thresh_list,1);
    
    wh_div=(0.9-0.2)/length(sel_cond_outer);
    waitbar(0.2,wh);
    for m=1:length(sel_cond_outer)
        temp_chan_idx=find(strcmp(alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).channel_list,channel_name));
        if ~isempty(temp_chan_idx)
            temp_chan_idx=temp_chan_idx(1);
            if temp_chan_idx<=length(alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat)
                if multi_thresh<1
                    eval(['data=[data;alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt},'];'])
                else
                    num_threshing=0;
                    while num_threshing<multi_thresh
                        num_threshing=num_threshing+1;
                        tempidx_thresh={};
                        temp_fields=fields(alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx));
                        temp_field_idx=find(strcmp(thresh_list{num_threshing,1},temp_fields));
                        temp_thresh_val=thresh_list{num_threshing,2};%thresh_val{num_threshing};
                        eval(['tempidx_thresh{1}=find(alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',temp_fields{temp_field_idx},'>=temp_thresh_val(1));'])
                        eval(['tempidx_thresh{2}=find(alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',temp_fields{temp_field_idx},'<=temp_thresh_val(2));'])
                        temp_curridx_thresh=intersect(tempidx_thresh{1},tempidx_thresh{2});
                        if num_threshing==1
                            curridx_thresh=temp_curridx_thresh;
                        else
                            curridx_thresh=intersect(curridx_thresh,temp_curridx_thresh);
                        end
                    end
                    eval(['data=[data;alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt},'(curridx_thresh)];'])
                end
            end
        end
        waitbar(0.2+((wh_div)*(m-1)),wh);
    end               
end


function refresh_graph(hObject,handles)
if ~isempty(handles.axes1)
    axes(handles.axes1);
    cla;
end
if isfield(handles,'curdata')
    popup_sel_index = get(handles.popupmenu1, 'Value'); %to keep running until switch over
    sel_conds = get(handles.listbox1,'Value');
    %mapping
    grps=handles.curdata.grps;
    selconds_a=[];
    for z=1:length(sel_conds)
        for n=1:length(grps)
            m=find(grps{n}==sel_conds(z));
            if ~isempty(m)
                selconds_a(z)=n;
                selconds_b(z)=m;
                break
            end
        end
    end
    sel_obj = get(handles.popupmenu1, 'Value');
    sel_chanX = get(handles.popupmenu3,'Value');
    sel_chanY = get(handles.popupmenu4,'Value');
    
    px = str2double(get(handles.edit5, 'String'));
    if isnan(px)
        px=0;
        set(handles.edit5, 'String', px);
    end
    py = str2double(get(handles.edit6, 'String'));
    if isnan(py)
        py=0;
        set(handles.edit6, 'String', py);
    end
    handles.pxy=[px,py];
    guidata(hObject,handles)
    
    if ~isempty(selconds_a)
        bin=str2double(get(handles.edit_bins_1d,'String'));
        if get(handles.radiobutton_1d,'Value')>0
            fig_prop.fontsize=handles.axfntsz;
            fig_prop.isnew=false;
            fig_prop.plot_num=1;
            [stats]=hist1d_4gui_NIS_objdata(handles.figure1,handles.pxy,bin,handles.curdata,handles.obj_list{sel_obj},[sel_chanX],selconds_a,selconds_b,handles.all_thresh_lists(handles.thresh_lists_idx).thresh_list,fig_prop);
            handles.axes1=gca;
            set(gca,'FontName','Arial','Fontsize',handles.axfntsz)
            ylabel('Number of Cells')
            set(handles.text10,'String','')
            set(handles.text11,'String','')
            set(handles.text12,'String','')
            set(handles.text13,'String','')
            
            txt_xstats=sprintf('%.0f cells; mean=%.1f, sd=%.1f',stats.counts(1),stats.mean(1),stats.std(1));
            set(handles.text17,'String',txt_xstats)
            set(handles.text18,'String','')
        else
            fig_prop.fontsize=handles.axfntsz;
            fig_prop.isnew=false;
            fig_prop.xylabel=[];
            fig_prop.addperc=handles.scat2d_quadtxt_on_out;
            [hax,pxy,stats]=hist2d_4gui_NIS_objdata(handles.figure1,handles.pxy,bin,handles.curdata,handles.obj_list{sel_obj},[sel_chanX,sel_chanY],selconds_a,selconds_b,handles.all_thresh_lists(handles.thresh_lists_idx).thresh_list,fig_prop);
            handles.axes1=hax;
            set(handles.axes1,'FontName','Arial','Fontsize',handles.axfntsz)
            ylabel('')
            txt_ll=sprintf('%.2f%s +/- %.2f%s',stats.perc_mean(2,1,1)*100,'%',stats.perc_std(2,1,1)*100,'%');
            txt_lr=sprintf('%.2f%s +/- %.2f%s',stats.perc_mean(2,2,1)*100,'%',stats.perc_std(2,2,1)*100,'%');%[num2str(stats.perc_mean{k}(2,2)*100,3) '% +/- ' num2str(stats.perc_sd{k}(2,2)*100,2) '%'];
            txt_ul=sprintf('%.2f%s +/- %.2f%s',stats.perc_mean(1,1,1)*100,'%',stats.perc_std(1,1,1)*100,'%');
            txt_ur=sprintf('%.2f%s +/- %.2f%s',stats.perc_mean(1,2,1)*100,'%',stats.perc_std(1,2,1)*100,'%');
            set(handles.text10,'String',txt_ul)
            set(handles.text11,'String',txt_ur)
            set(handles.text12,'String',txt_ll)
            set(handles.text13,'String',txt_lr)
            
            txt_xstats=sprintf('%.0f cells; mean=%.1f, sd=%.1f',stats.xy_counts(1),stats.xy_mean(1),stats.xy_std(1));
            txt_ystats=sprintf('%.0f cells; mean=%.1f, sd=%.1f',stats.xy_counts(2),stats.xy_mean(2),stats.xy_std(2));
            set(handles.text17,'String',txt_xstats)
            set(handles.text18,'String',txt_ystats)
        end
        
        if ~isempty(handles.ax_x)
            xlim(handles.ax_x)
        end
        if ~isempty(handles.ax_y)
            ylim(handles.ax_y)
        end
    end

    guidata(hObject,handles);
end

function [daty,daterr]=collect_data4bar(hObject,handles,curgrps,selquad)
if isfield(handles,'curdata')

    %mapping
    selconds_a=curgrps{1};
    selconds_b=curgrps{2};

    sel_obj = get(handles.popupmenu1, 'Value');
    sel_chanX = get(handles.popupmenu3,'Value');
    sel_chanY = get(handles.popupmenu4,'Value');
    
    px = str2double(get(handles.edit5, 'String'));
    if isnan(px)
        px=0;
        set(handles.edit5, 'String', px);
    end
    py = str2double(get(handles.edit6, 'String'));
    if isnan(py)
        py=0;
        set(handles.edit6, 'String', py);
    end
    handles.pxy=[px,py];
    guidata(hObject,handles)
    
    if ~isempty(selconds_a)
        bin=str2double(get(handles.edit_bins_1d,'String'));
        if get(handles.radiobutton_1d,'Value')>0
            fig_prop.fontsize=handles.axfntsz;
            fig_prop.isnew=false;
            fig_prop.plot_num=1;
            fig_prop.noplot=true;
            [stats]=hist1d_4gui_NIS_objdata(handles.figure1,handles.pxy,bin,handles.curdata,handles.obj_list{sel_obj},[sel_chanX],selconds_a,selconds_b,handles.all_thresh_lists(handles.thresh_lists_idx).thresh_list,fig_prop);

            switch selquad
                case 'Left'
                    daty=nanmean(stats.counts_L./stats.counts_total)*100;
                    daterr=nanstd(stats.counts_L./stats.counts_total)*100;
                case 'Right'
                    daty=nanmean(stats.counts_R./stats.counts_total)*100;
                    daterr=nanstd(stats.counts_R./stats.counts_total)*100;
            end

        else
            fig_prop.fontsize=handles.axfntsz;
            fig_prop.isnew=false;
            fig_prop.xylabel=[];
            fig_prop.addperc=handles.scat2d_quadtxt_on_out;
            fig_prop.noplot=true;
            [hax,pxy,stats]=hist2d_4gui_NIS_objdata(handles.figure1,handles.pxy,bin,handles.curdata,handles.obj_list{sel_obj},[sel_chanX,sel_chanY],selconds_a,selconds_b,handles.all_thresh_lists(handles.thresh_lists_idx).thresh_list,fig_prop);
            
            switch selquad
                case 'Left'
                    daty=nanmean(stats.counts_L./stats.counts_total)*100;
                    daterr=nanstd(stats.counts_L./stats.counts_total)*100;
                case 'Right'
                    daty=nanmean(stats.counts_R./stats.counts_total)*100;
                    daterr=nanstd(stats.counts_R./stats.counts_total)*100;
                case 'Top'
                    daty=nanmean(stats.counts_T./stats.counts_total)*100;
                    daterr=nanstd(stats.counts_T./stats.counts_total)*100;
                case 'Bottom'
                    daty=nanmean(stats.counts_B./stats.counts_total)*100;
                    daterr=nanstd(stats.counts_B./stats.counts_total)*100;
                case 'Top Left'
                    daty=nanmean(stats.counts_UL./stats.counts_total)*100;
                    daterr=nanstd(stats.counts_UL./stats.counts_total)*100;
                case 'Top Right'
                    daty=nanmean(stats.counts_UR./stats.counts_total)*100;
                    daterr=nanstd(stats.counts_UR./stats.counts_total)*100;
                case 'Bottom Left'
                    daty=nanmean(stats.counts_LL./stats.counts_total)*100;
                    daterr=nanstd(stats.counts_LL./stats.counts_total)*100;
                case 'Bottom Right'
                    daty=nanmean(stats.counts_LR./stats.counts_total)*100;
                    daterr=nanstd(stats.counts_LR./stats.counts_total)*100;
            end

        end

    end

    guidata(hObject,handles);
end


function [data_y,data_err]=get_all_bardata(hObject,handles)
if isfield(handles,'curdata')
listquad={'Left','Right'};
if get(handles.radiobutton_1d,'Value')==0 %(that means 2d scatter chosen)
    listquad{3}='Top';
    listquad{4}='Bottom';
    listquad{5}='Top Left';
    listquad{6}='Top Right';
    listquad{7}='Bottom Left';
    listquad{8}='Bottom Right';
end
%collect data
curgrps=handles.curdata.workinggroup;
for n=1:length(listquad)
    for m=1:size(curgrps,2)
        [data_y(n,m),data_err(n,m)]=collect_data4bar(hObject,handles,curgrps(1:2,m),listquad{n});
    end
end
else
    data_y=[];
    data_err=[];
end

function update_bargtable(hObject,handles)
if isfield(handles,'curdata')
allbardata_y=handles.bardata_y;
allbardata_err=handles.bardata_err;

cellbardata_y=num2cell(handles.bardata_y');
cellbardata_err=num2cell(handles.bardata_err');

cellbarnames=handles.curdata.workinggroup(3,:)';

firstpiece=[cellbarnames,cellbardata_y];
secondpiece=[cellbarnames,cellbardata_err];

formatted_data=[firstpiece;...
    [{'std-dev:'},cell(1,size(cellbardata_y,2))];...
    secondpiece];

set(handles.bargtable,'Data',formatted_data)

set(handles.list_selgrps,'String',cellbarnames')
end



function refresh_all_input_objects(hObject,handles,others)

app_chan_list={};
for n=1:length(handles.curdata.proc_data)
    for m=1:length(handles.curdata.proc_data(n).data)
        app_chan_list=[app_chan_list,handles.curdata.proc_data(n).data(m).channel_list];
    end
end
objlist=unique(app_chan_list);
set(handles.popupmenu1,'String',objlist)
set(handles.popupmenu1,'Value',others.popup1)
handles.obj_list=objlist;

guidata(hObject,handles);

set(handles.listbox1,'String',handles.curdata.samp_list)
set(handles.listbox1,'Value',others.list1)

chanlist=fields(handles.curdata.proc_data(1).data(1).chan_dat(1));
set(handles.popupmenu4,'String',chanlist)
set(handles.popupmenu4,'Value',others.popup4)
set(handles.popupmenu3,'String',chanlist)
set(handles.popupmenu3,'Value',others.popup3)

set(handles.edit5, 'String', handles.pxy(1));
set(handles.edit6, 'String', handles.pxy(2));



function [list] = string_parser(in,parse_by)
lenstr=length(in);
n=1;
list={};listct=1;
start=1;finish=1;
while n<lenstr
    if strcmp(in(n),parse_by)
        if start~=finish
            list{listct}=in(start:(finish-1));
            listct=listct+1;
        end
        start=n+1;
    end
    n=n+1;
    finish=n;
end
if start~=finish
    list{listct}=in(start:finish);
end


function isuniq = search_thresh_list_for_repeats(toBadd,curlist)
if isempty(curlist)
    section123=[];
else
    stridx=find(strcmp(curlist(:,1),toBadd{1,1}));
    minmaxlist=cell2mat(curlist(:,2));
    minidx=find(minmaxlist(:,1)==toBadd{1,2}(1));
    maxidx=find(minmaxlist(:,2)==toBadd{1,2}(2));
    section12=intersect(stridx,minidx);
    section123=intersect(section12,maxidx);
end
if isempty(section123)
    isuniq=true;
else
    isuniq=false;
end

function whichone = select_ctrl_GUI(gui_title,list,questionprompt)
if nargin<1 || isempty(gui_title)
    gui_title = '';
end
if nargin<2 || isempty(questionprompt)
    questionprompt = 'What Color Would You Like To Use?';
end

[whichone,ok]=listdlg('ListString',list,'PromptString',questionprompt,'Name',gui_title,'SelectionMode','multiple');

if ~ok
    whichone=-1;
end

function outtext=dat1D_to_str(indat)%,col)
outtext='';
sz=length(indat);
%if nargin==1
for n=1:sz
    outtext=[outtext,sprintf([num2str(indat(n)),'\r'])];
end

%{
else
    for m=1:sz(1)
        outtext=[outtext,sprintf([col{m},'\t'])];
        for n=1:sz(2)
            if n<sz(2)
                outtext=[outtext,sprintf([num2str(indat(m,n)),'\t'])];
            else
                outtext=[outtext,num2str(indat(m,n))];
            end
        end
        if m<sz(1)
            outtext=[outtext,sprintf('\r')];
        end
    end
end
%}