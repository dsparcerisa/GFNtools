%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

basePath = [fileparts(which('loadRCCoefs')) filesep 'calibrations'];
calFile = 'fitCoef_FQS_EBT3_rescan.mat';
fullCalFilePath = [basePath filesep calFile];
load(fullCalFilePath);
fprintf('Loaded calibration file (F1) at %s\n', fullCalFilePath);

calFile3 = 'fitCoef3_FQS_EBT3_rescan.mat';
fullCalFilePath3 = [basePath filesep calFile3];
load(fullCalFilePath3);
fprintf('Loaded calibration file (F3) at %s\n', fullCalFilePath3);

global RCCalCoefs
RCCalCoefs = zeros(3,3,2);
RCCalCoefs(1,:,1) = CoefR1_siHDR;
RCCalCoefs(2,:,1) = CoefG1_siHDR;
RCCalCoefs(3,:,1) = CoefB1_siHDR;
RCCalCoefs(1,:,2) = dCoefR1_siHDR;
RCCalCoefs(2,:,2) = dCoefG1_siHDR;
RCCalCoefs(3,:,2) = dCoefB1_siHDR;

global RCCalCoefs3
RCCalCoefs3 = zeros(3,3,2);
RCCalCoefs3(1,:,1) = CoefR3_siHDR;
RCCalCoefs3(2,:,1) = CoefG3_siHDR;
RCCalCoefs3(3,:,1) = CoefB3_siHDR;
RCCalCoefs3(1,:,2) = dCoefR3_siHDR;
RCCalCoefs3(2,:,2) = dCoefG3_siHDR;
RCCalCoefs3(3,:,2) = dCoefB3_siHDR;

% RCCalCoefs(1,:,1) = CoefR1;
% RCCalCoefs(2,:,1) = CoefG1;
% RCCalCoefs(3,:,1) = CoefB1;
% RCCalCoefs(1,:,2) = dCoefR1;
% RCCalCoefs(2,:,2) = dCoefG1;
% RCCalCoefs(3,:,2) = dCoefB1;

