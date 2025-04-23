<template slot="items">
  <div>
    <div v-if="urlTooLong()">

        <el-row>
          <i style="font-size:100px;" class="el-icon-warning-outline"></i>
        </el-row>

        <el-row>
          <div style="font-size:20px; margin-top:10px;">
            The URL is too long ({{computedurl.length}} characters) for your browser ({{$browserDetect.meta.name}})
          </div>
        </el-row>

        <el-row type="flex" justify="center">
          <el-card style="width:300px; text-align:center; margin-top:10px;" shadow="never">
            <el-table
              :data="browsersData"
              size="mini"
              style="">
              <el-table-column
                prop="name"
                label="Browser"
                width="180">
              </el-table-column>
              <el-table-column
                prop="maxSize"
                label="Max Size">
              </el-table-column>
            </el-table>
          </el-card>
        </el-row>

    </div>
    <iframe
      v-else
      id="grafana-iframe"
      :src="computedurl"
      frameborder="0"
      :width="containerWidth"
      :height="containerHeight"
      ref="iframeContent"
      v-bind:style="iFrameContainerComputed"
      @keydown="printKey($event)"
    ></iframe>
  </div>
</template>

<script>
/* eslint-disable */
import _ from "lodash";
import axios from "axios";
import moment from "moment";
import Vue from "vue";
import browserDetect from "vue-browser-detect-plugin";
import { start } from "repl";
Vue.use(browserDetect);

const $ = require("jquery");

window.$ = $;

