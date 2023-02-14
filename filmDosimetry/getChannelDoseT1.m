%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

function D = getChannelDoseT1(CoefX, PVX)

    % Validate inputs
    validateattributes(CoefX,{'double'},{'numel',3});
    validateattributes(PVX,{'double'},{'>=',0,'<=',1});

    D = CoefX(3) + CoefX(2) ./ (PVX - CoefX(1));
end

