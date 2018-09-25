# This recipe download sequencing data from SRA
# then performs quality control on it.

# Stop the script on errors.
set -ue

# Set the SRA number.
SRA=SRR519926

# Download 1000 reads from SRA.
fastq-dump --split-files -X 10000 $SRA

# Create a directory to store fastqc reports in.
mkdir -p fastqc_reports

# Run the fastqc report on the data.
fastqc *.fastq -o fastqc_reports

# Create the adapter sequence used for trimming.
echo ">illumina" > adapter.fa
echo "AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC" >> adapter.fa

# Run trimmomatic on the data.
trimmomatic PE ${SRA}_1.fastq ${SRA}_2.fastq -baseout ${SRA}.trimmed.fq  ILLUMINACLIP:adapter.fa:2:30:5 SLIDINGWINDOW:4:20

# Run trimmomatic on the trimmed data.
fastqc *.fq -o fastqc_reports


