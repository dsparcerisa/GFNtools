function showAvailableRCCals
    avCals = getAvailableRCCals;
    for i=1:numel(avCals)
        disp(avCals{i})
    end
end