
dir=$1                  #project dir
sid=$2                  #sample id
rawfqdir=$3             #coped fq folder, raw/sid/sid.R1.fastq.gz

if [ ! -d "$dir/02.Assembly" ]; then
        mkdir "$dir/02.Assembly"
fi

if [ ! -d "$dir/02.Assembly/stat" ]; then
    mkdir "$dir/02.Assembly/stat"
fi

#edit here

sfolder="$dir/02.Assembly/stat"
clean_fq1="$sfolder/$sid.clean.1.fq"
clean_fq2="$sfolder/$sid.clean.2.fq"
contig="$sfolder/megahit/final.contigs.fa"

statistical_length=500
contig_min_length=500

cd $sfolder
datalist="$sfolder/scaftigs.ss.list"
ls "$dir/02.Assembly/*/*.scaftigs.500.ss.txt" >$datalist
soaplog=/Disk04/Project/Micro/liyanli/A540_BeeMetaGenome/03.ReadsMapping/soap.log.list


perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/04.MGsoap/lib/assemble_infomation_stat.pl  --data_list $datalist  --soap_log  $soaplog  --outdir  $sfolder  --outfile assembly_stat.txt



