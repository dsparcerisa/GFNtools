%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

function [D, errD] = getChannelDoseT3_wErrors(CoefX, netODX, dCoefX, dnetODX)

    % Validate inputs
    validateattributes(CoefX,{'double'},{'numel',4});
    validateattributes(dCoefX,{'double'},{'numel',4, '>=',0});
    %validateattributes(netODX,{'double'},{'>=',-0.2,'<=',1});
    %validateattributes(dnetODX,{'double'},{'>=',0,'<=',1});
    
    a = CoefX(1);
    b = CoefX(2);
    c = CoefX(3);
    n = CoefX(4);
    
    da = dCoefX(1);
    db = dCoefX(2);
    dc = dCoefX(3);    
    
    D = real(a + b.*netODX + c.*netODX.^n);
    errD = sqrt( real(da.^2) + ...
                 real(db .* netODX).^2 + ...
                 real(dc .* netODX.^n).^2 + ...
                 real(dnetODX .* (b + c.*n.*netODX.^(n-1))).^2 );
end

