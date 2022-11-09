%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Created September 2019 by Elektra Schubert (based on code by Maja       %
% Brydevall)                                                              %
%                                                                         %
%                       Description here                                  %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Housekeeping

sca;
close all; 
clear all;
clearvars;
  
Screen('Preference', 'SkipSyncTests', 1); % Skip sync tests - REMOVE WHEN RUNNING ACTUAL EXPERIMENT
KbName('UnifyKeyNames');

PsychDefaultSetup(2);

PsychDebugWindowConfiguration([],0.5) % Makes screen see through (good for debugging)
     
%   Initialize the random number  generator
rand('state', sum(100*clock));

% Specify whether task is being run with or without EEG ('true' or 'false')
% This also needs to be changed in the Study1_Part1 script
EEGTask = false;

%% Specify paths 
%   Update this with the paths to the folders on the computer you are using

if ismac % If using a mac
    
    exp.Paths.mainPath = '/Users/elektraschubert/Documents/PhD/Study 1/Experimental Code/'; % Update this with the path to the folder of this script
    
    addpath(genpath(exp.Paths.mainPath)); % Location of task script
    
    exp.Paths.resdir = [exp.Paths.mainPath 'Study1 Results/']; % Location of results folder
    
elseif ispc % If using a PC
    
    exp.Paths.mainPath = 'XXXXX'; % Update this with the path to the folder of this script
    
    addpath(genpath(exp.Paths.mainPath)); % Location of task script

    exp.Paths.resdir = [exp.Paths.mainPath 'XXXXX Results\']; % Location of results folder
    
else Error('Not PC or Mac')
    
end

cd(exp.Paths.resdir); % change directory to the results directory

%% ************************************************************************
%************************* PRE EXPERIMENT PROMPT **************************
%**************************************************************************

%   Enter the participant ID
ParticipantDemo.ID = input('Participant ID (IDNN): ', 's'); 

%   Check input format 
while numel(ParticipantDemo.ID) ~= 4; % Input must be 4 characters long
    ParticipantDemo.ID = input('Please use IDNN format! Enter participant ID again: ', 's');
end 
if numel(ParticipantDemo.ID) == 4;
    while isempty(str2num(ParticipantDemo.ID(4))) == 1; % Fourth element must be numeric
        ParticipantDemo.ID = input('Please use pNN format! Enter participant ID again: ', 's');
    end
end

%   Enter the participant's age
ParticipantDemo.Age = input('Participant Age (xx): ', 's'); 

%   Enter the participant's gender
ParticipantDemo.Gender = input('Participant Gender (1=F, 2=M, 3=Other): ', 's'); 


%   Create file for writing data out
exp.outputname1 = [ParticipantDemo.ID '_Part1.xls'];

exp.outfile1 = fopen(exp.outputname1,'a+'); % Open a file for writing data out (a+ means if file already exists, add data to the end of it)
fprintf(exp.outfile1, 'ParticipantID\t Age\t Gender\t ImageID\t ImageTimeStamp\t TasteRating\t TasteRT\t HealthRating\t HealthRT\t \n');

% exp.outputname2 = [ParticipantDemo.ID '_Part2.xls'];

% exp.outfile2 = fopen(exp.outputname2,'a+'); % Open a file for writing data out (a+ means if file already exists, add data to the end of it)
% fprintf(exp.outfile2, 'ParticipantID\t Age\t Gender\t ImageID\t TrialNumber\t Strategy\t StrategyTrigger\t ImageID\t ImageTrigger\t WTCRating\t WTCRT\t \n');

%% ************************************************************************
%******************************* SETUP ************************************
%**************************************************************************

%   Setup keyboard buttons and colours 
KbName('UnifyKeyNames');
Key1=KbName('LeftArrow'); Key2=KbName('RightArrow'); Key3=KbName('1!'); Key4=KbName('2@'); Key5=KbName('3#'); Key6=KbName('4$'); Key7=KbName('5%');
spaceKey = KbName('Space'); escKey = KbName('ESCAPE');    
exp.grey = [211 211 211]; exp.white = [ 255 255 255]; exp.black = [ 0 0 0]; exp.darkgrey = [105 105 105];
params.bgcolour = exp.grey; params.textcolour = exp.black;  

%   IMAGE LIST 1 - Locate image folder
stim.foodImgFolder1 = [exp.Paths.mainPath 'FoodImages1'];
stim.foodImgList1 = dir(fullfile(stim.foodImgFolder1,'*.jpg'));
stim.foodImgList1 = {stim.foodImgList1(:).name};
I1 = stim.foodImgList1; % make list

I1 = I1.'; % switch rows and columns 

J1 = [368:541] % replace this with trigger numbers eventually
J1 = J1.'; % switch rows and columns 

stim.foodImgList1 = horzcat(I1, num2cell(J1));  % concatenate image and trigger index matrices

%   IMAGE LIST 2 - Locate image folder
stim.foodImgFolder2 = [exp.Paths.mainPath 'FoodImages2'];
stim.foodImgList2 = dir(fullfile(stim.foodImgFolder2,'*.jpg'));
stim.foodImgList2 = {stim.foodImgList2(:).name};
I2 = stim.foodImgList2; % make list

I2 = I2.'; % switch rows and columns 

J2 = [551:724] % replace this with trigger numbers eventually
J2 = J2.'; % switch rows and columns 

stim.foodImgList2 = horzcat(I1, num2cell(J1));  % concatenate image and trigger index matrices


% Total Number of Trials
params.nTrials = length(stim.foodImgList1) + length(stim.foodImgList2); % Number of trials will be based on the number of images in folder

%   Number of blocks
params.nBlocks = 12

%   Number of trials per block
params.nBlockTrials = params.nTrials/params.nBlocks

%   Randomise the trials (i.e. the image order)
stim.foodImgListRandomised1 = Shuffle(stim.foodImgList1,2); % shuffle rows in matrix before each trial
stim.foodImgListRandomised2 = Shuffle(stim.foodImgList2,2); % shuffle rows in matrix before each trial 

%   Screen Parameters
[exp.mainwin, exp.rect] = Screen(0, 'OpenWindow');
Screen('FillRect', exp.mainwin, params.bgcolour);
exp.center = [exp.rect(3)/2 exp.rect(4)/2]; 
exp.WCenter = exp.rect(3)/2;
exp.HCenter = exp.rect(4)/2;
Screen(exp.mainwin, 'Flip');

%   Endpoints for the sliding scales (regular and reversed)
stim.endPoints = {'Not at all', 'Very much'}; % Regular scale, question 2
stim.endPoints2 = {'Not at all', 'Very'}; % Regular scale, question 3
stim.endPoints3 = {'Never', 'Every Week'}; % Regular scale, question 1
stim.endPoints4 = {'Not at all', 'Definitely'}; % Regular scale, question 3

stim.REVendPoints = {'Very much', 'Not at all'}; % Reveresed scale, question 2
stim.REVendPoints2 = {'Very', 'Not at all'}; % Reversed scale, question 3
stim.REVendPoints3 = {'Every Week', 'Never'}; % Regular scale, question 1
stim.REVendPoints4 = {'Definitely', 'Not at all'}; % Regular scale, question 3


%   Intitialise trigger scripts
if EEGTask
    [triggerParams] = Study1_TriggerCode; 
end 

params.expStart = GetSecs;

%% RUN PART ONE

if EEGTask
    Study1_Part1(params, exp, stim, ParticipantDemo, triggerParams)
else 
    Study1_Part1(params, exp, stim, ParticipantDemo)
end 


%% 
ShowCursor;
Screen('CloseAll');
sca;