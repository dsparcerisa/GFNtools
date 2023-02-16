%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

function [D, dD] = getDoseT1_I(I, coefs, pxmax, dI)
    % Validate inputs
    validateattributes(pxmax,'numeric',{'positive'});
    intClasses = {'uint8','uint16','uint32','uint64'};
    validateattributes(I,intClasses,{'3d','<=',pxmax})
    validateattributes(coefs,'double',{'size',[3 3 2]});
    if nargin>3
        validateattributes(dI,'numeric',{'nonnegative','size',size(I)});
    else
        dI = 0*double(I);
    end
   
    % Define values
    CoefR =  coefs(1,:,1);
    CoefG =  coefs(2,:,1);
    CoefB =  coefs(3,:,1);
    dCoefR =  coefs(1,:,2);
    dCoefG =  coefs(2,:,2);
    dCoefB =  coefs(3,:,2);
    R = double(I(:,:,1)) / pxmax;
    G = double(I(:,:,2)) / pxmax;
    B = double(I(:,:,3)) / pxmax;
    dR = double(dI(:,:,1)) / pxmax;
    dG = double(dI(:,:,2)) / pxmax;
    dB = double(dI(:,:,3)) / pxmax;
    
    % Wrapper for detailed function
    [D, dD] = getDoseT1(CoefR, CoefG, CoefB, dCoefR, dCoefB, dCoefG, R, G, B, dR, dG, dB);
end
