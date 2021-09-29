.libPaths(c('/usr/local/lib/R/site-library', '/usr/lib/R/site-library', '/usr/lib/R/library'))
library(sequenza)

args <- commandArgs(trailingOnly=TRUE)
sample.id <- args[1]
seqz.file <- args[2]

seqz <- sequenza.extract(seqz.file, verbose = FALSE)
cp.table <- sequenza.fit(seqz)
sequenza.results(sequenza.extract = seqz,
    cp.table = cp.table, sample.id = sample.id)
