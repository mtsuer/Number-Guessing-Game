#!/bin/bash

  #PSQL="psql --username=freecodecamp --dbname=number_guess --no-align --tuples-only -c"
  PSQL="psql --username=postgres --dbname=number_guess --no-align --tuples-only -c"

BULUNDU=false
echo "Enter your username:"
read GELEN_ISIM

#yorum2
#yorum3
#yorum4
#yorum5

   ISIM_ID_SONUC=$($PSQL "SELECT user_id FROM users WHERE user_name = '$GELEN_ISIM'")

        # if customer doesn't exist
        if [[ -z $ISIM_ID_SONUC ]]
        then
          # get new customer name
          #echo -e "\nWhat's your name?"
          #read GELEN_ISIM
          echo "Welcome, $GELEN_ISIM! It looks like this is your first time here."
          # insert new customer
          ISIM_EKLEME_SONUC=$($PSQL "INSERT INTO users(user_name) VALUES('$GELEN_ISIM')")           
          ISIM_ID_SONUC=$($PSQL "SELECT user_id FROM users WHERE user_name = '$GELEN_ISIM'")
          else
             OYUNCU_TOPLAM_OYUN_SAYISI=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id = '$ISIM_ID_SONUC'")
             OYUNCU_EN_IYI_OYUN_SAYISI=$($PSQL "SELECT MIN(game_skor) FROM games WHERE user_id = '$ISIM_ID_SONUC'")
          echo "Welcome back, $GELEN_ISIM! You have played $OYUNCU_TOPLAM_OYUN_SAYISI games, and your best game took $OYUNCU_EN_IYI_OYUN_SAYISI guesses."
        fi

RANDOM_SAYIM=$((1 + $RANDOM % 1000))

echo $RANDOM_SAYIM
echo "Guess the secret number between 1 and 1000:"

SAYAC=0
while [ $BULUNDU == false ]
do
SAYAC=$((SAYAC + 1))
read GELEN_SAYIM
if [[ $GELEN_SAYIM =~ ^[0-9]+$ ]]
then
        if [[ $RANDOM_SAYIM -eq $GELEN_SAYIM ]]
        then
        BULUNDU=true
        ISIM_SORGU_SONUC=$($PSQL "INSERT INTO games(user_id, game_skor) VALUES('$ISIM_ID_SONUC', '$SAYAC')") 

        echo "You guessed it in $SAYAC tries. The secret number was $RANDOM_SAYIM. Nice job!"
        

        elif [[ $RANDOM_SAYIM < $GELEN_SAYIM ]]
        then
        echo "It's lower than that, guess again:"

        else
        echo "It's higher than that, guess again:"
        fi
else
echo "That is not an integer, guess again:"
fi
done




