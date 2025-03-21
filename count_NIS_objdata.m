function [mns,sds,channel_names,norm_counts,raw_counts] = count_NIS_objdata(alldata)
%function [mns,sds,channel_names,norm_counts,raw_counts] = count_NIS_objdata(alldata)
%must pass in datapts as names of fields - exact name!!

firsttime=true;
app_chan_list={};
for n=1:length(alldata)
    for m=1:length(alldata(n).data)
        app_chan_list=[app_chan_list,alldata(n).data(m).channel_list];
    end
end
channel_names=unique(app_chan_list);
for n=1:length(alldata)
    for m=1:length(alldata(n).data)
        if firsttime
            raw_counts=[];
            firsttime=false;
            channel_idx=select_ctrl_GUI('Select channel',channel_names,'Select channel to normalize to:');
        end
        for l=1:length(channel_names)
            temp_chan_idx=find(strcmp(alldata(n).data(m).channel_list,channel_names{l}));
            if ~isempty(temp_chan_idx)
                temp_chan_idx=temp_chan_idx(1);
                if temp_chan_idx<=length(alldata(n).data(m).chan_dat)
                    temp_fn=fieldnames(alldata(n).data(m).chan_dat(temp_chan_idx));
                    eval(['raw_counts(n,l,m)=length(alldata(n).data(m).chan_dat(temp_chan_idx).',temp_fn{1},');'])
                else
                    raw_counts(n,l,m)=0;
                end
            end
        end
    end
end
norm_counts=zeros(size(raw_counts));
for ch=1:size(raw_counts,2)
    norm_counts(:,ch,:)=raw_counts(:,ch,:)./raw_counts(:,channel_idx,:);
end
mns=nanmean(norm_counts,3);
sds=nanstd(norm_counts,0,3);
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
