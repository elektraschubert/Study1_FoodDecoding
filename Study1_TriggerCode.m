function [triggerParams] = Study1_TriggerCode
 
%%% open parallel port (ioport)
fprintf('Opening parallel port...\n')
% create an instance of the io64 object
triggerParams.ioObj = io64;
% initialize the hwinterface.sys kernel-level I/O driver
status = io64(triggerParams.ioObj);
if status
    error('Cannot initialise io64.\n');
end
%if status = 0, you are now ready to write and read to a hardware port
% set parallel port address (should be d010 on LPT3)
triggerParams.address = hex2dec('378'); % e010 is standard LPT1 output port address (0x378)
% write value 0 to part to reset
data_out=0;                                 %sample data value
io64(triggerParams.ioObj,triggerParams.address,data_out);   %output command
 
fprintf('Done.\n')
 
end