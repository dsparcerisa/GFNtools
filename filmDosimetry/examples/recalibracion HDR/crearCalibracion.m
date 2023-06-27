%%% GFNTools %%%
%%% (C) Daniel Sanchez Parcerisa 2023 %%%

clear all; close all;

%% Load files
dosesFile = 'dosesGy_FQS.mat';
load(dosesFile);
imagesFile = 'loadedImgs_noHDR.mat';
load(imagesFile);

%% Calculate averages
N = numel(dosesGy);
meanRGBvalues = zeros(N,3);
errRGBvalues = zeros(N,3);

%% Create mean values
for i=1:N
allR = allIMgs{i}(:,:,1);
allR = allR(:);
stdR = allstdIMgs{i}(:,:,1);
stdR = stdR(:);
valR = mean(allR);
errR = sqrt(std(allR)^2 + mean(stdR)^2 / 3);

allG = allIMgs{i}(:,:,2);
allG = allG(:);
stdG = allstdIMgs{i}(:,:,2);
stdG = stdG(:);
valG = mean(allG);
errG = sqrt(std(allG)^2 + mean(stdG)^2 / 3);

allB = allIMgs{i}(:,:,3);
allB = allB(:);
stdB = allstdIMgs{i}(:,:,3);
stdB = stdB(:);
valB = mean(allB);
errB = sqrt(std(allB)^2 + mean(stdB)^2 / 3);

meanRGBvalues(i,:) = (1/maxBits) * [valR valG valB];
errRGBvalues(i,:) = (1/maxBits) * [errR errG errB];
end

R_noHDR = meanRGBvalues(:,1);
dR_noHDR = errRGBvalues(:,1);
G_noHDR = meanRGBvalues(:,2);
dG_noHDR = errRGBvalues(:,2);
B_noHDR = meanRGBvalues(:,3);
dB_noHDR = errRGBvalues(:,3);

%% Fit type I
[fR1_noHDR, gofR1] = fitTypeI(dosesGy, R_noHDR, dR_noHDR);
[fG1_noHDR, gofG1] = fitTypeI(dosesGy, G_noHDR, dG_noHDR);
[fB1_noHDR, gofB1] = fitTypeI(dosesGy, B_noHDR, dB_noHDR);

CoefR1_noHDR = [fR1_noHDR.alpha fR1_noHDR.beta fR1_noHDR.gamma];
CoefG1_noHDR = [fG1_noHDR.alpha fG1_noHDR.beta fG1_noHDR.gamma];
CoefB1_noHDR = [fB1_noHDR.alpha fB1_noHDR.beta fB1_noHDR.gamma];

DR1 = confint(fR1_noHDR,0.683);
dCoefR1_noHDR = 0.5*(DR1(2,:) - DR1(1,:));
DG1 = confint(fG1_noHDR,0.683);
dCoefG1_noHDR = 0.5*(DG1(2,:) - DG1(1,:));
DB1 = confint(fB1_noHDR,0.683);
dCoefB1_noHDR = 0.5*(DB1(2,:) - DB1(1,:));
dosePoints = 0:0.1:(round(max(dosesGy)));


%% Make plots
subplot(1,2,1);

plot(dosePoints, fR1_noHDR(dosePoints), 'r-'); hold on
plot(dosePoints, fG1_noHDR(dosePoints), 'g-');
plot(dosePoints, fB1_noHDR(dosePoints), 'b-');
errorbar(dosesGy,meanRGBvalues(:,1),errRGBvalues(:,1),'r.');
errorbar(dosesGy,meanRGBvalues(:,2),errRGBvalues(:,2),'g.');
errorbar(dosesGy,meanRGBvalues(:,3),errRGBvalues(:,3),'b.');

grid on
xlabel('Doses [Gy]')
ylabel('Relative pixel value');
title('Scanning without HDR');
ylim([0 0.7]);
xlim([0 12]);

%% Load files
imagesFile = 'loadedImgs_siHDR.mat';
load(imagesFile);

%% Calculate averages
N = numel(dosesGy);
meanRGBvalues = zeros(N,3);
errRGBvalues = zeros(N,3);

%% Create mean values
for i=1:N
allR = allIMgs{i}(:,:,1);
allR = allR(:);
stdR = allstdIMgs{i}(:,:,1);
stdR = stdR(:);
valR = mean(allR);
errR = sqrt(std(allR)^2 + mean(stdR)^2 / 3);

allG = allIMgs{i}(:,:,2);
allG = allG(:);
stdG = allstdIMgs{i}(:,:,2);
stdG = stdG(:);
valG = mean(allG);
errG = sqrt(std(allG)^2 + mean(stdG)^2 / 3);

