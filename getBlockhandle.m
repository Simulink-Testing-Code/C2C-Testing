function partition = getBlockhandle(sys,varargin)
    % sys = 'sampleModel1';
    if nargin ==1
            partition_num =  cfg.PARTITION_NUM;
    end
    if nargin ==2
            partition_num =  varargin{1};
    end
    [input,valuemap] = getGP(sys);
    seed = cfg.SEED;
    result = getPartition(input,partition_num,seed);
    partition = cell(partition_num,1); 
    for i=1:length(result)
%         partition(i,1:length(result{i,1}))= valuemap.values(num2cell(result{i,1}));
        partition{i,:}= valuemap.values(num2cell(result{i,1}));
    end
end

