#!/usr/bin/perl -w

@filearray = glob("genomeblast*.sh");
for $file(@filearray)
{
    system "bash $file";
}
