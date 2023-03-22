#!/bin/bash

#Autor rozwiazania: Mateusz Marzec

echo "Witaj w skrypcie do szukania deklaracji obiektow"
trap "exit 1" SIGINT SIGHUP SIGKILL SIGTERM SIGTSTP
#load arg do tablicy
i=-1
for arg in "$@"	
do
i=`expr $i + 1`
TAB[$i]=$arg
done

ilePlikow=$i
szukanyTyp="${TAB[0]}"
echo "plikow $ilePlikow"
#potwierdzenia i testy
i=0
for n in ${TAB[0]}
do
i=`expr $i + 1`
wlasc=$n
done
if [ $i -ne 1 ]
then
echo "Wybrany typ nie jest prawidlowy. Czy miales na mysli typ: $wlasc ? [t/n]"
read ans
if [ $ans == 't' ]
then
echo "Powtorz komende o proponowanej skladni:"
skladnia="$0 $wlasc "
for ((i=1 ; i<=ilePlikow ;i++))
do
skladnia=${skladnia}${TAB[$i]}
done
echo $skladnia
exit 1
else
exit 1
fi
fi
echo "Szukane deklaracje lub definicje typu $szukanyTyp"
echo "Liczba wpisanych plikow: $ilePlikow"
echo "Wpisano nastepujace pliki:"
flaga=0
for ((j=1 ; j<= ilePlikow ; j++))
do
plik=${TAB[$j]}
if [ -f "$plik" ]
then
if [ -r "$plik" ]
then
if [[ $plik == *.c ]]
then
echo "$plik"

else
echo "$plik - UWAGA: plik moze (ale nie musi) nie byc kodem zrodlowym w C"
fi
else
echo "$plik - brak prawa do odczytu"
flaga=1
fi
else
echo "$plik - brak takiego pliku"
flaga=1
fi 
done
if [ $flaga -ne 0 ]
then
exit 1
fi
#wyszukiwanie w plikach
echo "Wyniki wyszukiwania: "
for ((i=1 ; i<=ilePlikow ; i++))
do
wynik=$(grep -E -n -o -e ^${szukanyTyp}[\*]*[[:blank:]]+[\*]*[[:alpha:]][[:alnum:]]\{0,30}[[:blank:]]*[\;\=] -e [\;\(\{[:blank:]]+${szukanyTyp}[\*]*[[:blank:]]+[\*]*[[:alpha:]][[:alnum:]]\{0,30}[[:blank:]]*[\;\=] "${TAB[$i]}")
#wynik=$(grep -E -n -o -e ^${szukanyTyp}[[:blank:]]+[[:alpha:]][[:alnum:]]\{0,30}[[:blank:]]*[\;\=] -e [\;\(\{[:blank:]]+${szukanyTyp}[[:blank:]]+[[:alpha:]][[:alnum:]]\{0,30}[[:blank:]]*[\;\=] ${TAB[$i]})
echo "plik $i : ${TAB[$i]}"
echo "$wynik"
echo 
done
exit 0
