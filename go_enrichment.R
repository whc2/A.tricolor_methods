library(clusterProfiler)
library(ggplot2)

# Load background gene set
go_anno <- read.delim('red.pep.fa.tsv.gene.wego.go', header=FALSE, stringsAsFactors =FALSE) 
names(go_anno) <- c('gene_id','ID')

# Load GO database
go_class <- read.delim('go_term.list', header=FALSE, stringsAsFactors =FALSE) 
names(go_class) <- c('ID','Description','Ontology')  

# Merge GO annotation
go_anno <- merge(go_anno, go_class, by = 'ID', all.x = TRUE)  

# Gene ids of DEGs
gene_list <- read.delim('Rgreen_Rred_DEGs.csv.sig.higer_red.id',stringsAsFactors = FALSE) 
names(gene_list) <- c('gene_id') 
gene_select <- gene_list$gene_id

# Enrichment analysis
go_rich <- enricher(gene = gene_select,
                    TERM2GENE = go_anno[c('ID','gene_id')],
                    TERM2NAME = go_anno[c('ID','Description')],
                    pvalueCutoff = 0.05,
                    pAdjustMethod = 'BH',
                    qvalueCutoff = 0.2,
                    maxGSSize = 200) 
                    
# Draw plot
# Histogram
diff_barplot <- barplot(go_rich,showCategory=50,title="EnrichmentGO_diff",drop=T)

ggsave("diff_barplot_green_red_Hred.pdf",width = 8,height = 10,family="GB1")##ggplot

pdf("diff_barplot_green_red_Hred.pdf",width = 8,height = 10)
diff_barplot
dev.off()

# Dot plot
diff_dotplot <- dotplot(go_rich,showCategory=50,title="EnrichmentGO_diff")
ggsave("diff_dotplot_green_red_Hred.pdf",width = 8,height = 10,family="GB1")##ggplot

pdf("diff_dotplot_green_red_Hred.pdf",width = 8,height = 10)
diff_dotplot
dev.off()

# Output results for checking
write.table(go_rich, 'diff_green_red_Hred.txt', sep='\t', row.names = FALSE, quote = FALSE)
#write.table(go_anno, 'go_anno_fiff.txt', sep='\t', row.names = FALSE, quote = FALSE)
