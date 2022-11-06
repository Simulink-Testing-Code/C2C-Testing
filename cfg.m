classdef cfg
    %CFG 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties(Constant = true)
        PARTITION_NUM = 3;
        SEED = 123;
        MYSUBSYSTEM_NUM=2;
        ISUSENOTHING=false;  %使用默认直接生成代码，不分区，不提升子系统，为true时会覆盖ISUSINGRANDOM
        ISUSINGRANDOM = false;
        EMI_NUM = 3;
        Max_attempts = 10;
        MaxPartsNum = 20;
        MODEL_TIMEOUT = 300;
        ISCHECK = false;
        MODEL_RUNTIME = '10.0';
        INPUTFILE = 'input\';
        NO_OUTPUT = '.\result\noyout';
        DIFF_FILE = '.\result\different';
        IDENDICAL = '.\result\identical';
        FAILDIR = '.\result\genFail\';          %变体失败
        SILFAILDIR = '.\result\SILFail\';       %SIL仿真失败
        CacheFolder = 'D:\chy\C2C2022_10_20_src\result\code';
        CodeGenFolder = 'D:\chy\C2C2022_10_20_src\result\codeGen';
        Normal = 'normal';
        SIL = 'Software-in-the-Loop (SIL)';
    end
    
    methods(Static)
    end
end

