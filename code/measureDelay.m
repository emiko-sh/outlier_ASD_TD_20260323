% to measure the delay of pursuit 
% delay from the angle of target
function s = measureDelay(s, tgTheta)
sizeS= length(s);
Tmax=20000;
w=400; % time width -400 ms to 400 ms
        
for row=1:sizeS
        minTimePoint=[];
        minTimeDiff=[];
        Tmin=[];
        Lmin=[];
        compt=[];
        msTheta = s(row).msTheta;

        for k=1:Tmax
        L=ones(401,1).*nan;
        compt(:,1) = k-w:k+w;

                for m=1:w*2+1
                t=compt(m); % -200 ms to +200 ms
                % k+t  where t=-200 to 200 ms is for time to compare
                if or (t<1, t>Tmax) % over or under
                L(m)=nan;
                else
                L(m)= abs(tgTheta(t)-msTheta(k));
                end

                [M,I] = min(L);
                Tmin(m,1)=compt(I);
                Lmin(m,1)=M;
                end

        [M, I] = min (Lmin);
        minTimePoint(k,1) = Tmin (I) ;
        minTimeDiff(k,1) = M ;
        end
    %s(row).minTimePoint = minTimePoint;
    %s(row).minTimeDiff = minTimeDiff; 
    targetTime(:,1) = 1:Tmax;
    s(row).timeDiff = minTimePoint-targetTime; 
    
end

%plotMeasureDelay();
%savePlot();

%--end of function--
end

%% --function --

function plotMeasureDelay()
figure(3);
plot(minTimeDiff);

figure(4);
plot(minTimePoint);

figure(1);
f=gcf;
f.Position = ([100, 200, 1400, 500]);
axes
box on;hold on;
ax=gca;
ax.Units='pixels';
ax.FontSize=18;
ax.FontName='Helvetica';
ax.LineWidth=2;
ax.Position = [100, 100, 1200, 300] ;

targetTime(:,1) = 1:Tmax;
scatter([1:Tmax], minTimePoint-targetTime, '.');
xlabel('t (real) ms');
ylabel('t (delay or preceed) ms');

txt = '';
annotation('textbox','Position', [.01 0.01 .1 .06] ,'FitBoxToText', 'on',...
        'String', txt,...
        'LineStyle', 'none', 'Interpreter', 'latex', 'Color', [0 0 0]);

hold on;
plot([0 Tmax] , [0 0], 'k-', 'LineWidth', 2);
h2= scatter (tt (peaks(:,1) ).*1000, peaks(:,2).*0, 'p', 'fill');
end

function savePlot()
txt = ['Fig', script_name(7:end), '_', filename, '_f5'];
saveas(figure(5), fullfile('20181113 figures02', txt), 'png');
end
