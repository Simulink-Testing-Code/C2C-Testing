%%ReadModel类实现读取文件夹中的模型并返回模型对象，具体内容如下
%path 为模型所在文件夹路径，file为模型文件夹内容包括模型名称，父文件夹等
%，models为模型名称，
%i为文件中的模型次序（.,..,model1.slx）
classdef ReadModel
    properties
        len
        name
        path
        list
    end
    methods
        function  obj= ReadModel(i)
            Filepath = fullfile(pwd,'corpus_seed','*.slx');
            disp('种子文件读取位置为：')
            disp(Filepath);
            file = dir(Filepath);
            file_path = {file.folder}';
            models = {file.name}';
            obj.list = models;
            obj.len = size(models,1);
            %disp(len)
            if nargin <1
                obj.name = '未输入模型次序';
            end
            if nargin == 1
                obj.path = fullfile(file_path{i},models{i});
                obj.name = models{i};
            end
        end
    end
end


