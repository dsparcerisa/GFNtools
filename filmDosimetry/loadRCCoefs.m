%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

basePath = [fileparts(which('loadRCCoefs')) filesep 'calibrations'];
calFile = 'fitCoef_FQS_EBT3.mat';
fullCalFilePath = [basePath filesep calFile];
load(fullCalFilePath);
fprintf('Loaded calibration file at %s\n', fullCalFilePath);