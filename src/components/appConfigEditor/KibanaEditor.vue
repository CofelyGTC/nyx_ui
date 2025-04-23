<template>
  <div id="kibana-editor">
    <el-card>
      <!-- <h1>{{fieldList}}</h1> -->
      <el-form>
        <el-row>
          <el-col :span="8">
            <el-form-item label="Hidden Query" :label-width="formLabelWidth">
              <el-input size="mini" @blur="computeUrl" v-model="currentConfig.config.hiddenQuery" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>

          <el-col :span="8">
            <el-form-item label="Filter Column" :label-width="formLabelWidth">
              <el-input size="mini" v-model="currentConfig.config.filtercolumn" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="8" style="text-align: left;">
            <el-form-item label="Dashboard" :label-width="formLabelWidth">
              <el-select
                size="mini"
                @change="kibanaDashboardSelected"
                v-model="currentConfig.config.kibanaId"
                placeholder="Select"
                :loading="listLoading"
                style="width:100%"
                filterable
              >
                <el-option
                  v-for="dash in dashboards"
                  :key="dash.id"
                  :label="dash.space+' - '+dash.attributes.title"
                  :value="dash.id"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8" style="text-align: left;">
            <el-form-item :label-width="formLabelWidth">
              <el-button
                :disabled="currentConfig.config.kibanaId==null||dashboards.length==0"
                size="mini"
                type="danger"
                @click="openInKibana()"
                style="width:100%"
              >Open in Kibana</el-button>
            </el-form-item>
          </el-col>

          <el-col :span="8">
            <el-form-item
              label="Kibana Time"
              :label-width="formLabelWidth"
              prop="config.kibanaTime"
            >
              <el-input
                size="mini"
                @blur="kibanaTimeChange"
                v-model="currentConfig.config.kibanaTime"
              ></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        </el-form>
        <el-form>
        <el-row>&nbsp;</el-row>

        <el-row :gutter="24" style="text-align:left">
          <el-col :span="8">
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
          </el-col>
          <el-col :span="8">
            <el-form-item label :label-width="formLabelWidth">
              <el-row>
                <el-switch
                  v-model="currentConfig.queryFilterChecked"
                  active-text="Query Filter"
                  @change="query_filter_changed"
                ></el-switch>
              </el-row>

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
            <el-row>
              <el-switch v-model="currentConfig.hideFilter"
              @change="computeUrl"
              active-text="Hide Filter"></el-switch>
            </el-row>
            <el-row>
              <el-switch
                v-model="currentConfig.timeRefresh"
                @change="computeUrl"
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
                <el-option label="5 seconds" value="5000"></el-option>
                <el-option label="10 seconds" value="10000"></el-option>
                <el-option label="30 seconds" value="30000"></el-option>
                <el-option label="45 seconds" value="45000"></el-option>
                <el-option label="1 minute" value="60000"></el-option>
                <el-option label="5 minutes" value="300000"></el-option>
                <el-option label="15 minutes" value="900000"></el-option>
                <el-option label="30 minutes" value="1800000"></el-option>
                <el-option label="1 hour" value="3600000"></el-option>
                <el-option label="2 hours" value="7200000"></el-option>
                <el-option label="12 hours" value="43200000"></el-option>
                <el-option label="1 day" value="86400000"></el-option>
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
import Vue from "vue";
import axios from "axios";
import rison from "rison";

// import _ from "lodash";

//import kibanaeditor from "@/components/appConfigEditor/KibanaEditor";
//Vue.component("KibanaEditor", kibanaeditor);

function transformObject(obj) {
  return rison.encode(obj);
}

