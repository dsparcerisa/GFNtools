function [names,IMgs,stdIMgs] = loadRCset(RCpath)

NumEscaneos = 3;

[Fpath, Fname, Fext] = fileparts(RCpath);
RCpath2 = fullfile(Fpath, [Fname ' (2)' Fext]);
RCpath3 = fullfile(Fpath, [Fname ' (3)' Fext]);

imgInfo = imfinfo(RCpath);
bitsPerSample = imgInfo.BitsPerSample(1);

I{1} = imread(RCpath);
I{2} = imread(RCpath2);
I{3} = imread(RCpath3);

Ifinal = repmat(I{1},[1 1 1 NumEscaneos]);
Ifinal = double(Ifinal);
for i=1:NumEscaneos
    Ifinal(:,:,:,i) = double(I{i});
end

Ifinal_mean = mean(Ifinal,4);
Ifinal_std = std(Ifinal,[],4);

imshow(I{1})
Nimgs = input('How many images in this file? ')

croppings = {};
names = {};
for i=1:Nimgs
    fprintf('Select cropping for img %i\n', i);
    figure(99);
    if bitsPerSample == 8
            [~, croppings{i}] = imcrop(uint8(Ifinal_mean)); close(99);
    elseif bitsPerSample==16
            [~, croppings{i}] = imcrop(uint16(Ifinal_mean)); close(99);
    else
        error('Unknown image format. Review bit depth.');
    end
    names{i} = input('What is the name of this cropping?: ', 's');
    IMgs{i} = imcrop(Ifinal_mean,croppings{i});
    stdIMgs{i} = imcrop(Ifinal_std,croppings{i});
end

for i=1:numel(IMgs)
    subplot(numel(IMgs),1,i);
    imshow(IMgs{i})
    title(i);
end

end

