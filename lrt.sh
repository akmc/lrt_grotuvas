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
#   REIKALAVIMAI: --- 
#       AUTORIUS: AKMC komanda (GitHUB prisidėję asmenys)
#      LICENCIJA: GPL v2
#
#        VERSIJA: 0.alpha
#        SUKURTA: 2014-06-28
#===================================================================================

#-----------------------------------------------------------------------------------
# Nustatymai
#-----------------------------------------------------------------------------------

grotuvas="mpv"                                    # video grotuvas
lrt="http://www.lrt.lt/mediateka/tiesiogiai"			# URL iki kanalo
# Vėliavėlės naudojamos, kai reikia atjungti grotuvą nuo terminalo
v1=""
v2=""

# grotuvas_param='--vf crop=1050:574:0:2 --deinterlace=yes'	# instrukcijos PASISKAITOME.md faile

# jei yra - nuskaityti naudotojo nustatymus iš ~/.lrtrc failo
if [ -f ${HOME}/.lrtrc ]; then
	source ${HOME}/.lrtrc
fi

#-----------------------------------------------------------------------------------
# Pagrindinė scenarijaus dalis
#-----------------------------------------------------------------------------------

# Patikrinama ar yra įdiegtas nurodytas grotuvas. Jei neįdiegtas - nutraukiamas scenarijus ir pranešama vartotojui
command -v ${grotuvas} >/dev/null 2>&1 || { echo "Nerasta programa \"${grotuvas}\" ! Patikrinkite konfiguraciją ${0} failo viršuje."; exit 1; }
# Patikrinama ar yra įdiegtas curl. Jei neįdiegtas - nutraukiamas scenarijus ir pranešama vartotojui
command -v curl >/dev/null 2>&1 || { echo "Nerasta programa \"curl\"! Ji privaloma scenarijaus veikimui. Prašome įsidiegti ir bandyti dar kartą."; exit 1; }
# Patikrinama ar yra įdiegtas nohup. Jei neįdiegtas - nutraukiamas scenarijus ir pranešama vartotojui
command -v nohup >/dev/null 2>&1 || { echo "Nerasta programa \"nohup\"! Ji privaloma scenarijaus veikimui. Prašome įsidiegti ir bandyti dar kartą."; exit 1; }
 
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
        ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-televizija | grep -oP "rtmp\S+[a-z0-9]{32}")/LTV1 ${v2}
        ;;
    2|tv2|kultura)
        ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-kultura | grep -oP "rtmp\S+[a-z0-9]{32}")/ltv2 ${v2}
        ;;
    3|tv3|lituanica)
        ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-lituanica | grep -oP "rtmp\S+[a-z0-9]{32}")/world ${v2} 
        ;;
    4|r1|radijas)
        ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-radijas | grep -oP "rtmp\S+[a-z0-9]{32}")/radio.mp3 ${v2}
        ;;
    5|r2|klasika)
        ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-klasika | grep -oP "rtmp\S+[a-z0-9]{32}")/radio.mp3 ${v2}
        ;;
    6|r3|opus)
        ${v1} ${grotuvas} ${grotuvas_param} $(curl -s ${lrt}/lrt-opus | grep -oP "rtmp\S+[a-z0-9]{32}")/radio.mp3 ${v2}
        ;;
    *)
        echo "Nenurodytas kanalas!"
        echo ""
        echo "Pagalba: ${0} -h/--help"
        ;;
esac

#-----------------------------------------------------------------------------------
# TODO
#-----------------------------------------------------------------------------------
# 1. Pasitikrinimą ar transliuojama (kartais netransliuojama internetu dėl autorinių teisių. galima gaudyt tekstą html'e, arba grep statusą "null")
# 2. Langas radijo transliacijai (kad išsijungti būtų galima žmoniškai :))
# 3. Mintis - gal būtų šaunu rodyti statinį radijo kanalo paveiksliuką audio grojimo metu (sumixuoti skirtingus video ir audio kanalaus)
# 4. Pakeist -h/--help ir -d/--detach pavadinimus į lietuviškus
