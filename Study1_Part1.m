function Study1_Part1(params, exp, stim, ParticipantDemo, triggerParams) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created September 2019 by Elektra Schubert (based on code by Maja
% Brydevall)
%
% This experiment investigates emotion regulation strategies (distraction
% and reappraisal) and their impact on dietary decision-making. This is
% the first part, where participants view images of unhealthy foods and
% are asked three questions:
%
%    1. How often do you consume this food?
%    2. How much do you enjoy the taste of this food? (Sliding scale)
%    3. How healthy do you consider this food to be? (Sliding scale)
%
% For questions 2 and 3, the sliding scale will be reversed for 50%
% of trials.
% 
% For the second part of this experiment, see Study1_Part2
%
% Updated: September 2019 Elektra Schubert
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KbName('UnifyKeyNames');

EEGTask = false;

%% ************************************************************************
%************************** WELCOME SCREEN ********************************
%**************************************************************************
  
%   Experimental instructions, wait for a spacebar response to start
Screen('FillRect', exp.mainwin, params.bgcolour);
Screen('TextSize', exp.mainwin, 42);
Screen('DrawText', exp.mainwin, ['Part 1'], exp.center(1)-350,exp.center(2)-50,params.textcolour);
Screen('TextSize', exp.mainwin, 20);
Screen('DrawText', exp.mainwin, ['You will be shown images of various foods.'], exp.center(1)-350, exp.center(2)+30, params.textcolour);
Screen('TextSize', exp.mainwin, 20);
Screen('DrawText', exp.mainwin, ['Please answer all questions for each of the foods displayed.'], exp.center(1)-350, exp.center(2)+80, params.textcolour);
Screen('TextSize', exp.mainwin, 20);
Screen('DrawText', exp.mainwin, ['Press Space Bar to begin.'], exp.center(1)-350, exp.center(2)+130, params.textcolour);
Screen('Flip', exp.mainwin);

if EEGTask
    Study1_sendTrigger(triggerParams, 349) % Send trigger for welcome screen
end 

while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('Space'))==1
         if EEGTask==1
             Study1_sendTrigger(triggerParams, 545) % Send trigger for spacebar press
         end 
        break
    end 
end 

%% ************************************************************************
%************************ EXPERIMENT PART 1 *******************************
%**************************************************************************

% Start with taste or health question?
tOrH = [1 2];
startingTrial = datasample(tOrH,1);
    if startingTrial == 1
        tastyOrHealthy = [1 2 1 2 1 2 1 2 1 2 1 2].';
    elseif startingTrial == 2
        tastyOrHealthy = [2 1 2 1 2 1 2 1 2 1 2 1].';
    end 

