function avCals = getAvailableRCCals
    basePath = [fileparts(which('showAvailableRCCals')) filesep 'newCalibrations'];
    fileList = dir(basePath);
    validMask = [fileList.isdir]==0;
    fileList = fileList(validMask);
    allFiles = {fileList.name};
    allFiles = allFiles';
    avCals = {};
    for i = 1:numel(allFiles)
        [path,name,ext] = fileparts(allFiles{i});
        avCals{i} = name;
    end
end