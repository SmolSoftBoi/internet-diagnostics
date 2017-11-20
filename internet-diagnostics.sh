#!/usr/bin/env bash

# Colors
RESET="\033[0m"
BOLD="\033[1m"
BRAND="${BOLD}\033[94m"
SUCCESS="\033[92m"
INFO="\033[94m"
WARNING="\033[93m"
DANGER="\033[91m"

# Date & Time
dateTime=$(date +%Y-%m-%d_%H.%M.%S)

# Directory
directory="/var/tmp"

# File
file="${directory}/Internet Diagnostics_${dateTime}"

count=1
pingCount=100

# Header
header() {
	echo -e "\n${BRAND} $@ ${RESET}\n"
}

# Chapter
chapter() {
    echo -e "\n${BRAND} $((count)). $@ ${RESET}\n"
    echo -e "\n $((count++)). $@ \n" >> "$file"
}

chapterTxt() {
    echo -e "\n${BRAND} $((count++)). $@ ${RESET}\n" >> "${file}"
}

# Body
body() {
	echo -e "${BRAND} $@ ${RESET}"
}

echo ""
header "                                                                              "
header "                             Internet Diagnostics                             "
header "                                                                              "
header "                   We are about to diagnose your internet!                    "
header "                                    🌎 🌍 🌏                                    "
header "                                                                              "
body "Internet Diagnostics detects common problems with your internet connection. It"
body "can also monitor your internet connection for intermittent connectivity       "
body "failures.                                                                     "
body "                                                                              "
body "Upon completing this assistant, a diagnostics report will be created in       "
body "/var/tmp."
body "                                                                              "
body "Internet Diagnostics may temporarily change your network settings when running"
body "diagnostics tests.                                                            "
body "                                                                              "
body "Internet Diagnostics is running diagnostics tests. This may take several      "
body "minutes to complete.                                                          "
body "                                                                              "
echo ""

echo -ne "  Optionally, enter any additional information about your wireless network"
echo -e "  below."
echo -e "  For example; wireless router is located in the upstairs bedroom clostet."
echo -ne "  ${BOLD}"
read info
echo -ne "${RESET}"

echo "${info}" >> "${file}"

chapter "Router Test"

routerIp=$(netstat -nr | awk '$1 == "default" {print $2; exit}')

ping -a -c "${pingCount}" "${routerIp}" >> "${file}"

chapter "External Test"

externalIp=$(dig +short apple.com | awk '{print $1; exit}')

ping -a -c "${pingCount}" "${externalIp}" >> "${file}"

chapter "ISP Test"

echo -ne "  Who is your ISP? ${BOLD}"
read isp
echo -ne "${RESET}"

ispIp=$(awk -v isp="${isp}" '$1 == isp {print $2}' isps)

if [ -z "${ispIp}" ]
    then
        echo -ne "  What is ${isp}'s test IP address? ${BOLD}"
        read ispIp
        echo -ne "${RESET}"
        echo "${isp} ${ispIp}" >> "${file}"
fi

ping -a -c "{$pingCount}" "{$ispIp}" >> "{$file}"

chapter "Route to Router Test"

ifconfig -a >> "${file}"

chapter "Route to External Test"

traceroute "${externalIp}" >> "${file}"

chapter "NetStat"

netstat -a >> "${file}"