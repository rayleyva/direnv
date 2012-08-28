#!/usr/bin/perl
#use strict ;
use warnings ;
use 5.10.0;
use Storable qw( freeze );
use Compress::Zlib ;
use MIME::Base64 qw( encode_base64 );

delete $ENV{qw(_ PWD OLDPWD SHLVL SHELL DIRENV_BACKUP DIRENV_LIBEXEC)};
$env = \%ENV;

$env = freeze($env);

$env = Compress::Zlib::memGzip($env) or die "Gzip error";

$env = encode_base64($env);

print $env;
