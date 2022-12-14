% EXAMPLE_run_decoding_analyses.m
%
% This script is used for configuring and running decoding analyses in DDTBOX.  
% A brief explanation of each configurable setting is described below.
% More information on the analysis options in this script, as well as 
% a tutorial on how to run MVPA in DDTBOX, can be found in the DDTBOX wiki, 
% available at: https://github.com/DDTBOX/DDTBOX/wiki
%
% Please make copies of this script for your own projects.
% 
% This script calls decoding_erp.m
%
%
% Copyright (c) 2013-2017, Daniel Feuerriegel and contributors 
% 
% This file is part of DDTBOX.
%
% DDTBOX is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.



%% Housekeeping

% Clears the workspace and closes all figure windows
clear variables;
close all;




%% Select Subject Datasets and Discrimination Groups (dcgs)

% Set the subject datasets on which to perform MVPA
sbj_todo = [3]; 
% Total set [2:40]

% Enter the discrimination groups (dcgs) for decoding analyses. 
% Each discrimination group should be in a separate cell entry.
% Decoding analyses will be run for all dcgs listed here.
% e.g. dcgs_for_analyses{1} = [1];
% e.g. dcgs_for_analyses{2} = [3];
% Two discrimination groups can be entered when performing cross-condition decoding.
% (SVM trained using the first entry/dcg, tested on the second entry/dcg)
% e.g. dcgs_for_analyses{1} = [1, 2];

dcgs_for_analyses{1} = [1];

% Perform cross-condition decoding? 
% 0 = No / 1 = Yes

cross = 0;




%% Filepaths and Locations of Subject Datasets

% Enter the name of the study (for labeling saved decoding results files)
study_name = 'HealthDecoding';

% Base directory path (where single subject EEG datasets and channel locations files are stored)
bdir = '/Users/elektraschubert/Documents/PhD/Study 1/MVPA Analyses/DDTBOX Data/Health/';

% Output directory (where decoding results will be saved)
output_dir = '/Users/elektraschubert/Documents/PhD/Study 1/MVPA Analyses/Decoding Results/Health/';
    
% Filepaths of single subject datasets (relative to the base directory)
sbj_code = {...

    ['ID2_Health'];... % 
    ['ID3_Health'];... % 
    ['ID4_Health'];... % 
    ['ID5_Health'];... % 
    ['ID6_Health'];... % 
    ['ID7_Health'];... % 
    ['ID8_Health'];... % 
    ['ID9_Health'];... % 
    ['ID10_Health'];... % 
    ['ID11_Health'];... % 
    ['ID12_Health'];... % 
    ['ID13_Health'];... % 
    ['ID14_Health'];... % 
    ['ID15_Health'];... % 
    ['ID16_Health'];... % 
    ['ID17_Health'];... % 
    ['ID18_Health'];... % 
    ['ID19_Health'];... % 
    ['ID20_Health'];... % 
    ['ID21_Health'];... % 
    ['ID22_Health'];... % 
    ['ID23_Health'];... % 
    ['ID24_Health'];... % 
    ['ID25_Health'];... % 
    ['ID26_Health'];... % 
    ['ID27_Health'];... % 
    ['ID28_Health'];... % 
    ['ID29_Health'];... % 
    ['ID30_Health'];... % 
    ['ID31_Health'];... % 
    ['ID32_Health'];... % 
    ['ID33_Health'];... % 
    ['ID34_Health'];... % 
    ['ID35_Health'];... % 
    ['ID36_Health'];... % 
    ['ID37_Health'];... % 
    ['ID38_Health'];... % 
    ['ID39_Health'];... % 
    ['ID40_Health'];... % 
    
    };
    

% Automatically calculates number of subjects from the number of data files
nsbj = size(sbj_code, 1);

% MATLAB workspace name for single subject data arrays and structures
data_struct_name = 'eeg_sorted_cond'; % Data arrays for use with DDTBOX must use this name as their MATLAB workspace variable name
  



%% EEG Dataset Information

nchannels = 64; % Number of channels
sampling_rate = 512; % Data sampling rate in Hz
pointzero = 100; % Corresponds to the time of the event of interest (e.g. stimulus presentation) relative to the start of the epoch (in ms)

% For plotting single subject temporal decoding results 
% (not required if performing spatial or spatiotemporal decoding)
channel_names_file = 'channelinfo.mat'; % Name of the .mat file containing channel labels and channel locations
channellocs = [bdir, 'Channel Locations/']; % Path of the directory containing channel information file




%% Condition and Discrimination Group (dcg) Information

% Label each condition / category
% Usage: cond_labels{condition number} = 'Name of condition';
% Example: cond_labels{1} = 'Correct Responses';
% Example: cond_labels{2} = 'Error Responses';
% Condition label {X} corresponds to data in column X of the single subject
% data arrays.

