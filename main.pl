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
$game->add($gamer3);

# раздать карты
$game->give_out();

p $game->trump;
exit;
# начали играть до конца
while(!$game->end)
{
  for my $gamer(@{$game->{gamers}})
  {
    # если игрок под атакой - защищаемся, в противном случае атакуем
    if($gamer->under_attack)
    {
      $gamer->guard;
    }
    else
    {
      $gamer->attack;
    }
  }
}