set -ue

# The input directory for the data
DDIR=$(dirname {{reads.value}})
FILE=$(basename {{reads.value}})

# Unzip if the data is zipped
if [[ $FILE == *.zip ]]; then
echo "unzipping"
unzip $DDIR/$FILE -d $DDIR/data
DDIR=$DDIR/data
fi

# Library type of input reads.
LIBRARY={{library.value}}

# Position at which forward read sequences to be truncated from at 3' end.
POS_RIGHT_F={{trunc_right_f.value}}

#Position at which reverse read sequences to be truncated from at 3' end.
POS_RIGHT_R={{trunc_right_r.value}}

#Position until which forward read sequences to be truncated from at 5' end.
POS_LEFT_F={{trunc_left_f.value}}

#Position until which reverse read sequences to be truncated from at 5' end.
POS_LEFT_R={{trunc_left_r.value}}

# No. of threads to use.
N=4

# Create main store for results.
STORE=results
mkdir -p $STORE

# Directory that holds input data as qiime2 artifact.
DATA=$STORE/data
mkdir -p $DATA

# Directory that holds DADA2 results
DADA2=$STORE/dada2

# Directory that holds BLAST+ taxonomy classification results.
BLAST=$STORE/blast-taxa


# The reference sequence to classify against.
REF_FASTA={{reference.value}}
echo "Converting reference to qiime2 format"
REFERENCE=$DATA/refs.qza
# qiime tools import --input-path $REF_FASTA --output-path $REFERENCE --type 'FeatureData[Sequence]'

# TAXDIR=/export/refs/taxonomy
# TAXDIR=/Users/asebastian/work/web-dev/biostar-recipes/export/refs/taxonomy
# Download taxonomy specific files. Run these in  $TAXDIR.
# This operation only needs to be done once for the entire website.
# (cd $TAXDIR && wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz)
# (cd $TAXDIR && wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/nucl_gb.accession2taxid.gz)
# (cd $TAXDIR && gunzip taxdump.tar.gz)
# (cd $TAXDIR && gunzip nucl_gb.accession2taxid.gz)
# Create the conversion table (accession to taxid mapping).
# cat $TAXDIR/nucl_gb.accession2taxid | cut -f 2 > $TAXDIR/accessions.txt
# Untar file
# tar -xvf $TAXDIR/taxdump.tar

# Build custom taxonomy lineage. Run this in $TAXDIR.
# R script should be present in $TAXDIR.
# This will create lineage.tsv file.
# Rscript qiime2_taxa.R nodes.dmp names.dmp accessions.txt
# Make the file tab separated with two columns
# sed -i 's/;/\t/' lineage.tsv
# sed -i '/accession.version/d' lineage.tsv
# Create a database of taxon lineage.
# python taxon_db.py taxon_db lineage.tsv
#

# Collect accessions from reference fasta.
cat $REF_FASTA | grep ">" | sed 's/ .*$//g' |sed 's/>//g' >$DATA/accessions.txt

# Create taxonomy file.
python -m recipes.code.get_taxa_lineage --accessions $DATA/accessions.txt --outfile $DATA/taxonomy.tsv

# Change to qiime2 environment
export CONDA_PS1_BACKUP=""
export JAVA_LD_LIBRARY_PATH=""
export CONDA_PATH_BACKUP=/home/www/miniconda3/bin
export CONDA_PREFIX=/home/www/miniconda3/envs/engine
export JAVA_HOME_CONDA_BACKUP=""


# Include the path to qiime2 environment here.
#source activate /Users/asebastian/miniconda3/envs/qiime2
source activate /home/www/miniconda3/envs/qiime2

# This is needed only in Linux machine.
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# Convert reference file to qiime2 artifact.
qiime tools import --input-path $REF_FASTA --output-path $REFERENCE --type 'FeatureData[Sequence]'

