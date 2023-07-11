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


%% NetOD
index0Gy = find(dosesGy==0);
NOD_R = log10(R_noHDR(index0Gy)./R_noHDR);
NOD_G = log10(G_noHDR(index0Gy)./G_noHDR);
NOD_B = log10(B_noHDR(index0Gy)./B_noHDR);
dNOD_R = (1/log(10)) * sqrt( (dR_noHDR./R_noHDR).^2 + (dR_noHDR(index0Gy)/R_noHDR(index0Gy))^2 );
dNOD_G = (1/log(10)) * sqrt( (dG_noHDR./G_noHDR).^2 + (dG_noHDR(index0Gy)/G_noHDR(index0Gy))^2 );
dNOD_B = (1/log(10)) * sqrt( (dB_noHDR./B_noHDR).^2 + (dB_noHDR(index0Gy)/B_noHDR(index0Gy))^2 );

%% Fit type III
[fR3_noHDR, gofR3] = fitTypeIII(dosesGy, NOD_R, dNOD_R);
[fG3_noHDR, gofG3] = fitTypeIII(dosesGy, NOD_G, dNOD_G);
[fB3_noHDR, gofB3] = fitTypeIII(dosesGy, max(0,NOD_B), dNOD_B);

CoefR3_noHDR = [fR3_noHDR.a fR3_noHDR.b fR3_noHDR.c fR3_noHDR.n];
CoefG3_noHDR = [fG3_noHDR.a fG3_noHDR.b fG3_noHDR.c fG3_noHDR.n];
CoefB3_noHDR = [fB3_noHDR.a fB3_noHDR.b fB3_noHDR.c fB3_noHDR.n];

DR3 = confint(fR3_noHDR,0.683);
dCoefR3_noHDR = 0.5*(DR3(2,:) - DR3(1,:));
dCoefR3_noHDR(4) = 0;
DG3 = confint(fG3_noHDR,0.683);
dCoefG3_noHDR = 0.5*(DG3(2,:) - DG3(1,:));
dCoefG3_noHDR(4) = 0;
DB3 = confint(fB3_noHDR,0.683);
dCoefB3_noHDR = 0.5*(DB3(2,:) - DB3(1,:));
dCoefB3_noHDR(4) = 0;

dosePoints = 0:0.1:(round(max(dosesGy)));

%% Make plots
subplot(1,2,1);

NODPoints = 0:0.01:1;
plot(NODPoints, fR3_noHDR(NODPoints), 'r-'); hold on
plot(NODPoints, fG3_noHDR(NODPoints), 'g-'); hold on
plot(NODPoints, fB3_noHDR(NODPoints), 'b-'); hold on
errorbar(NOD_R, dosesGy, dNOD_R, 'horizontal', 'r.'); 
errorbar(NOD_G, dosesGy, dNOD_G, 'horizontal', 'g.'); 
errorbar(NOD_B, dosesGy, dNOD_B, 'horizontal', 'b.'); 

grid on
ylabel('Doses [Gy]')
xlabel('netOD');
title('Scanning without HDR');
ylim([0 12]);
xlim([0 0.5]);

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

NOD_R_siHDR = log10(R_siHDR(index0Gy)./R_siHDR);
NOD_G_siHDR = log10(G_siHDR(index0Gy)./G_siHDR);
NOD_B_siHDR = log10(B_siHDR(index0Gy)./B_siHDR);
dNOD_R_siHDR = (1/log(10)) * sqrt( (dR_siHDR./R_siHDR).^2 + (dR_siHDR(index0Gy)/R_siHDR(index0Gy))^2 );
dNOD_G_siHDR = (1/log(10)) * sqrt( (dG_siHDR./G_siHDR).^2 + (dG_siHDR(index0Gy)/G_siHDR(index0Gy))^2 );
dNOD_B_siHDR = (1/log(10)) * sqrt( (dB_siHDR./B_siHDR).^2 + (dB_siHDR(index0Gy)/B_siHDR(index0Gy))^2 );

%% Fit type III
[fR3_siHDR, gofR3] = fitTypeIII(dosesGy, NOD_R_siHDR, dNOD_R_siHDR);
[fG3_siHDR, gofG3] = fitTypeIII(dosesGy, NOD_G_siHDR, dNOD_G_siHDR);
[fB3_siHDR, gofB3] = fitTypeIII(dosesGy, max(0,NOD_B_siHDR), dNOD_B_siHDR);

