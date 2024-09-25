#/bin/bash
VERSION="5.3.31"
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
#   5.2.12  EBU Change background color when grafana darkmode
#   5.2.13  EBU Fix login: elContainer style if null
#   5.2.14  EBU Grafana dark mode - Text Color & BG Color & Bar Color
#   5.3.0   EBU Add ConfigTree.vue
#   5.3.1   EBU Fix ConfigTree.vue css
#   5.3.2   EBU add Order auto when new config & reload config
#   5.3.3   EBU Fix multiple deletion && Fix Header Table
#   5.3.7   EBU Add Title Env Variable
#   5.3.8   JFI skipActiveDirectory added
#   5.3.9   EBU Add tree view for configuration creation and Grafana time picker
#   5.3.10  EBU Fix tree config creation and Add auto-refresh when deleting or duplicating a configuration
#   5.3.11  EBU Add Auto-refresh Optiboard when carousel is modified
#   5.3.12  EBU Add Optiboard Mode Main4G && Add Dockerfile update & upgrade
#   5.3.13  EBU Add @USERLOGIN for external url && Fix token=TOKEN
#   5.3.14  EBU Add phrase for @USERLOGIN
#   5.3.15  JFI replace("%40","@")
#   5.3.16  JFI autosignin if user & password set
#   5.3.17  JFI decodeURIComponent insteaed of replace
#   5.3.18  EBU Add Optiboard Usage counter option
#   5.3.19  EBU Fix moment timestamp & size table
#   5.3.23  EBU optiboard add third color
#   5.3.24  EBU Fix Grafana default time
#   5.3.25  EBU Add Grafana query
#   5.3.26  EBU fix Config Get Apps from submenus
#   5.3.27  EBU Add filter by client privilege for carousel view list
#   5.3.28  EBU Add Carousel Views: Switch button fon background cache
#   5.3.29  EBU Filter carousel by client and more optimizations for consumers not admin
#   5.3.31  EBU Add logo selection & Fix privileges