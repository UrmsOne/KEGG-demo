clusterProfilerKEGGShell <- function(pwd,output_path,id_txt="",kegg_txt="",log_txt="",use_barplot=FALSE,use_dotplot=FALSE,use_pathview=TRUE) {
    # params
    # pwd: 设置运行路径，
    # output_path: 设置图片输出目录
    # id_txt: 包含基因的symbol、logFC、entrezID等信息的文件，默认为项目根路基下的"id.txt"文件。可使用相对路径指定自己的文件。
    # kegg_txt: 富集分析生成的文件，默认为空。
    # log_txt: 错误日志输出文件
    # use_barplot: 是否画柱状图
    # use_dotplot: 是否画点图
    # use_pathview: 是否画通路图

    print("Shell starting!")
    cur_path = getwd()
    # if (pwd==""){
    #     pwd="C:\\Users\\urmsone\\Desktop\\KEGG"
    # }
    if (pwd!=""){
        print("Setwd!")
        setwd(pwd)
    }
    #setwd("C:\\Users\\urmsone\\Desktop\\KEGG")
    #print("Setwd!")
    #setwd(pwd)
    library("clusterProfiler")
    if (id_txt==""){
        # id.txt文件在当前项目的根路径下，输入的pwd为当前项目的根路径
        # 这里setwd()后可用相对路径直接读取
        id_txt="id.txt"
    }
    print("Reading id.txt!")
    rt=read.table(id_txt, sep="\t",header=T,check.names=F)
    rt=rt[is.na(rt[,"entrezID"])==F,]

    geneFC=rt$logFC
    gene=rt$entrezID
    names(geneFC)=gene

    print("KEGG starting!")
    #kegg富集分析
    if(kegg_txt==""){
        kegg_txt="KEGG.txt"
        kk <- enrichKEGG(gene = gene, organism = "hsa", pvalueCutoff =0.05, qvalueCutoff =0.05)
        write.table(kk,file=kegg_txt,sep="\t",quote=F,row.names = F)
    }

    # 检测输出文件是否存在
    if(!dir.exists(output_path)){
        dir.create(output_path)
    }

    #柱状图
    if(use_barplot==TRUE){
        print("Barplot starting!")
        barplot_path = file.path(output_path,"barplot")
        if (!dir.exists(barplot_path)){
            dir.create(barplot_path)
        }
        file_path = file.path(barplot_path,"barplot.tiff")
        tiff(file=file_path,width = 30,height = 20,units ="cm",compression="lzw",bg="white",res=600)
        barplot(kk, drop = TRUE, showCategory = 20)
        dev.off()
        print("Barplot completed!")
    }

    #点图
    if(use_dotplot==TRUE){
        print("Dotplot starting!")
        dotplot_path = file.path(output_path,"dotplot")
        if (!dir.exists(dotplot_path)){
            dir.create(dotplot_path)
        }
        file_path = file.path(dotplot_path,"dotplot.tiff")
        tiff(file=file_path,width = 30,height = 20,units ="cm",compression="lzw",bg="white",res=600)
        dotplot(kk, showCategory = 20)
        dev.off()
        print("Dotplot completed!")
    }

    #通路图
    #library("pathview")
    #source("./pathview-u.R")
    #keggxls=read.table("KEGG.txt",sep="\t",header=T)
    #for(i in keggxls$ID){
    #  pv.out <- pathview(gene.data = geneFC, pathway.id = i, species = "hsa", out.suffix = "pathview")
    #}
    if(use_pathview==TRUE){
        print("Pathview starting!")
        library("pathview")
        library("stringr")
        source("pathview-u.R")
        keggxls=read.table(kegg_txt,sep="\t",header=T)
        # pathview_path=file.path(getwd(),output_path,"pathview")
        pathview_path=file.path(output_path,"pathview")
        if(!dir.exists(pathview_path)){
            dir.create(pathview_path)
        }
        setwd(pathview_path)
        if (log_txt=="") {
            log_txt="log.txt"
        }
        log_txt=file.path(pwd,log_txt)
        #download_path=file.path(pathview_path,"download")
        if(!dir.exists("download")){
            dir.create("download")
        }
        try(write.table(date(),file=log_txt,append=TRUE))
        for(i in keggxls$ID){
            # TODO: 添加由于网络问题出错时，重新执行生成该通路图的逻辑,最多重试5次
            count=0
            err=TRUE
            while(count<5&&err==TRUE){
                tryCatch({
                    pv.out <- pathview_u(gene.data = geneFC, pathway.id = i, species = "hsa", out.suffix = "pathview",kegg.dir="download")
                    err=FALSE
                },warning = function(w){
                    msg=paste("ID:",i,"warning:",w, sep=" ")
                    try(write.table(msg,file=log_txt,append=TRUE,fileEncoding="UTF-8"))
                },error=function(e){
                    image=str_c(i,".png")
                    if (file.exists(image)){
                        try(file.remove(image))
                    }
                    # xml=str_c(i,".xml")
                    # if (file.exists(xml)){
                    #     try(file.remove(xml))
                    # }
                    msg=paste("ID:",i,"error:",e, sep=" ")
                    try(write.table(msg,file=log_txt,append=TRUE,fileEncoding="UTF-8"))
                },finally={
                    count=count+1
                })
            }
        }
        print("Pathview completed!")
    }
    if(pwd!=""){
        setwd(cur_path)
    }
}