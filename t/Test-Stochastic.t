# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Test-Stochastic.t'

#########################

use Test::More tests => 6;
use Test::Stochastic qw{stochastic_ok};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $sub_uniform_a   = sub { return "a" };
my $sub_uniform_abcd = sub { 
  my $random = rand();
  return (qw(a b c d))[int($random * 4)];
};
my $sub_biased_abcd = sub { 
  my $random = rand();
  return (qw(a b b c c c d d d d))[int($random * 10)];
};

stochastic_ok $sub_uniform_a, {a => 1};
stochastic_ok $sub_uniform_abcd, {a => 0.25, b => 0.25, c => 0.25};
stochastic_ok $sub_biased_abcd, { a=>0.1, b=> 0.2, c=>0.3, d => 0.4};

stochastic_ok {a => 1}, $sub_uniform_a;
stochastic_ok {a => 0.25, b => 0.25, c => 0.25}, $sub_uniform_abcd;
stochastic_ok { a=>0.1, b=> 0.2, c=>0.3, d => 0.4}, $sub_biased_abcd;

