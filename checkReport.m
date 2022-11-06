function checkReport()
    addpath("corpus_seed\");
    %     try
    mlist = ReadModel();
    difflist = dir('.\result\diff\*.slx');
    temp = {difflist.name}';
    for n=1:length(temp)
        temp{n,2} = findInCell(temp{n,1},mlist.list);
    end
    diffT = cell2table(temp,'VariableNames',{'diff_model','model_num'});
    diffT

    prompt = 'What is the needed model? ';
    i = input(prompt) 
    model = ReadModel(i);
    % model = model;
    disp(model.name)
    sub.newpath = fullfile(difflist(1).folder,model.name,'\');
    emimodels = dir(fullfile(sub.newpath,'*_*.slx'));

    if isempty(emimodels)
%         没有变体，sil不同
    else
        rootdir = sub.newpath;
        sub.newmodel = {emimodels.name}';
        sub.newpath = cellfun(@(x) fullfile(rootdir,x),sub.newmodel,'UniformOutput',false);
    end
        
        check(model.path,model.name,sub.newpath,sub.newmodel);
        bdclose all;
end