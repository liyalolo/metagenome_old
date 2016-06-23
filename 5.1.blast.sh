
dir=$1                  #project dir
sid=$2                  #sample id

if [ ! -d "$dir/05.TaxAnnotation" ]; then
    mkdir "$dir/05.TaxAnnotation"
fi

if [ ! -d "$dir/05.TaxAnnotation/Blast" ]; then
    mkdir "$dir/05.TaxAnnotation/Blast"
fi


sfolder="$dir/05.TaxAnnotation/Blast"
unigene="$dir/05.TaxAnnotation/UniqGenes/Uniq.Genes.CDS.cdhit.fa"
unigeneProtein="$dir/05.TaxAnnotation/UniqGenes/Uniq.Genes.protein.cdhit.fa"
profile="$dir/04.GeneSet/Gene_prof/Uniq.Genes.abundance.profile"

cd $sfolder
/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/software/Function/blastall -i $unigeneGene -d /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/database/MicroNT_20141127/AFVB.nt.fa  -o Unigene.blast.out  -p blastn -F F -m 8 -a 12 -e 1e-5 -b 50


Micro_stat="$dir/05.TaxAnnotation/Micro_stat"
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/03.Taxonomy/lib/LCA_anno_flow.pl --depth $profile -m8 Unigene.blast.out --output Uniq.Genes -outdir $Micro_stat

perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/03.Taxonomy/lib/get_taxonomy_abundace.pl -mat Uniq.Genes.tax.depth.xls --outdir Relative --output Uniq.Genes