cond_labels{1} = 'Image Presentation (Health)';

        
% Discrimination groups
% Enter the condition numbers of the conditions used in classification analyses.
% Usage: dcg{discrimination group number} = [condition 1, condition 2];
% Example: dcg{1} = [1, 2]; to use conditions 1 and 2 for dcg 1

% If performing support vector regression, only one condition number is
% needed per dcg.
% SVR example: dcg{1} = [1]; to perform SVR on data from condition 1

dcg{1} = [1];

% Support Vector Regression (SVR) condition labels
% Enter the array entry containing condition labels for each discrimination
% group number. The SVR_labels array contains multiple cells, each
% containing a list of SVR condition labels.
% Usage: svr_cond_labels{dcg} = [cell number in SVR_labels];
% Example: svr_cond_labels{1} = [2]; to use SVR labels in cell 2 for dcg 1

svr_cond_labels{1} = [1];
              
% Label each discrimination group
% Usage: dcg_labels{Discrimination group number} = 'Name of discrimination group'
% Example: dcg_labels{1} = 'Correct vs. Error Responses';

dcg_labels{1} = 'Health Ratings';

% This section automaticallly fills in various parameters related to dcgs and conditions 
ndcg = size(dcg, 2);
nclasses = size(dcg{1}, 2);      
ncond = size(cond_labels, 2);




%% Multivariate Classification/Regression Parameters

analysis_mode = 3; % ANALYSIS mode (1 = SVM classification with LIBSVM / 2 = SVM classification with LIBLINEAR / 3 = SVR with LIBSVM)
stmode = 3; % SPACETIME mode (1 = spatial / 2 = temporal / 3 = spatio-temporal)
avmode = 1; % AVERAGE mode (1 = no averaging; use single-trial data / 2 = use run-averaged data). Note: Single trials needed for SVR
window_width_ms = 20; % Width of sliding analysis window in ms
step_width_ms = 10; % Step size with which sliding analysis window is moved through the trial
zscore_convert = 0; % Convert data into z-scores before decoding? 0 = no / 1 = yes
cross_val_steps = 5; % How many cross-validation steps (if no runs available)?
n_rep_cross_val = 10; % How many repetitions of full cross-validation with re-ordered data?
perm_test = 1; % Run decoding using permuted condition labels? 0 = no / 1 = yes
permut_rep = 10; % How many repetitions of full cross-validation for permuted labels analysis?

% Feature weights extraction
feat_weights_mode = 0; % Extract feature weights? 0 = no / 1 = yes

% Single subject decoding results plotting
display_on = 1; % Display single subject decoding performance results? 0 = no / 1 = yes
perm_disp = 1; % Display the permuted labels decoding results in figure? 0 = no / 1 = yes




%% Copy All Settings Into the cfg Structure
% No user input required in this section

cfg.bdir = bdir;
cfg.output_dir = output_dir;
cfg.sbj_code = sbj_code;
cfg.nsbj = nsbj;
cfg.data_struct_name = data_struct_name;
cfg.nchannels = nchannels;
cfg.channel_names_file = channel_names_file;
cfg.channellocs = channellocs;
cfg.sampling_rate = sampling_rate;
cfg.pointzero = pointzero;
cfg.cond_labels = cond_labels;
cfg.dcg = dcg;
cfg.dcg_labels = dcg_labels;
cfg.svr_cond_labels = svr_cond_labels;
cfg.ndcg = ndcg;
cfg.nclasses = nclasses;
cfg.ncond = ncond;
cfg.study_name = study_name;
cfg.cross = cross;
cfg.analysis_mode = analysis_mode;
cfg.stmode = stmode;
cfg.avmode = avmode;
cfg.window_width_ms = window_width_ms;
cfg.step_width_ms = step_width_ms;
cfg.zscore_convert = zscore_convert;
cfg.perm_test = perm_test;
cfg.cross_val_steps = cross_val_steps;
cfg.n_rep_cross_val = n_rep_cross_val;
cfg.permut_rep = permut_rep;
cfg.feat_weights_mode = feat_weights_mode;
cfg.display_on = display_on;
cfg.perm_disp = perm_disp;



%% Run the Decoding Analyses For Specified Subjects and dcgs

for dcg_set = 1:length(dcgs_for_analyses)
    
    clear dcg_todo;
    dcg_todo = dcgs_for_analyses{dcg_set};
        
    for sbj = sbj_todo

        % Save subject and dcg numbers into the configuration settings
        % structure
        cfg.sbj = sbj;
        cfg.dcg_todo = dcg_todo;
        
        % Set subject-specific filepaths for opening and saving files
        cfg.data_open_name = [bdir, (sbj_code{sbj}), '.mat'];
        cfg.data_save_name = [bdir, (sbj_code{sbj}), '_data.mat'];
        cfg.regress_label_name = [bdir, sbj_code{sbj}, '_regress_sorted_data.mat']; % Filepath for regression labels file

        % Run the decoding analyses
        decoding_erp(cfg);

    end % of for sbj
    
end % of for dcg_set