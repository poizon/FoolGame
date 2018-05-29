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

sub nick
{
  my $this = shift;
  my $nick = shift;
  if($nick)
  {
    $this->{nick} = $nick;
  }

  return $this->{nick};
}


sub get_card
{
  my $this = shift;
  my $card = shift;
  push(@{$this->{cards}}, $card);
}

sub under_attack
{
  my $this = shift;

  return $this->{guard} ? 1 : 0;
}

sub attack
{

}

sub guard
{

}
1;