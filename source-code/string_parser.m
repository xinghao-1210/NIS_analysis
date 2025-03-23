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
end