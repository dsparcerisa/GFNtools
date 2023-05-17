%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

basePath = [fileparts(which('loadRCCoefs')) filesep 'calibrations'];
calFile = 'fitCoef_FQS_EBT3_rescan.mat';
fullCalFilePath = [basePath filesep calFile];
load(fullCalFilePath);
fprintf('Loaded calibration file at %s\n', fullCalFilePath);

global RCCalCoefs
RCCalCoefs = zeros(3,3,2);
RCCalCoefs(1,:,1) = CoefR1_siHDR;
RCCalCoefs(2,:,1) = CoefG1_siHDR;
RCCalCoefs(3,:,1) = CoefB1_siHDR;
RCCalCoefs(1,:,2) = dCoefR1_siHDR;
RCCalCoefs(2,:,2) = dCoefG1_siHDR;
RCCalCoefs(3,:,2) = dCoefB1_siHDR;

% RCCalCoefs(1,:,1) = CoefR1;
% RCCalCoefs(2,:,1) = CoefG1;
% RCCalCoefs(3,:,1) = CoefB1;
% RCCalCoefs(1,:,2) = dCoefR1;
% RCCalCoefs(2,:,2) = dCoefG1;
% RCCalCoefs(3,:,2) = dCoefB1;

