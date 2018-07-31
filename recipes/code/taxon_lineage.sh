set -ue
#TAXDIR=/export/refs/taxonomy
TAXDIR=`pwd`
# Download taxonomy specific files. Run these in  $TAXDIR.
# This operation only needs to be done once for the entire website.

(cd $TAXDIR && wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz)
(cd $TAXDIR && wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/nucl_gb.accession2taxid.gz)
(cd $TAXDIR && gunzip taxdump.tar.gz)
(cd $TAXDIR && gunzip nucl_gb.accession2taxid.gz)

# Untar file
tar -xvf $TAXDIR/taxdump.tar

#Create accession list.
cat $TAXDIR/nucl_gb.accession2taxid |  cut -f 2 | grep -v "accession" >$TAXDIR/accessions.txt

# Run R script in $TAXDIR to create lineage.tsv file
Rscript qiime2_taxa.R nodes.dmp names.dmp accessions.txt

# Make the file tab separated with two columns
sed -i 's/;/\t/' lineage.tsv

# Create an sqlite database of taxon lineage for faster processing later on.
python taxon_db.py taxon_db lineage.tsv