# Convert taxonomy file to qiime 2 artifact.
TAXONOMY=$DATA/taxonomy.qza
qiime tools import --input-path $DATA/taxonomy.tsv --output-path $TAXONOMY --type FeatureData[Taxonomy]

# Sample Metadata file.
SHEET={{sheet.value}}

# Import the input files as a qiime2 artifact.
echo "Importing data as qiime2 artifact."

{% if library.value == "SE" %}

qiime tools import --type 'SampleData[SequencesWithQuality]'  --input-path $DDIR \
--source-format CasavaOneEightSingleLanePerSampleDirFmt --output-path $DATA/data.qza

{% else %}

qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]'  --input-path $DDIR \
--source-format CasavaOneEightSingleLanePerSampleDirFmt --output-path $DATA/data.qza

{% endif %}

echo "Generating summary data."
qiime demux summarize --i-data $DATA/data.qza --o-visualization $DATA/data.qzv

# De-noising with Dada2 and feature table generation.
echo "De-noising with dada2. "

{% if library.value == "SE" %}

(time qiime dada2 denoise-single --verbose  --i-demultiplexed-seqs $DATA/data.qza --output-dir $DADA2 --p-n-threads $N \
--p-trunc-len $POS_RIGHT_F --p-trim-left $POS_LEFT_F ) 2>&1

{% else %}

(time qiime dada2 denoise-paired --verbose  --i-demultiplexed-seqs $DATA/data.qza --output-dir $DADA2 --p-n-threads $N \
--p-trunc-len-f $POS_RIGHT_F --p-trunc-len-r $POS_RIGHT_R --p-trim-left-f $POS_LEFT_F --p-trim-left-r $POS_LEFT_R ) 2>&1

{% endif %}

echo "Making FeatureTable files."
qiime feature-table summarize --i-table $DADA2/table.qza --o-visualization $DADA2/table.qzv --m-sample-metadata-file $SHEET

echo "Making FeatureData files"
qiime feature-table tabulate-seqs --i-data $DADA2/representative_sequences.qza --o-visualization $DADA2/representative_sequences.qzv

# Taxonomy classification.
echo "Running classify-consensus-blast taxonomy assignment."
qiime feature-classifier classify-consensus-blast --i-query $DADA2/representative_sequences.qza --i-reference-reads $REFERENCE \
--i-reference-taxonomy $TAXONOMY --p-evalue 1e-11 --p-strand plus --p-maxaccepts 1 --p-perc-identity 0.99 --output-dir $BLAST --verbose

echo "Generating visualization of classification.qza taxonomy file"
qiime metadata tabulate --m-input-file $BLAST/classification.qza --o-visualization $BLAST/classification.qzv

# Generate a bar plot of classification.
qiime taxa barplot --i-table $DADA2/table.qza --i-taxonomy $BLAST/classification.qza --m-metadata-file $SHEET --o-visualization $STORE/taxa-bar-plots.qzv

for id in $(seq 1 7)
do
# Create collapsed table at species level.
qiime taxa collapse  --i-table $DADA2/table.qza --i-taxonomy $BLAST/classification.qza --p-level $id --o-collapsed-table $BLAST/taxa_level${id}_table.qza

qiime tools export --output-dir $BLAST $BLAST/taxa_level${id}_table.qza
biom convert -i $BLAST/feature-table.biom -o $BLAST/taxa_level${id}_table.txt --to-tsv
done

# Change to engine environment.
source activate /Users/asebastian/miniconda3/envs/engine
#source activate /home/www/miniconda3/envs/qiime2

for id in $(seq 1 7)
do
# Format table to create heatmaps.
python -m recipes.code.qiime_counts_to_csv --infile $BLAST/taxa_level${id}_table.txt --outdir $BLAST  --taxa-level $id

done
# Remove intermediate files.
# rm -f $BLAST/*table*txt $BLAST/*table*qza


# Draw the heat maps for each csv report
python -m recipes.code.plotter $BLAST/*perc.csv --type heat_map

