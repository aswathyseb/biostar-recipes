set -ue

# The input directory for the data
DDIR=$(dirname {{reads.value}})

# The reference sequence to classify against.
REFERENCE={{reference.value}}

# Taxonomy file.
TAXONOMY={{taxonomy.value}}

# Sample Metadata file.
SHEET = {{sheet.value}}

# Library type of input reads.
LIBRARY={{library.value}}

# Output generated while running the tool.
RUNLOG=runlog/runlog.txt

# Wipe clean the runlog.
echo "" > $RUNLOG

# No. of threads to use.
N=4

{% if library.value == "SE" %}
    # SE specific settings.
    IMPORT_TYPE=SampleData[SequencesWithQuality]
    DADA2_COMMAND=denoise-single
{% else %}
    IMPORT_TYPE=SampleData[PairedEndSequencesWithQuality]
    DADA2_COMMAND=denoise-paired
{% endif %}

# Create main store for results
STORE=results
mkdir -p $STORE

# Import the input files as a qiime2 artifact.

echo "Importing data as qiim2 artifact."
qiime tools import --type $IMPORT_TYPE --input-path $DDIR --source-format CasavaOneEightSingleLanePerSampleDirFmt \
--output-path $STORE data.qza

echo "Generating summary data:"
qiime demux summarize --i-data $STORE/data.qza --o-visualization $STORE/run2.qzv

echo "Denoising with dada2".
qiime dada2 $DADA2_COMMAND --verbose  --i-demultiplexed-seqs $STORE/data.qza --p-trunc-len-f




