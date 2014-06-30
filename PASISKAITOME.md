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

1. Scenarijaus atsisiuntimas

Scenarijų galite atsisiųsti Jums patogiausiu būdu. Rekomenduojame taip:
"git clone https://github.com/akmc/lrt_grotuvas.git"

2. Konfigūracija (pavyzdys yra lrt.sh failo viršuje)

Redaguojame scenarijaus "Nustatymai" bloke esančius nustatymus. Scenarijus taip pat skaito Jūsų namų aplanke esantį .lrtrc failą, todėl rekomenduojame tokį susikurti (pvz žemiau).

3. Paleidimas

Paleidžiame su komanda: sh lrt.sh tv1 -d

4. Papildomai

4.1 Žemiau pateikiami galimi nustatumai tiek pačiame scenarijaus "lrt.sh" faile, tiek "~/.lrtrc" (rekomenduojama) faile:

  # MPV Medija grotuvui
  grotuvas='mpv'						# Medija grotuvo vykdomoji komanda
  grotuvas_param='--vf crop=1050:574:0:2 --deinterlace=yes'	# Šie nustatymai nukerpa nuo gaunamo vaidzo viršaus 2px. LRT televizijos kanale viršuje dežiniau yra negražus mirguliukas.


  # VLC Medija grotuvui
  grotuvas='vlc'						# Medija grotuvo vykdomoji komanda
  grotuvas_param='--video-filter=croppadd --croppadd-croptop=2'	# Šie nustatymai nukerpa nuo gaunamo vaidzo viršaus 2px. LRT televizijos kanale viršuje dežiniau yra negražus mirguliukas.

4.2 ".lrtrc" failo nustatymai perrašys scenarijaus faile esančius nustatymus

4.3 Patogu pasidaryti nuorodą į scenarijų (leis paleisti scenarijų iš bet kur sistemoje):
  echo #PATH				# Pateiks kelius į aplankus turinčius sistemos vykdomuosius
  ln -s lrt.sh /vienas/iš/$PATH/lrt	# Simbolinė nuoroda iš scenarijaus į failą lrt esantį viename vykdomųjų aplankų
