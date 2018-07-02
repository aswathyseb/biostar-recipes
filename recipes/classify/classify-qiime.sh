set -ue

export JAVA_LD_LIBRARY_PATH=""

# Include the path to qiime2 environment here.
#source activate /Users/asebastian/miniconda3/envs/qiime2
source activate /home/www/miniconda3/envs/qiime2

# This is needed only in Linux machine.
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# The input directory for the data
DDIR=$(dirname {{reads.value}})

FILE=$(basename {{reads.value}})

if [[ $FILE == *.zip ]]; then
echo "unzipping"
unzip $DDIR/$FILE -d $DDIR/data
DDIR=$DDIR/data
fi

# The reference sequence to classify against.
REFERENCE={{reference.value}}

# Taxonomy file.
TAXONOMY={{taxonomy.value}}

# Sample Metadata file.
SHEET={{sheet.value}}

# Library type of input reads.
LIBRARY={{library.value}}

# Output generated while running the tool.
RUNLOG=runlog/runlog.txt
mkdir -p runlog

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

# Create main store for results.
STORE=results
mkdir -p $STORE

# Directory that holds input data.
DATA=$STORE/data
mkdir -p $DATA

# Directory that holds DADA2 results
DADA2=$STORE/dada2

# Directory that holds BLAST+ taxonomy classification results.
BLAST=$STORE/blast-taxa

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
echo "De-noising with dada2."

{% if library.value == "SE" %}

qiime dada2 denoise-single --verbose  --i-demultiplexed-seqs $DATA/data.qza --output-dir $DADA2 --p-n-threads $N \
--p-trunc-len $POS_RIGHT_F --p-trim-left $POS_LEFT_F

{% else %}

qiime dada2 denoise-paired --verbose  --i-demultiplexed-seqs $DATA/data.qza --output-dir $DADA2 --p-n-threads $N \
--p-trunc-len-f $POS_RIGHT_F --p-trunc-len-r $POS_RIGHT_R --p-trim-left-f $POS_LEFT_F --p-trim-left-r $POS_LEFT_R

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

qiime taxa barplot --i-table $DADA2/table.qza --i-taxonomy $BLAST/classification.qza --m-metadata-file $SHEET --o-visualization $STORE/taxa-bar-plots.qzv
