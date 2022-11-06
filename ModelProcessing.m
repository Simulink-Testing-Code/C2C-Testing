%处理模型，获取模型的模块信息并且将模型提升为子系统
%bL表示模块名称
%blen 表示模型中的模块数量
%model表示获取的模型信息，包括模型名称和路径，以及模型所在文件夹包含的模型个数
a = ReadModel();
disp(['文件夹包含',num2str(a.len),'个模型']);
addpath("corpus_seed\");
for i = 1:a.len
%     try
        model = ReadModel(i);
       % model = model;
        fprintf('\nCurrent model num is  %d \t:',i);
        if ~cfg.ISUSENOTHING
%             如果使用分区算法
            sub = CombSubsystem(model);   %重组模型并保存到result中
            if sum(sub.newpath.strlength)==0
                disp('变体失败')
                mkdir(cfg.FAILDIR);
                copyfile(model.path,strcat(cfg.FAILDIR,'\'))
                bdclose all;
                continue;
            end
            subpath = strcat(sub.newpath,'.slx');
            try
                Comparition(model.path,model.name,sub.newpath,sub.newmodel);
            catch
                disp('不支持SIL仿真')
                mkdir(cfg.SILFAILDIR);
                copyfile(model.path,strcat(cfg.SILFAILDIR,'\'))
                bdclose all;
            end
            bdclose all;
        else
%             如果使用默认模型直接生成代码
            try
                Comparition(model.path,model.name);
            catch
                disp('不支持SIL仿真')
                mkdir(cfg.SILFAILDIR);
                copyfile(model.path,strcat(cfg.SILFAILDIR,'\'))
                bdclose all;
             end
        end
        bdclose all;
end
clear *.slxc
clear *.mexw64
[status,msg] = rmdir('.\result\code\','s');
[status,msg] = rmdir('.\result\\codeGen\','s');

