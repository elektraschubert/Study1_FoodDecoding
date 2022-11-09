% EEG Preprocessing Stage 4 Script
%
% This script creates data files in the correct format for performing MVPA
% with DDTBOX. 
%
% Written by Daniel F, 7/18
%
% NOTE: Make sure that the current MATLAB directory is that which contains
% this script! Some code has been included to do this automatically on the
% Supernova computer


%% Housekeeping
clear all;
close all;

% Set current directory to EmoReg project folder on Supernova computer
cd('/Users/elektraschubert/Documents/PhD/Study 1/MVPA Analyses');

%% Define variables

% IDs to analyse
subjectsToAnalyse = [2:40]; % Enter the ID numbers you want to analyse. Wither as [1, 2, 3 etc] or [1:40]
% Total set [1:9, 13, 17:24, 26:44];

% Include EEG data folder/directory (if in a subfolder)
EEG_dataFolderName = '/Users/elektraschubert/Documents/PhD/Study 1/MVPA Analyses/EEG Data/'; 

% Events of interest in the dataset
eventsOfInterest = {'HealthImage'}; % Implementation Stage: {'ImagePresentation'}, Anticipation Stage: {'DistractSymbol'} or {'ReappraiseSymbol'}

% Channels for EEG data used in MVPA
channels_eeg = 1:64; 

% Start and end of epochs (relative to events of interest)
% Time unit is seconds
epochStartEnd = [-0.09495, 1.194];

% % Baseline period for baseline-correction (in ms from event onset)
% baselineStartEnd = [-100, 0];

% % Channels to include in artefact rejection routine
% channelsForAR = 1:64;
% 
% % Potential amplitude threshold for artefact rejection
% ARThreshold = [-150, 150]; % 100 Microvolts



%% Loop through and preprocess data

for subject = 1:length(subjectsToAnalyse)
    
    % Load the dataset that was prepared in Script 1
    EEG = pop_loadset('filename', [EEG_dataFolderName, 'ID', int2str(subjectsToAnalyse(subject)), '_CSD.set']);


    
   
    
    
%     % Artefact rejection (absolute amplitude threshold)
%     EEG = pop_eegthresh(EEG, 1, channelsForAR, ARThreshold(1), ARThreshold(2), epochStartEnd(1), epochStartEnd(2) , 0, 1);
%     
    
    % Epoch the data (specific to events of interest in the specified analysis)
    EEG = pop_epoch( EEG, eventsOfInterest, epochStartEnd, 'newname', 'BDF file epochs', 'epochinfo', 'yes');
    
    % Extract only specified trials (Health trials)
    clear health_trial;
    clear health_trial_epoched_data;
    
    for eventNo = 1:numel(EEG.event)
        
        if strcmp(EEG.event(eventNo).type, 'HealthImage')
            
            health_trial(EEG.event(eventNo).epoch) = 1;
            
        end % of if strcmp
    end % of for eventNo
    
    % Extract only the specified EEG data epochs into a matrix
    health_trial_epoched_data = EEG.data(:,:, health_trial == 1);
   
    
    clear trial_numbers_by_epoch_temp;
    clear trial_numbers_by_epoch;
    
    for eventNo = 1:numel(EEG.event)
        
        trial_numbers_by_epoch_temp(EEG.event(eventNo).epoch) = str2num(EEG.event(eventNo).trial);

    end % eventNo

    trial_numbers_by_epoch = trial_numbers_by_epoch_temp(health_trial == 1);
             
    
    % Save data in eeg_sorted_cond cell arrays
     eeg_sorted_cond{1,1} = permute(health_trial_epoched_data, [2, 1, 3]); 

    
    % Save the EEG data and SVR Labels
    save(['DDTBOX Data/Health/ID', int2str(subjectsToAnalyse(subject)), '_CSD_Health'], 'eeg_sorted_cond'); 

    % Generate SVR labels
    healthRatings = ({EEG.event(:).healthRating}).';
    SVR_labels = cell2mat(healthRatings);
    save(['DDTBOX Data/Health/ID', int2str(subjectsToAnalyse(subject)), '_CSD_Health_regress_sorted_data'], 'SVR_labels'); 
    clear SVR_labels
    

end % of for subject