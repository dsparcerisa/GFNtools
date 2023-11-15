function loadRCCalibration(calName)
    avCals = getAvailableRCCals;
    if ismember(avCals,calName) ~= 1
        disp('Available calibrations are:');
        showAvailableRCCals
        error('Could not find unique calibration with name \"%s\"', calName)
    end
    basePath = [fileparts(which('showAvailableRCCals')) filesep 'newCalibrations' filesep calName '.mat'];
    global RCCalibration
    load(basePath); close
    fprintf('Loaded calibration %s\n', calName)
end