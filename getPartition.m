function result = getPartition(input,partition_num,seed)

    [status,cmdout] = system("ad_fms.exe "+input+" "+partition_num+" "+seed);
    if status~=0
        warning('分区失败')
    end
    temp = strsplit(cmdout);
    result = cell(partition_num,1); %保存分组的划分结果。
    ignor = 0;
    for i = 20:3:length(temp)-1   
        result{str2num(temp{1,i})+1,1} = [result{str2num(temp{1,i})+1,1},ignor];
        ignor = ignor+1;
    end

end