# C2C-TESTING
Embedded coder Testing

- 在文件夹`courpus_seed`文件夹中放入实验需要的种子文件
- 在进行实验之前需要配置`cfg.m`文件，在该文件中修改自己<br>用于保存生成代码的文件和中间文件路径,以及需要的分区大小和每个分区粒度大小
- 配置文件完成后，将`courpus_seed`文件夹加入工作路径，即设定为```addpath(YOUR_PATH)```
- 运行ModelProcess启动程序<br>
note: 当因为某种意外中断后可以根据修改循环开始的模型次序`i`继续实验。
