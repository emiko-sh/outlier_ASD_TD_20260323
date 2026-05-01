function s = extractData03(s, path, file, numTrials, positionTrials, validataion)
% targetXY_FL.mat is required
% continuous0516.m (function) is required

load(fullfile(path, file), 'celldata'); 

% data for fast Lissajous
% 20500 points 20 sec + 0.5 sec for artifact by brink
t1=20500;
%t2=20001; output would be 20001 point

timeStamp=zeros(t1,1)*NaN;
gx=zeros(t1,1)*NaN;
gy=zeros(t1,1)*NaN;
pupil=zeros(t1,1)*NaN;


for k=1:numTrials % 2 is usual, some participants have 4 - 6 trials
        for m =1:t1
        pos = positionTrials(k,1);
        txt = celldata{pos+m};
        currentCell = strsplit(txt, '\t');

        % https://jp.mathworks.com/help/matlab/ref/strsplit.html
            if length(currentCell)>3
            timeStamp(m) = str2double(currentCell{1});
            gx(m) =str2double(currentCell{2});
            gy(m) =str2double(currentCell{3});
            pupil(m)  = str2double(currentCell{4});
            else
            timeStamp(m) = str2double(currentCell{1});
            gx(m) =NaN;
            gy(m) =NaN;
            pupil(m)  = 0;
            end
        end
        
%%
% https://jp.mathworks.com/help/signal/ref/medfilt1.html
gx=medfilt1(gx,3);
gy=medfilt1(gy,3);
input = [gx, gy];
[msTheta, gxRB, gyRB]=continuous0516(input);
rMeasued=hypot(gx-640, gy-512);

s(k).person=file(1:8);
s(k).dataPath=path;
s(k).dataCellFile=file;
s(k).trials=k;
s(k).timeStamp=timeStamp;
s(k).x=gxRB;
s(k).y=gyRB;
s(k).pupil=pupil;
s(k).numTrials=numTrials;
s(k).msTheta= msTheta(1:20000);
s(k).rMeasued= rMeasued(1:20000);

end

% -- end of function --
end