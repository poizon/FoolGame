package Game;

use strict;
use warnings;
use feature 'say';
use List::Util qw(shuffle);
use DDP;

sub new
{
  my $class = shift;

  my $self = {
    deck => [qw/0xA1 0xA2 0xA3 0xA4 0xA5 0xA6 0xA7 0xA8 0xA9
                0xB1 0xB2 0xB3 0xB4 0xB5 0xB6 0xB7 0xB8 0xB9
                0xC1 0xC2 0xC3 0xC4 0xC5 0xC6 0xC7 0xC8 0xC9
                0xD1 0xD2 0xD3 0xD4 0xD5 0xD6 0xD7 0xD8 0xD9/],
    trump => undef,
    gamers => [],
  };

  bless($self,$class);
}

sub shuffle_deck
{
  my $this = shift;
  @{$this->{deck}} = shuffle @{$this->{deck}};
}

sub give_out
{
  my $this = shift;
  # к раздаче по 6 штук на каждого игрока
  my @distrib = splice(@{$this->{deck}},0,scalar @{$this->{gamers}}*6);
  # раздаем карты игрокам
  while(@distrib)
  {
    for my $gamer(@{$this->{gamers}})
    {
      my $card = shift @distrib;
      $gamer->get_card($card);
    }
  }

}

sub add
{
  my $this = shift;
  my $gamer = shift;
  push(@{$this->{gamers}}, $gamer);
}

1;