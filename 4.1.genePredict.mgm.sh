
dir=$1                  #project dir
sid=$2                  #sample id

if [ ! -d "$dir/04.GeneSet" ]; then
        mkdir "$dir/04.GeneSet"
fi

if [ ! -d "$dir/04.GeneSet/GenePredict" ]; then
    mkdir "$dir/04.GeneSet/GenePredict"
fi

if [ ! -d "$dir/04.GeneSet/GenePredict/$sid" ]; then
    mkdir "$dir/04.GeneSet/GenePredict/$sid"
fi


#edit here
sfolder="$dir/04.GeneSet/GenePredict/$sid"
finalContig="$dir/02.Assembly/$sid/megahit/final.contigs.fa"

cd $sfolder
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/02.Gene_set/MetaGeneMark_linux64/screening_length.pl $finalContig 300 $sid.300.fa

/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/02.Gene_set/MetaGeneMark_linux64/gmhmmp -a  -d -f G -p 1   -m /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/02.Gene_set/MetaGeneMark_linux64/MetaGeneMark_v1.mod -o $sid.mgm $sid.300.fa
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/02.Gene_set/MetaGeneMark_linux64/Modification.mgmFile.pl -mgm $sid.mgm -mark $sid


perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/02.Gene_set/MetaGeneMark_linux64/nt_from_gff.pl $sid.rename.mgm >$sid.CDS.fa
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/02.Gene_set/MetaGeneMark_linux64/aa_from_gff.pl $sid.rename.mgm >$sid.protein.fa
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/02.Gene_set/MetaGeneMark_linux64/mgm2gff.pl $sid.rename.mgm


perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/00.Commbin/static_genepedict.pl $sid.CDS.fa $sid.CDS.fa.stat.xls
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/00.Commbin/get_len_fa.pl $sid.CDS.fa >$sid.CDS.fa.len
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/00.Commbin/line_diagram.pl -fredb2 -fredb -numberc -vice -ranky2 "0:2" -samex -bar -frame  -y_title "Frequence(#)" -y_title2 "Percentage(%)" -barstroke black -barstroke2 black -symbol -signs "Frequence(#),Percentage(%)" -color "cornflowerblue,gold" -linesw 2 -opacity 80 -opacity2 40  -sym_xy p0.6,p0.98  --sym_frame  -x_mun 0,200,8  -x_title "ORF Length(bp)" --h_title 'Gene Length Distribution' $sid.CDS.fa.len  >$sid.CDS.fa.len.svg
/usr/bin/convert  -density 120 $sid.CDS.fa.len.svg $sid.CDS.fa.len.png



