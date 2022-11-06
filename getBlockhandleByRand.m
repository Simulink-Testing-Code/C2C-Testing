function partition = getBlockhandleByRand(sys)
% 获取模型顶层模块的句柄
    BlockhanPath = Simulink.findBlocks(sys, Simulink.FindOptions('SearchDepth',1));
%     获取模块的路径名称
    BlockhanName = getfullname(BlockhanPath);
% 随机挑选模块组成我们的预备子系统
% 为了作为对比，将随机模块的个数设置为，（模块总数/分区个数）向上取整
    RandBlocksNum = ceil(numel(BlockhanName)/cfg.PARTITION_NUM);

    if (RandBlocksNum*cfg.MYSUBSYSTEM_NUM)<numel(BlockhanName)
%         如果要划分的模块个数小于模型的模块个数，则生成一组随机数，
%         划分为对应个数的子系统，防止随机生成的模块冲突（不同子系统包含同一模块）
        allBlocks = BlockhanName(randperm(size(BlockhanName,1),RandBlocksNum*cfg.MYSUBSYSTEM_NUM))';
        for i=1:cfg.MYSUBSYSTEM_NUM
            partition{i,:} = allBlocks((i-1)*RandBlocksNum+1:i*RandBlocksNum);
        end
    else
%         如果超出个数限制，将所有被选中的模块划分为一个子系统
            partition{1,:} = BlockhanName(randperm(size(BlockhanName,1),RandBlocksNum*cfg.MYSUBSYSTEM_NUM))';
    end

end