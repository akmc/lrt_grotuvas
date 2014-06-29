#!/bin/bash
#===================================================================================
#         FAILAS: lrt.sh
#
#     NAUDOJIMAS: Instrukcijos pateikimos faile SKAITYK.md
#
#      APRAŠYMAS: Scenarijus groja LRT internetu transliuojamus kanalus Jūsų 
#                 pasirinktame grotuve.
#
# PRIKLAUSOMYBĖS: curl, medija grotuvas, gnu coreutils
#       AUTORIUS: AKMC komanda (GitHUB prisidėję asmenys)
#      LICENCIJA: GPL v2
#
#        VERSIJA: 0.alpha
#        SUKURTA: 2014-06-28
#===================================================================================

#-----------------------------------------------------------------------------------
# Nustatymai
#-----------------------------------------------------------------------------------

grotuvas="mpv" # video grotuvas
grotuvas_param="--vf crop=1050:574:0:2 --deinterlace=yes" # instrukcijos PASISKAITOME.md faile

#-----------------------------------------------------------------------------------
# Po šitos linijos nerekomenduojama ką nors keisti
#-----------------------------------------------------------------------------------

lrt="http://www.lrt.lt/mediateka/tiesiogiai" # URL iki kanalo
v1="" # lygus nohup jeigu yra naudojama -d/--detach
v2="" # lygus & jeigu yra naudojama -d/--detach

# jei yra - nuskaityti naudotojo nustatymus iš ~/.lrtrc failo
if [ -f ${HOME}/.lrtrc ]; then
	source ${HOME}/.lrtrc
fi

nepri="autorių\|netransliuojama\|pabaiga"

#-----------------------------------------------------------------------------------
# Pagrindinė scenarijaus dalis
#-----------------------------------------------------------------------------------

# Patikrinama ar yra programos, kurios yra privalomos scenarijui
if [ $(command -v ${grotuvas} curl nohup grep | wc -l) -lt 4 ]; then 
  echo "Nerasta ${grotuvas}, curl, nohup arba grep ! Patikrinkite konfiguraciją ${0} failo viršuje"
  exit 1
fi

# Patikrinam ir nustatom papildomus argumentus grotuvui jeigu vartotojas nori jį atjungti nuo terminalo
if [ "${2}" == "-d" ] || [ "${2}" == "--detach" ]; then
  v1="nohup"
  v2="&"
  echo "Media grotuvas bus atjungtas nuo terminalo!"
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
        if [ $(curl -s ${lrt}/lrt-televizija | grep ${nepri} | wc -l) -eq 1 ]; then
          echo "Lrt programa netransliuojama dėl autorių teisių arba dėl kitokių priežaščių. Nutraukiamas darbas"
          exit 1
        else
          ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-televizija | grep -oP "rtmp\S+[a-z0-9]{32}")/LTV1 ${v2}
        fi
        ;;
    2|tv2|kultura)
        if [ $(curl -s ${lrt}/lrt-kultura | grep ${nepri} | wc -l) -eq 1 ]; then
          echo "Lrt programa netransliuojama dėl autorių teisių arba dėl kitokių priežaščių. Nutraukiamas darbas"
          exit 1
        else
          ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-kultura | grep -oP "rtmp\S+[a-z0-9]{32}")/LTV1 ${v2}
        fi
        ;;
    3|tv3|lituanica)
        if [ $(curl -s ${lrt}/lrt-lituanica | grep ${nepri} | wc -l) -eq 1 ]; then
          echo "Lrt programa netransliuojama dėl autorių teisių arba dėl kitokių priežaščių. Nutraukiamas darbas"
          exit 1
        else
          ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-lituanica | grep -oP "rtmp\S+[a-z0-9]{32}")/LTV1 ${v2}
        fi
        ;;
    4|r1|radijas)
        if [ $(curl -s ${lrt}/lrt-radijas | grep ${nepri} | wc -l) -eq 1 ]; then
          echo "Lrt programa netransliuojama dėl autorių teisių arba dėl kitokių priežaščių. Nutraukiamas darbas"
          exit 1
        else
          ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-radijas | grep -oP "rtmp\S+[a-z0-9]{32}")/LTV1 ${v2}
        fi
        ;;
    5|r2|klasika)
        if [ $(curl -s ${lrt}/lrt-klasika | grep ${nepri} | wc -l) -eq 1 ]; then
          echo "Lrt programa netransliuojama dėl autorių teisių arba dėl kitokių priežaščių. Nutraukiamas darbas"
          exit 1
        else
          ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-klasika | grep -oP "rtmp\S+[a-z0-9]{32}")/LTV1 ${v2}
        fi
        ;;
    6|r3|opus)
        if [ $(curl -s ${lrt}/lrt-opus | grep ${nepri} | wc -l) -eq 1 ]; then
          echo "Lrt programa netransliuojama dėl autorių teisių arba dėl kitokių priežaščių. Nutraukiamas darbas"
          exit 1
        else
          ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-opus | grep -oP "rtmp\S+[a-z0-9]{32}")/LTV1 ${v2}
        fi
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
