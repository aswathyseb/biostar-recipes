set -ue

# The input directory for the data
DDIR=$(dirname {{reads.value}})
FILE=$(basename {{reads.value}})

# Unzip if the data is zipped
if [[ $FILE == *.zip ]]; then
echo "unzipping"
unzip -q -o $DDIR/$FILE -d $DDIR/data
DDIR=$DDIR/data
fi

# The list of files in the directory.
SHEET={{sheet.value}}

# Library type of input reads.
LIBRARY={{library.value}}

# Acceptable error rate.
ERROR={{error_rate.value}}

# Output generated while running the tool.
RUNLOG=runlog/runlog.txt

# Wipe clean the runlog.
echo "" > $RUNLOG

# How many parallel processes to allow.
N=2

# Create main store for results
#STORE=results
#mkdir -p $STORE

# Directory to store reads with correct PCR barcode.
CORRECT=correct-barcodes
mkdir -p $CORRECT

# Directory to store reads with incorrect PCR barcode.
INCORRECT=incorrect-barcodes
mkdir -p $INCORRECT

# Validate sample sheet
url="https://gist.githubusercontent.com/aswathyseb/5d695e86a80cf9b86a0be57eb635bf6e/raw/91bcbfbee957d9d38c04f3f947eeed500e94ee90/exists.py"
curl -s $url >validate.py
python validate.py $DDIR $SHEET

{% if library.value == "SE" %}
    # Filter out reads with in correct PCR barcode.
    cat ${SHEET} | parallel --header : --colsep , -j 2 cutadapt -g ^{fwd_barcode} -e $ERROR --no-trim $DDIR/{read1} -o $CORRECT/{read1} --untrimmed-output $INCORRECT/incorrect_barcode_{read1} >>$RUNLOG

{% else %}
    # Filter out reads with in correct PCR barcode.
    cat ${SHEET} | parallel --header : --colsep , -j 2 cutadapt -g ^{fwd_barcode} -G ^{rev_barcode} \
    -e $ERROR --pair-filter any --no-trim $DDIR/{read1}  $DDIR/{read2}  -o $CORRECT/{read1} -p $CORRECT/{read2} --untrimmed-output $INCORRECT/incorrect_barcode_{read1} --untrimmed-paired-output $INCORRECT/incorrect_barcode_{read2} >>$RUNLOG

{% endif %}


# Read stats after PCR barcode check.
seqkit stat $CORRECT/* >correct-barcode-stats.txt
seqkit stat $INCORRECT/* >incorrect-barcode-stats.txt


# zip output files.
zip -q -r $CORRECT.zip $CORRECT
zip -q -r $INCORRECT.zip $INCORRECT

# remove *.gz files
rm -rf $CORRECT $INCORRECT


