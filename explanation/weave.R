#!/usr/bin/Rscript --vanilla

library(R2HTML)

for (file in commandArgs(trailingOnly=T)) {
    Sweave(file, driver=RweaveHTML)
}

