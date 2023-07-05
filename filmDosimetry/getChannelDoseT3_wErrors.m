%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

function [D, errD] = getChannelDoseT3_wErrors(CoefX, netODX, dCoefX, dnetODX)

    % Validate inputs
    validateattributes(CoefX,{'double'},{'numel',3});
    validateattributes(dCoefX,{'double'},{'numel',3, '>=',0});
    %validateattributes(netODX,{'double'},{'>=',-0.2,'<=',1});
    %validateattributes(dnetODX,{'double'},{'>=',0,'<=',1});
    
    a = CoefX(1);
    b = CoefX(2);
    n = CoefX(3);
    
    da = dCoefX(1);
    db = dCoefX(2);
    
    D = real(a.*netODX + b.*netODX.^n);
    errD = sqrt( real(da .* netODX).^2 + ...
                 real(db .* netODX.^n).^2 + ...
                 real(dnetODX .* (a + b.*n.*netODX.^(n-1))).^2 );
end

