#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
id: Sequenza-command
label: Sequenza-command

requirements:
  DockerRequirement:
    dockerPull: waszaklab/sequenza-pipeline:v0.8
  ResourceRequirement:
    ramMin: 8192

baseCommand: ["bash", "/opt/sequenza-command.sh"]

inputs:
  sample-id:
    type: string
    inputBinding:
      position: 1
      prefix: -i
  tumor-bam:
    type: File
    inputBinding:
      position: 2
      prefix: -t
    secondaryFiles:
      - .bai
  normal-bam:
    type: File
    inputBinding:
      position: 3
      prefix: -n
    secondaryFiles:
      - .bai
  normal-type:
    type: string?
    default: 'matched'
    inputBinding:
        position: 4
        prefix: -y
  sex:
    type: string?
    default: 'female'
    inputBinding:
        position: 5
        prefix: -s
  reference-fasta:
    type: File
    inputBinding:
      position: 6
      prefix: -r
    secondaryFiles:
      - .fai
  hom_threshold:
    type: float?
    doc: 'Threshold to select homozygous positions, e.g. 0.9'
    inputBinding:
      position: 7
      prefix: -o
  het_threshold:
    type: float?
    doc: 'Threshold to select heterozygous positions, e.g. 0.25'
    inputBinding:
      position: 8
      prefix: -e
  cellularity:
    type: string?
    doc: 'Candidate cellularity values. Single value (e.g. 0.8) or MIN,MAX,STEP (e.g. 0.1,1,0.01)'
    inputBinding:
        position: 9
        prefix: -c
  ploidy:
    type: string?
    doc: 'Candidate ploidy values. Single value (e.g. 2) or MIN,MAX,STEP (e.g. 1,7,0.1)'
    inputBinding:
        position: 10
        prefix: -p
  num-threads:
    type: int
    inputBinding:
      position: 11
      prefix: -d

outputs:
  seqz:
    type: File[]
    outputBinding:
      glob: '*.seqz.gz'
  cn_bars:
    type: File
    outputBinding:
      glob: '*_CN_bars.pdf'
  cp_contours:
    type: File
    outputBinding:
      glob: '*_CP_contours.pdf'
  alternative_fit:
    type: File
    outputBinding:
      glob: '*_alternative_fit.pdf'
  alternative_solutions:
    type: File
    outputBinding:
      glob: '*_alternative_solutions.txt'
  chromosome_depths:
    type: File
    outputBinding:
      glob: '*_chromosome_depths.pdf'
  chromosome_view:
    type: File
    outputBinding:
      glob: '*_chromosome_view.pdf'
  confints_cp:
    type: File
    outputBinding:
      glob: '*_confints_CP.txt'
  gc_plots:
    type: File
    outputBinding:
      glob: '*_gc_plots.pdf'
  genome_view:
    type: File
    outputBinding:
      glob: '*_genome_view.pdf'
  model_fit:
    type: File
    outputBinding:
      glob: '*_model_fit.pdf'
  mutations:
    type: File
    outputBinding:
      glob: '*_mutations.txt'
  segments:
    type: File
    outputBinding:
      glob: '*_segments.txt'
  sequenza_cp_table:
    type: File
    outputBinding:
      glob: '*_sequenza_cp_table.RData'
  sequenza_extract:
    type: File
    outputBinding:
      glob: '*_sequenza_extract.RData'
  sequenza_log:
    type: File
    outputBinding:
      glob: '*_sequenza_log.txt'
