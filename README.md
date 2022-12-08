## Introduction
These scripts were used for the genome project of *Amaranthus tricolor*. *A. tricolor*, also known as Joseph’s coat and Chinese spinach, is a C4 eudicot in the genus *Amaranthus*, family Amaranthaceae, order Caryophyllales. It is a vegetable and ornamental amaranth, with high lysine, dietary fiber and squalene content. Chinese cuisine traditionally uses *A. tricolor* (**xiàncài**) as a standalone steamed or boiled vegetable dish. For genome assembly, the contig assembly based on HiFi data was very fragment, so Nanopore Ultra-long data was used to link contig to longer scaffolds. The details were in following docs and the reference.

## Genome assembly
We documented the pipeline used in the paper to scaffold contigs assembled by [hifiasm](https://github.com/chhylp123/hifiasm) by Oxford Nanopore Ultra-long reads. Please refer to [methods for assmebly](01.assmelby.md).

## Transcriptome analysis
This part included computation of gene expression, differentially expressed genes (DEGs) detection and gene ontology (GO) enrichment analysis. Please refer to [methods for transcriptome](02.transcriptome.md).

## Reference
> Wang H, Xu D, Wang S, Wang A, Lei L, Jiang F, Yang B, Yuan L, Chen R, Zhang Y, Fan W. Chromosome-scale *Amaranthus tricolor* genome provides insights into the evolution of the genus *Amaranthus* and the mechanism of betalain biosynthesis. DNA Res. 2022 Dec 6:dsac050. [https://doi.org/10.1093/dnares/dsac050](https://doi.org/10.1093/dnares/dsac050)
