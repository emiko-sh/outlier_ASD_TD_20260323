
% These code snippets accompany the paper:
% "Detecting outliers of pursuit eye movements: a preliminary analysis
% of autism spectrum disorder" (Shishido et al., 2026).
% The scripts are not fully executable as provided; general MATLAB
% procedures such as data import and function definitions are omitted.
% Users may contact the authors regarding missing components.
% While tailored for EyeLink data, the framework can be extended to
% other eye-tracking systems by modifying sampling rates and display
% pixel dimensions.
% — Emiko Shishido, 2026

%% PreProcessData
% The EyeLink EDF dataset is converted into a text file
% via the dos command:
%     dos(['edf2asc ', fileName(1:end-4), ' -neye -s']);
% The resulting text file is subsequently imported
% into MATLAB and stored as a .mat cell array.

L=dir('*.edf');
for k=1:length(L)
fileName=L(k).name;
dos(['edf2asc ', fileName(1:end-4), ' -neye -s']);
% dos command provided by EyeLink
% this generate a txt file in the same directory as edf file
end

%% ReadHeadder
% The header information is extracted
% from the EyeLink-generated text file.

ReadHeadder.m

%% Computation of timeDiff and rMeasured
% Step 1:
% Using extractData03(...), gx, gy, and pupil values are obtained.
% Within extractData03, gx and gy are median-filtered, and msTheta
% is derived via continuous0515test(input). rMeasured is computed
% as hypot(gx-640, gy-512).
%
% Step 2:
% The measureDelay(...) function estimates timeDiff and stores
% the resulting values within the structure s. Blink removal
% relies on removeBlinkFunction03 with a fixed velocity threshold
% (Type A, threshold = 1.2).

extractData03.m
continuous0516.m
removeBlinkFunction03.m

blinkType = 'A';
blinkVal=1.2;

measureDelay.m

%% Identify regions that are unsuitable
% NaN values are inserted outside the valid domains of timeDiff
% and rMeasured.
%
% Step 1:
% The function checkEachParticipantDat02(...) applies a Hampel filter
% to the pupil signal to eliminate half blinks (ws=500, ss=30).
%
% Step 2:
% Using timeDiff and rMeasured, checkEachParticipantDat02 identifies
% gaze samples located near the monitor center and replaces them
% with NaN for subsequent analysis.

checkEachParticipantDat02.m

%% Outlier Detection via PCA 
% PCA weights are estimated using data from the Healthy Control (HC) group.
% These weights are then applied to compute the squared Mahalanobis distance
% for each individual in both the HC and ASD (Autism Spectrum Disorder) groups.
% The resulting metrics are used to construct the figures presented in the paper.

for k=1:length(s6)
row= s6(k).s3row;

    if row(2)>0
    a1=s3(row(1)).timeDiff; 
    a2=s3(row(2)).timeDiff; 
    a=[a1;a2];
    else % 2個目のデータがないとき
    a=s3(row(1)).timeDiff;
    end

    if row(2)>0
    b1=s3(row(1)).rMeasued; 
    b2=s3(row(2)).rMeasued; 
    rMeasued=[b1;b2];
    ratio=rMeasued./[rTarget;  rTarget];
    else % 2個目のデータがないとき
    rMeasued=s3(row(1)).rMeasued; 
    ratio=rMeasued./rTarget;  
    end

    ratio=ratio(isfinite(ratio));

timeDiff_mean(k,1)=nanmean(a);
timeDiff_std(k,1)=nanstd(a);
ratio_mean(k,1) = nanmean(ratio);
ratio_std(k,1) = nanstd(ratio);

clear a1 a2 a b1 b2
end

hc01=timeDiff_mean(idxHC&idx49);
hc02=timeDiff_std(idxHC&idx49);
hc03=ratio_std(idxHC&idx49);
hcdat=[hc01,hc02,hc03];

asd01=timeDiff_mean(idxASD&idx49);
asd02=timeDiff_std(idxASD&idx49);
asd03=ratio_std(idxASD&idx49);
asdat=[asd01,asd02,asd03];

dat=zeros(length(hcdat), 3)*NaN;
dat(:,1)=hcdat(:,1); % delta time mean
dat(:,2)=hcdat(:,2); % delta time std
dat(:,3)=hcdat(:,3); % this is about r

% Compute coefforth from control data
C = corr(dat,dat); % Compute the correlation matrix.
w = 1./var(dat);
[wcoeff, score, latent, tsquared, explained] = pca(dat,...
'VariableWeights',w);
% Automatic computation of the covariance-structure loadings (wcoeff),
% the principal component scores (score), and Hotelling’s T² statistics
% (tsquared) as squared form of Mahalanobis distance

c3 = wcoeff(:,1:3);%C3 is three dimensional
coefforth = inv(diag(std(dat)))*wcoeff;% or: coefforth = diag(sqrt(w))*wcoeff;

[~, mu,sigma]=zscore(dat); % mean and standard deviation of Healthy Control (HC)
cscores = (dat-mu)./sigma*coefforth; % Corrected Scores in PCA Space

% https://www.mathworks.com/help/stats/mahal.html
% manually computing Hotelling’s T² statistics using Mahalanobis distance
% Mahalanobis Distance of HC
st2 = mahal(cscores ,cscores ) ;

% Mahalanobis Distance of ASD
cscoresASD = (asdat-mu)./sigma*coefforth;
st2ASD = mahal(cscoresASD, cscores) ;

% 'mahal' returns squared distance; "Outlier Score" in the paper is sqrt(output).

