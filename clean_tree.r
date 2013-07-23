#Reads_thresh = 50
#Markerfile = 'positions.csv'
#Quality_thresh = 30
#Base_majority = .95
#Outputfile = 'out.csv'

allow_base = c('a', 't', 'c', 'g', 'A', 'T', 'C', 'G', '.')
Pileupfile = 'tmp/out.pu'
require(mice)
header_names = c("chr", "name", "hg", "pos", "mut", "anc", "der")
marker_table = cc(read.table(Markerfile, col.names=header_names, fill=TRUE, na.strings=""))
pileup_table = read.table(Pileupfile, col.names=c('chr', 'pos', 'refbase', 'reads', 'align', 'quality'), fill=TRUE, na.strings='')
pileup_table = pileup_table[(pileup_table$chr %in% unique(marker_table$chr)) & pileup_table$reads > Reads_thresh, ]
marker_pileup = merge(marker_table, pileup_table)


base_branch = function(mydat)
{
    myalign = strsplit(mydat[10], '')[[1]]
    myquality = strtoi(charToRaw(mydat[11]), 16L) - 33
    if(Quality_thresh > 0)
    {
        myalign = myalign[myquality > Quality_thresh]
    }
    myalign[myalign == ','] = '.'
    align_tab = prop.table(table(myalign))
    max_perc = max(align_tab)
    max_base = names(align_tab)[which.max(align_tab)]
    if(max_perc < Base_majority | !(max_base %in% allow_base))
    {
        base = '?'
    }
    else if(max_base == '.')
    {
        base = mydat[8]
    }
    else
    {
        base = max_base
    }
    if(base == mydat[6])
    {
        branch = "A"
    }
    else if(base == mydat[7])
    {
        branch = "D"
    }
    else
    {
        branch = "?"
    }
    res = c(base, branch)
    names(res) = c('base', 'branch')
    res
}

require(plyr)
marker_pileup = cbind(marker_pileup, t(apply(marker_pileup, 1, base_branch)))
write.table(marker_pileup, file=Outputfile, sep='\t', quote=FALSE, row.names=FALSE)
