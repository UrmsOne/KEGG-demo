# setwd("C:/Users/urmsone/Desktop/KEGG-demo/shell")
# TODO: 添加命令行参数来，控制clusterProfilerKEGGShell函数的参数使用情况
library("getopt")
command = matrix(c(
    'pwd', 'p', 1, "character","设置当前路径",
    'use_barplot', 'b',1, "logical", "画柱状图",
    'use_dotplot', 'd',1, "logical", "画点状图",
    'use_pathview', 'v',1, "logical", "画点状图",
    'help', 'h', 0,"",""), 
    byrow=TRUE, ncol=5)
args = getopt(command)
cat(paste(getopt(command, usage=T),"\n"))
print(args$pwd)
# if (!is.null(args$help)) || is.null(args$use_pathview) || is.null(args$use_dotplot) || is.null(args$use_barplot) || is.null(pwd)){
#     cat(paste(getopt(command, usage=T),"\n"))
#     q()
# }