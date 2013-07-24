#This file should be copied to /usr/local/arwin/src/

Reads_thresh = 50
Markerfile = 'positions.csv'
Quality_thresh = 30
Base_majority = .95
Outputfile = 'out.csv'
Pileupfile = 'tmp/out.pu'

allow_base = c('a', 't', 'c', 'g', 'A', 'T', 'C', 'G', '.')
require(mice)
header_names = c("chr", "name", "hg", "pos", "mut", "anc", "der")
marker_table = cc(read.table(Markerfile, col.names=header_names, fill=TRUE, na.strings=""))
pileup_table = read.table(Pileupfile, col.names=c('chr', 'pos', 'refbase', 'reads', 'align', 'quality'), fill=TRUE, na.strings='')
pileup_table = pileup_table[(pileup_table$chr %in% unique(marker_table$chr)) & pileup_table$reads > Reads_thresh, ]
marker_pileup = merge(marker_table, pileup_table)
marker_pileup$ANC = toupper(marker_pileup$anc)
marker_pileup$DER = toupper(marker_pileup$der)
marker_pileup$REFBASE = toupper(marker_pileup$refbase)
marker_pileup$ALIGN = toupper(marker_pileup$align)


base_branch = function(mydat)
{
    myalign = strsplit(mydat[15], '')[[1]]
    myalign[myalign == ','] = '.'
    #tryCatch(coef(s)[2, 4], error = function(e) 1)
    myquality = strtoi(charToRaw(mydat[11]), 16L) - 33
    if(Quality_thresh > 0)
    {
        myalign = myalign[myquality > Quality_thresh]
    }
    align_tab = prop.table(table(myalign))
    max_perc = max(align_tab)
    max_base = names(align_tab)[which.max(align_tab)]
    if(max_perc < Base_majority | !(max_base %in% allow_base))
    {
        base = NA
    }
    else if(max_base == '.')
    {
        base = mydat[14]
    }
    else
    {
        base = max_base
    }
    base
}

marker_pileup$base = apply(marker_pileup, 1, base_branch)
eqANC = (marker_pileup$base == marker_pileup$ANC)
eqDER = (marker_pileup$base == marker_pileup$DER)
marker_pileup$branch = ifelse(eqANC & eqDER, 'E', ifelse(eqANC, 'A', ifelse(eqDER, 'D', NA)))
marker_pileup$quality = paste('Q', marker_pileup$quality)
write.table(marker_pileup, file=Outputfile, sep='\t', quote=FALSE, row.names=FALSE)
