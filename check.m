function obj = check(seedmodelpath,seedmodelname,newmodelpaths,newmodelnames)
            Simulink.sdi.clear
            seedmodelname = seedmodelname(1:end-4);
            addpath(seedmodelpath)
            load_system(seedmodelpath)
            sprintf('seed model name is ：%s,\n new model name is ：%s',seedmodelname,newmodelnames{1})
            seed_result = Compar(seedmodelname,cfg.Normal,cfg.SIL);
            if ~seed_result 
                    %种子模型代码生成错误
                    sprintf('模型%s: %s 和 %s 仿真结果不一致',seedmodelname,cfg.Normal,cfg.SIL)
            end
            if ~strcmp(newmodelnames{1},seedmodelname)

                for i =1:length(newmodelnames)
                    newmodelpath = newmodelpaths{i};
                    newmodelname = newmodelnames{i}(1:end-4);
                    sprintf('seed model path is：%s\n,new model path is ：%s',seedmodelpath,newmodelpath)
                    load_system(newmodelpath)
                    load_system(seedmodelpath)
                    if ~cfg.ISCHECK
                        Simulink.sdi.clear
                    end
                    out1 = doSim(newmodelname,cfg.Normal);
                    out2 = doSim(newmodelname,cfg.SIL);

                    save_system(seedmodelpath)
                    save_system(newmodelpath)
                    open_system(seedmodelpath)
                    open_system(newmodelpath)
                
                end
            end

end