use strict;
my $q = shift;
my $bam = shift;
my $output = shift || "$bam.$q.bam";

my $usage = "perl $0 {query} {bam} {?output}";

die $usage unless $bam =~ /\.bam/;

$q =~ s/R/[AG]/g;
$q =~ s/Y/[CT]/g;
$q =~ s/S/[GC]/g;
$q =~ s/W/[AT]/g;
$q =~ s/K/[GT]/g;
$q =~ s/M/[AC]/g;
$q =~ s/B/[CGT]/g;
$q =~ s/D/[AGT]/g;
$q =~ s/H/[ACT]/g;
$q =~ s/V/[ACG]/g;
$q =~ s/N/[ATCG]/g;

open TEST, "samtools --version | " or die "$usage\nsamtools is requred";

open OUT, ">$output.tmp.sam" or die $!;
open(TEMP,"samtools view -H $bam |") or die($!);
while (my $line = <TEMP>)
{
	print OUT $line;
}

open(TEMP,"samtools view $bam |") or die($!);
my $readCount = 1;
my $printedCount = 0;
while (my $tempLine = <TEMP>)
{
	if ($readCount % 1000000 == 0)
	{
		print "read $readCount (printed $printedCount)\n";
	}
	$readCount++;
	my @tempLineEls = split(/\t/,$tempLine);

	my $seq = $tempLineEls[9];

	if ($seq =~ /$q/)
	{
		print OUT $tempLine;
		$printedCount++;
	}
}
close OUT;
print "read $readCount (printed $printedCount)\n";
print `samtools view -bS $output.tmp.sam > $output`;
print `rm $output.tmp.sam`;
print "Finished. Produced  $output\n";
