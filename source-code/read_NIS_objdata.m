function  [groups,outhead_data,grps,xlsfilename2save,curdir] = read_NIS_objdata(datapts,xlsfile,grps)

%%%%%%%%%%%%% read data from file

if nargin<2
    [xlsfile,curdir]=search4excel_files_in_dir();
end
wh=waitbar(0,'Please do not touch primary GUI while loading Excel data...');
try
    
temp_needs_deleting=false;
waitbar(0.05,wh);
if strcmp(xlsfile(end-3),'.') %means it's *.xls
    xlsfilename2save=[xlsfile(1:(end-4))];
else %means it's *.xlsx
    xlsfilename2save=[xlsfile(1:(end-5))];
end
savelater=true;
waitbar(0.10,wh)
if exist([xlsfilename2save '.mat'])==2
    load([xlsfilename2save '.mat']);
    savelater=false;
    groups=proc_data;
    outhead_data=datapts;
    waitbar(0.6,wh);
    warndlg(['File is already processed. Loading in *.mat file'])
else
    if exist(['temp123.mat'])==2
        load temp123.mat
    else
        [typ, desc] = xlsfinfo(xlsfile);
        oridesc=desc;
        waitbar(0.25,wh);
        if length(oridesc)==1
            [dat,head,supertemp]=xlsread(xlsfile);
            headers=supertemp(1,:);
            srcidx=find(strcmp(headers,'Source'));
            namefiles=unique(supertemp(2:end,srcidx));
            notgood=true;
            attempts=0;tolatt=5;maxdispnum=12;
            while notgood && attempts<tolatt
                release=false;
                allfilledin=true;
                
                if length(namefiles)>maxdispnum
                    numparse=ceil(length(namefiles)/maxdispnum);
                    remnum=rem(length(namefiles),maxdispnum);
                    for kk=1:numparse
                        if kk<numparse
                            rangemat=[(((kk-1)*maxdispnum)+1):(kk*maxdispnum)];
                        else
                            if remnum==0
                                rangemat=[(((kk-1)*maxdispnum)+1):(kk*maxdispnum)];
                            else
                                rangemat=[(((kk-1)*maxdispnum)+1):length(namefiles)];
                            end
                        end
                        parse_trynewdesc=inputdlg(namefiles(rangemat),['Name the Conditions - part ',num2str(kk),':']);
                        if isempty(parse_trynewdesc)
                            for mm=1:length(rangemat)
                                parse_trynewdesc{mm,1}='';
                            end
                        end
                        for ll=1:length(parse_trynewdesc)
                            trynewdesc{rangemat(ll)}=parse_trynewdesc{ll};
                        end
                    end
                else
                    trynewdesc=inputdlg(namefiles,'Name the Conditions');
                end
                if isempty(trynewdesc)
                    for mm=1:length(namefiles)
                        trynewdesc{mm,1}='';
                    end
                end
                for n=1:length(namefiles)
                    if attempts<4
                        if isempty(trynewdesc{n})
                            disp(['Must fill in all condition names! ',num2str((tolatt-1)-attempts),' more chances!'])
                            allfilledin=false;
                            break
                        elseif n==length(trynewdesc)
                            release=true;
                        end
                    else
                        if isempty(trynewdesc{n})
                            trynewdesc{n}=namefiles{n};
                        end
                        if n==length(trynewdesc)
                            release=true;
                        end
                    end
                end
                if length(trynewdesc)~=length(unique(trynewdesc))
                    release=false;
                    if allfilledin
                        errordlg('Condition names must be unique!')
                    end
                end
                if release
                    notgood=false;
                    desc=trynewdesc;
                else
                    attempts=attempts+1;
                    if attempts==tolatt % should never get here, on attempt 4, should auto-name
                        errordlg('Guess you did not want to load this file.')
                    end
                end
            end
        end
        running=[];
        if nargin<3
            grps={};
            ct=1;
            while true
                out=select_ctrl_GUI(['Select group ' num2str(ct)],desc,['Select group ' num2str(ct)]);
                if out(1)==-1
                    break
                else
                    grps{ct}=out;
                    ct=ct+1;
                    running=[running,out];
                end
            end
        end
        waitbar(0.30,wh);
        wh_div=0.4/length(grps);
        samp_list=desc(unique(running));
        for n=1:length(grps)
            tempg=grps{n};
            wh_div_inner=wh_div/length(tempg);
            for m=1:length(tempg)
                if length(oridesc)==1
                    curfileidx=find(strcmp(namefiles{tempg(m)},supertemp(:,srcidx)));
                    group(n).raw{m}=[headers;supertemp(curfileidx,:)];
                else
                    [dat,head,group(n).raw{m}]=xlsread(xlsfile,desc{tempg(m)});
                end
                waitbar(0.30+((wh_div)*(n-1))+((wh_div_inner)*(m-1)),wh);
            end
        end
        %save('temp123','group','grps') %buggy - file saved is way too large
    end
    %temp_needs_deleting=true;
    
    clear dat head
    
    waitbar(0.70,wh,'Please do not touch primary GUI while processing Excel data...')
    %%%%%%%%%%%%%% start data gathering
    headers=group(1).raw{1}(1,:);
    ididx=find(strcmp(headers,'BinaryID'));
    
    if nargin<1
        datapts_idx=select_ctrl_GUI('Select Data',headers,'Select data to read:');
    else
        if iscell(datapts)
            for n=1:length(datapts)
                datapts_idx(n)=find(strcmpi(headers,datapts{n}));
            end
        else
            datapts_idx=datapts;
        end
    end
    
    wh_div=0.25/length(grps);
    groups=[];
    for n=1:length(grps)
        tempg=grps{n};
        wh_div_inner=wh_div/length(tempg);
        for m=1:length(tempg)
            channels=unique(group(n).raw{m}(2:end,ididx));
            chan_list={};dat_list={}; %resetting values
            for z=1:length(channels)
                temp=string_parser(channels{z},' ');
                tempstr=temp{end};
                chan_list{z}=tempstr(2:(end-1));
                dat_list{z}=find(strcmp(group(n).raw{m}(:,ididx),channels{z}));
            end
            groups(n).data(m).channel_list=chan_list;
            if ~isequal(length(groups(n).data(m).channel_list),length(channels))
                ljk=0; %for debugging
            end
            for a=1:length(channels)
                for b=1:length(datapts_idx)
                    tempdat=cell2mat(group(n).raw{m}(dat_list{a},datapts_idx(b)));
                    eval(['groups(n).data(m).chan_dat(a).',headers{datapts_idx(b)},'=tempdat;'])
                end
            end
            
            waitbar(0.70+((wh_div)*(n-1))+((wh_div_inner)*(m-1)),wh);
        end
    end
% for recycling for future
outhead_data=headers(datapts_idx);
end
waitbar(0.95,wh)

if savelater
    proc_data=groups;
    datapts=outhead_data;
    save(xlsfilename2save,'proc_data','grps','datapts','samp_list');
end
if temp_needs_deleting
    delete temp123.mat
end
waitbar(1,wh)
close(wh)

catch
    errordlg('Failed to load and process excel file.')
    close(wh)
end

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

end