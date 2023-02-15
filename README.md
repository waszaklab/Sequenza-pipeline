# Sequenza-pipeline
Analyze somatic copy number alteration of tumor using [Sequenza](http://www.cbs.dtu.dk/biotools/sequenza/). WGS/WES BAM files of matched tumor and normal are analyzed.

## Requirements
- [cwltool](https://github.com/common-workflow-language/cwltool)
- [Docker](https://www.docker.com/) or [Singularity](https://sylabs.io/)

## Usage for a single pair of tumor/normal
#### 1. Pull docker image from Docker Hub.
```
docker pull waszaklab/sequenza-pipeline:v0.9
```
#### 2. Download pipeline
```
git clone https://github.com/waszaklab/Sequenza-pipeline.git
cd Sequenza-pipeline
```
#### 3. Prepare config file
Specify sample ID, tumor BAM, normal BAM, reference FASTA, and the number of threads for computation in a YAML-format config file. See `example/sequenza-command.yaml`.
#### 4. Run pipeline
```
cwl-runner sequenza-command.cwl config.yaml
```
