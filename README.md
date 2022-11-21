# MOPART
## [MOPART](https://github.com/Simulink-Testing-Code/RECORD.git)
**Matlab env dependencies:**
1. **Matlab 2022a**
2. **Simulink default**
3. **Matlab Coder**
4. **Simulink Coder**
5. **Embedded Coder**
***
### Datatest:
If you wish to use publicly available datasets, you can access *[third-party datasets](https://drive.google.com/drive/folders/173ik08oi3BCnPzjlZkHYhMAkp93zW-V4?usp=sharing)*. If you wish to use a random model, 
you can visit *[Dr. Shafiul's homepage](https://github.com/verivital/slsf_randgen/wiki)*. Get the latest experimental model generation tools SLFORGE/CYFUZZ

##### [SLforge: Automatically Finding Bugs in a Commercial Cyber-Physical Systems Development Tool](https://github.com/verivital/slsf_randgen/wiki#getting-slforge)
**The format of the model is divided into mdl and slx according to the Simulink standard. If you use some third-party open source models, make sure that the dependencies 
between the models and the data are loaded into your memory. We do not recommend using third-party models in unfiltered conditions, which will cause your computer
to crash abnormally. Please be careful**
***
### Our Works
Engineers frequently generate embedded code from Simulink models for various control applications. However, bugs in code generation may inject unexpected behaviors to target applications that use the code.To this end, we propose , a model partition based differential testing method for code generation testing in Simulink. uses multiple-way network partitioning to generate diverse bug-triggering Simulink models that can output equivalent embedded code. then analyzes the outputs of these Simulink models with differential testing to find bugs.Experiments show that  is effective in finding code generation bugs,which finds 11 confirmed bugs in only two weeks.

***
### Hello World
Before you start, put the seed files you need for your experiment in the folder 'corpus_seed'.Second, if you want to run this method more carefully, you should configure the 'cfg.m' file, in which you can modify the files and intermediate file paths you use to save the generated code, as well as the required partition size and granularity of each partition.Once configured, add the `courpus_seed` folder to the working path, which is set to ```addpath(Seed_Model_Path)```
When all of the above preparation is complete, you simply enter ```ModelProcessing``` on the Matlab command line to launch the program and begin the model partitioning and variant process.This will help you get started with MOPART tools.
note: When the program is interrupted due to some accident, you can continue the experiment by modifying the loop order 'i' in the file ```ModelProcessing.m``` according to the progress that has been completed before.
***

### Here are the details of these bugs
These errors in the error file can be reproduced using Matlab R2022a.

You can find all bug files in path `c2c-Bug`.

The 'C2C-Bug' folder contains the compressed package of all bug-related information, including the model that triggers the bug, the model equivalent model, the comparison diagram of the execution results obtained by using the data inspector, and the detailed introduction of the bugs.

05794231 Incorrect code generation

05807041 Code generation error caused by subsystem  

05824672  SIL exception caused by Complex to Real-Img in subsystem

05824768  the Unary Minus module loses data after generating codes

05829052  The delay module in a multilayer subsystem raises an error

05842603  The MinMax Runing Resettable module lost data

05842655  Model code exception caused by bias module in subsystem

05842869  Repeating Sequence Interpolated Generating error signals

05862281  The Polyval module has abnormal data after code generation

05862510  Math function error handling in code generation

05864689  Trigonometric Function module incorrectly used
***
**Thanks to MathWorks consultants Zouyi Yang and Gu Bill for their support. We've had so much help from MathWorks staff in finding and confirming bugs that we can't list them all. I would like to express my gratitude here.**
