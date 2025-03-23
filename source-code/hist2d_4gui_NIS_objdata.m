function [hax,pxy,stats] = hist2d_4gui_NIS_objdata(fnew,pxy,bin,curdata,sel_obj,datapt,sel_cond_outer,sel_cond_inner,thresh_list,fig_prop)%,fntsz,new,xylabel)

fntsz=fig_prop.fontsize;
new=fig_prop.isnew;
xylabel=fig_prop.xylabel;

select_stats_threshold=true; %new feature
fntsz=10;
markersize=1;
markershape='o';
databits=12;
maxlim=ceil((2^databits/100))*100;

alldata=curdata.proc_data;
head=curdata.datapts;
grps=curdata.grps;

add_perc2graph=fig_prop.addperc;
add_tot2graph=false;
buffer_dist=30;
%{
if nargin<2
    add_perc2graph=true;%this takes precidence over total counts (i.e. this must be false to allow total counts to have an opportunity to be displayed)
    add_tot2graph=true;
elseif isempty(addtext) || length(addtext)~=2
    add_perc2graph=true;%this takes precidence over total counts (i.e. this must be false to allow total counts to have an opportunity to be displayed)
    add_tot2graph=true;   
else
    add_perc2graph=boolean(addtext(1));
    add_tot2graph=boolean(addtext(2));
end
buffer_dist=30; %text buffer distance from lines (only useful if either add_perc2graph or add_tot2graph is true)

if nargin<1
    samp_bin_ratio=15;
    set_min_bin=20;
elseif isempty(bin)
    samp_bin_ratio=15;
    set_min_bin=20;
end

if nargin<3
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

if nargin<4
    sel_cond=1:length(alldata);
elseif isempty(sel_cond)
    sel_cond=1:length(alldata);
end

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
channel_name=sel_obj;

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



data={};
data_grp_by_rep={};

data{1}=[];
data{2}=[];

for m=1:length(sel_cond_outer)
    temp_chan_idx=find(strcmp(alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).channel_list,channel_name));
    if ~isempty(temp_chan_idx)
        temp_chan_idx=temp_chan_idx(1);
        if temp_chan_idx<=length(alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat)
            if multi_thresh<1
                eval(['data{1,1}=[data{1,1};alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt(1)},'];'])
                eval(['data{1,2}=[data{1,2};alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt(2)},'];'])
                eval(['data_grp_by_rep{1,m,1}=alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt(1)},';'])
                eval(['data_grp_by_rep{1,m,2}=alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt(2)},';'])
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
                eval(['data{1,1}=[data{1,1};alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt(1)},'(curridx_thresh)];'])
                eval(['data{1,2}=[data{1,2};alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt(2)},'(curridx_thresh)];'])
                eval(['data_grp_by_rep{1,m,1}=alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt(1)},'(curridx_thresh);'])
                eval(['data_grp_by_rep{1,m,2}=alldata(sel_cond_outer(m)).data(sel_cond_inner(m)).chan_dat(temp_chan_idx).',head{datapt(2)},'(curridx_thresh);'])
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
x={};y={};
for n=1:length(data)
    [yori{n},x{n}]=hist(data{n},bin);
    y{n}=yori{n}/(x{n}(2)-x{n}(1)); %normalizes
end

h = findobj(gca,'Type','patch');
for n=1:length(data)
    set(h(n),'Facecolor',default_colors(n),'EdgeColor','k');
end
hold off
%}
if ~isfield(fig_prop,'noplot')
for k=1
    figure(fnew);
    if new
        hold on
    else
        hold off
    end
    n=1;%sel_cond(k);
    if ~isempty(data{n,1})
        hax=dscatter_sltfix(data{n,1},data{n,2},'MSIZE',markersize,'MARKER',markershape);
    else
        hax=[];
    end
    hold on
    %plot(x{n},y{n},'Color',default_colors{n}*0.9,'LineWidth',1.5)
    xlim([0 maxlim])
    ylim([0 maxlim])
    
    %%%%% final analysis
    if nargin<1
        pxy=[];
    end
    if isempty(pxy) || length(pxy)~=2
        if k==length(sel_cond)
            if select_stats_threshold
                [px,py]=ginput(1);
            else
                px=0;
                py=0;
            end
        end
    else
        px=pxy(1);
        py=pxy(2);
    end
    pxy(1)=px;
    pxy(2)=py;
end
else
    hax=[];
    px=pxy(1);
    py=pxy(2);
end

for n=1:size(data,1)
    [LL,LR,UL,UR]=count4quadrants(data{n,1},data{n,2},px,py);
    totalcounts(:,:,n)=[UL,UR;LL,LR];
    perc(:,:,n)=totalcounts(:,:,n)/(sum(sum((totalcounts(:,:,n)))));
    %{
    tempidx=find(x{n}>=px);
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
    %}
end
stats.total_counts=totalcounts;
stats.perc=perc;
sz=size(data_grp_by_rep);
for a=1:sz(1) %=1
    for b=1:sz(2)
        [tc_ll(a,b),tc_lr(a,b),tc_ul(a,b),tc_ur(a,b)]=count4quadrants(data_grp_by_rep{a,b,1},data_grp_by_rep{a,b,2},px,py); %tc for total counts
        perc_ll(a,b)=tc_ll(a,b)/(tc_ll(a,b)+tc_lr(a,b)+tc_ul(a,b)+tc_ur(a,b));
        perc_lr(a,b)=tc_lr(a,b)/(tc_ll(a,b)+tc_lr(a,b)+tc_ul(a,b)+tc_ur(a,b));
        perc_ul(a,b)=tc_ul(a,b)/(tc_ll(a,b)+tc_lr(a,b)+tc_ul(a,b)+tc_ur(a,b));
        perc_ur(a,b)=tc_ur(a,b)/(tc_ll(a,b)+tc_lr(a,b)+tc_ul(a,b)+tc_ur(a,b));
        %{
        [temp_yori,temp_x]=hist(data_grp_by_rep{a,b},bin/sz(2));
        temp_y=temp_yori/(temp_x(2)-temp_x(1));
        tempidx=find(temp_x>=px);
        temp_wmn(a,b)=wmean(temp_x(tempidx),temp_y(tempidx));
        %}
    end
    new_tc_mn(:,:,a)=[nanmean(tc_ul(a,:)),nanmean(tc_ur(a,:));nanmean(tc_ll(a,:)),nanmean(tc_lr(a,:))];
    new_tc_sd(:,:,a)=[nanstd(tc_ul(a,:)),nanstd(tc_ur(a,:));nanstd(tc_ll(a,:)),nanstd(tc_lr(a,:))];
    new_perc_mn(:,:,a)=[nanmean(perc_ul(a,:)),nanmean(perc_ur(a,:));nanmean(perc_ll(a,:)),nanmean(perc_lr(a,:))];
    new_perc_sd(:,:,a)=[nanstd(perc_ul(a,:)),nanstd(perc_ur(a,:));nanstd(perc_ll(a,:)),nanstd(perc_lr(a,:))];
end
counts_by_rep{1,1}=tc_ul;
counts_by_rep{1,2}=tc_ur;
counts_by_rep{2,1}=tc_ll;
counts_by_rep{2,2}=tc_lr;
perc_by_rep{1,1}=perc_ul;
perc_by_rep{1,2}=perc_ur;
perc_by_rep{2,1}=perc_ll;
perc_by_rep{2,2}=perc_lr;

stats.limits_xy=[px,py];
stats.perc_mean=new_perc_mn;
stats.perc_std=new_perc_sd;
stats.tc_mean=new_tc_mn;
stats.tc_std=new_tc_sd;
stats.detailed_counts=counts_by_rep;
stats.detailed_perc=perc_by_rep;

for n=1:length(data)
    [yori{n},x{n}]=hist(data{n},bin);
    y{n}=yori{n}/(x{n}(2)-x{n}(1)); %normalizes
    %tempidx=find(x{n}>=px);
    tempidx=1:length(x{n});
    ct(n)=sum(yori{n}(tempidx));
    
    
    wmn(n)=wmean(x{n}(tempidx),y{n}(tempidx));
    wsd(n)=wstd(x{n}(tempidx),y{n}(tempidx));

end
stats.xy_counts=ct;
stats.xy_mean=wmn;
stats.xy_std=wsd;

if isfield(fig_prop,'noplot')
clear tempidx
sz=size(data_grp_by_rep);
for a=1:1%sz(1)
    for b=1:sz(2)
        for c=1:sz(3)
        [temp_yori{b,c},temp_x{b,c}]=hist(data_grp_by_rep{a,b,c},bin);
        temp_y{b,c}=temp_yori{b,c}/(temp_x{b,c}(2)-temp_x{b,c}(1));
        tempidx{b,c}=find(temp_x{b,c}>=px);
        temp_wmn(a,b,c)=wmean(temp_x{b,c}(tempidx{b,c}),temp_y{b,c}(tempidx{b,c}));

        end
    end
    new_wmn(a)=nanmean(temp_wmn(a,:));
    new_wsd(a)=nanstd(temp_wmn(a,:));
end

for b=1:sz(2)
    tempidx_L=find(temp_x{b,1}<=px);
    ct_L(b)=sum(temp_yori{b,1}(tempidx_L));
    tempidx_R=find(temp_x{b,1}>px);
    ct_R(b)=sum(temp_yori{b,1}(tempidx_R));
    tempidx_T=find(temp_x{b,2}>py);
    ct_T(b)=sum(temp_yori{b,2}(tempidx_T));
    tempidx_B=find(temp_x{b,2}<=py);
    ct_B(b)=sum(temp_yori{b,2}(tempidx_B));
    %{
    tempidx_UL=find(x{1}<=px & x{2}>py);
    ct_UL(b)=sum(temp_yori{1}(tempidx_UL));
    tempidx_UR=find(x{1}>px & x{2}>py);
    ct_UR(b)=sum(temp_yori{1}(tempidx_UR));
    tempidx_LL=find(x{1}<=px & x{2}<=py);
    ct_LL(b)=sum(temp_yori{1}(tempidx_LL));
    tempidx_LR=find(x{1}>px & x{2}<=py);
    ct_LR(b)=sum(temp_yori{1}(tempidx_LR));
    %}
end
stats.counts_L=ct_L;
stats.counts_R=ct_R;
stats.counts_T=ct_T;
stats.counts_B=ct_B;
stats.counts_UL=tc_ul;
stats.counts_UR=tc_ur;
stats.counts_LL=tc_ll;
stats.counts_LR=tc_lr;
stats.counts_total=tc_ul+tc_ur+tc_ll+tc_lr;
end

if ~isfield(fig_prop,'noplot')
%{
xtxt=inputdlg(['What would you like to label ',head{datapt(1)},':  '],'X Axis Label');
ytxt=inputdlg(['What would you like to label ',head{datapt(2)},':  '],'Y Axis Label');
%}
xtxt=[];ytxt=xtxt;
%%%%%%%% make graph pretty
for k=1%:length(sel_cond)
    %figure(f(k));
    if add_perc2graph && new
        txt_ll=sprintf('%.2f%s +/- %.2f%s',new_perc_mn(2,1,k)*100,'%',new_perc_sd(2,1,k)*100,'%');
        txt_lr=sprintf('%.2f%s +/- %.2f%s',new_perc_mn(2,2,k)*100,'%',new_perc_sd(2,2,k)*100,'%');%[num2str(new_perc_mn{k}(2,2)*100,3) '% +/- ' num2str(new_perc_sd{k}(2,2)*100,2) '%'];
        txt_ul=sprintf('%.2f%s +/- %.2f%s',new_perc_mn(1,1,k)*100,'%',new_perc_sd(1,1,k)*100,'%');
        txt_ur=sprintf('%.2f%s +/- %.2f%s',new_perc_mn(1,2,k)*100,'%',new_perc_sd(1,2,k)*100,'%');
    elseif add_tot2graph && new
        txt_ll=sprintf('%.2f%s +/- %.2f%s',new_tc_mn(2,1,k)*100,'%',new_tc_sd(2,1,k)*100,'%');%[num2str(new_tc_mn{k}(2,1),3) ' +/- ' num2str(new_tc_sd{k}(2,1),2)];
        txt_lr=sprintf('%.2f%s +/- %.2f%s',new_tc_mn(2,2,k)*100,'%',new_tc_sd(2,2,k)*100,'%');
        txt_ul=sprintf('%.2f%s +/- %.2f%s',new_tc_mn(1,1,k)*100,'%',new_tc_sd(1,1,k)*100,'%');
        txt_ur=sprintf('%.2f%s +/- %.2f%s',new_tc_mn(1,2,k)*100,'%',new_tc_sd(1,2,k)*100,'%');
    end
    if (add_perc2graph || add_tot2graph) && new
        hold on
        text(buffer_dist,py-buffer_dist,txt_ll,'HorizontalAlignment','left','VerticalAlignment','top','Fontsize',fntsz)
        text(maxlim-buffer_dist,py-buffer_dist,txt_lr,'HorizontalAlignment','right','VerticalAlignment','top','Fontsize',fntsz)
        text(buffer_dist,maxlim-buffer_dist,txt_ul,'HorizontalAlignment','left','VerticalAlignment','top','Fontsize',fntsz)
        text(maxlim-buffer_dist,maxlim-buffer_dist,txt_ur,'HorizontalAlignment','right','VerticalAlignment','top','Fontsize',fntsz)
        clear txt*
        hold off
    end

    hold on
    plot([px,px],[-10^10 10^10],'k','LineWidth',1)
    plot([-10^10 10^10],[py,py],'k','LineWidth',1)
    hold off
    
    set(gca,'box','on') %looks good for these plots
    if new
        set(fnew,'color',[1,1,1])
        set(gca,'FontName','Arial','Fontsize',round(fntsz*1.5))
        set(gca,'FontWeight','bold')%'XTickLabel',package.TargetNames(sel_tar),'Fontsize',fontsize,
        set(gcf,'Position',[300+(k*25) 75+(k*25) 600 600])
    end
    xlim([0 maxlim])
    ylim([0 maxlim])
    if ~isempty(xtxt)
        xlabel(xtxt)
    end
    if ~isempty(ytxt)
        ylabel(ytxt)
    end
    if ~isempty(xylabel)
        xlabel(xylabel{1})
        ylabel(xylabel{2})
    end
end
end
end


function [ll,lr,ul,ur] = count4quadrants(xdata,ydata,bound_x,bound_y)
%note that bottom and left are inclusive (<=) while top and right are exclusive(>)

%working on lower left quadrant (< both boundary x and y)
temp_xfind=find(xdata<=bound_x);
temp_yfind=find(ydata<=bound_y);
ll=length(intersect(temp_xfind,temp_yfind));
clear temp*

%working on lower right quadrant (>boundary x but <boundary y)
temp_xfind=find(xdata>bound_x);
temp_yfind=find(ydata<=bound_y);
lr=length(intersect(temp_xfind,temp_yfind));
clear temp*

%working on upper left quadrant (<boundary x but >boundary y)
temp_xfind=find(xdata<=bound_x);
temp_yfind=find(ydata>bound_y);
ul=length(intersect(temp_xfind,temp_yfind));
clear temp*

%working on upper right quadrant (> both boundary x and y)
temp_xfind=find(xdata>bound_x);
temp_yfind=find(ydata>bound_y);
ur=length(intersect(temp_xfind,temp_yfind));
clear temp*
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