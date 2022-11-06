classdef Comparition
    properties
        seedmodelpath;
        seedmodelname;
        newmodelpath;
        newmodelname;
    end

    methods
        function obj = Comparition(seedmodelpath,seedmodelname,varargin)
            if nargin ==2
%                 选择默认模型进行代码生成。
                obj.seedmodelpath = seedmodelpath;
                obj.seedmodelname = seedmodelname(1:end-4);
                addpath(seedmodelpath)
                catchpath = ['.\result\diff\',seedmodelname];
                decdir = strcat(catchpath,'\');
                load_system(seedmodelpath)
                sprintf('seed model name is ：%s\n,new model name is ：%s',obj.seedmodelname,obj.newmodelname)
                seed_result = Compar(obj.seedmodelname,cfg.Normal,cfg.SIL);
                if ~seed_result 
                        %种子模型代码生成错误
                        sprintf('模型%s: %s 和 %s 仿真结果不一致',obj.seedmodelname,cfg.Normal,cfg.SIL)
                        mkdir(catchpath);
                        copyfile(obj.seedmodelpath,decdir)
                end
                save_system(obj.seedmodelpath)
                close_system(obj.seedmodelpath)
            end
            if nargin>2
                newmodelpath=varargin{1};
                newmodelname=varargin{2};
                obj.seedmodelpath = seedmodelpath;
                obj.seedmodelname = seedmodelname(1:end-4);
                addpath(seedmodelpath)
                catchpath = ['.\result\diff\',seedmodelname];
                decdir = strcat(catchpath,'\');
                load_system(seedmodelpath)
                sprintf('seed model name is ：%s\n,new model name is ：%s',obj.seedmodelname,obj.newmodelname)
                seed_result = Compar(obj.seedmodelname,cfg.Normal,cfg.SIL);
                if ~seed_result 
                        %种子模型代码生成错误
                        sprintf('模型%s: %s 和 %s 仿真结果不一致',obj.seedmodelname,cfg.Normal,cfg.SIL)
                        mkdir(catchpath);
                        copyfile(obj.seedmodelpath,decdir)
                end
    
                for i =1:numel(newmodelpath)
                    obj.newmodelpath = newmodelpath(i);
                    obj.newmodelname = newmodelname(i);
                    sprintf('seed model path is：%s\n,new model path is ：%s',obj.seedmodelpath,obj.newmodelpath)
                    try
                        load_system(newmodelpath(i))
                    catch
                        break
                    end
                    load_system(seedmodelpath)
                    
                    emi_result = Compar(obj.newmodelname,cfg.Normal,cfg.SIL);
                    se_emi_result = Compar(obj.seedmodelname,cfg.SIL,obj.newmodelname,cfg.SIL);
                    
                    if ~emi_result
                        %变体代码生成错误
                        sprintf('模型%s: %s 和 %s 仿真结果不一致',obj.newmodelname,cfg.Normal,cfg.SIL)
                        mkdir(catchpath);
                        copyfile(strcat(obj.newmodelpath,'.slx'),decdir)
                    elseif ~se_emi_result
                        sprintf('模型 %s 和 模型 %s 仿真结果不一致',obj.seedmodelname,obj.newmodelname)
                        mkdir(catchpath);
                        copyfile(strcat(obj.newmodelpath,'.slx'),decdir)
                        copyfile(obj.seedmodelpath,decdir)
                    end
                    
                    
                    try
                        save_system(obj.seedmodelpath)
                        save_system(obj.newmodelpath)
                        close_system(obj.seedmodelpath)
                        close_system(obj.newmodelpath)
                    catch
                        bdclose all;
                    end
                end
            end
        end
       
        
    end
end
