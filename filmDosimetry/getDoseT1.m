%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

function [D, dD] = getChannelDoseT1(CoefR1, CoefG1, CoefB1, dCoefR1, dCoefB1, dCoefG1, R, G, B, dR, dG, dB)

% Inputs are validated in individual color functions

% Red
[D_R, dD_R] = getChannelDoseT1_wErrors(CoefR1, R, dCoefR1, dR);

% Green
[D_G, dD_G] = getChannelDoseT1_wErrors(CoefG1, G, dCoefG1, dG);

% Blue
[D_B, dD_B] = getChannelDoseT1_wErrors(CoefB1, B, dCoefB1, dB);

% Weighted average
D = (D_R ./ dD_R.^2 +  D_G ./ dD_G.^2 +  D_B ./ dD_B.^2) ...
    ./ (1 ./ dD_R.^2 +  1 ./ dD_G.^2 +  1 ./ dD_B.^2);
dD = (1 ./ dD_R.^2 +  1 ./ dD_G.^2 +  1 ./ dD_B.^2).^(-0.5); % TODO: Must correct for chi2!!!

end

