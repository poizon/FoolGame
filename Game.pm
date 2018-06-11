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
    # колода
    deck => [qw/0xA1 0xA2 0xA3 0xA4 0xA5 0xA6 0xA7 0xA8 0xA9
                0xB1 0xB2 0xB3 0xB4 0xB5 0xB6 0xB7 0xB8 0xB9
                0xC1 0xC2 0xC3 0xC4 0xC5 0xC6 0xC7 0xC8 0xC9
                0xD1 0xD2 0xD3 0xD4 0xD5 0xD6 0xD7 0xD8 0xD9/],
    # козырь
    trump => undef,
    # игроки
    gamers => [],
    # стол с картами
    desktop => {
      beat => [],# побитые карты
      active => [],# не побитые карты
      },
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

=head2 guard(gamer)

защита игрока

=cut
sub guard
{
  my $this = shift;
  my $gamer = shift;
  # Проверяем есть ли не побитые карты на столе (desktop)
  return if $this->all_beat;
  # ищем возможные комбинации для карт на столе которые нужно побить
  # находим все комбинации, выбираем лучшие
  # бьем, перемещаем из active в beat
  @{$gamer->{cards}} = sort @{$gamer->{cards}};
  my $can_beat = 0;
  for (my $i=0; $i <= scalar @{$this->{desktop}->{active}}; $i++)
  {
    # не могу побить
    $can_beat = 0;
    for my $card(@{$gamer->{cards}})
    {
      # если можем побить
      if(oct $card > oct $this->{desktop}->{active}[$i])
      {
        # say "card: $card on desk: $desk_card";
        my $card = splice(@{$this->{desktop}->{active}},$i,1);
        push(@{$this->{desktop}->{beat}}, $card);
        # могу побить
        $can_beat = 1;
        last;# выходим из этого цикла for во внешний for
      }
    }
  }
  #
  # здесь проверяем осталось ли что не побитое, если осталось
  # прогоняем уже с поиском по козыврям
  say "Can beat? $can_beat";
  # если и с козырями побить не можем - весь desktop->{active} и desktop->{beat}
  # забираем к игроку
  return;
}

=head2 all_beat()

Проверяет все ли побиты карты на столе, если все - то возвращает true

=cut
sub all_beat
{
  my $this = shift;
  # если в массиве с активными картами нет элементов
  # значит все побили
  return scalar @{$this->{desktop}->{active}} ? 0 : 1;
}

=head2 attack()

атака игрока

=cut
sub attack
{
  my $this = shift;
  my $gamer = shift;
  # если не все побиты - ждем когда будут все побиты ?
  return if ! $this->all_beat;
  # если есть карты на столе - подбираем из того что есть
  if (@{$this->{desktop}->{beat}})
  {
    say "Beat:";
    p $this->{desktop}->{beat};
  }
  # если нет, то берем наименьшую карту
  else
  {
    @{$gamer->{cards}} = sort @{$gamer->{cards}};
    my $card = shift @{$gamer->{cards}};
    push( @{$this->{desktop}->{active}}, $card);
  }
  # подбираем что можно подбросить
  # Отбираем лучшую комбинацию
  # помещаем в active
  return;
}

1;