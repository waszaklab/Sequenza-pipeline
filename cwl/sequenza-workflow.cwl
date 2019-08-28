#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
id: Sequenza-workflow
label: Sequenza-workflow

requirements:
  DockerRequirement:
    dockerPull: mfrkn/sequenza-pipeline:latest

baseCommand: ["bash", "/opt/gc.sh"]
inputs:
  reference-fasta:
    type: File
    inputBinding:
      position: 1
outputs:
  gc-wiggle:
    type: File
    outputBinding:
      glob: '*.gc50Base.wig.gz'