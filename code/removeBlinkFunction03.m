function ScrnPos= removeBlinkFunction03(input)

    global blinkType;
    global blinkVal;

% This function assigns NaN values to samples surrounding blinks.
% Input y: [NÅ~2] matrix, where columns represent x and y positions.
% Output yout: matrix of identical size, with blink segments replaced by NaN.

y=input;

v = sqrt(sum(diff(y,[],1).^2, 2)); % velocity
v(end+1,:) = v(end,:);
medianVelocity = nanmedian((abs(v)));

    if blinkType=='A'
    thresh=blinkVal; % fixed number
    elseif blinkType=='B'
    thresh = blinkVal*medianVelocity; 
    end

totalPts = numel(v);

% searching for NaN
% During blink periods, the recorded x and y positions
% are assigned NaN values for reliability.
nanPosition = isnan(y(:,1)) | isnan(y(:,2));

blinkPositions = [];
isUp = false;
for n = 1:numel(nanPosition)
    if ~isUp && nanPosition(n) == 1
        isUp = true;
        blinkPositions(1,end+1) = n;
    elseif isUp && nanPosition(n) == 1
        blinkPositions(2,end) = n;
    elseif isUp && nanPosition(n) == 0
        isUp = false;
    end
end

% For each NaN interval, the algorithm identifies stable regions
% located immediately before and after the blink period.
% A sample is classified as stable when its velocity
% remains below the predefined threshold value.

goodPositions = (v <= thresh); 

previous = 0;
goodPositionsForward = zeros(size(goodPositions));
for n = 1:numel(goodPositions)
    if goodPositions(n) == 1
        goodPositionsForward(n) = previous+1;
        previous = previous+1;
    else
        previous = 0;
    end
end

previous = 0;
goodPositionsBackward = zeros(size(goodPositions));
goodPositionsFlip = goodPositions(end:-1:1);
for n = 1:numel(goodPositions)
    if goodPositionsFlip(n) == 1
        goodPositionsBackward(n) = previous+1;
        previous = previous+1;
    else
        previous = 0;
    end
end
goodPositionsBackward = goodPositionsBackward(end:-1:1);

nGoodPts = 10;
trueBlinkPositions = blinkPositions;

for n = 1:size(blinkPositions,2)
    start = blinkPositions(1,n);
    possibleStarts = find(goodPositionsBackward > nGoodPts);
    possibleStarts(possibleStarts > start) = [];
    if isempty(possibleStarts)
        possibleStarts = 1;
    else
        possibleStarts = possibleStarts(end);
    end
    
    trueBlinkPositions(1,n) = possibleStarts;
    
    endpos = blinkPositions(2,n);
    possibleEnds = find(goodPositionsForward > nGoodPts);
    possibleEnds(possibleEnds < endpos) = [];
    if isempty(possibleEnds)
        possibleEnds = totalPts;
    else
        possibleEnds = possibleEnds(1);
        
    end
    trueBlinkPositions(2,n) = possibleEnds;
    
end

% The blink interval is temporally expanded, and the resulting
% extended region is assigned NaN values.
for n = 1:size(trueBlinkPositions,2)
    start = trueBlinkPositions(1,n);
    endpos = trueBlinkPositions(2,n);
        y(start:endpos,:) = nan;
end

ScrnPos= y;

% -- end of function --
end