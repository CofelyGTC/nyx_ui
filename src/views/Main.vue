<template>
  <div v-if="$store.getters.activeApp">
    <ChangePassword
      v-if="changePasswordVisible"
      v-on:changepassword_closed="changePasswordVisible=false"
    ></ChangePassword>
    <el-container v-bind:style="styleContainerComputed">
      <!--el-container-->
      <el-header style="text-align: right; font-size: 12px">
        <el-row :gutter="24">
          <el-col :span="1">
            <el-button class="menu-button" style="background-color: #002439 !important; padding:17px; color:#70BD95 !important" @click="changeMenuState">
              <v-icon name="bars" scale="1.5" @click="changeMenuState"/>
            </el-button>
          </el-col>
          <el-col :span="5" style="text-align: left; font-size: 22px;color:white;">
            <span>
              &nbsp;{{$store.getters.maintitle}}
            </span>
          </el-col>
          <el-col :span="18" style="text-align: right;" class="time-selector-row">           
            <div
              v-if="$store.getters.activeApp.timeSelectorChecked && ($store.getters.activeApp.timeSelectorType==undefined || $store.getters.activeApp.timeSelectorType=='classic')"
            >
              <!-- CLASSIC TIME SELECTED -->
              <div>
                <el-popover
                  v-if="$store.getters.activeApp.timeSelectorChecked && (timeType=='relative')"
                  placement="bottom"
                  width="500"
                  trigger="click"
                  
                  @hide="relativeTimeClosed"
                >
                  <el-form style="margin-top: 7px;">
                    <el-row>
                      <el-col :span="12">
                        <el-form-item :label="$t('time.last')">
                          <el-input-number
                            :min="1"
                            size="mini"
                            v-model="relativeTimeValue"
                            autocomplete="off"
                            @change="relativeTimeClosed"
                          ></el-input-number>
                        </el-form-item>
                      </el-col>
                      <el-col :span="12">
                        <el-form-item >
                        <el-select
                          style="width:97%"
                          size="mini"
                          v-model="relativeTimeType"
                          placeholder="Please select a value"
                          @change="relativeTimeClosed"
                        >
                          <el-option :label="$t('time.minute')" value="m"></el-option>
                          <el-option :label="$t('time.hour')" value="h"></el-option>
                          <el-option :label="$t('time.day')" value="d"></el-option>
                          <el-option :label="$t('time.week')" value="w"></el-option>
                        </el-select>
                        </el-form-item>
                      </el-col>
                    </el-row>
                  </el-form>
                  <el-button
                    size="mini"
                    slot="reference"
                    style="margin-right:5px;"
                  >{{$t('time.last')}} {{relativeTimeValue}} {{relativeTimeType}}</el-button>
                </el-popover>
              </div>
              <div 
                v-if="$store.getters.activeApp.timeSelectorChecked && (timeType=='absolute')"
              >
                <el-date-picker
                  style="top:0px;"
                  :picker-options="rangePickerOptions"
                  v-model="timerange"
                  v-on:change="timeRangeChanged"
                  size="mini"
                  type="datetimerange"
                  range-separator="To"
                  start-placeholder="Start date"
                  end-placeholder="End date"
                  align="center"
                  :clearable="false"
                  :default-time="['00:00:00', '23:59:59']"
                  :unlink-panels="true"
                ></el-date-picker>&nbsp;&nbsp;
              </div>
              <el-radio-group
                style="margin-bottom:3px;"
                @change="timeModeChanged"
                v-if="$store.getters.activeApp.timeSelectorChecked"
                size="mini"
                v-model="timeType"
                fill="#70BD95"
              >
                <el-radio-button label="absolute">{{$t('time.absolute')}}</el-radio-button>
                <el-radio-button label="relative">{{$t('time.relative')}}</el-radio-button>
              </el-radio-group>&nbsp;&nbsp;
            </div>

            <div
              v-if="$store.getters.activeApp.timeSelectorChecked && ($store.getters.activeApp.timeSelectorType=='day')"
            >
              <!-- day TIME SELECTED -->
              <el-date-picker
                v-model="dayPicker"
                v-on:change="dayChanged"
                :picker-options="{firstDayOfWeek:1}"
                type="date"
                size="mini"
                placeholder="Pick a day"
                :clearable="false"
              ></el-date-picker>&nbsp;&nbsp;
            </div>

            <div
              v-if="$store.getters.activeApp.timeSelectorChecked && ($store.getters.activeApp.timeSelectorType=='week')"
            >
              <!-- week TIME SELECTED -->
              <el-date-picker
                v-model="weekPicker"
                v-on:change="weekChanged"
                :picker-options="{firstDayOfWeek:1}"
                type="week"
                size="mini"
                placeholder="Pick a week"
                :clearable="false"
              ></el-date-picker>&nbsp;&nbsp;
            </div>
            <div
              v-if="$store.getters.activeApp.timeSelectorChecked && ($store.getters.activeApp.timeSelectorType=='month')"
            >
              <!-- month TIME SELECTED -->
              <el-date-picker
                v-model="monthPicker"
                v-on:change="monthChanged"
                type="month"
                size="mini"
                placeholder="Pick a month"
                :clearable="false"
              ></el-date-picker>&nbsp;&nbsp;
            </div>
            <div
              v-if="$store.getters.activeApp.timeSelectorChecked && ($store.getters.activeApp.timeSelectorType=='year')"
            >
              <!-- year TIME SELECTED -->
              <el-date-picker
                v-model="yearPicker"
                v-on:change="yearChanged"
                type="year"
                size="mini"
                placeholder="Pick a year"
                :clearable="false"
              ></el-date-picker>&nbsp;&nbsp;
            </div>
            <!-- </el-col>
            <el-col :span="3" style="text-align:right;">-->
            <Apps v-on:appclicked="appClicked"></Apps>&nbsp;&nbsp;
            <Logout v-on:changepassword="changePassword"></Logout>
          </el-col>
        </el-row>
      </el-header>

      <el-container :style="{'background-color':$store.getters.activeApp.darkMode?'#052538':'#fff'}">
        <transition name="el-zoom-in-top">
          <el-aside width="200px" v-bind:style="styleAsideComputed" class="aside" v-show="menuOpen">
            <el-row class="tac">
              <el-col :span="24">
                <el-menu
                  :default-active="$store.getters.currentSubCategory.fulltitle"
                  :unique-opened="true"
                  class="el-menu-vertical"
                  text-color="#70BD95"
                  active-text-color="#FFFFFF"
                >
                  <!--            v-if="menu.category!='apps'"-->
                  <el-submenu
                    v-for="menu in filteredmenus"
                    :key="menu.category"
                    :index="menu.category"
                  >
                    <template slot="title">
                      <!--<i class="el-icon-location"></i>-->
                      <span>{{menu.loc_category}}</span>
                    </template>
                    <el-menu-item
                      v-for="subMenu in menu.submenus"
                      :index="subMenu.fulltitle"
                      :key="subMenu.fulltitle"
                      @click="appClicked(subMenu)"
                      class="submenu-item"
                    >
                      <!-- :key="menu.category+'/'+subMenu.title" -->
                      <!-- :index="menu.category+'/'+subMenu.title" -->
                      <!-- <v-icon
                        class="menuiconaside"
                        :name="subMenu.icon"
                        v-if="subMenu.icon"
                        scale="1"
                      /> -->
                      <img 
                        class="menuiconaside" 
                        v-if="subMenu.icon && subMenu.icon.includes('https')" 
                        :src="subMenu.icon" 
                        style="height:16px;width: 16px;filter: brightness(0%) invert(54%) sepia(100%) hue-rotate(80deg) saturate(1.4)"
                      > 
                      <!-- style="height:16px;width: 16px;filter: invert(76%) sepia(12%) saturate(1095%) hue-rotate(96deg) brightness(89%) contrast(84%)" -->
                      <v-icon 
                        class="menuiconaside" 
                        v-else-if="subMenu.icon" 
                        :name="subMenu.icon" 
                        scale="1" 
                      />
                      &nbsp;{{subMenu.loc_title}}
                    </el-menu-item>
                  </el-submenu>
                </el-menu>
              </el-col>
            </el-row>
            <!--span style="color:white;font-size:8px;">{{$store.getters.containerSize}}</span-->
          </el-aside>
        </transition>

        <el-main class="nooverflowmain">
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script>
import axios from "axios";
import logout from "@/components/Logout";
import apps from "@/components/Apps";
import changepassword from "@/components/ChangePassword";
import Vue from "vue";
import moment from "moment";
import _ from "lodash";

