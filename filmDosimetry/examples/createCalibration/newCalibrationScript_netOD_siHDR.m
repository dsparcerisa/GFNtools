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


%% NetOD
index0Gy = find(dosesGy==0);
NOD_R = log10(R(index0Gy)./R);
NOD_G = log10(G(index0Gy)./G);
NOD_B = log10(B(index0Gy)./B);
dNOD_R = (1/log(10)) * sqrt( (dR./R).^2 + (dR(index0Gy)/R(index0Gy))^2 );
dNOD_G = (1/log(10)) * sqrt( (dG./G).^2 + (dG(index0Gy)/G(index0Gy))^2 );
dNOD_B = (1/log(10)) * sqrt( (dB./B).^2 + (dB(index0Gy)/B(index0Gy))^2 );

%% Fit type III
[fR3, gofR3] = fitTypeIII(dosesGy, NOD_R, dNOD_R);
[fG3, gofG3] = fitTypeIII(dosesGy, NOD_G, dNOD_G);
[fB3, gofB3] = fitTypeIII(dosesGy, max(0,NOD_B), dNOD_B);

CoefR3 = [fR3.a fR3.b fR3.c fR3.n];
CoefG3 = [fG3.a fG3.b fG3.c fG3.n];
CoefB3 = [fB3.a fB3.b fB3.c fB3.n];

DR3 = confint(fR3,0.683);
dCoefR3 = 0.5*(DR3(2,:) - DR3(1,:));
dCoefR3(4) = 0;
DG3 = confint(fG3,0.683);
dCoefG3 = 0.5*(DG3(2,:) - DG3(1,:));
dCoefG3(4) = 0;
DB3 = confint(fB3,0.683);
dCoefB3 = 0.5*(DB3(2,:) - DB3(1,:));
dCoefB3(4) = 0;

dosePoints = 0:0.1:(round(max(dosesGy)));

%% Make plots
subplot(1,2,1);

NODPoints = 0:0.01:1;
plot(NODPoints, fR3(NODPoints), 'r-'); hold on
plot(NODPoints, fG3(NODPoints), 'g-'); hold on
plot(NODPoints, fB3(NODPoints), 'b-'); hold on
errorbar(NOD_R, dosesGy, dNOD_R, 'horizontal', 'r.'); 
errorbar(NOD_G, dosesGy, dNOD_G, 'horizontal', 'g.'); 
errorbar(NOD_B, dosesGy, dNOD_B, 'horizontal', 'b.'); 

grid on
ylabel('Doses [Gy]')
xlabel('netOD');
title(calFolder,'Interpreter','none');
%ylim([0 12]);
ylim([0 max(dosesGy)]);
xlim([0 1])


% Prueba autoconsistencia
[D, dD] = getDoseT3(CoefR3, CoefG3, CoefB3, dCoefR3, dCoefB3, dCoefG3, ...
    NOD_R, NOD_G, NOD_B, dNOD_R, dNOD_G, dNOD_B)
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
RCCalibration.type = 'netOD'
RCCalibration.name = [calFolder '-' RCCalibration.type];
RCCalibration.scanType = 'HDR';
RCCalibration.maxBitSize = maxBits;
RCCalibration.CoefR = CoefR3;
RCCalibration.CoefG = CoefG3; 
RCCalibration.CoefB = CoefB3;
RCCalibration.dCoefR = dCoefR3;
RCCalibration.dCoefG = dCoefG3;
RCCalibration.dCoefB = dCoefB3;
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