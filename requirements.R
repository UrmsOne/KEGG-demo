init <- function(){
    # 该程序需要手动安装的依赖有colorspace，stringi，DOSE，clusterProfiler，pathview
    install.packages("colorspace")
    install.packages("stringi")
    install.packages("stringr")
    library("stringr")
    install.packages("getopt")
    # 换源
    if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
    options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
    BiocManager::install(version = "3.10")
    BiocManager::install(c("DOSE", "clusterProfiler","pathview"))
}