Vue.component("Logout", logout);
Vue.component("Apps", apps);
Vue.component("ChangePassword", changepassword);

// @ is an alias to /src
export default {
  name: "home",
  data: () => ({
    styleContainer: "B",
    maintitle: "NYX",
    timerange: "",
    timerangeselected: false,
    startDate: "",
    yearPicker: moment(),
    monthPicker: moment(),
    weekPicker: moment(),
    dayPicker: moment(),
    menuOpen: true,
    resizeListener: null,
    changePasswordVisible: false,
    timeType: "absolute",

    relativeTimeType: "h",
    relativeTimeValue: 4,

    rangePickerOptions: {
    }
  }),
  computed: {
    styleContainerComputed: function() {
      return {
        overflow: "hidden",
        border: 0 + "px solid #eee",
        //padding: 1 + "px",
        height: this.containerSize.height - 0 + "px"
      };
    },
    styleAsideComputed: function() {
      return {
        overflow: "auto",
        height: this.containerSize.height - 60 + "px"
      };
    },
    apiurl() {
      return this.$store.getters.apiurl;
    },
    menus() {
      return this.$store.getters.menus;
    },
    apps() {
      return this.$store.getters.apps;
    },
    creds() {
      return this.$store.getters.creds;
    },
    filteredmenus() {
      // console.log('this.$store.getters.filteredmenus: ', this.$store.getters.filteredmenus);
      return this.$store.getters.filteredmenus;
    },
    containerSize() {
      return this.$store.getters.containerSize;
    }
  },
  methods: {
    updateDateFin() {
      // if (this.$store.getters.activeApp.type == 'grafana'){
      //   if (this.timeType == "absolute"){
      //     this.end = new Date();
      //     this.timeRangeChanged([this.startDate, this.end], "update");
      //   }
      //   if (this.timeType == "relative"){
      //     this.$store.commit({
      //       type: "setTimeRange",
      //       data: {
      //         type: "relative",
      //         relativeType: this.relativeTimeType,
      //         relativeValue: this.relativeTimeValue
      //       }
      //     });
      //   }
      // }
    },
    getClient(){
      //var demandor = this.$store.getters.creds.user.id          
      var url = this.$store.getters.apiurl + "getClient"

      console.log('CHECK NYX CLIENT')

      axios
      .get(url)
        .then((response) => {
            if(response.data.error!="")
            console.log("Client Calls list error...");
            else{
                // console.log(response.data)
                //var res = JSON.parse(response.data)
                var res = response.data
                // console.log("CLIENT : ")
                // console.log(res)
                var client = res.client
                this.$store.commit({
                  type: "setClient",
                  data: client
                });
                
                // console.log(client)
                
                
                
               
            }
            return null;
        });  

    },
    changeMenuState() {
      this.menuOpen = !this.menuOpen;
      this.$store.commit({
        type: "setMenuState",
        data: this.menuOpen
      });
    },
    timeModeChanged(e) {
      this.timeType = null
      this.timeType = e
      if (e == "relative") {
        this.relativeTimeClosed();
      } else if (e == "absolute") {
        this.timeRangeChanged(this.timerange);
      }
    },
    relativeTimeClosed: _.debounce(function() {
      
      console.log("RELATIVE TIME RANGE CHANGED");
      this.$store.commit({
        type: "setTimeRange",
        data: {
          type: "relative",
          relativeType: this.relativeTimeType,
          relativeValue: this.relativeTimeValue
        }
      });
      this.$globalbus.$emit("timerangechanged", {
        type: "relative",
        subtype: "classic"
      });
    }, 500),    
    dayChanged(e) {
      console.log("DAY CHANGED");
      var dstart = moment(e);
      var dend = moment(e);
      dend.endOf("day");

      var ran = [dstart.toDate(), dend.toDate()];
      this.timerange = ran;
      this.$store.commit({
        type: "setTimeRange",
        data: { range: ran, type: "absolute", subtype: "day" }
      });
      this.$globalbus.$emit("timerangechanged", {
        range: ran,
        type: "absolute",
        subtype: "day"
      });
    },
    weekChanged(e) {
      console.log("WEEK CHANGED");
      var dstart = moment(e);
      var dend = moment(e);
      dend.endOf("week");

      var ran = [dstart.toDate(), dend.toDate()];
      this.timerange = ran;
      this.$store.commit({
        type: "setTimeRange",
        data: { range: ran, type: "absolute", subtype: "week" }
      });
      this.$globalbus.$emit("timerangechanged", {
        range: ran,
        type: "absolute",
        subtype: "week"
      });
    },
    monthChanged(e) {
      console.log("MONTH CHANGED");
      var dstart = moment(e);
      var dend = moment(e);
      dend.endOf("month");

      var ran = [dstart.toDate(), dend.toDate()];
      this.timerange = ran;
      this.$store.commit({
        type: "setTimeRange",
        data: { range: ran, type: "absolute", subtype: "month" }
      });
      this.$globalbus.$emit("timerangechanged", {
        range: ran,
        type: "absolute",
        subtype: "month"
      });
    },
    yearChanged(e) {
      console.log("YEAR CHANGED");
      var dstart = moment(e);
      var dend = moment(e);
      dend.endOf("year");

      var ran = [dstart.toDate(), dend.toDate()];
      this.timerange = ran;
      this.$store.commit({
        type: "setTimeRange",
        data: { range: ran, type: "absolute", subtype: "year" }
      });
      this.$globalbus.$emit("timerangechanged", {
        range: ran,
        type: "absolute",
        subtype: "year"
      });
    },
    timeRangeChanged(e) {
      console.log("TIME RANGE CHANGED");
      this.timerange = e;
      this.$store.commit({
        type: "setTimeRange",
        data: { range: e, type: "absolute", subtype: "classic" }
      });
      this.$globalbus.$emit("timerangechanged", {
        range: e,
        type: "absolute",
        subtype: "classic"
      });
    },
    changePassword() {
      this.changePasswordVisible = true;
    },
    appClicked(e) {
      // console.log("app clicked");
      // console.log(e);
      if (e.type == "external") {
        window.open(e.config.url);
      } else {
        this.maintitle = e.loc_title;
    
        var path = "/main/" + e.apps[0].rec_id

        if(path != this.$route.path)
          this.$router.push(path);
      }
    },
    changeContainerSize: _.debounce(function(newSize) {
      this.$store.commit({
        type: "changeContainerSize",
        data: { height: newSize.innerHeight, width: newSize.innerWidth }
      });
    }, 500)
  },
  created: async function() {
    console.log("Main vue created");

    this.rangePickerOptions= {
      shortcuts: [
        {
          text: this.$t("datepicker.last_24_hours"),
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 1);
            picker.$emit("pick", [start, end]);
          }
        },
        {
          text: this.$t("datepicker.last_7_days"),
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
            picker.$emit("pick", [start, end]);
          }
        },
        {
          text: this.$t("datepicker.previous_month"),
          onClick(picker) {
            const start = new Date();
            var dateFrom = moment(start)
              .subtract(1, "months")
              .startOf("month")
              .toDate();
            var dateTo = moment(start)
              .subtract(1, "months")
              .endOf("month")
              .toDate();
            picker.$emit("pick", [dateFrom, dateTo]);
          }
        },
        {
          text: this.$t("datepicker.current_month"),
          onClick(picker) {
            const start = new moment().startOf("month").toDate();
            const end = new moment().endOf("month").toDate();
            picker.$emit("pick", [start, end]);
          }
        },
        {
          text: this.$t("datepicker.next_month"),
          onClick(picker) {
            const start = new Date();
            var dateFrom = moment(start)
              .add(1, "months")
              .startOf("month")
              .toDate();
            var dateTo = moment(start)
              .add(1, "months")
              .endOf("month")
              .toDate();
            picker.$emit("pick", [dateFrom, dateTo]);
          }
        },
        {
          text: this.$t("datepicker.last_3_months"),
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
            picker.$emit("pick", [start, end]);
          }
        },
        {
          text: this.$t("datepicker.last_year"),
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 365);
            picker.$emit("pick", [start, end]);
          }
        },
        {
          text: this.$t("datepicker.today"),
          onClick(picker) {
            const end = moment()
              .startOf("day")
              .add(1, "d")
              .toDate();
            const start = moment()
              .startOf("day")
              .toDate();

            picker.$emit("pick", [start, end]);
          }
        },
        {
          text: this.$t("datepicker.current_week"),
          onClick(picker) {
            const start = new moment().startOf("week").toDate();
            const end = new moment().endOf("week").toDate();
            picker.$emit("pick", [start, end]);
          }
        },
        {
          
          text: this.$t("datepicker.current_year"),
          onClick(picker) {
            const start = new moment().startOf("year").toDate();
            const end = new moment().endOf("year").toDate();
            picker.$emit("pick", [start, end]);
          }
        }
      ]
    }

    if (this.$store.getters.currentSubCategory == undefined && localStorage.authResponse) {
        var path = this.$route.path
        if(path[path.length-1] == '/')
          path = path.substring(0, path.length-1)

        var rec_id = path.replace('/main/', '')

        var authResponse = JSON.parse(localStorage.authResponse)

        var url =
          this.$store.getters.apiurl +
          "status?token=" +
          authResponse.data.cred.token;

        try {

          const response = await axios.get(url)

          if(response.status == 200 && response.data.error=='') {
            this.$store.commit({
              type: "login",
              data: authResponse.data
            });
            
            this.$store.commit({
              type: "changeApp",
              data: rec_id
            });

            if(authResponse.data.cred.user.privileges.includes('admin')) {

              this.$store.commit({
                type: "privileges",
                data: authResponse.data.all_priv
              });
              this.$store.commit({
                type: "filters",
                data: authResponse.data.all_filters
              });
            }
          }
        }
        catch (e){
          console.log(e);
        }
    }


    if (this.$store.getters.currentSubCategory == undefined) {
      // console.log('NOT LOGGED YET')
      var path = this.$route.path
      if(path[path.length-1] == '/')
	      path = path.substring(0, path.length-1)


      this.$store.state.redirection = path
      // console.log(this.$route)
      
      
      this.$router.push("/");

      return;
    }

    const end = new Date();
    const start = new Date();
    start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
    this.startDate = start;
    this.timeRangeChanged([start, end]);
    setInterval(this.updateDateFin, 10000)
  },
  mounted: function() {
    console.log("===============  REGISTERING FORCETIME:");
    this.$globalbus.$on("forcetime", payLoad => {
      console.log('force time for this app')

      let val = payLoad.substring(0, payLoad.length-1)
      let unit = payLoad.substring(payLoad.length-1, payLoad.length)

      this.yearPicker =  moment().add(val, unit)
      this.monthPicker =  moment().add(val, unit)
      this.weekPicker =  moment().add(val, unit)
      this.dayPicker =  moment().add(val, unit)

      if(this.$store.getters.activeApp.timeSelectorChecked && (this.$store.getters.activeApp.timeSelectorType=='year')) {
        this.yearChanged(this.monthPicker.format('YYYY'))
      }
      else if(this.$store.getters.activeApp.timeSelectorChecked && (this.$store.getters.activeApp.timeSelectorType=='month')) {
        this.monthChanged(this.monthPicker.format('YYYY-MM'))
      }
      else if(this.$store.getters.activeApp.timeSelectorChecked && (this.$store.getters.activeApp.timeSelectorType=='week')) {
        this.weekChanged(this.monthPicker.format('YYYY-MM-DD'))
      }
      else if(this.$store.getters.activeApp.timeSelectorChecked && (this.$store.getters.activeApp.timeSelectorType=='day')) {
        this.dayChanged(this.monthPicker.format('YYYY-MM-DD'))
      }
      
      
    });
    console.log("===============  REGISTERING CTRU:");
    this.$globalbus.$on("charttimerangeupdated", payLoad => {
      console.log("GLOBALBUS/CHARTTIMERANGEUPDATED/");
      const end = new Date();
      const start = new Date();
      start.setTime(payLoad[0]);
      end.setTime(payLoad[1]);
      this.timeType = "absolute";

      this.timeRangeChanged([start, end]);
    });

    console.log("Mounting Main Component");
    this.$store.commit({
      type: "changeContainerSize",
      data: { height: window.innerHeight, width: window.innerWidth }
    });

    this.$nextTick(() => {
      this.resizeListener = window.addEventListener("resize", () => {
        console.log("MAIN RESIZE");
        this.changeContainerSize(window);
      });
    });
    this.getClient();
  },
  beforeDestroy: function() {
    console.log("===============  UNREGISTERING CTRU:");
    this.$globalbus.$off("charttimerangeupdated");
    this.$globalbus.$off("forcetime");
    window.removeEventListener("resize", this.resizeListener);
  }
};
</script>
<style>
/* .el-aside {
  border-right: 1px solid rgb(226, 226, 226);
} */

