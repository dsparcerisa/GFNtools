%%% GFNTools %%%
%%% (C) Daniel Sánchez Parcerisa 2023 %%%

function [pixelsXcm, maxInt] = getImgMetaInfo(filePath)

    % Validate inputs
    validateattributes(filePath,{'char'},{'nonempty'});
    
    if exist(filePath, 'file') ~= 2
        error('File %s not found.', filePath);
    end
    
    % Function logic
    imgInfo = imfinfo(filePath);
    % 1 dpi = 0.393701 pixel/cm
    pixelsXcm = imgInfo.XResolution * 0.393701;
    maxInt = imgInfo.MaxSampleValue(1);
    
end

