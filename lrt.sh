#!/bin/bash
#        File:      lrt.sh
#        Date:      2014-06-27
#      Author:      AKMC
#   Copyright:      Copyright (C) (>>>YEAR<<<) Free Software Foundation, Inc.
# Description:      Lrt media grotuvas!
#        TODO:      Daugiau kanalu!
 
# video grotuvas
grotuvas='mpv'
# URL iki kanalo
url_base='http://www.lrt.lt/mediateka/tiesiogiai/'
 
case ${1} in
    -h|--help)
        print "usage: ${0} [options]"
        ;;
    ltv1)
        ${grotuvas} $(curl -s ${url_base}/lrt-televizija | grep -oP 'rtmp\S+[a-z0-9]{32}')/ltv1
        ;;
    ltv2)
        ${grotuvas} $(curl -s ${url_base}/lrt-kultura | grep -oP 'rtmp\S+[a-z0-9]{32}')/ltv2
        ;;
    *)
        print "usage: ${0} [options]"
        ;;
esac