CoefR3_siHDR = [fR3_siHDR.a fR3_siHDR.b fR3_siHDR.c fR3_siHDR.n];
CoefG3_siHDR = [fG3_siHDR.a fG3_siHDR.b fG3_siHDR.c fG3_siHDR.n];
CoefB3_siHDR = [fB3_siHDR.a fB3_siHDR.b fB3_siHDR.c fB3_siHDR.n];

DR3 = confint(fR3_siHDR,0.683);
dCoefR3_siHDR = 0.5*(DR3(2,:) - DR3(1,:));
dCoefR3_siHDR(4) = 0;
DG3 = confint(fG3_siHDR,0.683);
dCoefG3_siHDR = 0.5*(DG3(2,:) - DG3(1,:));
dCoefG3_siHDR(4) = 0;
DB3 = confint(fB3_siHDR,0.683);
dCoefB3_siHDR = 0.5*(DB3(2,:) - DB3(1,:));
dCoefB3_siHDR(4) = 0;


%% Make plot
subplot(1,2,2);
plot(NODPoints, fR3_siHDR(NODPoints), 'r-'); hold on
plot(NODPoints, fG3_siHDR(NODPoints), 'g-'); hold on
plot(NODPoints, fB3_siHDR(NODPoints), 'b-'); hold on
errorbar(NOD_R_siHDR, dosesGy, dNOD_R_siHDR, 'horizontal', 'r.'); 
errorbar(NOD_G_siHDR, dosesGy, dNOD_G_siHDR, 'horizontal', 'g.'); 
errorbar(NOD_B_siHDR, dosesGy, dNOD_B_siHDR, 'horizontal', 'b.'); 

grid on
ylabel('Doses [Gy]')
xlabel('netOD');
title('Scanning with HDR');
ylim([0 12]);
xlim([0 1]);
%% Save
save('fitCoef3_FQS_EBT3_rescan.mat','CoefR3_siHDR','CoefG3_siHDR','CoefB3_siHDR', ...
    'dCoefR3_siHDR','dCoefG3_siHDR','dCoefB3_siHDR', ...
    'CoefR3_noHDR','CoefG3_noHDR','CoefB3_noHDR', ...
    'dCoefR3_noHDR','dCoefG3_noHDR', 'dCoefB3_noHDR');

%% Prueba autoconsistencia
% basePath = [fileparts(which('loadRCCoefs')) filesep 'calibrations'];
% calFile = 'fitCoef_FQS_EBT3.mat';
% fullCalFilePath = [basePath filesep calFile];
% load(fullCalFilePath);

% [D_siHDR_oldCal, dD_siHDR_oldCal] = getDoseT3(CoefR1, CoefG1, CoefB1, dCoefR1, ...
%     dCoefB1, dCoefG1, R_siHDR, G_siHDR, B_siHDR, dR_siHDR, dG_siHDR, dB_siHDR);
[D_siHDR, dD_siHDR] = getDoseT3(CoefR3_siHDR, CoefG3_siHDR, CoefB3_siHDR, dCoefR3_siHDR, ...
    dCoefB3_siHDR, dCoefG3_siHDR, NOD_R_siHDR, NOD_G_siHDR, NOD_B_siHDR, dNOD_R_siHDR, dNOD_G_siHDR, dNOD_B_siHDR)
[D_noHDR, dD_noHDR] = getDoseT3(CoefR3_noHDR, CoefG3_noHDR, CoefB3_noHDR, dCoefR3_noHDR, ...
    dCoefB3_noHDR, dCoefG3_noHDR, NOD_R, NOD_G, NOD_B, dNOD_R, dNOD_G, dNOD_B)
figure(2);
errorbar(dosesGy,D_siHDR,dD_siHDR', 'b-');
hold on
errorbar(dosesGy,D_noHDR,dD_noHDR', 'r-');
% errorbar(dosesGy,D_siHDR_oldCal,dD_siHDR_oldCal', 'k-');
grid on
legend('With HDR','Without HDR') %,'With HDR old calibration');
xlabel('Actual doses [Gy]')
ylabel('Reported doses [Gy]')
title('Self consistency study');