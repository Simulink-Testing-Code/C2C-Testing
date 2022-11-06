classdef CombSubsystem
    properties
        name;      %当前模型名称
        path;       %模型加载路径
%         blocks_h;   %当前模型模块句柄
        comblocks;  %合并模型模块组合列表
        newmodel;   %组合后获得的新模型
        newpath;
        num_attempts = 0;
    end
    methods
        function obj = CombSubsystem(model)  
            emi_num = 1:cfg.EMI_NUM;
            obj.newmodel = strings(1,cfg.EMI_NUM);
            obj.newpath = strings(1,cfg.EMI_NUM);
            i = 1;
            obj.name = replace(model.name,'.slx','');
            obj.path = model.path;
            disp(['obj.path为:',obj.path])

            while true
                if i<cfg.EMI_NUM+1
                    close_system([obj.name '_' num2str(i)],0);
                end
                load_system(obj.path)
                open_system(obj.path)
                %随机数并获取句柄
                if cfg.ISUSINGRANDOM
%                     随机策略
                    partition = getBlockhandleByRand(obj.name);
%                     随机策略只选择一个作为子系统
                else
                    partition = getBlockhandle(obj.name);
                end
                 % randperm(size(P,1),n)用这个函数获取n个不重复的随机数。
    %                 obj.comblocks = partition{randi(size(partition,1))};
    %                 Preselected module group premg预选模块组
%                 随机策略运行的时候，根据需要更改子系统个数。默认为1
                premg = randperm(size(partition,1),cfg.MYSUBSYSTEM_NUM);

                for n=1:cfg.MYSUBSYSTEM_NUM
                    obj.comblocks{n}=partition{premg(n)};%原来的obj.comblocks相当于现在的obj.comblocks{1,n}
                end

                try
                    obj.go();
                catch
                    close_system(obj.path,0);
                    continue
                end
                %检查
                if ~obj.checkloop(obj.name)
                    %有代数环则不保存关闭
                    close_system(obj.path,0)
                    obj.num_attempts = obj.num_attempts+1;
                    if obj.num_attempts>cfg.Max_attempts
                        break;
                    end
                elseif i<=cfg.EMI_NUM
                    %不包含代数环且模型不足十个
                    mkdir(['.\result\newmodel\',obj.name,'\']);            
                    newp=strcat('.\result\newmodel\',obj.name,'\');
                    s = [newp obj.name '_' num2str(emi_num(i))];
                    disp(s);

                    close_system(obj.path,s);
                    close_system(obj.path,0);
                    obj.newmodel(i) = [obj.name '_' num2str(emi_num(i))];
                    obj.newpath(i) = strcat(newp,[obj.name '_' num2str(emi_num(i))]);
                    i = i+1;
                    if i ==cfg.EMI_NUM+1
                        disp('成功创建所需新模型，退出循环');
                        disp('obj.newmodel:')
                        disp(obj.newmodel)
                        disp('obj.newpath:')
                        disp(obj.newpath);
                        %生成十个新模型
                        break
                    end
                else
                    disp('成功创建所需新模型，退出循环');
                    disp('obj.newmodel:')
                    disp(obj.newmodel)
                    disp('obj.newpath:')
                    disp(obj.newpath);
                    %生成十个新模型
                    break
                end
          
            end
 
        end
        
        function  go(obj)
            disp("组合模型句柄如下：");
%             这里的输入必须是句柄（数值）
            for n=1:numel(obj.comblocks)
                handles =  getSimulinkBlockHandle(obj.comblocks{1,n});
                Simulink.BlockDiagram.createSubsystem(handles,'Name',['Mysubsystem_',num2str(n)]);   %利用模块组创建子系统
                strsp = strsplit(obj.comblocks{1,n}{1,1},'/');
                lastbl = strsp(1:end-1);
                lastbn = strcat(lastbl,'/');
                disp(lastbn);
                lastpath = strcat(lastbn{1:end});
                subpath = [lastpath,['Mysubsystem_',num2str(n)]];
                disp(['subpath路径为：',subpath])
                subhandle = getSimulinkBlockHandle(subpath,true);       %获取子系统句柄
                disp(['当前模块句柄为：',num2str(subhandle)]);
                set_param(subhandle,'TreatAsAtomicUnit','on','RTWSystemCode','Reusable function',...
                        'RTWFcnNameOpts', 'User specified','RTWFcnName',['Mysubsystem_',num2str(n)],'RTWFileNameOpts','Use function name')
            end
        end
        
        %function [] = simmodel()
        %end
        
        function [startnum,combnum,blocksh] = ranum(obj,mname)
            obj.blocks_h = Simulink.findBlocks(mname);  %获得模型模块句柄
            %disp(obj.blocks_h);
            blenth = length(obj.blocks_h);  %模型包含模块数量
            disp(['模型',mname,'中包含',num2str(blenth),'个模块'])
            
            while true
                startnum = randi(blenth);
                combnum = randi(round(blenth/2));
                if sum([startnum,combnum])<= blenth 
                    break
                end
            end
            blocksh = obj.blocks_h;

        end

        %检查模型是否包含代数环,调用函数前，模型必须已经加载
        function  ret = checkloop(obj,mod)
            try
                [loops,~] = Simulink.BlockDiagram.getAlgebraicLoops(mod); 
                ret = isempty(loops);  %无代数环则ret=1
            catch
                ret = false;
            end
        end
            
            
            
    end
        

    
end
