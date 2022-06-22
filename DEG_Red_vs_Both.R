library(DESeq2)
raw_count <- read.table("z.all_counts.lst.txt", header = TRUE, row.names = "gene_id", sep = "\t")
count_data <- raw_count[, 5:12]
head(count_data)
condition <- factor(c("Both", "Both", "Both", "Both", "Red", "Red", "Red", "Red"), levels = c("Both", "Red"))
col_data <- data.frame(row.names = colnames(count_data), condition)
colnames(count_data)
col_data
dds <- DESeqDataSetFromMatrix(countData = count_data, colData = col_data, design = ~ condition)
dds_filter <- dds[rowSums(counts(dds)) > 1, ]
dds
dds_filter
dds_out <- DESeq(dds_filter)
res <- results(dds_out)
res
summary(res)
res <- res[order(res$padj), ]
diff_gene <- subset(res, padj < 0.05 && (log2FoldChange > 1 | log2FoldChange < -1))
write.csv(diff_gene, file = "DEG_Red_vs_Both.csv")
dds_out

library(genefilter)
library(pheatmap)
rld <- rlogTransformation(dds_out, blind=F)
topVarGene <- head(order(rowVars(assay(rld)), decreasing = TRUE), 10)
mat <- assay(rld)[topVarGene, ]
pheatmap(mat)

