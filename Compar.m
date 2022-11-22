function cp = Compar(model,mode,varargin)
%COMPAR 此处显示有关此函数的摘要
%   此处显示详细说明
% model is seed model
% newmodels are model mutations list
    cp = false;%比较结果
    %清理数据检查器数据
    
    if nargin <3
        error('比较器输入的模型个数不足，无法比较')
    end
    if nargin ==3
        newmodels = model;
        new_mode = varargin{1};
    end
    if nargin ==4
        newmodels = varargin{1};
        new_mode = varargin{2};
    end
    if ~cfg.ISCHECK
        Simulink.sdi.clear
    end
    try
        %执行需要比较的模型运行
        out1 = doSim(model,mode);
        out2 = doSim(newmodels,new_mode);
    catch
       %应该修改为按照sim错误处理，这里按照模型不同处理。
        cp =false;
        return;
    end

    runIDs = Simulink.sdi.getAllRunIDs;
    if length(runIDs)<2
        Simulink.sdi.clear
        try
            %执行需要比较的模型运行
            out1 = doSim(model,mode);
            out2 = doSim(newmodels,new_mode);
        catch
            cp =false;
            return;
        end
        runIDs = Simulink.sdi.getAllRunIDs;
    end
    runID1 = runIDs(end-1);
    runID2 = runIDs(end);
    
    diffResults = Simulink.sdi.compareRuns(runID1,runID2,'reltol',1e-3,'timetol',0);
    diffResults.Summary
    numComparisons = diffResults.count;
    fprintf('compare %s in mode %s and %s in mode %s \n',model,mode,newmodels,new_mode);
    for k = 1:numComparisons
        resultAtIdx = getResultByIndex(diffResults,k);
        
        sigID1 = resultAtIdx.signalID1;
        sigID2 = resultAtIdx.signalID2;
        if ~isempty(sigID2) && ~isempty(sigID1)
            sig1 = Simulink.sdi.getSignal(sigID1);
            sig2 = Simulink.sdi.getSignal(sigID2);
        else
            break
        end
        displayStr = 'Signals %s and %s: %s \n';
        fprintf(displayStr,sig1.Name,sig2.Name,resultAtIdx.Status);
    end
    if diffResults.Summary.OutOfTolerance>0
        %结果不同
        cp = false;
    else
        %结果相同
        cp = true;
    end

end

