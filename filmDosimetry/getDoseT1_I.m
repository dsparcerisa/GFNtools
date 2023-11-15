%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

function [D, dD] = getDoseT1_I(I, pxmax, dI)

    global RCCalibration
    
    % Validate inputs
    validateattributes(pxmax,{'numeric'},{'positive'});
    intClasses = {'uint8','uint16','uint32','uint64','double'};
    validateattributes(I,intClasses,{'nonnegative','3d','<=',pxmax})
    if nargin>2
        validateattributes(dI,{'numeric'},{'nonnegative','size',size(I)});
    else
        dI = 0*double(I);
    end
   
    % Define values
    CoefR =  RCCalibration.CoefR;
    CoefG =  RCCalibration.CoefG;
    CoefB =  RCCalibration.CoefB;
    dCoefR =  RCCalibration.dCoefR;
    dCoefG =  RCCalibration.dCoefG;
    dCoefB =  RCCalibration.dCoefB;
    
    R = double(I(:,:,1)) / pxmax;
    G = double(I(:,:,2)) / pxmax;
    B = double(I(:,:,3)) / pxmax;
    dR = double(dI(:,:,1)) / pxmax;
    dG = double(dI(:,:,2)) / pxmax;
    dB = double(dI(:,:,3)) / pxmax;
    
    % Wrapper for detailed function
    [D, dD] = getDoseT1(CoefR, CoefG, CoefB, dCoefR, dCoefB, dCoefG, R, G, B, dR, dG, dB);
end
