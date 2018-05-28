package Gamer;

use strict;
use warnings;
use feature 'say';

our $counter = 1;

sub new
{
  my $class = shift;
  my $nick = shift || 'Ivan';

  my $self = {
    cards => [],
    guard => 0,# under attack flag,
    nick  => $nick . $counter,
    id    => $counter++,
  };

  bless($self,$class);
}

sub myname
{
  my $this = shift;

  return $this->{nick};
}


sub get_card
{
  my $this = shift;
  my $card = shift;
  push(@{$this->{cards}}, $card);
}

1;