.el-aside .el-menu {
  border-right: none;
  background-color: #002439 !important;
}

.el-main {
  padding: 2px !important;
  padding-left: 10px !important;
}

body {
  margin: 0px;
  overflow: hidden;
  background-color: white;
}

.aside {
  text-align: left;
  overflow: none;
  height: 100%;
  background-color: #002439 !important;
}
.el-menu-vertical:not(.el-menu--collapse) {
  width: 200px;
}

.el-submenu__title {
  height: 40px !important;
  line-height: 40px !important;
  font-weight: bold;
}

.el-submenu .el-menu-item {
  height: 40px !important;
  line-height: 40px !important;
  padding: 0 45px;
  min-width: 200px;
}

.menuiconaside {
  margin-bottom: 3px;
}
.menuiconbig {
  margin-bottom: -8px;
  color: white;
}
.nooverflowmain {
  overflow: hidden !important;
}

.el-dialog__title {
  color: white !important;
}

.el-dialog__headerbtn .el-dialog__close {
  color: white !important;
}

.el-picker-panel [slot="sidebar"] + .el-picker-panel__body,
.el-picker-panel__sidebar + .el-picker-panel__body {
  margin-left: 160px !important;
}

.el-picker-panel [slot="sidebar"],
.el-picker-panel__sidebar {
  width: 150px !important;
}

.el-header {
  background-color: white !important;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.2);
  line-height: 60px;
  background-color: #002439 !important;
  border-bottom: 0px;
}
.el-header button{
  background-color: #70BD95 !important;
  color: white;
  border: 0px;
}
.el-header .el-date-editor {
  background-color: #70BD95 !important;
  border: 0px !important;
  line-height:20px;
  border-radius: 4px;
}
.el-header .el-date-editor *{
  background-color: #70BD95 !important;
  color: white  !important;
  border: 0px !important;
}
.el-header .el-col-5 span {
  font-weight: bold;
  color: #c0c4cc;
}

.el-header .el-col-5 {
  max-height: 60px;
  overflow: hidden;
}

.el-dialog__header {
  background-color: #70BD95 !important;
}
.login-container {
  background-color: #70BD95 !important;
}

.el-table th > .cell {
  color: black;
}

.el-form-item__error {
  top: 80% !important;
}

.el-loading-mask {
  background-color: hsla(0, 0%, 100%, 0.7) !important;
  transition: opacity 2.1s !important;
}

.time-selector-row div {
  display: inline-block;
}
.el-menu-item.is-active:hover{
  color: #002439 !important;
}
.el-menu-item.is-active:focus{
  color: #002439 !important;
}
</style>