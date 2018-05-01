## Collabrative Ananlysis in Bioinformatics 
![](./images/collab.jpg ) 
Natay Aberra 
Aswathy Sebastian 
Istavan Albert 


---

## Introduction 

- __Dr. Istvan Albert__ - Professor of Bioinformatics, enabled the project.

- __Aswathy Sebastian__ - Bioinformatician, wrote pipelines used for metabarcode analysis

- __Natay Aberra__ ( me ) - Programmer, made platform used to run and share pipelines. 
![](./images/state.png)

---

## Metabarcoding project

Classify a population of fish in the great lakes using different methods and compare their results. 

- Quickly search of invasive species 

---

## Bioinformatic Recipes

- __Problem__ : Bioinformatics is experiencing a _reproducibility crisis_. 
- __Solution__ :  A web application allowing scientists to document, execute and share data analysis scripts. 

We call these analysis scripts ___recipes___. 
  


---
## Create a project



---

## Upload some data
Uploading large data ( > 25 MB):

- The website allows  


---
## Copy over recipes 

---
## Run your own version 


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
2. ecoPCR
3. cutadapt (v1.16)
4. FastX toolkit (v 0.0.13)
5. Blast (v 2.6.0)
6. bowtie2
7. NCBI taxonomy dmp files.
8. NCBI nucl_gb.accession2taxid
9. biopython
10. R-3.4.2
11. R-packages (ggplot2 , plyr, dplyr, seqRFLP, reshape2, tibble, devtools, Matrix,
                mgcv, readr, stringr, vegan, plotly, otparse, ggrepel, cluster )

12. BIOCLITE Packages (phyloseq, genefilter, impute, Biostrings, dada2 )

---

## 

And then you may encounter problems like ...

- OBITools - failed to parse CPython sys.version: '2.7.14
- entrez_qiime.py - cogent/align/_compare.pyx doesn't match any files
- package ‘otparse’ is not available (for R version )
- No specific error messages.

---

## 

However, we could successfully create a CRUX based library for vertebrates.
    - took 6 hours.

__Once you get past the hurdles and make it work, it is much easier to incorporate this as a recipe and run the 
analysis.__

---
