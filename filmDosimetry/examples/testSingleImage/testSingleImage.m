%%% GFNTools %%%
%%% (C) Daniel Sanchez Parcerisa 2023 %%%

%% Abrir todos los archivos
clear all; close all

%% Load image
%imPath = 'GFNlogo.tif';
imPath = 'ejemplo.tif';
figure(99);
I_orig = imread(imPath);
I = imcrop(I_orig);
close(99);
figure(98);
I0 = imcrop(I_orig);
close(98);

%%
[pixCM, maxBits] = getImgMetaInfo(imPath);

loadRCCoefs
[D_I, dD_I] = getDoseT1_I(I, maxBits);
[D_I3, dD_I3] = getDoseT3_I(I, I0, maxBits);

%% Combined plot
subplot(2,2,1);
imagesc(D_I); caxis([0 20]); colorbar;
title('Dose T1 [Gy]');

subplot(2,2,2);
imagesc(dD_I); caxis([0 1]); colorbar;
title('Error');

subplot(2,2,3);
imagesc(D_I3); caxis([0 20]); colorbar;
title('Dose T3 [Gy]');

subplot(2,2,4);
imagesc(dD_I3); caxis([0 1]); colorbar;
title('Error');

meanDose = mean(D_I(:),'omitnan')
scanError = mean(dD_I(:),'omitnan')
standardError = std(D_I(:),'omitnan')
errDose = sqrt(scanError ^2 + standardError^2)

meanDose3 = mean(D_I3(:),'omitnan')
scanError3 = mean(dD_I3(:),'omitnan')
standardError3 = std(D_I3(:),'omitnan')
errDose3 = sqrt(scanError3^2 + standardError3^2)

%% Histograms
histogram(D_I(:)); hold on
histogram(D_I3(:)); hold on
