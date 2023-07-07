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
numScans = 3;
saveName = 'imageSet.mat';
save(saveName);