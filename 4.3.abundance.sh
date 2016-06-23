dir=$1                  #project dir
sid=$2                  #sample id

if [ ! -d "$dir/Gene_abundance" ]; then
        mkdir "$dir/Gene_abundance"
fi

if [ ! -d "$dir/Gene_abundance/$sid" ]; then
    mkdir "$dir/Gene_abundance/$sid"
fi


#edit here

sfolder="$dir/Gene_abundance/$sid"
unigene="$dir/04.GeneSet/Index/Uniq.Genes.CDS.cdhit.fa.index"
geneLen="$dir/04.GeneSet/UniqGenes/Uniq.Genes.CDS.cdhit.fa.len"
clean_fq1="$dir/01.DataClean/$sid/$sid.clean.1.fq"
clean_fq2="$dir/01.DataClean/$sid//$sid.clean.2.fq"

cd $sfolder
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/02.Gene_set/MetaGeneMark_linux64/abundance_v1.0.pl -m 4 -s 32 -r 1 -n 150 -x 500 -v 15 -i 0.9 -t 6 -f Y -z Y   -d $unigene -g $geneLen -a $clean_fq1 -b $clean_fq2 -p $sid
