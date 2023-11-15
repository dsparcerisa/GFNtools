clear all; close all
calFolder = 'EBT4_octubre2023_GM';

%% Read calibration doses
%xlsFilePath = ['.' filesep calFolder filesep 'datosCalibracion.xlsx'];
xlsFilePath = 'datosCalibracion_EBT4.xlsx';
calFile = readtable(xlsFilePath,Range="I2:I13",ReadVariableNames=false);
dosesGy = calFile.Var1;

%% Read images file
%imagesFilePath = ['.' filesep calFolder filesep 'calImages.mat'];
imagesFilePath = 'calImages_siHDR.mat';
load(imagesFilePath);

%% Calculate averages
N = numel(dosesGy);
meanRGBvalues = zeros(N,3);
errRGBvalues = zeros(N,3);
maxBits =  2^16-1;

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

R = meanRGBvalues(:,1);
dR = errRGBvalues(:,1);
G = meanRGBvalues(:,2);
dG = errRGBvalues(:,2);
B = meanRGBvalues(:,3);
dB = errRGBvalues(:,3);

%% Fit type I
[fR1, gofR1] = fitTypeI(dosesGy, R, dR);
[fG1, gofG1] = fitTypeI(dosesGy, G, dG);
[fB1, gofB1] = fitTypeI(dosesGy, B, dB);

CoefR1 = [fR1.alpha fR1.beta fR1.gamma];
CoefG1 = [fG1.alpha fG1.beta fG1.gamma];
CoefB1 = [fB1.alpha fB1.beta fB1.gamma];

DR1 = confint(fR1,0.683);
dCoefR1 = 0.5*(DR1(2,:) - DR1(1,:));
DG1 = confint(fG1,0.683);
dCoefG1 = 0.5*(DG1(2,:) - DG1(1,:));
DB1 = confint(fB1,0.683);
dCoefB1 = 0.5*(DB1(2,:) - DB1(1,:));
dosePoints = 0:0.1:(round(max(dosesGy)));

subplot(1,2,1)
plot(dosePoints, fR1(dosePoints), 'r-'); hold on
plot(dosePoints, fG1(dosePoints), 'g-');
plot(dosePoints, fB1(dosePoints), 'b-');
errorbar(dosesGy,meanRGBvalues(:,1),errRGBvalues(:,1),'r.');
errorbar(dosesGy,meanRGBvalues(:,2),errRGBvalues(:,2),'g.');
errorbar(dosesGy,meanRGBvalues(:,3),errRGBvalues(:,3),'b.');

grid on
xlabel('Doses [Gy]')
ylabel('Relative pixel value');
title(calFolder,'Interpreter','none');
ylim([0 1]);
xlim([0 max(dosesGy)])
calFigure = gcf;


% Prueba autoconsistencia
[D, dD] = getDoseT1(CoefR1, CoefG1, CoefB1, dCoefR1, ...
    dCoefB1, dCoefG1, R, G, B, dR, dG, dB);
subplot(1,2,2)
errorbar(dosesGy,D,dD', 'b-');
hold on
plot(dosesGy,dosesGy, 'k-');
ylim([0 1+max(dosesGy)])
xlim([0 1+max(dosesGy)])
grid on
legend('Calibration','Reference','Location','northwest');
xlabel('Actual doses [Gy]')
ylabel('Reported doses [Gy]')
title('Self consistency study');

%% Crear calibracion
RCCalibration.type = 'rational'; % rational or netOD
RCCalibration.name = [calFolder '-' RCCalibration.type];
RCCalibration.scanType = 'HDR';
RCCalibration.maxBitSize = maxBits;
RCCalibration.CoefR = CoefR1;
RCCalibration.CoefG = CoefG1; 
RCCalibration.CoefB = CoefB1;
RCCalibration.dCoefR = dCoefR1;
RCCalibration.dCoefG = dCoefG1;
RCCalibration.dCoefB = dCoefB1;
RCCalibration.graph = gcf;
RCCalibration.calDoses = dosesGy;
RCCalibration.calIMGs = allIMgs;

RCtype = readtable(xlsFilePath,Range="E2:E2",ReadVariableNames=false);
RCCalibration.RCtype = RCtype.Var1{1};

RClot = readtable(xlsFilePath,Range="E4:E4",ReadVariableNames=false);
RCCalibration.RClot = RClot.Var1{1};

RCIrrDate = readtable(xlsFilePath,Range="E14:E14",ReadVariableNames=false);
RCCalibration.RCIrrDate = RCIrrDate.Var1{1};

RCScanDate = readtable(xlsFilePath,Range="E15:E15",ReadVariableNames=false);
RCCalibration.RCScanDate = RCScanDate.Var1{1};

RCCalibration.objectSaveName = [RCCalibration.name '.mat'];
save(RCCalibration.objectSaveName,'RCCalibration');