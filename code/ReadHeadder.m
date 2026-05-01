function s = ReadHeadder(sampleNum, dataDir, L)
%k=1;
file = L(sampleNum).name;
load([dataDir,file], 'celldata');

p = findStart(celldata);
timeStampStart = celldata{p};% start time stamp

dataStart = p+6;
headderStart =p-22;
%%
txt=celldata{p-4};
thresholds = txt;
%%
calCell=NaN;
calQtxt='';
calQrow=cell(3,1);
calQrow(1,1)=celldata(p-21);
calQrow(2,1)=celldata(p-20);
calQrow(3,1)=celldata(p-19);
for k=1:3
    txt = calQrow{k};
    if contains(txt, 'CALIBRATION HV9')
    pos = strfind(txt, 'CALIBRATION HV9');
    calCell= p -22 +k;
    calQtxt=txt(pos+12+12: pos+18+12);
    else
    continue
    end
    
end
%%
valCell=NaN;
valQtxt='';
valQrow=cell(3,1);
valQrow(1,1)=celldata(p-20);
valQrow(2,1)=celldata(p-19);
valQrow(3,1)=celldata(p-18);
for k=1:3
    txt = valQrow{k,1};
    if contains(txt, 'VALIDATION HV9')
    pos = strfind(txt, 'VALIDATION HV9');
    valCell= p -21 +k;
    valQtxt=txt(pos+11+12: pos+15+12);
    else
    continue
    end
    
end
%%
try
isfinite(valCell);
catch exception
disp([num2str(k), ' is NaN']);
end

if isfinite(valCell)
[point9Error, offsetError]= findDeg(celldata, valCell);
else
point9Error=[];
offsetError=[];
end

s.num = sampleNum;
s.calQ=calQtxt;
s.valQ=valQtxt;
s.calCell=calCell;
s.valCell=valCell;
s.point9Err=point9Error;
s.offsetErr=offsetError;
s.file = file;
s.folder = dataDir;
s.headderStartCell = headderStart;
s.dataStartCell = dataStart;
s.timeStampStart=timeStampStart;
s.thresholds =thresholds;


end

function p=findStart(celldata)
p=0;
marker = true;
while marker
p=p+1;
txt = celldata{p}; % char
num =unicode2native(txt);
target = uint8([83 84 65 82 84]);
    if length(num)>10
        if sum(target-num(1:5))>0% "START" 
        else
        marker = false;
        end
    end
end
end
%target =unicode2native('START');

function [point9Error offsetError]= findDeg(celldata, valCell)

point9Error=ones(1,10)*NaN;
for k=1:10
    txt = celldata{valCell+k-1};
    pos =strfind (txt, 'deg');
    point9Error(1,k) =str2double( txt(pos-5:pos-2));
end

%offsetError=ones(1,1)*NaN;
    txt = celldata{valCell+11};
    pos =strfind (txt, 'deg');
    offsetError =str2double( txt(pos-5:pos-2));

end
