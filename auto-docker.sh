#/bin/bash
VERSION="5.3.2"
sed -i '' -e "s/version:.*\",/version: \"v$VERSION\",/" ./src/store/store.js #For MACOS
sed -i "s/version:.*\",/version: \"v$VERSION\",/" ./src/store/store.js  #For Windows
docker build -t engiecofely/nyx_ui:v$VERSION .
docker push engiecofely/nyx_ui:v$VERSION
echo -en "\007"

### VERSION HISTORY ###

#   4.1.29  EBU Fix Multiple Deletion emplacement, add custom url icon
#   4.1.30  EBU Fix timerange for Grafana
#   4.1.31  EBU Fix custom url icon for all icon
#   4.1.32  EBU Fix unique color
#   4.1.35  EBU Fix Grafana param url
#   4.1.36  EBU Fix Grafana default time
#   4.1.37  EBU Add Optiboard Editor: add default view 
#   4.1.38  EBU Add Optiboard Editor: add default view 
#   4.1.39  EBU Add Optiboard Editor: add default view MULTIPLE
#   4.1.40  EBU Fix Optiboard Editor: filter views
#   5.0.1   JFI Breaking Change Azure Signin
#   5.0.5   JFI added store in
#   5.0.12  JFI added logout
#   5.0.14  JFI logout popup removed
#   5.2.1   JFI forgotten pw added
#   5.2.2   JFI merged
#   5.2.4   EBU Add custom carousel table for optiboard
#   5.2.7   EBU Fix search input on 1 line
#   5.2.8   EBU Fix checkbox in configuration privileges
#   5.2.10  EBU Fix Config Scroll
#   5.2.12  EBU Change background color when grafana drakmode
#   5.2.13  EBU Fix login: elContainer style if null
#   5.2.14  EBU Grafana dark mode - Text Color & BG Color & Bar Color
#   5.3.0   EBU Add ConfigTree.vue
#   5.3.1   EBU Fix ConfigTree.vue css
#   5.3.2   EBU add Order auto when new config & reload config