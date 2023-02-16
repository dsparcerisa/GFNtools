%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

function [D, errD] = getChannelDoseT1_wErrors(CoefX, PVX, dCoefX, dPVX)

    % Validate inputs
    validateattributes(CoefX,{'double'},{'numel',3});
    validateattributes(dCoefX,{'double'},{'numel',3, '>=',0});
    validateattributes(PVX,{'double'},{'>=',0,'<=',1});
    validateattributes(dPVX,{'double'},{'>=',0,'<=',1});
    

    D = CoefX(3) + CoefX(2) ./ (PVX - CoefX(1));
    errD = sqrt( dCoefX(3).^2 + ...
                (dCoefX(2)./(PVX-CoefX(1))).^2 + ...
                (CoefX(2).*dPVX./(PVX-CoefX(1).^2)).^2 + ...
                (CoefX(2).*dCoefX(1)./(PVX-CoefX(1).^2)).^2);
end

