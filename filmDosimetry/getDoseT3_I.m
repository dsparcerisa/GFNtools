%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

function [D, dD] = getDoseT3_I(I, I0, pxmax, dI, dI0)

    global RCCalCoefs3
    
    % Validate inputs
    validateattributes(pxmax,{'numeric'},{'positive'});
    intClasses = {'uint8','uint16','uint32','uint64','double'};
    validateattributes(I,intClasses,{'nonnegative','3d','<=',pxmax});
    validateattributes(I0,intClasses,{'nonnegative','3d','<=',pxmax});
    
    if nargin>3
        validateattributes(dI,{'numeric'},{'nonnegative','size',size(I)});
        validateattributes(dI0,{'numeric'},{'nonnegative','size',size(I0)});        
    else
        dI = 0*double(I);
        dI0 = 0*double(I0);        
    end
   
    % Define values
    CoefR3 =  RCCalCoefs3(1,:,1);
    CoefG3 =  RCCalCoefs3(2,:,1);
    CoefB3 =  RCCalCoefs3(3,:,1);
    dCoefR3 =  RCCalCoefs3(1,:,2);
    dCoefG3 =  RCCalCoefs3(2,:,2);
    dCoefB3 =  RCCalCoefs3(3,:,2);
    
    R = double(I(:,:,1)) / pxmax;
    G = double(I(:,:,2)) / pxmax;
    B = double(I(:,:,3)) / pxmax;
    dR = double(dI(:,:,1)) / pxmax;
    dG = double(dI(:,:,2)) / pxmax;
    dB = double(dI(:,:,3)) / pxmax;
    
    R0_I = double(I0(:,:,1)) / pxmax;
    G0_I = double(I0(:,:,2)) / pxmax;
    B0_I = double(I0(:,:,3)) / pxmax;
    
    R0 = mean(R0_I(:));
    G0 = mean(G0_I(:));
    B0 = mean(B0_I(:));
    
    dR0 = sqrt( mean2(double(dI0(:,:,1)) / pxmax)^2 + (std(R0_I(:)))^2/numel(R0));
    dG0 = sqrt( mean2(double(dI0(:,:,2)) / pxmax)^2 + (std(G0_I(:)))^2/numel(G0));
    dB0 = sqrt( mean2(double(dI0(:,:,3)) / pxmax)^2 + (std(B0_I(:)))^2/numel(B0));
     
    netODR = log10(R0./R);
    netODG = log10(G0./G);
    netODB = log10(B0./B);
    
    dnetODR = (1/log(10)) * sqrt( (dR./R).^2 + (dR0/R0)^2 );
    dnetODG = (1/log(10)) * sqrt( (dG./G).^2 + (dG0/G0)^2 );
    dnetODB = (1/log(10)) * sqrt( (dB./B).^2 + (dB0/B0)^2 );
   
    % Wrapper for detailed function
    [D, dD] = getDoseT3(CoefR3, CoefG3, CoefB3, dCoefR3, dCoefB3, dCoefG3, netODR, netODG, netODB, dnetODR, dnetODG, dnetODB);
end
