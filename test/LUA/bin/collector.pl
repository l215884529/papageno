#!/usr/bin/perl
$parser_name="./lua_parser";
$number_of_executions=1.0;
@thread_number=("1","2","3","4");
%input_files=(
  1 => '7k.lua',
  2 => '70k.lua',
  3 => '700k.lua',
  4 => '3.5M.lua',
  5 => '7M.lua',
  6 => '35M.lua',
);

while( my($file_idx,$filename) =each(%input_files)){
  foreach $threadno(@thread_number){
    $command=$parser_name." -j ".$threadno." ".$filename;
    print ("file $filename, index $file_idx, $threadno\n");
    $parse_time=0.0;
    $lex_time=0.0;
    for($run=0;$run<$number_of_executions;$run++){
      @output=qx($command);
      foreach $line (@output){
          if ($line =~ m/Parser.*/){
            @values = split(' ',$line);
            $parse_time+= $values[1];
          }
          elsif ($line =~ m/Lexer.*/){
            @values= split(' ',$line);
            $lex_time+= $values[1];
          }
      }
    }
    $timing_parse[$file_idx][$threadno]=$parse_time/$number_of_executions;
    $timing_lex[$file_idx][$threadno]  =$lex_time  /$number_of_executions;
  }
}

open(LEX_RESULTS,">../results/lex_results.dat");
open(PARSE_RESULTS,">../results/parse_results.dat");

print LEX_RESULTS "threads ";
print PARSE_RESULTS "threads ";

foreach $file_idx(sort(keys(%input_files))){
  print LEX_RESULTS $input_files{$file_idx}."\t";
  print PARSE_RESULTS $input_files{$file_idx}."\t";
}
print LEX_RESULTS "\n";
print PARSE_RESULTS "\n";

foreach $threadno(@thread_number){
  print LEX_RESULTS $threadno."\t";
  print PARSE_RESULTS $threadno."\t";
  foreach $file_idx(sort(keys(%input_files))){
    print PARSE_RESULTS $timing_parse[$file_idx][$threadno]."\t";
    print LEX_RESULTS $timing_lex[$file_idx][$threadno]."\t";
  }
  print LEX_RESULTS "\n";
  print PARSE_RESULTS "\n";
} 

close(LEX_RESULTS);
close(PARSE_RESULTS);
