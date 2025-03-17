function [stats,x,y,alldata] = hist1d_4gui_NIS_objdata(fnew,pxy,bin,curdata,sel_obj,datapt,sel_cond_outer,sel_cond_inner,thresh_list,fig_prop)%analysis_type,sel_cond,multi_thresh,datapts,xlsfile,grps)
%function [stats,x,y,alldata] = hist_NIS_objdata(bin,analysis_type,multi_thresh,datapts,xlsfile,grps)
%    analysis_type = 1 (combine replicates and do stats off of total histogram) (DEFAULT)
%    analysis_type = 2 (compute mean of each replicate and do stats off of those means)
%must pass in datapts as names of fields - exact name!!

fntsz=fig_prop.fontsize;
new=fig_prop.isnew;
num_added_plots=fig_prop.plot_num;

default_colors={[1 0 0],[0 1 0],[0 0 1],[1 1 0],[0 1 1],[1 0 1],[1 0.7 0.3],[0.7 1 0.3],[0.7 0.3 1],[1 0.3 0.7],[0.3 1 0.7],[0.3 0.7 1]};
select_stats_threshold=false;%true; %new feature
%select_conditions=false;%true; %newer feature
plot_means=false;
plot_sds=false;
analysis_type=1;
if isfield(fig_prop,'noplot')
    analysis_type=2;
end


alldata=curdata.proc_data;
head=curdata.datapts;
grps=curdata.grps;
%{
if nargin<1
    samp_bin_ratio=15;
    set_min_bin=20;
elseif isempty(bin)
    samp_bin_ratio=15;
    set_min_bin=20;
end
if nargin<2
    analysis_type=1;
elseif isempty(analysis_type)
    analysis_type=1;
end
if nargin<4
    multi_thresh=0;
elseif isempty(multi_thresh)
    multi_thresh=0;
end

%get data
if nargin<5
    [alldata,head,grps]=read_NIS_objdata();
    datapts=head;
elseif nargin<6
    [alldata,head,grps]=read_NIS_objdata(datapts);
elseif nargin<7
    [alldata,head,grps]=read_NIS_objdata(datapts,xlsfile);
else
    [alldata,head,grps]=read_NIS_objdata(datapts,xlsfile,grps);
end

if nargin<3
    sel_cond=1:length(alldata);
elseif isempty(sel_cond)
    sel_cond=1:length(alldata);
end
%}
%{
    if select_conditions
        ttt=[1:length(alldata)];
        for h=1:length(ttt)
            tttt{h}=num2str(ttt(h));
        end
        sel_cond=select_from_list_GUI('Object Selection',tttt,'Please select objects to display (or type "all")');
    else
        sel_cond=1:length(alldata);
    end
%}

%{
app_chan_list={};
for n=1:length(alldata)
    for m=1:length(alldata(n).data)
        app_chan_list=[app_chan_list,alldata(n).data(m).channel_list];
    end
end
all_channel_names=unique(app_chan_list);
channel_idx=select_ctrl_GUI('Select plot',all_channel_names,'Select cell-objects to plot:');
%}
channel_name=sel_obj;%all_channel_names{channel_idx};

num_thresh=0;
%{
while num_thresh<multi_thresh
    num_thresh=num_thresh+1;
    if num_thresh<2
        word_num_thresh='1st';
    elseif num_thresh<3
        word_num_thresh='2nd';
    elseif num_thresh<4
        word_num_thresh='3rd';
    else
        word_num_thresh=[num2str(num_thresh),'th'];
    end
    threshpt(num_thresh)=select_ctrl_GUI('Select plot',head,['Select ' word_num_thresh ' channel to threshold:']);
    try
        %temp=inputdlg([questionprompt,':  ',sprintf('\n'),running_list],gui_title);
        temp=inputdlg(['Thresholding ' channel_name ' with ' head{threshpt(num_thresh)} ': ',sprintf('\n'),'Please give lower bound OR both lower and upper bound'],'Intensity Threshold');
        tempstr=temp{1};
        temp_thresh_val=str2num(tempstr);
        if length(temp_thresh_val)==1
            thresh_val{num_thresh}=[temp_thresh_val,inf];
        elseif length(temp_thresh_val)~=2
            disp('Range not valid, using default [0,inf]')
            thresh_val{num_thresh}=[0,inf];
        else
            thresh_val{num_thresh}=temp_thresh_val;
        end
    catch
        thresh_val{num_thresh}=[0,inf];
    end
end
clear temp_thresh_val
if multi_thresh<1
   threshpt=length(head);
end
%}
multi_thresh=size(thresh_list,1);

