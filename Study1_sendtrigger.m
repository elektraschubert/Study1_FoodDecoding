function time = Study1_sendTrigger(triggerParams, trigger)
 
io64(triggerParams.ioObj,triggerParams.address,trigger);
time = GetSecs;
WaitSecs(0.02);
io64(triggerParams.ioObj,triggerParams.address,0);
 
end

%% LIST OF TRIGGER CODES

%******** Instructions ********
% 349 = Welcome Screen 
% 350 = Thank you screen
% 351 = Final Exit Screen 

%******** Task Structure ********
% 1-348 = Trial Numbers
% 352 = Trial Start
% 353 = Block Start
% 354-365 = Block Numbers
% 366 = Taste Block
% 367 = Health Block

%******** Stimuli ********
% 368-541 = Food Images (Taste)
% 551-724 = Food Images (Health)
% 542 = Image Presentation

%******** Responses ********
% 543 = Below 50 answer
% 544 = Above 50 answer
% 545 = Spacebar press
% 546 = Sliding Scale response
% 547 = Mouseclick 

%******** Non Image Display ********
% 548 = Fixation Cross
% 549 = Q1
% 550 = Q2