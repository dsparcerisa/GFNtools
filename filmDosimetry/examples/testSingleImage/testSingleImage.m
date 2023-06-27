%%% GFNTools %%%
%%% (C) Daniel Sanchez Parcerisa 2023 %%%

%% Abrir todos los archivos
clear all; close all

%% Load image
imPath = 'GFNlogo.tif';
I = imread(imPath);
I = imcrop(I);

[pixCM, maxBits] = getImgMetaInfo(imPath);

loadRCCoefs
[D_I, dD_I] = getDoseT1_I(I, maxBits);

subplot(1,3,1);
imshow(uint16(I))
title('Scanned RC');

meanDose = mean2(D_I)
scanError = mean2(dD_I)
standardError = std2(D_I)
errDose = sqrt(scanError ^2 + standardError^2)

subplot(1,3,2);
imagesc(D_I); caxis([0 20]); colorbar;
title('Dose [Gy]');
subplot(1,3,3);
imagesc(dD_I./D_I); caxis([0 0.1]); colorbar;
title('Relative error');

meanDose = mean2(D_I)
scanError = mean2(dD_I)
standardError = std2(D_I)
errDose = sqrt(scanError ^2 + standardError^2)