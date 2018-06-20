set -ue

# The input directory for the data
DDIR=$(dirname {{reads.value}})

# The reference sequence to classify against.
REFERENCE={{reference.value}}

# Taxonomy file.
TAXONOMY={{taxonomy.value}}

# Sample Metadata file.
SHEET={{sheet.value}}

# Library type of input reads.
#LIBRARY={{library.value}}

# Output generated while running the tool.
RUNLOG=runlog/runlog.txt

# Position at which forward read sequences to be truncated from at 3' end.
POS_RIGHT_F={{trunc_right_f.value}}

#Position at which reverse read sequences to be truncated from at 3' end.
POS_RIGHT_R={{trunc_right_r.value}}

#Position until which forward read sequences to be truncated from at 5' end.
POS_LEFT_F={{trunc_left_f.value}}

#Position until which reverse read sequences to be truncated from at 5' end.
POS_LEFT_R={{trunc_left_r.value}}

# Wipe clean the runlog.
echo "" > $RUNLOG

# No. of threads to use.
N=4

# Create main store for results
STORE=results
mkdir -p $STORE

# Directory that holds DADA2 results
DADA2=$STORE/dada2

# Directory that holds BLAST+ taxonomy classification results.
BLAST=$STORE/blast-taxa

# Import the input files as a qiime2 artifact.
echo "Importing data as qiime2 artifact."
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]'  --input-path $DDIR \
--source-format CasavaOneEightSingleLanePerSampleDirFmt --output-path $STORE/data.qza

echo "Generating summary data."
qiime demux summarize --i-data $STORE/data.qza --o-visualization $STORE/data.qzv

# De-noising with Dada2 and feature table generation.
echo "De-noising with dada2."
qiime dada2 denoise-paired --verbose  --i-demultiplexed-seqs $STORE/data.qza --output-dir $DADA2 --p-n-threads $N \
--p-trunc-len-f $POS_RIGHT_F --p-trunc-len-r $POS_RIGHT_R --p-trim-left-f $POS_LEFT_F --p-trim-left-r $POS_LEFT_R

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

qiime taxa barplot --i-table $DADA2/table.qza --i-taxonomy $BLAST/classification.qza --m-metadata-file $SHEET --o-visualization $STORE/taxa-bar-plots.qzv
