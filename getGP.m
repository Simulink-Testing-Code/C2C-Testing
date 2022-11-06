function [input,valuemap] = getGP(sys)
    %读深度为1的顶层模块，获取模块路径和名称：'sampleModel1/cfblk10'
    try
        load_system(sys);
        BlockPaths = getfullname(Simulink.findBlocks(sys,Simulink.FindOptions('SearchDepth',1)));
        % 创建模块和对应数组序号的映射 得到mymap，
        % mymap.values({'sampleModel1/cfblk12'})可获得序号(可包含多个路径返回多个序号)，
        % 序号用于分区输入。
        values = 0:length(BlockPaths)-1;
        mymap = containers.Map(BlockPaths,values);
        valuemap = containers.Map(values,BlockPaths);
        % 根据每个模块路径，获取该模块连接的模块，从而建立网络
        % 将每个模块的目标模块，放置在BlockPaths中该模块的后方，即BlockPath{i,2...}
        % 例如，BlockPath{9,1} = sampleModel1/cfblk5连接的两个模块
        % 分别放置在BlockPath{9,2},BlockPath{9,3},不包括控制线
        for i = 1:length(BlockPaths)
            Block_Ports = get_param(BlockPaths{i,1},'PortConnectivity');
            for j=1:numel(Block_Ports)%多个端口，只需考虑输出即可
                if isempty(Block_Ports(j).DstBlock)
                    continue
                else
                    myDstBlock = getfullname(Block_Ports(j).DstBlock);
                    if iscell(myDstBlock)
                        BlockPaths(i,2:numel(myDstBlock)+2-1) = myDstBlock;
                    else
                        myDstBlock = {myDstBlock};
                        BlockPaths(i,2:numel(myDstBlock)+2-1) = myDstBlock;
                    end
                end
            end
        end
        block_num = length(BlockPaths);%当前图模块个数;
        pin_num = sum(~cellfun('isempty',BlockPaths),"all")-block_num;%当前图线(边)条数;
        %创建模型对象图文件
        if ~exist(cfg.INPUTFILE,'dir')
            mkdir(cfg.INPUTFILE)
        end
        infile = fopen([cfg.INPUTFILE 't_' sys],'w');
        fprintf(infile,'%d\n',block_num);
        fprintf(infile,'%d\n',pin_num);
        %利用mymap将模型模块关系转换为无向图
        gp = zeros(pin_num,4);%图graph
        t = 1;
        for i = 1:length(BlockPaths)
        %     构造矩阵
            for j = 2:sum(~cellfun('isempty',BlockPaths(i,:)),"all")
                gp(t,3) = cell2mat(mymap.values(BlockPaths(i,1)));  %Source block
                gp(t,4) = cell2mat(mymap.values(BlockPaths(i,j))); %DstBlock
                t = t+1;
            end
        end
        %权值都为1;
        %一个边连接两个节点
        gp(:,1) = 1;
        gp(:,2) = 2;
        [r,c] = size(gp);
        for i = 1:r
            for j = 1:c
                fprintf(infile,'%d\t',gp(i,j));
            end
            fprintf(infile,'\n');
        end
        for i = 1:block_num
            fprintf(infile,'%d\n',1);
        end
        [input,~,~,~] = fopen(infile);
    catch e
        fclose(infile);
        e.message
    end
fclose(infile);
end