%{
if (iscell(datapts) && length(datapts)<2) || (~iscell(datapts))
    if iscell(datapts)
        datapt=find(strcmp(head,datapts{1}));
    else
        datapt=find(strcmp(head,datapts));
    end
else
    datapt=select_ctrl_GUI('Select plot',head,'Select channel to plot:');
end
%}

data={};
data_grp_by_rep={};
for n=1
    data{n}=[];
    %tempg=grps{n};
    for m=1:length(sel_cond_outer)
        temp_chan_idx=find(strcmp(alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).channel_list,channel_name));
        if ~isempty(temp_chan_idx)
            temp_chan_idx=temp_chan_idx(1);
            if temp_chan_idx<=length(alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat)
                if multi_thresh<1
                    eval(['data{n}=[data{n};alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt},'];'])
                    eval(['data_grp_by_rep{n,m}=alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt},';'])
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
                    eval(['data{n}=[data{n};alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt},'(curridx_thresh)];'])
                    eval(['data_grp_by_rep{n,m}=alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt},'(curridx_thresh);'])
                end
            end
        end
    end
end


%%%%%%% Plotting 

%{
if nargin<1
    minbin=inf;
    for n=1:length(data)
        if minbin>length(data{n})
            minbin=round(length(data{n})/samp_bin_ratio);
        end
    end
    if minbin<set_min_bin
        bin=set_min_bin;
    else
        bin=minbin;
    end
end
%}
x={};y={};
for n=1:length(data)
    [yori{n},x{n}]=hist(data{n},bin);
    y{n}=yori{n}/(x{n}(2)-x{n}(1)); %normalizes
end
%{
h = findobj(gca,'Type','patch');
for n=1:length(data)
    set(h(n),'Facecolor',default_colors(n),'EdgeColor','k');
end
hold off
%}
if ~isfield(fig_prop,'noplot')
figure(fnew);hold on

for k=1%:length(sel_cond)
    n=1;%sel_cond(k);
    px=pxy(1);
    if ~new
        hold off
        plot(x{n},y{n},'Color',default_colors{n}*0.9,'LineWidth',1.5)
        oldylim=ylim;
        hold on
        plot([px,px],[-10^10 10^10],'k','LineWidth',1)
    else
        hold on
        if num_added_plots<2
            oldylim=[0 ceil(max(y{n})/(10^(floor(log10(max(y{n}))))))*10^2];
            plot([px,px],[-10^10 10^10],'k','LineWidth',1)
        end
        if num_added_plots<=length(default_colors)
            plot(x{n},y{n},'Color',default_colors{num_added_plots}*0.9,'LineWidth',1.5)
        else
            plot(x{n},y{n},'Color',rand(1,3)*0.9,'LineWidth',1.5)
        end
        if num_added_plots>=2
            curylim=ylim;
            oldylim=[min(0,curylim(1)),max(curylim(2),ceil(max(y{n})/(10^(floor(log10(max(y{n}))-1))))*10^(floor(log10(max(y{n})))-1))];
        end
    end
    hold on
end
else
    px=pxy(1);
    py=pxy(2);
end


%%%%% final analysis
%{
if select_stats_threshold
    [px,py]=ginput(1);
else
    px=0;
end
%}


for n=1:length(data)
    %tempidx=find(x{n}>=px);
    tempidx=1:length(x{n});
    ct(n)=sum(yori{n}(tempidx));

    wmn(n)=wmean(x{n}(tempidx),y{n}(tempidx));
    hold on
    if plot_means
        plot([wmn(n),wmn(n)],ylim,'Color',default_colors{n},'LineWidth',2)
    end
    wsd(n)=wstd(x{n}(tempidx),y{n}(tempidx));
    if plot_sds
        plot([wmn(n)-wsd(n),wmn(n)-wsd(n)],ylim,'--','Color',default_colors{n},'LineWidth',0.5)
        plot([wmn(n)+wsd(n),wmn(n)+wsd(n)],ylim,'--','Color',default_colors{n},'LineWidth',0.5)
    end
end
stats.counts=ct;
if analysis_type==1
    stats.mean=wmn;
    stats.std=wsd;
elseif analysis_type==2
    sz=size(data_grp_by_rep);
    for a=1:1%sz(1)
        for b=1:sz(2)
            [temp_yori,temp_x]=hist(data_grp_by_rep{a,b},bin);
            temp_y=temp_yori/(temp_x(2)-temp_x(1));
            tempidx=find(temp_x>=px);
            temp_wmn(a,b)=wmean(temp_x(tempidx),temp_y(tempidx));

            ct_total(b)=sum(temp_yori);
            tempidx_L=find(temp_x<px);
            ct_L(b)=sum(temp_yori(tempidx_L));
            tempidx_R=find(temp_x>=px);
            ct_R(b)=sum(temp_yori(tempidx_R));
            
        end
        new_wmn(a)=nanmean(temp_wmn(a,:));
        new_wsd(a)=nanstd(temp_wmn(a,:));
    end
    stats.mean=new_wmn;
    stats.std=new_wsd;
    stats.data_means=temp_wmn;
    stats.counts_total=ct_total;
    stats.counts_L=ct_L;
    stats.counts_R=ct_R;
end



%%%%%%%% make graph pretty
if ~isfield(fig_prop,'noplot')
set(gca,'box','on')
if new
    set(gca,'box','off')
    set(fnew,'color',[1,1,1])
    set(gca,'FontName','Arial','Fontsize',fntsz)
    set(gca,'FontWeight','bold')%'XTickLabel',package.TargetNames(sel_tar),'Fontsize',fontsize,
    set(gcf,'Position',[300+(k*25) 75+(k*25) 600 600])
    ylabel('Number of cells')
    xlabel(head{datapt})
end
xlim([0 4100]) %for 12-bit data
ylim(oldylim)

hold off
end
end


function whichone = select_ctrl_GUI(gui_title,list,questionprompt)
if nargin<1 || isempty(gui_title)
    gui_title = '';
end
if nargin<2 || isempty(questionprompt)
    questionprompt = 'What Color Would You Like To Use?';
end

[whichone,ok]=listdlg('ListString',list,'PromptString',questionprompt,'Name',gui_title);

if ~ok
    whichone=-1;
end

end

function whichones = type_in_GUI(gui_title,questionprompt)


temp=inputdlg([questionprompt,':  ',sprintf('\n'),running_list],gui_title);
tempstr=temp{1};
if strcmpi(tempstr,'all')
    whichones=[1:max(size(list))];
else
    whichones=str2num(tempstr);
end

end

function whichones = select_from_list_GUI(gui_title,list,questionprompt)

running_list=['1. ',list{1}];
for a=2:max(size(list))
    running_list=[running_list,sprintf('\n'),num2str(a),'. ',list{a}];
end
temp=inputdlg([questionprompt,':  ',sprintf('\n'),running_list],gui_title);
tempstr=temp{1};
if strcmpi(tempstr,'all')
    whichones=[1:max(size(list))];
else
    whichones=str2num(tempstr);
end

end

function out = wmean(inx,iny)
try
    out=sum(inx.*iny)/sum(iny);
catch
    out=sum(inx'.*iny)/sum(iny);
end
end

function out = wstd(inx,iny)
temp=0;
mn=wmean(inx,iny);
normy=iny/sum(iny);
for n=1:length(inx)
    temp=temp+(((inx(n)-mn)^2)*normy(n));
end
out=sqrt(temp);
end