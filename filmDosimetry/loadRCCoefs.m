%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

basePath = [fileparts(which('loadRCCoefs')) filesep 'calibrations'];
calFile = 'fitCoef_FQS_EBT3.mat';
fullCalFilePath = [basePath filesep calFile];
load(fullCalFilePath);
fprintf('Loaded calibration file at %s\n', fullCalFilePath);

global RCCalCoefs
RCCalCoefs = zeros(3,3,2);
RCCalCoefs(1,:,1) = CoefR1;
RCCalCoefs(2,:,1) = CoefG1;
RCCalCoefs(3,:,1) = CoefB1;
RCCalCoefs(1,:,2) = dCoefR1;
RCCalCoefs(2,:,2) = dCoefG1;
RCCalCoefs(3,:,2) = dCoefB1;
