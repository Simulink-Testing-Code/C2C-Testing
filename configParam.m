function configParam(model) 
%CONFIGPARAM 此处显示有关此函数的摘要
%   此处显示详细说明
    disp(model);
    %代码和缓存文件保存路径
    myCacheFolder = cfg.CacheFolder;
    myCodeGenFolder = cfg.CodeGenFolder;   
    Simulink.fileGenControl('set', ...
       'CacheFolder',myCacheFolder, ...
       'CodeGenFolder',myCodeGenFolder, ...
       'keepPreviousPath',true, ...
       'createDir',true); 
    addpath(cfg.CacheFolder,cfg.CodeGenFolder)
    %% model confige and logging signals

    set_param(model, 'RecordCoverage','off');
    
    coverageSettings = get_param(model, 'CodeCoverageSettings');
    coverageSettings.CoverageTool='None';
    set_param(model, 'CodeCoverageSettings',coverageSettings);
    
    set_param(model, 'CodeExecutionProfiling','off');
    
    signalOp.signal_logging_setup(model);
    set_param(model, 'SignalLogging', 'on');
    set_param(model, 'SignalLoggingName', 'logsOut');
    set_param(model, 'SaveOutput','on','InspectSignalLogs','on')

%         
    set_param(model,'UpdateModelReferenceTargets','Force');
    set_param(model,'StopTime',num2str(cfg.MODEL_RUNTIME),'SolverType','Fixed-step',...
        'ProdHWDeviceType','Intel->x86–64 (Windows64)',...
        'ProdEqTarget','on',...
        'SupportContinuousTime','on',...
        'Solver','FixedStepAuto','FixedStep','auto','GenerateReport','on',...
        'ReturnWorkspaceOutputs','on','SystemTargetFile','ert.tlc');
    set_param(model,"IncludeHyperlinkInReport",'on',"GenerateTraceInfo",'on');
end

