#!/usr/bin/perl -w

use strict;
use warnings;
use feature 'say';
use DDP;

use Game;
use Gamer;

my $game = Game->new;
# тасуем колоду
$game->shuffle_deck;

# для каждого присоединившегося игрока создаем объект
my $gamer1 = Gamer->new;
$game->add($gamer1);

my $gamer2 = Gamer->new;
$game->add($gamer2);

my $gamer3 = Gamer->new;
$gamer3->set_guard;
$game->add($gamer3);

# раздать карты
$game->give_out();

# начали играть до конца
while(!$game->end)
{
  for my $gamer(@{$game->{gamers}})
  {
    # если игрок под атакой - защищаемся, в противном случае атакуем
    if($gamer->under_attack)
    {
      $game->guard($gamer);
    }
    else
    {
      $game->attack($gamer);
    }
  }
  # добрать из колоды карты до нужного кол-ва
  for my $gamer(@{$game->{gamers}})
  {
    sleep 1;
    # say scalar @{$gamer->{cards}};
    # если карт уже больше или = 6-ти пропускаем
    next if @{$gamer->{cards}} >= 6;
    my $card = shift @{$game->{deck}};
    $gamer->get_card($card);
  }

say "Last:";
p $game->{deck};

}