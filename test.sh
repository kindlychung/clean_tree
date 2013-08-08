# quit useless here, samtools generate different results even when using exactly the same files and settings.
# quit useless here, samtools generate different results even when using exactly the same files and settings.
# quit useless here, samtools generate different results even when using exactly the same files and settings.
# quit useless here, samtools generate different results even when using exactly the same files and settings.











./clean_tree.py arwin.bam positions.csv out.csv -r 20 -q 30 -b 95

DIFF=$(diff out.csv test.csv)
if [ "$DIFF" != "" ]
then
    echo "Something wrong? Check the csv files."
else
    echo "Everything ok!"
fi
