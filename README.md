# KEGG_DEMO
## 环境
* win10
* R 3.6.2
## 运行
### 通过RGui运行
* `git clone https://github.com/UrmsOne/KEGG-demo.git`
* 设置运行路径：setwd("xxx")，例如`setwd("C:\\Users\\urmsone\\Desktop\\KEGG-demo")`
   * 其中xxx为clone后的KEGG-demo绝对路径，注意，是两个反斜杠。
* 安装依赖（第一次运行才需要此步骤，仅需运行一次）：
    * `source("requirements.R")`
    * `init()`
    ![](https://github.com/UrmsOne/KEGG-demo/blob/master/img/install-requirements.png)
* 运行画图脚本：
    * `source("shell/clusterProfilerKEGGShell.R")`
    * `clusterProfilerKEGGShell(pwd="C:\\Users\\urmsone\\Desktop\\KEGG-demo",output_path="output")`
      * output_path为图片的输出路径
   ![](https://github.com/UrmsOne/KEGG-demo/blob/master/img/running.png)
   ![](https://github.com/UrmsOne/KEGG-demo/blob/master/img/end.png)
   
### 命令行方式运行
* `git clone https://github.com/UrmsOne/KEGG-demo.git`
* `cd KEGG-demo`
* `Rscript cmd/main.R -p  C:\\Users\\urmsone\\Desktop\\KEGG-demo -o output`

## 报错解决
### 报错1：Error in readPNG(paste(kegg.dir, "/", pathway.name, ".png", sep = "")) : libpng error: Read Error

原因：可能是因为网络问题导致图片hasxxx.png的信息下载不完整，在读取时报错。可对照截图。
报错时的hsa05321.png
![Image text](https://github.com/UrmsOne/KEGG-demo/blob/master/img/hsa05321-err.png)
正常时的hsa05321.png
![](https://github.com/UrmsOne/KEGG-demo/blob/master/img/hsa05321.png)

解决：添加异常处理机制，在出现error的时候重新执行该命令，控制最大retry的次数即可。（比较暴力的解决方案）

### 报错2：Info: Writing image file hsa04215.pathview.png Info: some node width is different from others, and hence adjusted! Error in img[pidx[i, 3]:pidx[i, 4], sel.px, 1:3] : 只有负下标里才能有零

![](https://github.com/UrmsOne/KEGG-demo/blob/master/img/hsa04215-err.png)

原因：拉下来的hsa04215.xml文件中部分entry为`type="rectangle" x="1" y="1" width="1" height="1"`,node.info函数在解析该xml文件的时候会生成x=1 y=1的记录，导致生成png图片的时候报错

![](https://github.com/UrmsOne/KEGG-demo/blob/master/img/hsa04215-xml.png)

解决：在pathview的源码中把entry为`type="rectangle" x="1" y="1" width="1" height="1"`的数据过滤掉
在RGui中导入pathview，并获取其源码。新建一个文件将源码写入，并在`plot.data.gene=node.map..`后加入一行代码`plot.data.gene<-plot.data.gene[rowSums(plot.data.gene[,c("x","y","width","height")])!=4,]`。在画通路图时使用自己修改后的函数即可。详细使用过程请参考clusterProfilerKEGGShell.R

![](https://github.com/UrmsOne/KEGG-demo/blob/master/img/pathview.png)

## 写在最后
第一次写R一天入门，装环境&&跑代码，代码渣渣代码风格也渣渣请勿喷（本人也是个驼峰下划线或用的小逗比，python下划线、go驼峰）。初衷是帮逗比二货同学跑R画图，结果跑出了error，花了半天时间google，最后发现ID为hsa04215的这个error只有提问没有结果。受好奇心的趋势暴力解决了该问题，记录一下。core目录下是同学给我的代码，一个脚本、一个id.txt文件。kegg过程中生成的kegg.txt大概有144条记录，直接使用core的代码基本上是跑不到最后的，因此为了方便使用封装了一下，添加了异常处理的逻辑，执行遇到error时重试，并将出错的ID写入log。本人不是搞生物的，有关代码的问题可讨论，与生物学相关的范畴就一无所知啦！希望随手一笔能帮助到有需要的人！

