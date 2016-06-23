
dir=$1                  #project dir
sid=$2                  #sample id

if [ ! -d "$dir/03.ReadsMapping" ]; then
        mkdir "$dir/03.ReadsMapping"
fi

if [ ! -d "$dir/03.ReadsMapping/$sid" ]; then
    mkdir "$dir/03.ReadsMapping/$sid"
fi

if [ ! -d "$dir/03.ReadsMapping/$sid/ref" ]; then
    mkdir "$dir/03.ReadsMapping/$sid/ref"
fi


#edit here

sfolder="$dir/03.ReadsMapping/$sid"
clean_fq1="$sfolder/$sid.clean.1.fq"
clean_fq2="$sfolder/$sid.clean.2.fq"
minLengthContig="$sfolder/$sid.lengthFiltered.contig.fa"
refScaftigs="$sfolder/ref/$sid.scaftigs.fa"
pesoap="$sfolder/$sid.pe.soap"
sesoap="$sfolder/$sid.se.soap"
soaplog="$sfolder/$sid.log"


cd "$sfolder/ref"
ln -s $minLengthContig $refScaftigs
/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/04.MGsoap/lib/2bwt-builder $refScaftigs


cd $sfolder
/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/04.MGsoap/lib/soap2.21 -l 32 -m 200 -x 600 -s 40 -v 13 -g 5 -r 1 -p 8   -a  $clean_fq1  -b $clean_fq2 -D $refScaftigs  -o $pesoap  -2 $sesoap  2>$soaplog


covFolder="$sfolder/coverage"
/System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/04.MGsoap/lib/soap.coverage -cvg    -depthsingle soap.coverage.depthsingle -o coverage.depth -plot soap.coverage.plot 0 400  -p 8   -i $pesoap $sesoap  -refsingle  2> cover.log

perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/04.MGsoap/lib/cover_table.pl  coverage.depth soap.coverage.depthsingle coverage.depth.table

#perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/04.MGsoap/lib/assemble_infomation_stat.pl  --data_list /Disk04/Project/Micro/liyanli/A540_BeeMetaGenome/02.Assembly/assembly.scaftigs_500.ss.list --soap_log /Disk04/Project/Micro/liyanli/A540_BeeMetaGenome/03.ReadsMapping/soap.log.list --outdir /Disk04/Project/Micro/liyanli/A540_BeeMetaGenome/03.ReadsMapping --outfile assembly_stat.txt


perl /System/Pipline/DNA/DNA_Micro/MetaGenome_pipeline/MetaGenome_pipeline_V2.2/lib/01.QC_Assembly/04.MGsoap/lib/line_diagram.pl   --signh --frame -x_title 'Sequencing depth(X)' -y_title 'Sequencing depth frequence'   soap.coverage.plot >coverage_depth.svg
/usr/bin/convert coverage_depth.svg coverage_depth.png

/usr/bin/convert coverage_depth.svg coverage_depth.png