export default {
  name: "Grafana",
  data: () => ({
    url: "",
    finalquery: "",
    computedurl: "",
    ready: false,
    queryField: "",
    queryfilter: "",
    timerange: "",
    specificTime: null,
    grafanaTimeBit: false,
    browsersData: [
      {
        name: 'Chrome',
        maxSize:'32779'
      }, 
      {
        name: 'Android',
        maxSize:'8192'
      },
      {
        name: 'Firefox',
        maxSize:'>64k'
      },
      {
        name: 'Safari',
        maxSize:'>64k'
      },
      {
        name: 'IE11',
        maxSize:2047
      },
      {
        name: 'Edge 16',
        maxSize:2047
      },
    ],
  }),
  watch: {
    queryField: function() {
      this.queryChanged();
    },
    configin: function() {
      this.createUrl();
    }
  },
  props: {
    config: {
      type: Object
    },
    // directLoad: {
    //   type: Boolean
    // }
  },
  computed: {
    configin: function() {
      return this.config;
    },
    containerHeight: function() {
      var headerheight = 0;
      if (this.$store.getters.currentSubCategory.apps.length > 1) {
        headerheight += 50;
      }
      if (
        this.config.queryFilterChecked ||
        this.config.downloadChecked ||
        this.config.queryBarChecked
      ) {
        //headerheight += 50;
      }
      console.log("HEIGHT:")
      console.log(this.$store.getters.containerSize.height , headerheight)
      return (
        this.$store.getters.containerSize.height - 60 - headerheight + "px"
      );
      //return "1400px";
    },
    containerWidth: function() {
      var left = 200;
      if (!this.$store.state.menuOpen) left = 0;

      return this.$store.getters.containerSize.width - left + "px";
      //return "1400px";
    },
    iFrameContainerComputed: function() {

      var headerheight = 0;
      if (this.$store.getters.currentSubCategory.apps.length > 1) {
        headerheight += 50;
      }
      if (
        this.config.queryFilterChecked ||
        this.config.downloadChecked ||
        this.config.queryBarChecked
      ) {
        //headerheight += 50;
      }

      var left = 200;
      if (!this.$store.state.menuOpen) left = 0;

      return {
        border: "0px solid #888",
        //overflow: "hidden !important",
        position: "fixed",
        top: 60 + headerheight + "px",
        left: left + "px",
        right: "0px"
      };

      return {};
    },
    styleContainerComputed: function() {
      if (this.$store.getters.currentSubCategory.apps.length == 1) {
        return {
          border: "10px solid green",
          overflow: "hidden !important",
          position: "absolute",
          bottom: "0px",
          top: "60px",
          left: "210px",
          right: "0px"
        };
      } else {
        return {
          border: "1px solid red",
          overflow: "auto",
          position: "absolute !important",
          bottom: "0px",
          top: "0px",
          left: "0px",
          right: "0px"
        };
      }
    }
  },
  methods: {
    printKey: function (e){
      console.log(e)
    },
    urlTooLong: function() {  
      if((this.$browserDetect.isEdge || this.$browserDetect.isIE) && this.computedurl.length > 2046)
        return true
      if(this.$browserDetect.isChrome && this.computedurl.length > 32778)
        return true
      if(this.$browserDetect.isChromeIOS > 8192)
        return true

      return false
    },
    createUrl: function() {
      if (this.ready) {
        console.log("UPDATE QUERY...");
        var cururl = this.config.config.computedurl;
        var searchParams = cururl.split('?')[1];
        var params = new URLSearchParams(searchParams);

        if (this.config.config.grafanaTime && !this.grafanaTimeBit){
          // Créer une instance de URLSearchParams
          const searchParams = new URLSearchParams(this.config.config.grafanaTime);

          // Récupérer les valeurs des paramètres
          const fromValue = searchParams.get("from");
          const toValue = searchParams.get("to");

          // Mettre à jour les paramètres dans l'objet data
          params.set("from", fromValue);
          params.set("to", toValue);
        } else {
          var startTimeAsUtc = moment(this.$store.getters.timeRange[0]).utc();
          var endTimeAsUtc = moment(this.$store.getters.timeRange[1]).utc();
          
          const now = new Date();
            const nowWithoutSeconds = new Date(now);
            nowWithoutSeconds.setSeconds(0, 0);

            const endTimeWithoutSeconds = new Date(endTimeAsUtc.unix()*1000);
            endTimeWithoutSeconds.setSeconds(0, 0);

            if (nowWithoutSeconds.getTime() === endTimeWithoutSeconds.getTime()) {
              const delta = endTimeAsUtc.unix()*1000 - startTimeAsUtc.unix()*1000;
              params.set("from", 'now-'+delta / 1000+'s');
              params.set("to", 'now');
            } else {
              params.set("from", startTimeAsUtc.unix()*1000);
              params.set("to", endTimeAsUtc.unix()*1000);
            }
          var updatedParams = params.toString();
          cururl = cururl.replace(searchParams, updatedParams);
          cururl = cururl.replace(/=&/g, "&");
        }

        if (this.config.config.grafanaTime) {
          this.grafanaTimeBit = true
        }
        this.computedurl = cururl;
      }
      console.log("COMPUTED URL: ", this.computedurl)
    },
    injectStyleIframe: function() {
      var iframe = document.getElementById("grafana-iframe");
      iframe.contentWindow.Mousetrap.reset();
      var hideFilterStyle =
        "filter-bar {  background-color: white !important; border-bottom:none !important;}  .filter-bar {  background-color: white !important; border-bottom:none !important;} ";

      if (this.config.hideFilter) {
        hideFilterStyle =
          "  filter-bar {display: none;}  .filter-bar {   background-color: white !important; border-bottom:none !important; height: 0px;visibility: hidden; padding: 0px !important;}";
      }

      $("iframe")
        .contents()
        .find("head")
        .append(
          $(
            "<style type='text/css'> dashboard-viewport-provider {background-color: white !important;}  .theme-light .dshDashboardViewport-withMargins{background-color:white !important;} " +
              hideFilterStyle +
              "  </style>"
          )
        );
    }
  },
  created: function() {
    setTimeout(
      function() {
        this.injectStyleIframe();
      }.bind(this),
      1500
    );
      
    this.ready = true;
    this.createUrl();
  },
  mounted: function() {
    console.log("===============  REGISTERING GRAFANA:");
    console.log(this.computedurl);
    this.$globalbus.$on("timerangechanged", payLoad => {
      console.log("GLOBALBUS/GRAFANATIMERANGE/");
      this.createUrl();
    });
  },
  beforeDestroy: function() {
    console.log("===============  UNREGISTERING GRAFANA:");
    this.$globalbus.$off("timerangechanged");
    this.$globalbus.$off("grafanaactivated");
  }
};
</script>

<style>
</style>

