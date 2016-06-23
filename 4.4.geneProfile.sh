dir=$1                  #project dir
sid=$2                  #sample id

if [ ! -d "$dir/Gene_prof" ]; then
        mkdir "$dir/Gene_prof"
fi

if [ ! -d "$dir/Gene_prof/$sid" ]; then
    mkdir "$dir/Gene_prof/$sid"
fi


#edit here

sfolder="$dir/Gene_prof/$sid"
unigene="$dir/04.GeneSet/Index/Uniq.Genes.CDS.cdhit.fa.index"

cd $sfolder
ls "$dir/Gene_abundance/*/*.abundance.gz" |perl -e  'while (<>){chomp;my $sam=(split /\//,$_)[-1];$sam=~s/\.abundance\.gz$//;print "$sam\t$sam\t$_\n";}' >abundance.list
/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/02.Gene_set/MetaGeneMark_linux64/profile_v1.0  -i abundance.list -p "$dir/Uniq.Genes"
