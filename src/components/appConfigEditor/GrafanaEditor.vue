<template>
  <div id="grafana-editor">
    <el-card>
      <!-- <h1>{{fieldList}}</h1> -->
      <el-form>
        <!--el-row>
          <el-col :span="8">
            <el-form-item label="Hidden Query" :label-width="formLabelWidth">
              <el-input size="mini" v-model="currentConfig.config.hiddenQuery" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>

          <el-col :span="8">
            <el-form-item label="Filter Column" :label-width="formLabelWidth">
              <el-input size="mini" v-model="currentConfig.config.filtercolumn" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row-->

        <el-row>
          <el-col :span="16" style="text-align: left;">
            <el-form-item label="Dashboard URL" :label-width="formLabelWidth">
              <el-input size="mini" 
              @blur="computeUrlFromGrafana"
              v-model="currentConfig.config.url" 
              autocomplete="off"
              ></el-input>
            </el-form-item>
          </el-col>

          <el-col :span="8">
            <el-form-item
              label="Grafana Time"
              :label-width="formLabelWidth"
              prop="config.grafanaTime"
            >
              <el-input
                size="mini"
                @blur="GrafanaTimeChange"
                v-model="currentConfig.config.GrafanaTime"
              ></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        </el-form>
        <el-form>
        <el-row>&nbsp;</el-row>

        <el-row :gutter="24" style="text-align:left">
          <!--el-col :span="8">
            <el-form-item label :label-width="formLabelWidth">
              <el-row>
                <el-switch
                  v-model="currentConfig.queryBarChecked"
                  active-text="Query Bar"
                  @change="query_bar_changed"
                ></el-switch>
              </el-row>
              <el-row>
                <el-switch v-model="currentConfig.downloadChecked" active-text="Download"></el-switch>
              </el-row>
              <el-row>
                
              </el-row>
            </el-form-item>
          </el-col-->
          <el-col :span="8">
            <el-form-item label :label-width="formLabelWidth">
              <!--el-row>
                <el-switch
                  v-model="currentConfig.queryFilterChecked"
                  active-text="Query Filter"
                  @change="query_filter_changed"
                ></el-switch>
              </el-row-->

              <el-row>
                <el-switch v-model="currentConfig.timeSelectorChecked" active-text="Time Selector"></el-switch>
              </el-row>

              <el-row>
                <el-select
                  size="mini"
                  v-model="currentConfig.timeSelectorType"
                  placeholder="Please select a type"
                  @change="timeSelectorTypeChange"
                  :disabled="!currentConfig.timeSelectorChecked"
                >
                  <el-option label="Free" value="classic"></el-option>
                  <el-option label="Day" value="day"></el-option>
                  <el-option label="Month" value="month"></el-option>
                  <el-option label="Week" value="week"></el-option>
                  <el-option label="Year" value="year"></el-option>
                </el-select>
              </el-row>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label :label-width="formLabelWidth">
            <!--el-row>
              <el-switch v-model="currentConfig.hideFilter" active-text="Hide Filter"></el-switch>
            </el-row-->
            <el-row>
              <el-switch
                v-model="currentConfig.timeRefresh"
                @change="timeRefreshSwitchChange"
                active-text="Time Refresh"
              ></el-switch>
            </el-row>
            <el-row>
              <el-select
                :disabled="!currentConfig.timeRefresh"
                size="mini"
                v-model="currentConfig.timeRefreshValue"
                placeholder="Refresh Interval"
                @change="timeRefreshSelectChange"
              >
                <el-option label="5 seconds" value="5s"></el-option>
                <el-option label="10 seconds" value="10s"></el-option>
                <el-option label="30 seconds" value="30s"></el-option>
                <el-option label="1 minute" value="1m"></el-option>
                <el-option label="5 minutes" value="5m"></el-option>
                <el-option label="15 minutes" value="15m"></el-option>
                <el-option label="30 minutes" value="30m"></el-option>
                <el-option label="1 hour" value="1h"></el-option>
                <el-option label="2 hours" value="2h"></el-option>
                <el-option label="12 hours" value="12h"></el-option>
                <el-option label="1 day" value="1d"></el-option>
              </el-select>
            </el-row>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <!-- <UserQueriesEditor
                  :currentConfig="currentConfig"
                  :allFields="allFieldsFilter"
          ></UserQueriesEditor>-->
        </el-row>
      </el-form>
      <div></div>
    </el-card>
  </div>
</template>
<script>

export default {
  field: "GrafanaEditor",
  data() {
    return (
      window.__FORM__ || {
        formLabelWidth: "120px",
        formFielfEditorVisible: false,
        currentField: {},
        listLoading: false,
        dashboards: [],
        selectedDash: null,
        selectedDashId: null
      }
    );
  },
  computed: {
    curConfigIn: function() {
      return this.currentConfig;
    },
    fieldList: function() {
      return this.currentConfig.config.headercolumns.map(x => x.field);
    }
  },
  watch: {},
  props: {
    currentConfig: { type: Object }
  },
  created: function() {
    //this.prepareData();
  },
  methods: {
    query_filter_changed:function() {
        if(this.currentConfig.queryFilterChecked)
          this.currentConfig.queryBarChecked=false;

    },
    query_bar_changed:function() {
        if(this.currentConfig.queryBarChecked)
          this.currentConfig.queryFilterChecked=false;

    },
    timeSelectorTypeChange() {
      if (this.currentConfig.timeSelectorType != null)
        this.currentConfig.timeSelectorChecked = true;

      var tmp = JSON.parse(JSON.stringify(this.currentConfig));
      this.currentConfig = null;
      this.currentConfig = tmp;
    },
    timeRefreshSelectChange() {
      if (this.currentConfig.timeRefreshValue != null)
        this.currentConfig.timeRefresh = true;


      this.computeUrlFromGrafana();


      var tmp = JSON.parse(JSON.stringify(this.currentConfig));
      this.currentConfig = null;
      this.currentConfig = tmp;
    },
    
    timeRefreshSwitchChange() {
      this.computeUrlFromGrafana();


      var tmp = JSON.parse(JSON.stringify(this.currentConfig));
      this.currentConfig = null;
      this.currentConfig = tmp; 

      console.log(this.currentConfig.config.url)
    },
    GrafanaTimeChange() {
      console.log("grafana time changed");
      this.computeUrlFromGrafana();
    },
    computeUrlFromGrafana() {
      console.log("computeUrlFromGrafana");
      if (this.currentConfig.url != "") {
        this.currentConfig.config.computedurl = this.currentConfig.config.url.replace("grafana","grafananyx") + this.computeGrafanaUrlFromOptions()
      }
    },
    computeGrafanaUrlFromOptions() {
      console.log('computeGrafanaUrl')
      var url = "";
      var timek = "from=now-7d&to=now";
      if (
        this.currentConfig.config != undefined &&
        this.currentConfig.config.grafanaTime != undefined
      ) {
        console.log("saving grafana time");
        console.log(this.currentConfig.config.grafanaTime); 
        timek = this.currentConfig.config.grafanaTime;
      }

      console.log(timek);
      this.currentConfig.config.grafanaTime = timek;
      var strRefresh=""
      if (this.currentConfig.timeRefresh && this.currentConfig.timeRefreshValue != null)
        strRefresh = '&refresh='+this.currentConfig.timeRefreshValue

      url +=  strRefresh + "&" + timek ;
      url += "&kiosk";
      console.log(
        "********************compute grafana url***********************"
      );
      console.log(url);

      return url;
    },
  }
};
</script>
<style>
#form-editor .padding-right {
  padding-right: 10px;
}
</style>