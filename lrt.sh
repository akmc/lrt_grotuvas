#!/bin/bash
#===================================================================================
#         FAILAS: lrt.sh
#
#     NAUDOJIMAS: Instrukcijos pateikimos faile PASISKAITOM.md
#
#      APRAŠYMAS: Scenarijus groja LRT internetu transliuojamus kanalus Jūsų 
#                 pasirinktame grotuve.
#
# PRIKLAUSOMYBĖS: curl, medija grotuvas, gnu coreutils
#       AUTORIUS: AKMC komanda (GitHUB prisidėję asmenys)
#      LICENZIJA: GPL v2
#
#        VERSIJA: 0.1
#        IŠLEISTA: 2014-06-30
#===================================================================================

#-----------------------------------------------------------------------------------
# Nustatymai
#-----------------------------------------------------------------------------------

grotuvas="mpv" # video grotuvas
#grotuvas_param="--vf crop=1050:574:0:2 --deinterlace=yes" # instrukcijos PASISKAITOME.md faile

#-----------------------------------------------------------------------------------
# Po šitos linijos nerekomenduojama ką nors keisti
#-----------------------------------------------------------------------------------

lrt="http://www.lrt.lt/mediateka/tiesiogiai" # URL iki kanalo
d=0
# jei yra - nuskaityti naudotojo nustatymus iš ~/.lrtrc failo
if [ -f ${HOME}/.lrtrc ]; then
  source ${HOME}/.lrtrc
fi

# Kokie žodžiai rodo, kad tas kanalas nėra transliuojamas?
nepri="autorių\|netransliuojama\|pabaiga" 

#-----------------------------------------------------------------------------------
# Funkcijos
#-----------------------------------------------------------------------------------
paleisti () {
  if [ $(curl -s ${lrt}/$1 | grep ${nepri} | wc -l) -eq 1 ]; then
    echo "Lrt programa netransliuojama dėl autorių teisių arba dėl kitokių priežaščių. Nutraukiamas darbas"
    exit 1
  else
    echo "Paleidžiama transliacija"
    if [ $d -eq 1 ]; then
      nohup ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/$1 | grep -oP "rtmp\S+[a-z0-9]{32}")/$2 &
    else
      ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/$1 | grep -oP "rtmp\S+[a-z0-9]{32}")/$2
    fi
  fi
}
#-----------------------------------------------------------------------------------
# Pagrindinė scenarijaus dalis
#-----------------------------------------------------------------------------------

wget --timeout=15 --spider ${lrt} &>/dev/null
if [ $? -ne 0 ]; then
  echo "${lrt} nėra pasiekiamas todėl nutraukiamas darbas!"
  exit 1
fi

# Patikrinama ar yra programos, kurios yra privalomos scenarijui
if [ $(command -v ${grotuvas} curl nohup grep wget | wc -l) -lt 5 ]; then 
  echo "Nerasta ${grotuvas}, curl, nohup, grep arba wget! Patikrinkite konfiguraciją ${0} failo viršuje"
  exit 1
fi

# Patikrinam ir nustatom papildomus argumentus grotuvui jeigu vartotojas nori jį atjungti nuo terminalo
if [ "${2}" == "-d" ] || [ "${2}" == "--detach" ]; then
  d=1
  echo "Media grotuvas bus atjungtas nuo terminalo"
fi

case ${1} in
  -h|--help)
    echo "Naudojimas: ${0} [kanalas] [-d/--detach]"
    echo ""
    echo "TV kanalai:"
    echo " 1 | tv1 | televizija = LRT Televizija"
    echo " 2 | tv2 | kultura = LRT Kultūra"
    echo " 3 | tv3 | lituanica = LRT Lituanika"
    echo ""
    echo "Radijo kanalai:"
    echo " 4 | r1 | radijas = LRT Radijas"
    echo " 5 | r2 | klasika = LRT Klasika"
    echo " 6 | r3 | opus = LRT Klasika"
    echo ""
    echo "LRT televizijai rodyti skirtų komandų pavyzdžiai:"
    echo "    Komanda: \"sh ${0} 1\""
    echo " arba"
    echo "    Komanda: \"sh ${0} tv1\""
    echo " arba"
    echo "    Komanda: \"sh ${0} televizija\""
    echo ""
    echo "Jeigu nenorite gauti grotuvo išeities teksto tai naudokite -d/--detach vėliavėlę."
    ;;
  1|tv1|televizija)
    paleisti lrt-televizija LTV1
    ;;
  2|tv2|kultura)
    paleisti lrt-kultura ltv2
    ;;
  3|tv3|lituanica)
    paleisti lrt-lituanica world
    ;;
  4|r1|radijas)
    paleisti lrt-radijas radio.mp3
    ;;
  5|r2|klasika)
    paleisti lrt-klasika radio.mp3
    ;;
  6|r3|opus)
    paleisti lrt-opus radio.mp3
    ;;
  *)
    echo "Nenurodytas ar neegzistuojantis kanalas!"
    echo ""
    echo "Pagalba: ${0} -h/--help"
    ;;
esac

#-----------------------------------------------------------------------------------
# TODO
#-----------------------------------------------------------------------------------
# 1. Langas radijo transliacijai (kad išsijungti būtų galima žmoniškai :))
# 2. Mintis - gal būtų šaunu rodyti statinį radijo kanalo paveiksliuką audio grojimo metu (sumixuoti skirtingus video ir audio kanalaus)
# 3. Pakeist -h/--help ir -d/--detach pavadinimus į lietuviškus
# 4. Perkelti -h/--help ir -d/--detach į pirmą argumentą, o kanalą - į antrą
