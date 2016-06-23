if [ $# -lt 3 ];
then echo "sh project.sh sample.list stepID projectDir rawFqDir

stepID:1,2,3
step1 /Disk04/Project/Micro/liyanli/workflow/template_shell/1.systemClean.sh
step2 /Disk04/Project/Micro/liyanli/workflow/template_shell/2.assembly.sh
step31 /Disk04/Project/Micro/liyanli/workflow/template_shell/3.1.map.sh
step32 /Disk04/Project/Micro/liyanli/workflow/template_shell/3.2.assembly.stat.sh
step41 /Disk04/Project/Micro/liyanli/workflow/template_shell/4.1.genePredict.mgm.sh
step42 /Disk04/Project/Micro/liyanli/workflow/template_shell/4.2.genePredict.cdhit.sh
step43 /Disk04/Project/Micro/liyanli/workflow/template_shell/4.3.abundance.sh
step44 /Disk04/Project/Micro/liyanli/workflow/template_shell/4.4.geneProfile.sh
step51 /Disk04/Project/Micro/liyanli/workflow/template_shell/5.1.blast.sh
step52 /Disk04/Project/Micro/liyanli/workflow/template_shell/5.2.pca_nmds_shannon.heatmap.topBarplot.sh



";
    exit 0;
fi

step1='/Disk04/Project/Micro/liyanli/workflow/template_shell/1.systemClean.sh';
step2="/Disk04/Project/Micro/liyanli/workflow/template_shell/2.assembly.sh";
step31="/Disk04/Project/Micro/liyanli/workflow/template_shell/3.1.map.sh";
step32="/Disk04/Project/Micro/liyanli/workflow/template_shell/3.2.assembly.stat.sh";
step41="/Disk04/Project/Micro/liyanli/workflow/template_shell/4.1.genePredict.mgm.sh";
step42="/Disk04/Project/Micro/liyanli/workflow/template_shell/4.2.genePredict.cdhit.sh";
step43="/Disk04/Project/Micro/liyanli/workflow/template_shell/4.3.abundance.sh";
step44="/Disk04/Project/Micro/liyanli/workflow/template_shell/4.4.geneProfile.sh";
step51="/Disk04/Project/Micro/liyanli/workflow/template_shell/5.1.blast.sh";
step52="/Disk04/Project/Micro/liyanli/workflow/template_shell/5.2.pca_nmds_shannon.heatmap.topBarplot.sh";


sampleList=$1
step=$2
projectDir=$3
rawFqDir=$4

if [ ! -d "$projectDir/shell" ]; then
    mkdir "$projectDir/shell"
fi


if [ ! -d "$projectDir/shell/step$step" ]; then
    mkdir "$projectDir/shell/step$step"
fi

sh_dir="$projectDir/shell/step$step"

case $step in
        "1")
                runStep=$step1
                ;;
        "2")
                runStep=$step2
                ;;
        "31")
                runStep=$step31
                ;;
        "32")
                runStep=$step32
                ;;
        "41")
                runStep=$step41
                ;;
        "42")
                runStep=$step42
                ;;
        "*")
                echo "wrong parameters"
                ;;
esac


j=16
for i in `cat $sampleList`;
do
        sh_name="$sh_dir/step$step.$i.sh";
        echo "sh $runStep $projectDir $i $rawFqDir" >$sh_name;
        echo -e "$sh_name\n" >"$sh_dir/step$step.sh"
        j=$(($j+1));
        if [ $j -gt 20 ];
        then $j=17
        fi
        echo "qsub -cwd -l h=tgs-$j -q tmp1.q -P tmp1 $sh_name"
done

echo -e "\n\n\n"


for i in `cat $sampleList`;
do
        echo "qsub -cwd -l vf=6g $sh_name"
done


echo -e "\n\n\n"

