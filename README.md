# bamMotifSearcher
Find reads in a bam file that contain a given sequence (can contain degenerate bases)

Degenerate bases are found here: https://www.bioinformatics.org/sms/iupac.html

## Usage:
```
perl filterBam.pl {query} {bam} {?output}
```

For example,

```
perl filterBam.pl ATWCG file.bam file.ATWCG.bam
```

This filters reads that have the motif ATWCG and puts them in  file.ATWCG.bam

Note: samtools must be available on the command line.

