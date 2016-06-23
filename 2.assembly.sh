
dir=$1                  #project dir
sid=$2                  #sample id

if [ ! -d "$dir/02.Assembly" ]; then
        mkdir "$dir/02.Assembly"
fi

if [ ! -d "$dir/02.Assembly/$sid" ]; then
    mkdir "$dir/02.Assembly/$sid"
fi

#edit here

sfolder="$dir/02.Assembly/$sid"
clean_fq1="$sfolder/$sid.clean.1.fq"
clean_fq2="$sfolder/$sid.clean.2.fq"

cd $sfolder
/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/software/Assembly/megahit-master/megahit -1 $clean_fq1  -2 $clean_fq2 -o $sfolder/megahit

finalContig="$sfolder/megahit/final.contigs.fa"
minLengthContig="$sfolder/$sid.lengthFiltered.contig.fa"
minLengthContigLength="$sfolder/$sid.lengthFiltered.contig.fa.len"
lenSVG="$sfolder/$sid.len.svg"
lenPNG="$sfolder/$sid.len.png"

#edit here
statistical_length=500
contig_min_length=500
perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/02.Assembly/lib/Scafseq.cut.pl  --length $statistical_length,$statistical_length  --cutoff $contig_min_length  --file $finalContig --sp $sid --output $minLengthContig

perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/00.Commbin/get_len_fa.pl $minLengthContig >$minLengthContigLength

perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/02.Assembly/../../00.Commbin/line_diagram.pl -fredb2 -fredb -numberc -vice -ranky2 "0:2" -samex -bar -frame  -y_title  "Frequence(#)" -y_title2 "Percentage(%)" -barstroke black -barstroke2 black -symbol -signs "Frequence(#),Percentage(%)" -color "cornflowerblue,gold" -linesw 2 -opacity 80 -opacity2 40  -sym_xy p0.6,p0.98  --sym_frame  -x_mun 0,500,6  -x_title "Scaftig Length(bp)"   --h_title 'Bee-E Length Distribution' $minLengthContigLength  >$lenSVG

/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/software/svg2xxx_release/svg2xxx -t png $lenSVG



