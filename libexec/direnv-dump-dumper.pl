#!/usr/bin/perl
#use strict ;
use warnings ;
use 5.10.0;
use Data::Dumper;
use Compress::Zlib ;
use MIME::Base64 qw( encode_base64 );

delete $ENV{qw(_ PWD OLDPWD SHLVL SHELL DIRENV_BACKUP DIRENV_LIBEXEC)};
$env = \%ENV;

$Data::Dumper::Terse = 1;          # don't output names where feasible
$Data::Dumper::Indent = 0;         # turn off all pretty print
$env = Dumper($env);

$env = Compress::Zlib::memGzip($env) or die "Gzip error";

$env = encode_base64($env);

print $env;
