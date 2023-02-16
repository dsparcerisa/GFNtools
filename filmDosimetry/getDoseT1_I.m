%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

function [D, dD] = getDoseT1_I(I, pxmax, dI)

    global RCCalCoefs
    
    % Validate inputs
    validateattributes(pxmax,'numeric',{'positive'});
    intClasses = {'uint8','uint16','uint32','uint64','double'};
    validateattributes(I,intClasses,{'nonnegative','3d','<=',pxmax})
    if nargin>2
        validateattributes(dI,'numeric',{'nonnegative','size',size(I)});
    else
        dI = 0*double(I);
    end
   
    % Define values
    CoefR =  RCCalCoefs(1,:,1);
    CoefG =  RCCalCoefs(2,:,1);
    CoefB =  RCCalCoefs(3,:,1);
    dCoefR =  RCCalCoefs(1,:,2);
    dCoefG =  RCCalCoefs(2,:,2);
    dCoefB =  RCCalCoefs(3,:,2);
    R = double(I(:,:,1)) / pxmax;
    G = double(I(:,:,2)) / pxmax;
    B = double(I(:,:,3)) / pxmax;
    dR = double(dI(:,:,1)) / pxmax;
    dG = double(dI(:,:,2)) / pxmax;
    dB = double(dI(:,:,3)) / pxmax;
    
    % Wrapper for detailed function
    [D, dD] = getDoseT1(CoefR, CoefG, CoefB, dCoefR, dCoefB, dCoefG, R, G, B, dR, dG, dB);
end
