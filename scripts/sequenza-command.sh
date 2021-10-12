#!/bin/bash

set -eu

#
# parse args
#
usage() {
  cat << EOS
Usage: `basename $0` [options]
  -s SAMPLE_ID           Sample ID (required)
  -t TUMOR_BAM           Tumor BAM file (required)
  -n NORMAL_BAM          Normal BAM file (required)
  -r REF_FASTA           FASTA file of GRCh37 (required)
  -y matched, unmatched  Type of normal (optional; default matched)
  -o HOM                 Threshold to select homozygous positions (optional, default see sequenza-utils)
  -e HET                 Threshold to select heterozygous positions (optional, default see sequenza-utils)
  -c THREADS             The number of threads (optional; default 1)
  -h                     Display help message
EOS
  exit 1
}

num_threads=1
normal_type="matched"
hom=""
het=""
while getopts s:t:n:y:r:o:e:c:h OPT; do
  case $OPT in
    s ) sample_id=$OPTARG;;
    t ) tumor_bam=$OPTARG;;
    n ) normal_bam=$OPTARG;;
    y ) normal_type=$OPTARG;;
    r ) reference_fasta=$OPTARG;;
    o ) hom=$OPTARG;;
    e ) het=$OPTARG;;
    c ) num_threads=$OPTARG;;
    h ) usage;;
    ? ) usage;;
  esac
done


if [[ "$normal_type" != "matched" && "$normal_type" != "unmatched" ]]
then
    >&2 echo "Invalid input: -y can only be set to 'matched' or 'unmatched'."
    exit 1
fi

opt_param_str=''
if [[ "$hom" != "" ]]; then
    opt_param_str="$opt_param_str --hom $hom"
fi

if [[ "$het" != "" ]]; then
    opt_param_str="$opt_param_str --het $het"
fi

#
# compute GC contents
#
reference_base=`basename $reference_fasta | sed -e 's/\.fa$\|\.fas$\|\.fasta$//'`
gc_wiggle="${reference_base}.gc50Base.wig.gz"
/usr/local/bin/sequenza-utils gc_wiggle -w 50 --fasta $reference_fasta -o $gc_wiggle

#
# run Sequenza
#
chromosomes="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y"

if [ $normal_type == "unmatched" ]; then
    echo "Unmatched normal mode"
    sequenza-utils bam2seqz -n ${tumor_bam} -t ${tumor_bam} -n2 ${normal_bam} \
        --fasta ${reference_fasta} -gc ${gc_wiggle} -o ${sample_id}.seqz.gz \
         -C ${chromosomes} --parallel ${num_threads} ${opt_param_str}
    # Unmatched normal processing will not create *_mutation.txt files,
    # but it is an output in matched normal processing and the CWL
    # requires this output
    touch empty_mutations.txt
else
    echo "Matched normal mode"
    sequenza-utils bam2seqz -n ${normal_bam} -t ${tumor_bam} \
        --fasta ${reference_fasta} -gc ${gc_wiggle} -o ${sample_id}.seqz.gz \
         -C ${chromosomes} --parallel ${num_threads} ${opt_param_str}
fi


{
  for chr in $chromosomes; do
    if [[ $chr = "1" ]]; then
      zcat ${sample_id}_1.seqz.gz
    else
      zcat ${sample_id}_${chr}.seqz.gz | tail -n +2
    fi
  done
} | sequenza-utils seqz_binning --seqz - -w 50 \
  -o ${sample_id}.small.seqz.gz

Rscript /opt/sequenza-command.R ${sample_id} ${sample_id}.small.seqz.gz
rm ${sample_id}.small.seqz.gz
