%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

function [D, dD] = getDoseT3(CoefR3, CoefG3, CoefB3, dCoefR3, dCoefB3, dCoefG3, netODR, netODG, netODB, dnetODR, dnetODG, dnetODB)

% Inputs are validated in individual color functions

% Red
[D_R, dD_R] = getChannelDoseT3_wErrors(CoefR3, netODR, dCoefR3, dnetODR);

% Green
[D_G, dD_G] = getChannelDoseT3_wErrors(CoefG3, netODG, dCoefG3, dnetODG);

% Blue
[D_B, dD_B] = getChannelDoseT3_wErrors(CoefB3, netODB, dCoefB3, dnetODB);

% Weighted average
D = (D_R ./ dD_R.^2 +  D_G ./ dD_G.^2 +  D_B ./ dD_B.^2) ...
    ./ (1 ./ dD_R.^2 +  1 ./ dD_G.^2 +  1 ./ dD_B.^2);
dD = (1 ./ dD_R.^2 +  1 ./ dD_G.^2 +  1 ./ dD_B.^2).^(-0.5); 

% Correction for over-dispersion (not used as it reduces uncertainty to
% unrealistic values)
% chi2 = sqrt((((D-D_R)./dD_R).^2 + ((D-D_G)./dD_G).^2 + ((D-D_B)./dD_B).^2)/2);
% dDc = chi2 .* dD;

end

