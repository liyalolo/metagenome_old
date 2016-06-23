dir=$1                  #project dir
sid=$2                  #sample id

if [ ! -d "$dir/04.GeneSet/UniqGenes" ]; then
    mkdir "$dir/04.GeneSet/UniqGenes"
fi


sfolder="$dir/04.GeneSet/UniqGenes"

cd $sfolder
cat "$dir/04.GeneSet/GenePredict/*/*.protein.fa" >$sfolder/total.protein.fa
cat "$dir/04.GeneSet/GenePredict/*/*.CDS.fa" >$sfolder/total.gene.fa


/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/software/cd-hit-v4.5.8/cd-hit-est -i total.gene.fa -o Uniq.Genes.CDS.cdhit.fa -T 0  -c 0.9 -n 8 -M 0
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/03.UniqSeq/lib/get_table.pl --in_clstr $sfolder/Uniq.Genes.CDS.cdhit.fa.clstr --output $sfolder/Uniq.Genes.CDS.table.txt

#get peptide from total.pep.fa
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/02.Gene_set/MetaGeneMark_linux64/get_pep_fa.pl $sfolder/Uniq.Genes.CDS.cdhit.fa  $sfolder/total.pep.fa >$sfolder/Uniq.Genes.protein.cdhit.fa

perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/00.Commbin/get_len_fa.pl $sfolder/Uniq.Genes.CDS.cdhit.fa >$sfolder/Uniq.Genes.CDS.cdhit.fa.len
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/00.Commbin/line_diagram.pl -fredb2 -fredb -numberc -vice -ranky2 "0:2" -samex -bar -frame  -y_title "Frequence(#)" -y_title2 "Percentage(%)" -barstroke black -barstroke2 black -symbol -signs "Frequence(#),Percentage(%)" -color "cornflowerblue,gold" -linesw 2 -opacity 80 -opacity2 40  -sym_xy p0.6,p0.98  --sym_frame  -x_mun 0,200,8  -x_title "ORF Length(bp)" --h_title 'UniqGene Length Distribution' $sfolder/Uniq.Genes.CDS.cdhit.fa.len >$sfolder/Uniq.Genes.CDS.cdhit.fa.len.svg
/usr/bin/convert -density 120 $sfolder/Uniq.Genes.CDS.cdhit.fa.len.svg  $sfolder/Uniq.Genes.CDS.cdhit.fa.len.png


#sine stat xls
cdsFaList="$sfolder/Uniq.Genes.CDS.cdhit.fa.list"
cdsStatXls="Uniq.Genes.CDS.cdhit.fa.stat.xls"
ls "$dir/04.GeneSet/GenePredict/*/*CDS.fa  $sfolder/Uniq.Genes.CDS.cdhit.fa" >$cdsFaList
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/02.Gene_set/../00.Commbin/static_genepedict.total.pl $cdsFaList $cdsStatXls


if [ ! -d "$dir/04.GeneSet/Index" ]; then
    mkdir "$dir/04.GeneSet/Index"
fi

sfolder="$dir/04.GeneSet/Index"
cd $sfolder
ln -s "$dir/04.GeneSet/UniqGenes/Uniq.Genes.CDS.cdhit.fa"
/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/04.MGsoap/lib/2bwt-builder Uniq.Genes.CDS.cdhit.fa 2>log


