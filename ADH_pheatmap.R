library(pheatmap)
library(RColorBrewer)
color_schemes = colorRampPalette(rev(brewer.pal(n=7, name="RdYlBu")))
TPM <- read.table("z.all_counts.lst.txt.TPM.ADH", header = TRUE, row.names = "gene_id", sep = "\t")

TPM

TPM <- TPM[, -c(1:4)]

TPM

TPM=log10(TPM+1)

pheatmap(TPM,color = color_schemes(100), main = "ADH",fontsize = 15,
#	scale="row",
	border_color = NA,
	na_col = "grey",
	cluster_rows = T,cluster_cols = F,
	show_rownames = T,show_colnames = T,
	treeheight_row = 30,treeheight_col = 30,
	cellheight = 15,cellwidth = 30,
#	cutree_row=2,cutree_col=2,
	display_numbers = F,
	legend = T,
	filename = "ADH_TPM.pdf"
)
