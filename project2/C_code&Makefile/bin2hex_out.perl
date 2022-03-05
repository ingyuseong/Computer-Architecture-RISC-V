#!/usr/bin/perl

open (FH, "<out.bin") or die "oooops: $!";

binmode FH;
$count = 0;
while (read(FH, $_, 1))
{
	$count += 1;
	$rem = $count % 4;
	if ($rem == 0) { $hex3 = ord($_);
	                #printf("%02X%02X%02X%02X\n", $hex0, $hex1, $hex2, $hex3);
	                printf("%02X%02X%02X%02X\n", $hex3, $hex2, $hex1, $hex0);
	               }
	if ($rem == 1) { $hex0 = ord($_); }
	if ($rem == 2) { $hex1 = ord($_); }
	if ($rem == 3) { $hex2 = ord($_); }
}
close(FH);