allB = allIMgs{i}(:,:,3);
allB = allB(:);
stdB = allstdIMgs{i}(:,:,3);
stdB = stdB(:);
valB = mean(allB);
errB = sqrt(std(allB)^2 + mean(stdB)^2 / 3);

meanRGBvalues(i,:) = (1/maxBits) * [valR valG valB];
errRGBvalues(i,:) = (1/maxBits) * [errR errG errB];
end

R_siHDR = meanRGBvalues(:,1);
dR_siHDR = errRGBvalues(:,1);
G_siHDR = meanRGBvalues(:,2);
dG_siHDR = errRGBvalues(:,2);
B_siHDR = meanRGBvalues(:,3);
dB_siHDR = errRGBvalues(:,3);

%% Fit type I
[fR1_siHDR, gofR1] = fitTypeI(dosesGy, R_siHDR, dR_siHDR);
[fG1_siHDR, gofG1] = fitTypeI(dosesGy, G_siHDR, dG_siHDR);
[fB1_siHDR, gofB1] = fitTypeI(dosesGy, B_siHDR, dB_siHDR);

CoefR1_siHDR = [fR1_siHDR.alpha fR1_siHDR.beta fR1_siHDR.gamma];
CoefG1_siHDR = [fG1_siHDR.alpha fG1_siHDR.beta fG1_siHDR.gamma];
CoefB1_siHDR = [fB1_siHDR.alpha fB1_siHDR.beta fB1_siHDR.gamma];

DR1 = confint(fR1_siHDR,0.683);
dCoefR1_siHDR = 0.5*(DR1(2,:) - DR1(1,:));
DG1 = confint(fG1_siHDR,0.683);
dCoefG1_siHDR = 0.5*(DG1(2,:) - DG1(1,:));
DB1 = confint(fB1_siHDR,0.683);
dCoefB1_siHDR = 0.5*(DB1(2,:) - DB1(1,:));



%% Make plot
subplot(1,2,2);
plot(dosePoints, fR1_siHDR(dosePoints), 'r-'); hold on
plot(dosePoints, fG1_siHDR(dosePoints), 'g-');
plot(dosePoints, fB1_siHDR(dosePoints), 'b-');
errorbar(dosesGy,meanRGBvalues(:,1),errRGBvalues(:,1),'r.');
errorbar(dosesGy,meanRGBvalues(:,2),errRGBvalues(:,2),'g.');
errorbar(dosesGy,meanRGBvalues(:,3),errRGBvalues(:,3),'b.');
grid on
xlabel('Doses [Gy]')
ylabel('Relative pixel value');
title('Scanning with HDR');
ylim([0 0.7]);
xlim([0 12]);

%% Save
save('fitCoef_FQS_EBT3_rescan.mat','CoefR1_siHDR','CoefG1_siHDR','CoefB1_siHDR', ...
    'dCoefR1_siHDR','dCoefG1_siHDR','dCoefB1_siHDR', ...
    'CoefR1_noHDR','CoefG1_noHDR','CoefB1_noHDR', ...
    'dCoefR1_noHDR','dCoefG1_noHDR', 'dCoefB1_noHDR');

%% Prueba autoconsistencia
basePath = [fileparts(which('loadRCCoefs')) filesep 'calibrations'];
calFile = 'fitCoef_FQS_EBT3.mat';
fullCalFilePath = [basePath filesep calFile];
load(fullCalFilePath);

[D_siHDR_oldCal, dD_siHDR_oldCal] = getDoseT1(CoefR1, CoefG1, CoefB1, dCoefR1, ...
    dCoefB1, dCoefG1, R_siHDR, G_siHDR, B_siHDR, dR_siHDR, dG_siHDR, dB_siHDR);
[D_siHDR, dD_siHDR] = getDoseT1(CoefR1_siHDR, CoefG1_siHDR, CoefB1_siHDR, dCoefR1_siHDR, ...
    dCoefB1_siHDR, dCoefG1_siHDR, R_siHDR, G_siHDR, B_siHDR, dR_siHDR, dG_siHDR, dB_siHDR);
[D_noHDR, dD_noHDR] = getDoseT1(CoefR1_noHDR, CoefG1_noHDR, CoefB1_noHDR, dCoefR1_noHDR, ...
    dCoefB1_noHDR, dCoefG1_noHDR, R_noHDR, G_noHDR, B_noHDR, dR_noHDR, dG_noHDR, dB_noHDR)
figure(2);
errorbar(dosesGy,D_siHDR,dD_siHDR', 'b-');
hold on
errorbar(dosesGy,D_noHDR,dD_noHDR', 'r-');
errorbar(dosesGy,D_siHDR_oldCal,dD_siHDR_oldCal', 'k-');
grid on
legend('With HDR','Without HDR','With HDR old calibration');
xlabel('Actual doses [Gy]')
ylabel('Reported doses [Gy]')
title('Self consistency study');