for b = 1:params.nBlocks
    
    % Determine whether this block will ask Tasty or Healthy question
    blockType = tastyOrHealthy(b,1);
    blockHistory(b,1) = blockType;


    if EEGTask
        Study1_sendTrigger(triggerParams, 353) % Send trigger for start of block
        WaitSecs(0.002)
        Study1_sendTrigger(triggerParams, 353+b) % Send trigger for block number
        WaitSecs(0.002)
        if blockType==1
            Study1_sendTrigger(triggerParams, 366) % Send trigger for block type (Tasty)
        elseif blockType==2
            Study1_sendTrigger(triggerParams, 367) % Send trigger for block type (Healthy)
        end
    end
    for i = 1:params.nBlockTrials
        if EEGTask
        Study1_sendTrigger(triggerParams, 352) %Send trigger for start of trial
        WaitSecs(0.002)
        if b == 1 Study1_sendTrigger(triggerParams, i) % send trigger for trial number (1-29)
        elseif b == 2 Study1_sendTrigger(triggerParams, (29+i)) % send trigger for trial number (30-58)
        elseif b == 3 Study1_sendTrigger(triggerParams, (58+i)) % send trigger for trial number (59-87)
        elseif b == 4 Study1_sendTrigger(triggerParams, (87+i)) % send trigger for trial number (88-116)
        elseif b == 5 Study1_sendTrigger(triggerParams, (116+i)) % send trigger for trial number (117-145)
        elseif b == 6 Study1_sendTrigger(triggerParams, (145+i)) % send trigger for trial number (146-174)
        elseif b == 7 Study1_sendTrigger(triggerParams, (174+i)) % send trigger for trial number (175-203)
        elseif b == 8 Study1_sendTrigger(triggerParams, (203+i)) % send trigger for trial number (204-232)
        elseif b == 9 Study1_sendTrigger(triggerParams, (232+i)) % send trigger for trial number (233-261)
        elseif b == 10 Study1_sendTrigger(triggerParams, (261+i)) % send trigger for trial number (262-290)
        elseif b == 11 Study1_sendTrigger(triggerParams, (290+i)) % send trigger for trial number (291-319)
        elseif b == 12 Study1_sendTrigger(triggerParams, (319+i)) % send trigger for trial number (320-248)
        end 
    end
    
    %   Fill screen
    Screen(exp.mainwin, 'FillRect', params.bgcolour);
    Screen('Flip', exp.mainwin,0);
    
    %   Fixationcross
    Screen('FillRect', exp.mainwin, params.bgcolour);
    Screen('TextSize', exp.mainwin, 42);
    Screen('DrawText', exp.mainwin, ['+'],exp.center(1), exp.center(2), params.textcolour);
    Screen('Flip', exp.mainwin);
    if EEGTask
    Study1_sendTrigger(triggerParams, 548) % Send trigger for fixation cross
    end
    WaitSecs(1.5);
    
    if blockType==1 % Taste block
        if startingTrial == 1
            if b == 1
                blockNumber = 1;
            elseif b == 3
                blockNumber = 2;
            elseif b == 5
                blockNumber = 3;
            elseif b == 7
                blockNumber = 4;
            elseif b == 9
                blockNumber = 5;
            elseif b == 11
                blockNumber = 6;
            end
        elseif startingTrial == 2 % Health Block
            if b == 2
                blockNumber = 1;
            elseif b == 4
                blockNumber = 2;
            elseif b == 6
                blockNumber = 3;
            elseif b == 8
                blockNumber = 4;
            elseif b == 10
                blockNumber = 5;
            elseif b == 12
                blockNumber = 6;
            end
        end 
           
    if blockNumber == 1 % First block
        stim.foodListBlocks1{blockNumber} = stim.foodImgListRandomised1(1:params.nBlockTrials,:); % first x amount of trials (makes up the first block)
        
    else % every other block
        stim.foodListBlocks1{blockNumber} = stim.foodImgListRandomised1((((blockNumber-1) * params.nBlockTrials)+1):(blockNumber * params.nBlockTrials),:); % makes up every subsequent block
    end 
    
    % Generate number indicating trial number specific to Health/Taste
    if blockNumber == 1 
        trialNoTaste = i;
    else
        trialNoTaste = (blockNumber-1)*i + i;
    end % if
        
    %   Load random image from image folder specified in setup section
    stim.foodFile1 = stim.foodListBlocks1{1,blockNumber}{i,1};
    global foodImageDisplay % This is set to global just so that the sliding scale script can use it (don't worry about it)
    randFoodImage1 = imread(fullfile(stim.foodImgFolder1,stim.foodFile1));
    foodImageDisplay = Screen('MakeTexture', exp.mainwin, randFoodImage1);
    
    %   Display the image alone for 2 sec
    Screen(exp.mainwin, 'FillRect', params.bgcolour);
    Screen('DrawTexture', exp.mainwin, foodImageDisplay, [], []);
    timeStamp = Screen('Flip', exp.mainwin);
    if EEGTask
    Study1_sendTrigger(triggerParams, 542) % Send generic trigger for an image being displayed
    WaitSecs(0.002)
    Study1_sendTrigger(triggerParams,stim.foodImgListRandomised1{367+trialNoTaste,2}) % Send specific trigger for image
    end 
    timeStampImageRate = timeStamp - params.expStart;
    WaitSecs(2);
    
    while 1
    
    %   Display image with TASTE RATING question
    Screen(exp.mainwin, 'FillRect', params.bgcolour);
    Screen('DrawTexture', exp.mainwin, foodImageDisplay, [], []);
            startTime = Screen('Flip', exp.mainwin);
            WaitSecs(0.1) % Show image alone for split second as we need a gap between the two scales being displayed to prevent accidntial reponse to second scale.
            xq3 = [1 2];% Randomly draw a 1 or a 2 (if 2, scale will be reversed)
            pos3 = randi(length(xq3));
            Screen(exp.mainwin, 'FillRect', params.bgcolour); %
            Screen('DrawTexture', exp.mainwin, foodImageDisplay, [], []);
            Screen(exp.mainwin, 'FillRect', params.bgcolour);
            Screen('TextSize', exp.mainwin, 24);
            question3 = 'How much do you enjoy the taste of this food?';
            if pos3 == 1
                [position, RT, answer] = slideScale(exp.mainwin, question3, exp.rect, stim.endPoints, 'device', 'mouse', 'scalaposition', 0.7, 'startposition', 'center', 'displayposition', true, 'range', 2)
                startTime = Screen('Flip', exp.mainwin);
                if EEGTask
                Study1_sendTrigger(triggerParams, 549) % Send trigger for Q2 displayed
                end
                tasteRT = RT;
            elseif pos3 == 2
                [position, RT, answer] = REVslideScale(exp.mainwin, question3, exp.rect, stim.REVendPoints, 'device', 'mouse', 'scalaposition', 0.7, 'startposition', 'center', 'displayposition', true, 'range', 2)
                startTime = Screen('Flip', exp.mainwin);
                if EEGTask
                Study1_sendTrigger(triggerParams, 549) % Send trigger for Q2 displayed
                end
                tasteRT = RT;
            end
            tasteRating = position;
            healthRating = 999;
            healthRT = 999;
            if EEGTask
                if position > 50 
                    Study1_sendTrigger(triggerParams, 544)
                    elseif Study1_sendTrigger(triggerParams, 543)
                end
            end 
    break
    end
    
    elseif blockType==2 % Health block
         if startingTrial == 2
            if b == 1
                blockNumber = 1;
            elseif b == 3
                blockNumber = 2;
            elseif b == 5
                blockNumber = 3;
            elseif b == 7
                blockNumber = 4;
            elseif b == 9
                blockNumber = 5;
            elseif b == 11
                blockNumber = 6;
            end
        elseif startingTrial == 1
            if b == 2
                blockNumber = 1;
            elseif b == 4
                blockNumber = 2;
            elseif b == 6
                blockNumber = 3;
            elseif b == 8
                blockNumber = 4;
            elseif b == 10
                blockNumber = 5;
            elseif b == 12
                blockNumber = 6;
            end
        end 
    
      if blockNumber == 1 % First block
         stim.foodListBlocks2{blockNumber} = stim.foodImgListRandomised2(1:params.nBlockTrials,:);

      else
         stim.foodListBlocks2{blockNumber} = stim.foodImgListRandomised2((((blockNumber-1) * params.nBlockTrials)+1):(blockNumber * params.nBlockTrials),:); % makes up every subsequent block
      end 
      
    % Generate number indicating trial number specific to Health/Taste
    if blockNumber == 1 
        trialNoHealth = i;
    else
        trialNoHealth = (blockNumber-1)*i + i;
    end % if
      
        
    %   Load random image from image folder specified in setup section
    stim.foodFile2 = stim.foodListBlocks2{1,blockNumber}{i,1};
    global foodImageDisplay % This is set to global just so that the sliding scale script can use it (don't worry about it)
    randFoodImage2 = imread(fullfile(stim.foodImgFolder2,stim.foodFile2));
    foodImageDisplay = Screen('MakeTexture', exp.mainwin, randFoodImage2);
    
    %   Display the image alone for 2 sec
    Screen(exp.mainwin, 'FillRect', params.bgcolour);
    Screen('DrawTexture', exp.mainwin, foodImageDisplay, [], []);
    timeStamp = Screen('Flip', exp.mainwin);
    if EEGTask
    Study1_sendTrigger(triggerParams, 542) % Send generic trigger for an image being displayed
    WaitSecs(0.002)
    Study1_sendTrigger(triggerParams,stim.foodImgListRandomised2{550+trialNoHealth,2}) % Send specific trigger for image
    end 
    timeStampImageRate = timeStamp - params.expStart;
    WaitSecs(2);
    
    while 1
        
    % Display image with HEALTH RATING question
    xq4 = [1 2]; % Randomly draw a 1 or a 2 (if 2, scale will be reversed)
    pos4 = randi(length(xq4));
    Screen(exp.mainwin, 'FillRect', params.bgcolour); %
    Screen('DrawTexture', exp.mainwin, foodImageDisplay, [], []);
            startTime = Screen('Flip', exp.mainwin);
            WaitSecs(0.1) % Show image alone for split second as we need a gap between the two scales being displayed to prevent accidntial reponse to second scale.
            Screen(exp.mainwin, 'FillRect', params.bgcolour);
            Screen('TextSize', exp.mainwin, 24);
            question4 = 'How healthy do you consider this food to be?';
            if pos4 == 1
                [position, RT, answer] = slideScale(exp.mainwin, question4, exp.rect, stim.endPoints2, 'device', 'mouse', 'scalaposition', 0.7, 'startposition', 'center', 'displayposition', true, 'range', 2)
                startTime = Screen('Flip', exp.mainwin);
                if EEGTask
                    Study1_sendTrigger(triggerParams, 550) % Send trigger for Q3 displayed
                end 
                healthRT = RT;
            elseif pos4 == 2
                [position, RT, answer] = REVslideScale(exp.mainwin, question4, exp.rect, stim.REVendPoints2, 'device', 'mouse', 'scalaposition', 0.7, 'startposition', 'center', 'displayposition', true, 'range', 2)
                startTime = Screen('Flip', exp.mainwin);
                if EEGTask
                    Study1_sendTrigger(triggerParams, 550) % Send trigger for Q3 displayed
                end
                healthRT = RT;
            end
            healthRating = position;
            tasteRating = 999;
            tasteRT = 999;
            if EEGTask
             if position > 50 
                 Study1_sendTrigger(triggerParams, 544)
             elseif Study1_sendTrigger(triggerParams, 543)
             end
            end

           break 
    end
    end
    if blockType==1
        fprintf(exp.outfile1, '%s\t %s\t %s\t %s\t %.2f\t %f\t %.2f\t %.2f\t %.2f\t \n', ParticipantDemo.ID, ParticipantDemo.Age, ParticipantDemo.Gender, stim.foodFile1, timeStampImageRate, tasteRating, tasteRT, healthRating, healthRT);
    elseif blockType==2
        fprintf(exp.outfile1, '%s\t %s\t %s\t %s\t %.2f\t %f\t %.2f\t %.2f\t %.2f\t \n', ParticipantDemo.ID, ParticipantDemo.Age, ParticipantDemo.Gender, stim.foodFile2, timeStampImageRate, tasteRating, tasteRT, healthRating, healthRT);
    end
    end 
 

    if b < params.nBlocks % if any block but the last block, display the break screen. Otherwise, go to the end screen
        
        Screen('FillRect', exp.mainwin, params.bgcolour);
        Screen('TextSize', exp.mainwin, 42);
        Screen('DrawText', exp.mainwin, ['Block complete'], exp.center(1)-50,exp.center(2)-50,params.textcolour);
        Screen('TextSize', exp.mainwin, 20);
        Screen('DrawText', exp.mainwin, ['Please take a short break.'], exp.center(1)-50, exp.center(2)+30, params.textcolour);
        Screen('TextSize', exp.mainwin, 20);
        Screen('DrawText', exp.mainwin, ['Press space bar to continue.'], exp.center(1)-50, exp.center(2)+80, params.textcolour);
        Screen('Flip', exp.mainwin); % flip the text created above onto the screen
        WaitSecs(5);
        KbWait; % wait for key press
        
    end
end
     
%% ************************************************************************
%**************************** EXIT SCREEN *********************************
%**************************************************************************

Screen('FillRect', exp.mainwin, params.bgcolour);
Screen('TextSize', exp.mainwin, 42);
Screen('DrawText', exp.mainwin, ['Thank you!'], exp.center(1)-350,exp.center(2)-50,params.textcolour);
Screen('TextSize', exp.mainwin, 20);
Screen('DrawText', exp.mainwin, ['You have completed the first part of the experiment'], exp.center(1)-350, exp.center(2)+30, params.textcolour);
Screen('TextSize', exp.mainwin, 20);
Screen('DrawText', exp.mainwin, ['Please let the researcher know you are ready for Part 2'], exp.center(1)-350, exp.center(2)+80, params.textcolour);
Screen('Flip', exp.mainwin); 
if EEGTask
    Study1_sendTrigger(triggerParams, 350) % Send trigger for thank you screen
end 
while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('Space'))==1
        if EEGTask
        Study1_sendTrigger(triggerParams, 351) % Send trigger for spacebar press
        end 
        break
    end  
end 

end % function
