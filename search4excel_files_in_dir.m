function [filename,dirn] = search4excel_files_in_dir()
temp=dir;
ind_xls_files=[];
for n=1:length(temp)
    tempname=temp(n).name;
    len_tn=length(tempname);
    if len_tn>4
        if strcmpi(tempname((len_tn-3):(len_tn)),'.xls') ||  strcmpi(tempname((len_tn-4):(len_tn)),'.xlsx')
            ind_xls_files=[ind_xls_files,n];
        end
    end
end

if length(ind_xls_files)==1
    dirn=pwd;
    dirn=[pwd,'\'];
    fn=temp(ind_xls_files).name;
else
    [fn,dirn] = uigetfile('*.xls;*.xlsx','All Excel files');
end
filename=[dirn,fn];
end