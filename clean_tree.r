#This file should be copied to /usr/local/arwin/src/

# Reads_thresh = 20
# Markerfile = '/home/arwin/clean_tree/positions.csv'
# Quality_thresh = 30
# Base_majority = .95
# Outputfile = '/home/arwin/clean_tree/tmp/out.csv'
# Pileupfile = '/home/arwin/clean_tree/tmp/out.pu'

options(stringsAsFactors = FALSE)

allow_base = c('a', 't', 'c', 'g', 'A', 'T', 'C', 'G', '.')
require(mice)
header_names = c("chr", "name", "hg", "pos", "mut", "anc", "der")
marker_table = read.table(Markerfile, col.names=header_names, fill=TRUE, na.strings="", comment.char="")
marker_table = cc(marker_table)
header_names = c('chr', 'pos', 'refbase', 'reads', 'align', 'quality')
pileup_table = read.table(Pileupfile, col.names=header_names, fill=TRUE, na.strings='', comment.char="")

require(plyr)
chromotable = ddply(pileup_table, .(chr), function(x) sum(x$reads))
colnames(chromotable)[2] = 'reads'
chromotable$perc = chromotable$reads / sum(chromotable$reads) * 100

pileup_table = pileup_table[(pileup_table$chr %in% unique(marker_table$chr)) & pileup_table$reads > Reads_thresh, ]
marker_pileup = merge(marker_table, pileup_table)
marker_pileup$ANC = toupper(marker_pileup$anc)
marker_pileup$DER = toupper(marker_pileup$der)
marker_pileup$REFBASE = toupper(marker_pileup$refbase)
marker_pileup$ALIGN = toupper(marker_pileup$align)


comb_indel_begin = function(align)
{
    while(any(align == '^'))
    {
        p0 = which(align == '^')[1]
        p1 = p0 + 1
        # begin = paste(align[p0:p1], collapse='')
        align = align[-(p0:p1)]
    }
    while(any(align == '+'))
    {
        p0 = which(align == '+')[1]
        nDigits = sum(align[(p0+1):(p0+3)] %in% 0:9)
        nIns = as.integer(paste(align[(p0+1):(p0+nDigits)], collapse=''))
        p1 = p0 + nDigits + nIns
        align = align[-(p0:p1)]
    }
    while(any(align == '-'))
    {
        p0 = which(align == '-')[1]
        nDigits = sum(align[(p0+1):(p0+3)] %in% 0:9)
        nIns = as.integer(paste(align[(p0+1):(p0+nDigits)], collapse=''))
        p1 = p0 + nDigits + nIns
        align = align[-(p0:p1)]
    }
    align = align[which(align != '$')]
    return(align)
}

getbase = function(mydat)
{
    print(mydat[, 1:4])
    myalign = strsplit(mydat$ALIGN, '')[[1]]
    myalign[myalign == ','] = '.'
    myalign = comb_indel_begin(myalign)
    #tryCatch(coef(s)[2, 4], error = function(e) 1)
    qualraw = charToRaw(mydat$quality)
    if(length(myalign) != length(qualraw)) {
        cat('align and quality not of the same length!\n')
        stop('align and quality not of the same length!\n')
    }
    myquality = strtoi(qualraw, 16L) - 33
    if(Quality_thresh > 0)
    {
        idx = myquality > Quality_thresh
        if(sum(idx == TRUE) < Reads_thresh) {
            print("No good reads!!!")
            res = data.frame(f_align=NA, f_qual=NA, f_len=NA, max_base=NA, max_perc=NA, base=NA)
            return(res)
        }
        myalign = myalign[idx]
        myquality = myquality[idx]
        qualraw = qualraw[idx]
    }
    align_tab = prop.table(table(myalign))
    max_perc = max(align_tab)
    max_base = names(align_tab)[which.max(align_tab)]

    if(max_perc >= Base_majority & max_base %in% allow_base)
    {
        if(max_base == '.')
        {
            base = mydat$REFBASE
        }
        else
        {
            base = max_base
        }
    } else {
        base = NA
    }

    myalign = paste(myalign, collapse='')
    f_qual = paste('Q', rawToChar(qualraw))
    print(align_tab)
    res = data.frame(f_align=myalign,
                     f_qual=f_qual,
                     f_len=nchar(myalign),
                     max_base=paste('M', max_base),
                     max_perc=max_perc, base=base)
    return(res)
}

require(foreach)
baseinfo = foreach(i = 1:nrow(marker_pileup), .combine = rbind) %do% {
    cat('Row: ', i, '\n')
    # if(i == 399) browser()
    getbase(marker_pileup[i, ])
}

cat('Dimensions of baseinfo: ', dim(baseinfo), '\n')
cat('Dimensions of marker_pileup: ', dim(marker_pileup), '\n')

marker_pileup = cbind(marker_pileup, baseinfo)
eqANC = (marker_pileup$base == marker_pileup$ANC)
eqDER = (marker_pileup$base == marker_pileup$DER)
marker_pileup$branch = ifelse(eqANC & eqDER, 'E', ifelse(eqANC, 'A', ifelse(eqDER, 'D', NA)))
marker_pileup$quality = paste('Q', marker_pileup$quality)
marker_pileup = marker_pileup[, ! names(marker_pileup) %in% c('ANC', 'DER', 'REFBASE', 'ALIGN')]
write.table(marker_pileup, file=Outputfile, sep='\t', quote=FALSE, row.names=FALSE)
write.table(chromotable, file=paste(Outputfile, '.chr.csv',  sep=''), sep='\t', quote=FALSE, row.names=FALSE)
