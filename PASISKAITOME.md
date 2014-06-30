lrt_grotuvas
============

Tai paprastas scenarijus, skirtas groti Lietuvos radijo ir televizijos internetu transliuojamas programas.

============

Funkcijos:

* Galimybė pasirinkti norimą kanalą
* Galimybė nurodyti media grotuvą
 
===========

Sintaksė:

./lrt.sh [kanalas] [-d/--detach].
Kanalas turi būtinai būti nurodytas. -d/--detach vėliavėlė yra _nebūtina_. Ji atjungia media grotuvo išėjimą nuo terminalo ir visą išėjimą perkelia į nohup.out.

============

Naudojimas:

1. Atsisiuntimas
2. chmod u+x lrt.sh
3. Konfigūracija (pavyzdys yra lrt.sh failo viršuje)
4. Paleidimas pagal sintaksę pvz.: ./lrt.sh tv1 -d
