# 该程序需要手动安装的依赖有colorspace，stringi，DOSE，clusterProfiler，pathview
install.packages("colorspace")
install.packages("stringi")
# 换源
options(BioC_mirror=”https://mirrors.tuna.tsinghua.edu.cn/bioc/“)
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(version = "3.10")
BiocManager::install(c("DOSE", "clusterProfiler","pathview"))

setwd("C:\\Users\\urmsone\\Desktop\\Li")
library("clusterProfiler")
rt=read.table("id.txt",sep="\t",header=T,check.names=F)
rt=rt[is.na(rt[,"entrezID"])==F,]

geneFC=rt$logFC
gene=rt$entrezID
names(geneFC)=gene

#kegg富集分析
kk <- enrichKEGG(gene = gene, organism = "hsa", pvalueCutoff =0.05, qvalueCutoff =0.05)
write.table(kk,file="KEGG.txt",sep="\t",quote=F,row.names = F)

#柱状图
tiff(file="barplot.tiff",width = 30,height = 20,units ="cm",compression="lzw",bg="white",res=600)
barplot(kk, drop = TRUE, showCategory = 20)
dev.off()

#点图
tiff(file="dotplot.tiff",width = 30,height = 20,units ="cm",compression="lzw",bg="white",res=600)
dotplot(kk, showCategory = 20)
dev.off()

#通路图
library("pathview")
source("./pathview-u.R")
keggxls=read.table("KEGG.txt",sep="\t",header=T)
for(i in keggxls$ID){
 pv.out <- pathview(gene.data = geneFC, pathway.id = i, species = "hsa", out.suffix = "pathview")
}
