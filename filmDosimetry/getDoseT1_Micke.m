function [D, dD, varMat] = getDoseT1_Micke(CoefR, CoefG, CoefB, dCoefR, dCoefB, dCoefG, R, G, B, dR, dG, dB, deltas)


% function [dose, varMat, realDR, realDG, realDB] = getDoseMicke(I, CoefR, CoefG, CoefB, pixelsXCM, deltas, pxmax)

% Must validate inputs

%% Definir funciones
DR = @(pv) CoefR(3) + CoefR(2)./(pv - CoefR(1));
DG = @(pv) CoefG(3) + CoefG(2)./(pv - CoefG(1));
DB = @(pv) CoefB(3) + CoefB(2)./(pv - CoefB(1));
aR = @(pv) -CoefR(2) ./ (pv - CoefR(1)).^2;
aG = @(pv) -CoefG(2) ./ (pv - CoefG(1)).^2;
aB = @(pv) -CoefB(2) ./ (pv - CoefB(1)).^2;

correctedDR = @(pv,delta) DR(pv) + aR(pv).*delta;
correctedDG = @(pv,delta) DG(pv) + aG(pv).*delta;
correctedDB = @(pv,delta) DB(pv) + aB(pv).*delta;

if ~exist('deltas')
    delta = -0.2:0.001:0.2;
else
    delta = deltas;
end

% Perturbed dose 
dev_min = 1.e30*ones(size(R));
delta0 = nan(size(R));

% Primero sin tener en cuenta los límites
for k = 1:numel(delta)
    dev = (correctedDR(R,delta(k))-correctedDG(G,delta(k))).^2 + ...
        (correctedDR(R,delta(k))-correctedDB(B,delta(k))).^2 + ...
        (correctedDB(B,delta(k))-correctedDG(G,delta(k))).^2;
    maskMin = dev<dev_min;
    dev_min(maskMin) = dev(maskMin);
    delta0(maskMin) = delta(k);
end

realDR = correctedDR(R,delta0);
realDG = correctedDG(G,delta0);
realDB = correctedDB(B,delta0);

% Y luego teniéndolos en cuenta
isR = double(realDG<10 & realDR<10);
isB = double(realDG>2 & realDB>2); % Nunca usar DB

for k = 1:numel(delta)
    dev = isR.*(correctedDR(R,delta(k))-correctedDG(G,delta(k))).^2 + ...
        isR.*isB.*(correctedDR(R,delta(k))-correctedDB(B,delta(k))).^2 + ...
        isB.*(correctedDB(B,delta(k))-correctedDG(G,delta(k))).^2;
    maskMin = dev<dev_min;
    dev_min(maskMin) = dev(maskMin);
    delta0(maskMin) = delta(k);
end

realDR = correctedDR(R,delta0);
realDG = correctedDG(G,delta0);
realDB = correctedDB(B,delta0);

D = (isR.*realDR+realDG+isB.*realDB)./ (1 + isR + isB);
dD = nan;
varMat = delta0;

end


