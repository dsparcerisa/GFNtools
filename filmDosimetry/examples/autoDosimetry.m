%% Clear variables and define data structures

addpath /Users/dani/GFNtools/filmDosimetry
clear all
allnames = {};
allIMgs = {};
allstdIMgs = {};


%% Load file and add to cell array
numScansPerFile = 3;

close all
[RCfile, RCpath] = uigetfile('todas.tif');
[pixCM, maxBits] = getImgMetaInfo(fullfile(RCpath,RCfile));

disp('Crop ZERO image')
[zeroName,zeroIMgs,zerostdIMgs] = loadRCset(fullfile(RCpath,RCfile),numScansPerFile,1);
close

disp('Crop ROIs')
[names,IMgs,stdIMgs] = loadRCset(fullfile(RCpath,RCfile),numScansPerFile);
allnames = {allnames{:}, names{:}};
allIMgs = {allIMgs{:}, IMgs{:}};
allstdIMgs = {allstdIMgs{:}, stdIMgs{:}};

close all

%% Calibration

[pixCM, maxBits] = getImgMetaInfo('todas.tif');

calName_netOD = 'EBT3_octubre2023_GM-netOD';
loadRCCalibration(calName_netOD)

numImages = numel(allnames);
D_I = nan(numImages,1);
dD_I = nan(numImages,1);
I0 = allIMgs{1};
for i=1:numImages
    I = allIMgs{i};
    [thisD_I, thisdD_I] = getDoseT3_I(I, I0, maxBits);
    D_I(i) = mean(thisD_I(:));
    dD_I(i) = sqrt(std(thisD_I(:)).^2 + mean(thisdD_I(:)).^2);
end

%% Export
T = table(allnames',D_I,dD_I,'VariableNames',{'name','D (Gy)','error D (Gy)'});
xlsFilePath = 'allImages.xls';
writetable(T,xlsFilePath)