export default {
  field: "KibanaEditor",
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
    currentConfigIn: function() {
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
    this.prepareData();
    console.log("created - this.currentConfig",this.currentConfig);
  },
  methods: {
    computeUrl(){
      this.computeUrlFromKibana()
    },
    query_filter_changed:function() {
        if(this.currentConfig.queryFilterChecked){
          this.currentConfig.queryBarChecked=false;
        }
        this.computeUrlFromKibana()
    },
    query_bar_changed:function() {
        if(this.currentConfig.queryBarChecked){
          this.currentConfig.queryFilterChecked=false;
        }
        this.computeUrlFromKibana()
    },
    timeSelectorTypeChange() {
      if (this.currentConfig.timeSelectorType != null){
        this.currentConfig.timeSelectorChecked = true;
      }
      this.computeUrlFromKibana()
    },
    timeRefreshSelectChange() {
      if (this.currentConfig.timeRefreshValue != null){
        this.currentConfig.timeRefresh = true;
      }
      this.computeUrlFromKibana();
    },
    prepareData() {
      this.loadKibanaDashboards();
    },
    openInKibana() {
      console.log(this.currentConfig);
      window.open(
        this.currentConfig.config.url
          .replace("kibananyx", "kibana")
          .replace("embed=true", "")
          .replace(",title:Test", "")
          .replace("title:Test,", "")
      );
    },
    kibanaTimeChange() {
      console.log("kibana time changed");
      this.computeUrlFromKibana();
    },

    kibanaDashboardSelected() {
      for (var i in this.dashboards) {
        if (this.dashboards[i].id == this.currentConfig.config.kibanaId) {
          this.selectedDash = this.dashboards[i];
          this.currentConfig.config.space = this.selectedDash.space
        }
      }
      this.computeUrlFromKibana()
    },

    computeUrlFromKibana() {
      console.log("computeUrlFromKibana");
      if (this.currentConfig.config.kibanaId != null) {
        var space = this.currentConfig.config.space != "default" ? `s/${this.currentConfig.config.space}/`: ""
        this.currentConfig.config.url =
        "." +
        this.$store.getters.kibanaurl.replace("kibana", "kibananyx") +
        `${space}app/dashboards#/view/` +
        this.computeKibanaUrlFromSelectedDash();
      }
    },

    computeKibanaUrlFromSelectedDash() {
      var url = this.currentConfig.config.kibanaId + "?embed=true";
      console.log(this.currentConfig);
      if(this.currentConfig.hideFilter) url += "&hide-filter-bar=" + this.currentConfig.hideFilter;
      if(this.currentConfig.queryBarChecked) url += "&show-query-input=" + this.currentConfig.queryBarChecked;
      
      var timek = "from:now-7d,mode:quick,to:now";
      if (
        this.currentConfig.config != undefined &&
        this.currentConfig.config.kibanaTime != undefined
      ) {
        timek = this.currentConfig.config.kibanaTime;
      }
      this.currentConfig.config.kibanaTime = timek;
      
      
      var strRefresh = "refreshInterval:(pause:!t,value:0)";
      if (this.currentConfig.timeRefresh && this.currentConfig.timeRefreshValue != null)
      strRefresh = 'refreshInterval:(pause:!f,value:'+this.currentConfig.timeRefreshValue+')'
    
    url += "&_g=(" + strRefresh + ",time:(" + timek + ")";
    
    if (this.currentConfig.config.hiddenQuery != undefined) {
      url += `,query:(language:lucene,query:'${this.currentConfig.config.hiddenQuery}')`;
    }else{
      url += ",query:(language:lucene,query:'*')";
    }
    
    url += ")";  
    console.log('url: ', url);
    return url;
  },
  
  loadKibanaDashboards: function() {
    this.listLoading = true;
    this.dashboards = [];
    var url = this.$store.getters.apiurl.replace(/\/$/,"") + 
        this.$store.getters.kibanaurl +
        "api/spaces/space"

      axios
        .get(url, {
          params:{
            token : this.$store.getters.creds.token
          }})
        .then(response => {
          this.loadKibanaDashboards2(response.data);
        })
        .catch(error => {
          console.log(error);
          setTimeout(() => {
            this.listLoading = false;

          }, 1500)
        });
    },

    loadKibanaDashboards2: async function(spaces) {
      this.dashboards = [];
      for (var i in spaces) {
        var space = spaces[i];

        var spaceurl = "s/" + space.id + "/";
        var url = this.$store.getters.apiurl.replace(/\/$/,"") + 
          this.$store.getters.kibanaurl +
          spaceurl +
          "api/saved_objects/_find?type=dashboard&per_page=1000&page=1";

        const response = await axios.get(url, {
          params:{
            token : this.$store.getters.creds.token
          }
        });
        this.addDashboards(response.data, space.id);
      }
      this.listLoading = false;
    },

    addDashboards: function(newdashs, space) {
      for (var i in newdashs.saved_objects) {
        var dash = newdashs.saved_objects[i];
        dash.space = space;
        this.dashboards.push(dash);
      }
    }
  }
};
</script>
<style>
#form-editor .padding-right {
  padding-right: 10px;
}
</style>