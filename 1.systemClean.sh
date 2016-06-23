if [ $# -lt 3 ];
then echo "sh $0 projectDir sampleID rawFqDir

Notice: assume rawFqDir contains
rawFqDir/sid.R1.fastq.gz

"
exit 0;
fi

dir=$1                  #project dir
sid=$2                  #sample id
rawfqdir=$3             #coped fq folder, raw/sid/sid.R1.fastq.gz

if [ ! -d "$dir/01.DataClean/" ]; then
        mkdir "$dir/01.DataClean/"
fi

if [ ! -d "$dir/01.DataClean/$sid" ]; then
    mkdir "$dir/01.DataClean/$sid"
fi

#edit here
raw_fq1="$rawfqdir/$sid.R1.fastq.gz"
raw_fq2="$rawfqdir/$sid.R2.fastq.gz"
fq1="$dir/01.DataClean/$sid/$sid.raw.1.fq.gz"
fq2="$dir/01.DataClean/$sid/$sid.raw.2.fq.gz"


ln -s $raw_fq1 $fq1
ln -s $raw_fq2 $fq2

sfolder="$dir/01.DataClean/$sid"
clean_fq1="$sfolder/$sid.clean.1.fq"
clean_fq2="$sfolder/$sid.clean.2.fq"
fq1check="$sfolder/$sid.fq1.check"
fq2check="$sfolder/$sid.fq2.check"

cd $sfolder
echo "$fq1,$fq2" >$sfolder/data.list
/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/software/QC/readfq.v8_meta  -z -q  38,40  -n  10 -l 15  -f  $sfolder/data.list  -3 $clean_fq1 -4 $clean_fq2 1>$sid.readfq_mata.stat


/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/software/QC/fqcheck  -r $clean_fq1 -c $fq1check
/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/software/QC/fqcheck  -r $clean_fq2 -c $fq2check


perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/01.QC/lib/distribute_fqcheck.pl  $fq1check $fq2check  -o $sfolder


