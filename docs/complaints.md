## Some life experiences

- Not all pipelines are easy to run as it look on paper.
- The more programs are incorporated in a pipeline, the easier for it to break.
- Some take you back in time.

__CRUX-Anacapa Toolkit__

- Taxonomic assignments of metabrcode reads using existing tools.

---
## CRUX-Anacapa Toolkit

__Tools to be installed__

1. OBITools
1. ecoPCR
1. cutadapt (v1.16)
1. FastX toolkit (v 0.0.13)
1. Blast (v 2.6.0)
1. bowtie2
1. NCBI taxonomy dmp files.
1. NCBI nucl_gb.accession2taxid 

---
## CRUX-Anacapa Toolkit

__Tools to be installed__

9. biopython
1. R-3.4.2
1. R-packages (ggplot2 , plyr, dplyr, seqRFLP, reshape2, tibble, devtools, Matrix,
                mgcv, readr, stringr, vegan, plotly, otparse, ggrepel, cluster )

1. BIOCLITE Packages (phyloseq, genefilter, impute, Biostrings, dada2 )

---
## And then you may encounter problems like ...

- OBITools - failed to parse CPython sys.version: '2.7.14
- Entrez_qiime.py - cogent/align/_compare.pyx doesn't match any files
- Package **otparse** is not available (for R version )
- No specific error messages.

---

## Where we are now

We could successfully create a CRUX based library for vertebrates.
    - took 6 hours.
    
    
__Once you get past the hurdles and make it work, it is much easier to incorporate this as a recipe and run the
analysis.__

---