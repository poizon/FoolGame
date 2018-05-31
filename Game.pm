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
  # определяем козырь
  $this->trump($this->{deck}->[0]);
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

=head2

определение конца игры. Если в колоде нет карт а игрок остался 1,
то все...

=cut
sub end
{
  my $this = shift;

  if (scalar @{$this->{deck}} and scalar @{$this->{gamers}} > 1 )
  {
    return 0;
  }

  return 1;

}

=head2

Здесь по идее можно следать так:
определяем какая буква в козыре и все карты в колоде с этой буквой меняем на x0F,
чтобы они были самыми старшими

=cut
sub trump
{
  my $this = shift;
  my $trump = shift;

  if($trump)
  {
    $trump = oct $trump;
    $this->{trump} = $trump <= oct '0xA9' ? 'A' :
                     $trump <= oct '0xB9' ? 'B' :
                     $trump <= oct '0xC9' ? 'C' : 'D';
  }

  return $this->{trump};
}

1;