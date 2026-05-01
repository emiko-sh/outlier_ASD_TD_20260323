function output = checkEachParticipantDat02(s3, Result, rTarget, jj)
p=0;
posMask = [1:1500, 4001:6000, 9001:11000, 14001:16000, 19001:20000];

    for currentData=1:length(Result)
        k=currentData;
        if Result(k).numTrials>0
            s = Result(k).s;
            for currentMeasure=1:length(s)
                %load data from s
                m=currentMeasure;
                timeDiff = s(m).timeDiff;
                rMeasued= s(m).rMeasued;
                x = s(m).x;
                        timeDiff(posMask)=NaN;
                        x = x(1:20000);
                        idNaNx = isnan(x);
                        timeDiff(idNaNx) = NaN;
                        timeDiff(rMeasued<120)=nan;
                        % Samples located within 120 pixels of the monitor center
                        % are excluded from the analysis.
                        timeDiff(jj)=NaN; 
                        % change half-blink region to nan and add 
                        % nan region of  above to rMeasued
                        idNaNtimeDiff=isnan(timeDiff);
                        rMeasued(idNaNtimeDiff)=nan;
                        rMeasued(jj)=NaN; % % This line may duplicate processing
                        rTarget=rTarget(1:20000);

                        %rMeasued(posMask)=NaN;
                        %rMeasued(idNaNx)=NaN;
                        %rMeasued(rMeasued<120)=nan;

                        ratio=rMeasued./rTarget;           
                        ratio=ratio(isfinite(ratio));
                        absDiffRatio=abs(ratio-1);

                        lengthMask=8500;
                        lengthNaN = sum(isnan(timeDiff));
                        nanRatio=(lengthNaN-lengthMask)/11500;% 11500 total length of usable data region
                        dataRatio = round((1-nanRatio)*100, 1);


                % data store with id

                p=p+1;% counter for s2

                s3(p).timeDiffraw =s(m).timeDiff;
                s3(p).timeDiff =timeDiff;
                s3(p).rMeasued=rMeasued;
                s3(p).person=s(m).person;
                s3(p).timeDiff_mean=nanmean(timeDiff);
                s3(p).timeDiff_std=nanstd(timeDiff);
                s3(p).ratio_mean=nanmean(ratio);
                s3(p).ratio_std=nanstd(ratio);
                s3(p).absDiffRatio_mean= nanmean(absDiffRatio);
                s3(p).absDiffRatio_std= nanstd(absDiffRatio);
                s3(p).posMask=posMask;
                s3(p).lengthMask= lengthMask;
                s3(p).dataRatio= dataRatio;


                s3(p).dataPath=s(m).dataPath;
                s3(p).filename=s(m).dataCellFile;
                s3(p).rawDataFile=Result(k).file;
                s3(p).valQ=Result(k).valQ;
                s3(p).trials=s(m).trials;
                s3(p).numInResultFile=Result(k).num;
            
            end 
            %----------- end of inner loop --------------
        else
            continue
        end
        % ---------- end of if -----------------
    end
    % ------- end of outer loop ----------------
    output = s3;
    %--- end of function----
end