% obtain pursuit angle from center of the monitor
% input deta [ x y ] is time series array of pixel data
% this function has some plot options
function [msTheta, mgx, mgy]=continuous0516(input)

% removeBlinkFunction
ScrnPos = removeBlinkFunction03(input); 

% 20500 point -> 20001 point
mgx = ScrnPos(1:20001,1); 
mgy = ScrnPos(1:20001,2); 

%https://jp.mathworks.com/help/matlab/ref/atan2.html
%example, P = atan2(Y,X)
msTheta=atan2d ((1024 - mgy-512) , ( mgx-640) );

% catch each peak and convert data to the continuous angle
%plotResult()

% -- end of function -- 
end

%% -- function --

function plotResult()
fBig = figure(1);
clf
fBig.Units='pixels';
fBig.Position=[100 0 1400 1100];
axes
box on;hold on;
ax=gca;
ax.Units='pixels';
ax.FontSize=18;
ax.FontName='Helvetica';
ax.LineWidth=2;
ax.Position = [100, 450, 1200, 300] ;
h1=plot(tt, msTheta, 'm' , 'LineWidth', 2);
xlabel('t (s)');
ylabel('degree -180 t o180');
grid on;
[pks1 ,locs1 ] = findpeaks (msTheta, 'MinPeakWidth', 1000);
[pks2 ,locs2] = findpeaks ( -1 *msTheta, 'MinPeakWidth', 1000);
pks2 = -1 * pks2;

tmp1= [locs1; locs2];
tmp2= [pks1; pks2];
[~,I]  = sort(tmp1, 1);
peaks =horzcat (tmp1 (I), tmp2(I)) ;

hold on;
%h1=plot(t, tgTheta);
h2= scatter (tt(peaks(:,1)), peaks(:,2), 'm');
%xlabel('t (s)');
ylabel('degree -180 t o180');
grid on;

ax.XTickLabel={};
end












    
    
    
    