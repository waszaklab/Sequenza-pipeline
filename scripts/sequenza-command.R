.libPaths(c('/usr/local/lib/R/site-library', '/usr/lib/R/site-library', '/usr/lib/R/library'))
suppressPackageStartupMessages({
  library(optparse)
  library(sequenza)
})

option_list = list(
  make_option(c("-f", "--seqz-file"), type="character", default=NULL, 
              help="Seqz file as returned by sequenza-utils", metavar="character"),
  make_option(c("-i", "--id"), type="character", default=NULL, 
              help="Sample ID", metavar="character"),
  make_option(c("-s", "--sex"), type="character", default='female', 
              help="Sex of the dample (male, female)", metavar="character"),
  make_option(c("-c", "--cellularity"), type="character", default='0.1,1,0.01', 
              help="Candidate cellularity values to sequenza.fit(). Single value or comma separated list of format min,max,step", metavar="character"),
  make_option(c("-p", "--ploidy"), type="character", default='1,7,0.1', 
              help="Candidate ploidy values to sequenza.fit(). Single value or comma separated list of format min,max,step", metavar="character")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

if(is.null(opt$`seqz-file`) || length(opt$`seqz-file`) < 1){
  stop('Please provide valid seqz-file. (-f)')
}
if(is.null(opt$`id`) || length(opt$`id`) < 1){
  stop('Please provide valid sample ID. (-i)')
}

seqz.file <- opt$`seqz-file`
sample.id <- opt$id
female <- opt$sex == 'female'

get_ranged_values_from_input <- function(s){
  if(grepl(',', s, fixed=T)){
    t <- sapply(strsplit(s, ',', fixed = T)[[1]], as.numeric)
    return(seq(t[1], t[2], t[3]))
  }else{
    return(as.numeric(s))
  }
}

cellularity <- get_ranged_values_from_input(opt$cellularity)
ploidy <- get_ranged_values_from_input(opt$ploidy)

message(sprintf('seqz-file: %s', seqz.file))
message(sprintf('sample.id: %s', sample.id))
message(sprintf('female: %s', female))
message(sprintf('cellularity: %s', paste(cellularity, collapse=',')))
message(sprintf('ploidy: %s', paste(ploidy, collapse=',')))

seqz <- sequenza.extract(seqz.file, verbose = FALSE)
cp.table <- sequenza.fit(seqz, cellularity=cellularity, ploidy=ploidy, female=female)
sequenza.results(sequenza.extract = seqz,
    cp.table = cp.table, sample.id = sample.id)
