%%% GFNTools %%%
%%% (C) Daniel Sanchez Parcerisa 2023 %%%

%% Abrir todos los archivos
clear all; close all

%% Load images
load('loadedImgs_siHDR.mat')
load('dosesGy_FQS.mat')

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
errR = sqrt(std(allR)^2 + mean(stdR)^2 / 3); % 3 escaneos

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
clearvars allR stdR valR errR
clearvars allB stdB valB errB
clearvars allG stdG valG errG i

%% Estudiar SOLAMENTE uno de los tipos

R = meanRGBvalues(:,1);
G = meanRGBvalues(:,2);
B = meanRGBvalues(:,3);
dR = errRGBvalues(:,1);
dG = errRGBvalues(:,2);
dB = errRGBvalues(:,3);
dosePoints = 0:0.1:(round(max(dosesGy)));

%% Cargar coeficientes basicos
loadRCCoefs

%% Hacer la batería de pruebas

% FIT 1
CoefR1 =  RCCalCoefs(1,:,1);
CoefG1 =  RCCalCoefs(2,:,1);
CoefB1 =  RCCalCoefs(3,:,1);
dCoefR1 =  RCCalCoefs(1,:,2);
dCoefG1 =  RCCalCoefs(2,:,2);
dCoefB1 =  RCCalCoefs(3,:,2);

% En rojo
[D_1_R, dD_1_R] = getChannelDoseT1_wErrors(CoefR1, R, dCoefR1, dR)

% En verde
[D_1_G, dD_1_G] = getChannelDoseT1_wErrors(CoefG1, G, dCoefG1, dG)

% En azul
[D_1_B, dD_1_B] = getChannelDoseT1_wErrors(CoefB1, B, dCoefB1, dB)

errorbar(dosesGy,D_1_R,dD_1_R,'r.'); hold on
errorbar(dosesGy,D_1_G,dD_1_G,'g.');
errorbar(dosesGy,D_1_B,dD_1_B,'b.');

[D, dD] = getDoseT1(CoefR1, CoefG1, CoefB1, dCoefR1, dCoefB1, dCoefG1, R, G, B, dR, dG, dB)
[D2, dD2, varMat] = getDoseT1_Micke(CoefR1, CoefG1, CoefB1, dCoefR1, dCoefB1, dCoefG1, R, G, B, dR, dG, dB, -0.01:0.001:0.01)


errorbar(dosesGy,D,dD,'k.'); hold on
plot(dosePoints,dosePoints,'k:');
grid on
axis([0 round(max(dosesGy)) 0 round(max(dosesGy))]);
residue_1 = rssq(D-dosesGy)
xlabel('Actual dose [Gy]')
ylabel('Reported dose [Gy]');
legend('R','G','B','Weighted average','Location','SouthEast')

%% Prueba en una sola imagen
iDose = 5;
dGy = dosesGy(iDose);
I = allIMgs{iDose};

loadRCCoefs
[D_I, dD_I] = getDoseT1_I(I, maxBits);

subplot(1,3,1);
imshow(uint16(I))
title('Scanned RC');

subplot(1,3,2);
imagesc(D_I); caxis([dGy*0.95 dGy*1.05]); colorbar;
title('Dose [Gy]');
subplot(1,3,3);
imagesc(dD_I./D_I); caxis([0 0.1]); colorbar;
title('Relative error');

meanDose = mean2(D_I)
scanError = mean2(dD_I)
standardError = std2(D_I)
errDose = sqrt(scanError ^2 + standardError^2)