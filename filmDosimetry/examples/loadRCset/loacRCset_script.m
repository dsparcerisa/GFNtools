%% Clear variables and define data structures
clear all
allnames = {};
allIMgs = {};
allstdIMgs = {};

%% Load file and add to cell array
close all
[RCfile, RCpath] = uigetfile('*.tif');
[names,IMgs,stdIMgs] = loadRCset(fullfile(RCpath,RCfile));
allnames = {allnames{:}, names{:}};
allIMgs = {allIMgs{:}, IMgs{:}};
allstdIMgs = {allstdIMgs{:}, stdIMgs{:}};
clearvars IMgs names RCfile RCpath stdIMgs

%% Save all
% numScans = [4
% 12
% 16
% 21
% 25
% 29
% 36
% 43
% 50
% 57
% 64
% 71
% 81
% 85
% 92
% 99];
times_min = [2
12
22
52
70
98
120
182
241
298
357
450
585
734
1446
2825];
numScans = 2*ones(size(times_min));
saveName = 'Call.mat';
save(saveName);