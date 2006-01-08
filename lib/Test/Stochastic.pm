package Test::Stochastic;

use 5.008006;
use strict;
use warnings;

use Test::More;
use Scalar::Util qw(reftype);

require Exporter;

our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw(
				   stochastic_ok
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.00_01';
$VERSION = eval $VERSION;  # see L<perlmodstyle>

my $TIMES = 100;
my $TOLERENCE = 0.1;

sub stochastic_ok {
  my ($arg1, $arg2, $msg) = @_;
  my ($sub, $hash);
  $msg ||= "stochastic_ok";

  if (reftype($arg1) eq "CODE") {
    ($sub, $hash) = ($arg1, $arg2);
  } else {
    ($sub, $hash) = ($arg2, $arg1);
  }

  my %seen;
  for (1..$TIMES) {
    $seen{ $sub->() }++;
  }

  while (my($k, $v) = each %$hash) {
    my ($min, $max) = _get_acceptable_range($v, $TIMES, $TOLERENCE);
    next if ($min <= $seen{$k} and $seen{$k} <= $max);
    
    $msg = "Value out of range for '$k': expected to see it between $min and $max times, but instead saw it $seen{$k} times";
    ok(0, $msg);
    return;
  }

  ok(1, $msg);

}

sub setup{
  my (%hash) = @_;
  while (my($k, $v) = each %hash) {
    if ($k eq "times") {
      $TIMES = $v;
    } elsif ($k eq "tolerence") {
      $TOLERENCE = $v;
    } else {
      die "unknown option $k passed to setup";
    }
  }
}

sub _get_acceptable_range{
  my ($p, $times, $tolerence) = @_;
  return(  ($p-$tolerence) * $times,
	   ($p+$tolerence) * $times
	);
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Test::Stochastic - checking probabilities of randomized methods

=head1 SYNOPSIS

  use Test::Stochastic qw(stochastic_ok);
  stochastic_ok sub { ...random sub...}, {a => 0.4, b => 0.6};
  stochastic_ok  {a => 0.4, b => 0.6}, sub { ...random sub...};
  Test::Stochastic::setup(times => 100, tolerence => 0.1);

=head1 DESCRIPTION

This module can be used to check the probability distribution of answers given by a method. The code fragments in the synopsis above check that the subroutine passed to C<stochastic_ok> returns C<a> with probability 0.4, and C<b> with probability 0.6.

This module will work only if the return values are numbers or strings. Future versions will handle references as well.


=head2 EXPORT

None by default, C<stochastic_ok> on request.



=head1 SEE ALSO

This uses C<Test::More>.

=head1 AUTHOR

Abhijit Mahabal, E<lt>amahabal@cs.indiana.eduE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Abhijit Mahabal

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
