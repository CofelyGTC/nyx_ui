<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="predictive-rules"
  >
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <h2>Description</h2>
          <el-row>
              <el-col :span=8>
                <el-form-item label="Rule ID" :label-width="formLabelWidth">
                    <el-input size="mini" v-model="ruleID" autocomplete="off"></el-input>
                </el-form-item>
              </el-col>  
              <el-col :span=8>
                <el-form-item label="Rule Name" :label-width="formLabelWidth">
                    <el-input size="mini" v-model="ruleName" autocomplete="off"></el-input>
                </el-form-item>
              </el-col> 
              <el-col :span=8>
                <el-form-item label="Rule Type" :label-width="formLabelWidth">
                   <el-select v-model="ruleType" filterable placeholder="Select">
                       <el-option v-for="(item, type) in rulesTypes" :key="type" :label="item" :value="item">
                       </el-option>
                   </el-select>
                </el-form-item>
              </el-col> 
          </el-row>
      </el-card>
      <br>
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <h2>Building</h2><br>
          <el-row>
              <el-form-item label="Select: " :label-width="formLabelWidth">
                   <el-select v-model="building" filterable placeholder="Select"  @change="changeBuilding">
                       <el-option v-for="(item, type) in buildingList" :key="type" :label="item" :value="item">
                       </el-option>
                   </el-select>
                </el-form-item>
          </el-row>
      </el-card>
      <br>
      <el-card v-if="building != ''" shadow="hover" :body-style="{ padding: '10px' }">
          <h2>Conditions</h2>
          <br>
          <el-row style="text-align:left;">
              <el-col>
                  <label>Weather</label>
              </el-col>
              <el-col v-for="(condition, index) in this.conditionsWeather" :key="index">
                  <el-row>
                        <el-col :span=4>
                           <el-form-item label="City" :label-width="formLabelWidth">
                              {{condition.city}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=3>
                           <el-form-item label="Table" :label-width="formLabelWidth">
                              {{condition.table}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=4>
                           <el-form-item label="Tag" :label-width="formLabelWidth">
                              {{condition.tag}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=4>
                           <el-form-item label="Value" :label-width="formLabelWidth">
                              <el-input-number size="mini" v-model="condition.value" :min="0"></el-input-number>
                           </el-form-item>
                        </el-col>
                        <el-col :span=4>
                           <el-form-item label="Symbol" :label-width="formLabelWidth">
                             <el-select v-model="condition.symbol">
                                 <el-option v-for="(item, id) in symbols" :key="id" :label="item" :value="item"></el-option>
                             </el-select>
                           </el-form-item>
                        </el-col>
                        <el-col :span=4>
                           <el-form-item label="Time (ms)" :label-width="formLabelWidth">
                              {{condition.time}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=1>
                           <center>
                           <el-button @click="removeWeatherCondition(index)" type="danger" icon="el-icon-delete" circle>
                           </el-button>
                           </center>
                       </el-col>
                  </el-row>
              </el-col>
          </el-row>
          <br>
          <el-row>
          
            <el-col :span=6>
              <el-form-item label="City" :label-width="formLabelWidth">
                  <el-select v-model="weatherCity">
                      <el-option v-for="(item, id) in cities" :key="id" :label="item" :value="item"></el-option>
                  </el-select>
                </el-form-item>
            </el-col>
            <el-col :span=6>
              <el-form-item label="Table" :label-width="formLabelWidth">
                  <el-select v-model="weatherTable">
                      <el-option v-for="(item, id) in weatherTables" :key="id" :label="item" :value="item"></el-option>
                  </el-select>
                </el-form-item>
            </el-col>
            <el-col :span=6>
              <el-form-item label="Tag" :label-width="formLabelWidth">
                  <el-select v-model="weatherTag">
                      <el-option v-for="(item, id) in weatherTags" :key="id" :label="item" :value="item"></el-option>
                  </el-select>
                </el-form-item>
            </el-col>
            </el-row>
            <el-row>
            <el-col :span=6>
                <el-form-item label="Value" :label-width="formLabelWidth">
                  <el-input-number size="mini" v-model="weatherValue"></el-input-number>
                </el-form-item>
              </el-col>
            <el-col :span=6>
              <el-form-item label="Symbol" :label-width="formLabelWidth">
                  <el-select v-model="weatherSymbol">
                      <el-option v-for="(item, id) in symbols" :key="id" :label="item" :value="item"></el-option>
                  </el-select>
                </el-form-item>
            </el-col>
            <el-col :span=6>
                <el-form-item label="Time (ms)" :label-width="formLabelWidth">
                  <el-input-number size="mini" v-model="weatherTime"></el-input-number>
                </el-form-item>
            </el-col>
            <el-col :span=2>
                <el-button type="primary" @click="addWeatherCondition()" icon="el-icon-plus" circle></el-button>
            </el-col>
            </el-row>
          <br>
          <el-row>
              <el-col style="text-align:left;">
                  <label>PLCs</label>
              </el-col>
              <el-col v-for="(condition, index) in this.conditionsPLC" :key="index">
                  <el-row>
                        <el-col :span=4>
                           <el-form-item label="PLC" :label-width="formLabelWidth">
                              {{condition.PLC}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=8>
                           <el-form-item label="Tag" :label-width="formLabelWidth2">
                              {{condition.tag}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=4>
                           <el-form-item label="Value" :label-width="formLabelWidth">
                              <el-input-number size="mini" v-model="condition.value" :min="0"></el-input-number>
                           </el-form-item>
                        </el-col>
                        <el-col :span=4>
                           <el-form-item label="Symbol" :label-width="formLabelWidth">
                             <el-select v-model="condition.symbol">
                                 <el-option v-for="(item, id) in symbols" :key="id" :label="item" :value="item"></el-option>
                             </el-select>
                           </el-form-item>
                        </el-col>
                        <el-col :span=4>
                           <center>
                           <el-button @click="removePLCCondition(index)" type="danger" icon="el-icon-delete" circle>
                           </el-button>
                           </center>
                       </el-col>
                  </el-row>     
              </el-col>
          </el-row>
          <br>
          <br>
          <el-row>
              <el-col :span=6>
                  <el-form-item label="PLC:" :label-width="formLabelWidth">
                   <el-select v-model="conditionPLC" filterable placeholder="Select" @change="changePLCCondition">
                       <el-option v-for="(item, type) in PLCs" :key="type" :label="item" :value="item">
                       </el-option>
                   </el-select>
                </el-form-item>
              </el-col>
              <el-col :span=6>
                  <el-form-item label="Tag:" :label-width="formLabelWidth">
                   <el-select v-model="conditionPLCTag" filterable placeholder="Select">
                       <el-option v-for="(item, type) in tagsPLCCondition" :key="type" :label="item" :value="item">
                       </el-option>
                   </el-select>
                </el-form-item>
              </el-col>
              <el-col :span=6>
                    <el-form-item label="Symbol" :label-width="formLabelWidth">
                        <el-select v-model="conditionPLCSymbol">
                            <el-option v-for="(item, id) in symbols" :key="id" :label="item" :value="item"></el-option>
                        </el-select>
                    </el-form-item>
              </el-col>
          </el-row>
          <el-row>
              <el-col :span=6>    
                <el-form-item label="Value: " :label-width="formLabelWidth2">
                    <el-input-number size="mini" v-model="conditionPLCValue" :min="0"></el-input-number>
                </el-form-item>
            </el-col>
            <el-col :span=6>    
                <el-form-item label="Time(ms): " :label-width="formLabelWidth2">
                    <el-input-number size="mini" v-model="conditionPLCTime" :min="0"></el-input-number>
                </el-form-item>
            </el-col>
            <el-col :span=6>
              &nbsp
            </el-col>
            <el-col :span=2>
                <el-button type="primary" @click="addPLCCondition()" icon="el-icon-plus" circle></el-button>
            </el-col>
          </el-row>

      </el-card>
      <br>
      <el-card v-if="building != ''" shadow="hover" :body-style="{ padding: '10px' }">
          <h2>Actions</h2>
          <br>
          <el-row style="text-align:left;">
           <el-col v-for="(action, index) in this.actions" :key="index">
                <el-row style="text-align:left;">
                       <el-col :span=4>
                           <el-form-item label="PLC" :label-width="formLabelWidth">
                              {{action.PLC}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=8>
                           <el-form-item label="Tag" :label-width="formLabelWidth">
                              {{action.tag}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=4>
                           <el-form-item label="Type" :label-width="formLabelWidth">
                              {{action.action}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=4 style="text-align:left;">    
                           <el-form-item label="Value: ">
                               <el-input-number size="mini" v-model="action.value" :min="0"></el-input-number>
                           </el-form-item>
                       </el-col>
                       <el-col :span=4>
                           <center>
                           <el-button @click="removeAction(index)" type="danger" icon="el-icon-delete" circle>
                           </el-button>
                           </center>
                       </el-col>
                </el-row>
           </el-col>
       </el-row>
        <br>
        <br>
          <el-row>
              <el-col :span=5>
                  <el-form-item label="Type:" :label-width="formLabelWidth">
                   <el-select v-model="actionType" filterable placeholder="Select">
                       <el-option v-for="(item, type) in actionsTypes" :key="type" :label="item" :value="item">
                       </el-option>
                   </el-select>
                </el-form-item>
              </el-col>
              <el-col :span=5>
                  <el-form-item label="PLC:" :label-width="formLabelWidth">
                   <el-select v-model="plcAction" filterable placeholder="Select" @change="changePLCAction">
                       <el-option v-for="(item, type) in PLCs" :key="type" :label="item" :value="item">
                       </el-option>
                   </el-select>
                </el-form-item>
              </el-col>
              <el-col :span=6>
                  <el-form-item label="Tag:" :label-width="formLabelWidth">
                   <el-select v-model="tagAction" filterable placeholder="Select">
                       <el-option v-for="(item, type) in tagsAction" :key="type" :label="item" :value="item">
                       </el-option>
                   </el-select>
                </el-form-item>
              </el-col>
              <el-col :span=6>    
                <el-form-item label="Value: " :label-width="formLabelWidth2">
                    <el-input-number size="mini" v-model="actionValue" :min="0"></el-input-number>
                </el-form-item>
            </el-col>
            <el-col :span=2>
                <el-button type="primary" @click="addAction()" icon="el-icon-plus" circle></el-button>
            </el-col>
            
          </el-row>
      </el-card> 
      <el-card v-if="building != ''" shadow="hover" :body-style="{ padding: '10px' }">
          <h2>Next Run</h2>
          <br>
          <el-row style="text-align:left;">
            <el-col :span=6>
              <el-form-item label="Last Run: " :label-width="formLabelWidth">
                {{lastRun}}
              </el-form-item>
            </el-col>
            <el-col :span=6>
              <el-form-item label="Next Run: " :label-width="formLabelWidth">
                {{nextRun | formatDate}}
              </el-form-item>
            </el-col>
          </el-row>
          <el-row style="text-align:left;">
            <el-col :span=6>
              <el-form-item label="Next Run Type: " :label-width="formLabelWidth2">
                <el-select v-model="nextRunType" filterable placeholder="Select">
                    <el-option v-for="(item, type) in nextRunTypes" :key="type" :label="item" :value="item">
                    </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col v-if="nextRunType=='daily'" :span=6>
              <el-form-item label="Day interval: " :label-width="formLabelWidth2">
                  <el-input-number size="mini" v-model="dailyDays" :min="0"></el-input-number>
              </el-form-item>
            </el-col>
            <el-col v-if="nextRunType=='daily'" :span=6>
              <el-form-item label="Hour: " :label-width="formLabelWidth2">
                  <el-time-select
                      v-model="dailyTime"
                      :picker-options="{
                        start: '00:00',
                        step: '00:15',
                        end: '23:45'
                      }"
                      placeholder="Pick a Time">
                    </el-time-select>

              </el-form-item>
            </el-col>
            <el-col v-if="nextRunType=='interval'" :span=6>
              <el-form-item label="Time Before Reset (ms): " :label-width="formLabelWidth2">
                  <el-input-number size="mini" v-model="interval" :min="0"></el-input-number>
              </el-form-item>
            </el-col>
          </el-row>

      </el-card>     

    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button @click="$emit('dialogclose')">{{this.$t("buttons.cancel")}}</el-button>
      <el-button
        v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
        type="primary"
        @click="saveRecord()"
      >{{this.$t("buttons.confirm")}}</el-button>
    </span>
  </el-dialog>
</template>

<script>
import Vue from "vue";

import YAML from "js-yaml";
import axios from "axios";
import moment from 'moment';

export default {
  name: "PredictiveRulesEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    formLabelWidth2: "180px",
    changed: false,
    dialogFormVisible: false,
    title: "Rule Editor",
    ruleID: '',
    ruleName: '',
    ruleType: '',
    rulesTypes: ['generic', 'customcode'],
    building: '',
    actions: [],
    buildingList: [],
    actionsTypes: ['write', 'read'],
    actionType: '',
    tagsAction: [],
    tagsCondition: [],
    PLCs: [],
    plcCondtion: '',
    plcAction: '',
    tagAction: '',
    actionValue: 0,
    conditionsWeather: [],
    conditionsPLC: [],
    conditions: {},
    symbols: ['>', '<', '<=', '>=', '==', '!='],
    conditionPLC: '',
    conditionPLCTag: '',
    conditionPLCSymbol: '>',
    conditionPLCValue: 0,
    conditionPLCTime: 0,
    tagsPLCCondition: [],
    cities: [],
    weatherTables: ['pred', 'real'],
    weatherTags: ['temp', 'temp_max', 'temp_min', 'hum', 'ppcp', 'qpcp', 'radiance', 'wind_direction', 'wind_speed_from', 'win_speed_to'],
    weatherCity: '',
    weatherTable: '',
    weatherTag: '',
    weatherValue: 0,
    weatherSymbol: '',
    weatherTime: 0,
    blocked: false,
    lastRun: 0,
    nextRunType: '',
    nextRunConf: {},
    //nextRun: 0,
    nextRunTypes: ['daily', 'interval'],
    dailyDays: '0',
    dailyTime: '00:00',
    interval: 0


  }),
  computed: {
    recordin: function() {
      return this.record;
    },
    recordstr: function() {
      return JSON.stringify(this.record);
    },
    recchanged: function() {
      return JSON.stringify(this.recordin) != JSON.stringify(this.newRec);
    },
    nextRun: function() {
        

      if(this.nextRunType == 'interval')
      {
        return this.lastRun + this.interval
      }
      else{
        
        var daysms = this.dailyDays*86400000 
        
        var nextrun = new Date(this.lastRun+daysms)

        console.typeof

        console.log(nextrun)
        console.log(this.dailyTime.substring(2,0))

        var hours = parseInt(this.dailyTime.substring(0,2))
        var minutes = parseInt(this.dailyTime.substring(3))

        //var hours = this.dailyTime.getHours()
        //var minutes = this.dailyTime.getMinutes()
        console.log(typeof nextrun)
        nextrun.setHours(hours)
        nextrun.setMinutes(minutes)
        nextrun.setSeconds(0)
        
        console.log(nextrun)

        return nextrun



      }
    }
  },
  filters: {
      formatDate: function(value){
        return moment(String(value)).format('DD-MM-YYYY HH:mm')
      }
  },
  props: {
    record: {
      type: Object
    },
    config: {
      type: Object
    },
    editMode: {
      type: String
    }
  },
  watch: {
    recordin: {
      handler: function() {
        this.prepareData();
      },
      deep: true
    }
  },
  created: function() {
    console.log("created event");

    console.log(this.record)

    if(this.record._source.actions)
    {
        console.log("ACTION")
        this.ruleID =  this.record._source.ruleID
        this.ruleName =  this.record._source.ruleName
        this.ruleType =  this.record._source.ruleType
        this.building = this.record._source.building
        this.actions = this.record._source.actions
        this.getPLCs();
        
    }
    if(this.record._source.conditions)
    {
        console.log("CONDITION")
        this.conditionsWeather = this.record._source.conditions.weather
        this.conditionsPLC = this.record._source.conditions.PLC
    }

    if(this.record._source.blocked)
    {
      this.blocked = this.record._source.blocked
    }

    if(this.record._source.lastRun)
    {
      this.lastRun = this.record._source.lastRun
    }

    if(this.record._source.nextRunConf)
    {
      this.nextRunConf = this.record._source.nextRunConf
    }

    if(this.record._source.nextRunType)
    {
      this.nextRunType = this.record._source.nextRunType
    }

    if(this.record._source.nextRun)
    {
      this.nextRun = this.record._source.nextRun
    }



    this.getBuildingsList();
    this.prepareData();
    this.getCities();

    
  },
  components: {},
  methods: {
    closeDialog: function() {
      this.$emit("dialogclose");
    },
    prepareData: function() {
      console.log("prepare data");
      this.dialogFormVisible = true;
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
    },

    removeAction: function(index){
    console.log("coucou")
    console.log(this.newRec._source.actions[index])
    //delete this.newRec._source.ingredients[index]
    this.actions.splice(index, 1)
    
    },

    removeWeatherCondition: function(index){
        this.conditionsWeather.splice(index, 1);
    },

    removePLCCondition: function(index){
        this.conditionsPLC.splice(index, 1);
    },

    saveRecord: function() {

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.lastUpdate = Date.now()
      this.newRec._source.actions = this.actions
      this.newRec._source.blocked = this.blocked
      this.newRec._source.building = this.building
      this.conditions.PLC = this.conditionsPLC
      this.conditions.weather = this.conditionsWeather
      this.newRec._source.conditions = this.conditions
      this.newRec._source.lastRun = this.lastRun
      this.newRec._source.nextRunType = this.nextRunType

      if(this.nextRunType == 'interval')
      {
        this.nextRunConf = {"interval": this.interval}
      }
      else
      {
        this.nextRunConf = {"day": this.dailyDays, "hour": this.dailyTime}
      }


      this.newRec._source.nextRunConf = this.nextRunConf
      this.newRec._source.nextRun = this.nextRun
      this.newRec._source.ruleID = this.ruleID
      this.newRec._source.ruleName = this.ruleName
      this.newRec._source.ruleType = this.ruleType


      /*
      dailyDays: '0',
      dailyTime: 0,
      interval: 0
      */

      this.$store.commit({
        type: "updateRecord",
        data: this.newRec
      });
      this.$notify({ 
        title: "Record saved.",
        type: "success",
        message: "Rule Saved",
        position: "bottom-right"
      });
      this.$emit("dialogcloseupdated");
    },

    getBuildingsList: function() {
        var url = this.$store.getters.apiurl + "lambdas/5/get_predictive_buildings_lists?apikey=" + this.$store.getters.creds.token;
        var body = {};
        axios
        .post(url, body)
        .then((response) => {
            console.log(response)
            this.buildingList = response.data.buildings
            this.$forceUpdate();
        });
    },

    getCities: function() {
      var url = this.$store.getters.apiurl + "lambdas/5/get_predictive_cities?apikey=" + this.$store.getters.creds.token;
        var body = {};
        axios
        .post(url, body)
        .then((response) => {
            console.log(response)
            this.cities = response.data.cities
            this.$forceUpdate();
        });

    },

    changeBuilding: function() {
        console.log("GET PLCs")
        this.getPLCs();
        
    },
    changePLCAction: function () {
        this.getTagsAction();
    },
    changePLCCondition: function () {
        this.getTagsPLCCondition();
    },
    getPLCs: function (){
        var url = this.$store.getters.apiurl + "lambdas/5/get_predictive_plc_lists?apikey=" + this.$store.getters.creds.token;
        var body = {"building": this.building};
        axios
        .post(url, body)
        .then((response) => {
            console.log(response)
            this.PLCs = response.data.plcs
            this.$forceUpdate();
        });
    },
    getTagsAction: function (){
        var url = this.$store.getters.apiurl + "lambdas/5/get_predictive_tags_lists?apikey=" + this.$store.getters.creds.token;
        var body = {"building": this.building, "plc": this.plcAction};
        axios
        .post(url, body)
        .then((response) => {
            console.log(response)
            this.tagsAction = response.data.tags
            this.$forceUpdate();
        });
    },

    getTagsPLCCondition: function (){
        var url = this.$store.getters.apiurl + "lambdas/5/get_predictive_tags_lists?apikey=" + this.$store.getters.creds.token;
        var body = {"building": this.building, "plc": this.conditionPLC};
        axios
        .post(url, body)
        .then((response) => {
            console.log(response)
            this.tagsPLCCondition = response.data.tags
            this.$forceUpdate();
        });

    },

    addAction: function (){
        var action = {
            "PLC": this.plcAction,
            "action": this.actionType,
            "tag": this.tagAction,
            "value": this.actionValue
        }

        console.log(this.actions)

        this.actions.push(action)
    },
    addPLCCondition: function(){
        var condition = {
            "PLC": this.conditionPLC,
            "symbol": this.conditionPLCSymbol,
            "tag": this.conditionPLCTag,
            "value": this.conditionPLCValue

        }

        this.conditionsPLC.push(condition);
    },
    addWeatherCondition: function(){
      var condition = {
        "city": this.weatherCity,
        "symbol": this.weatherSymbol,
        "table": this.weatherTable,
        "tag": this.weatherTag,
        "time": this.weatherTime,
        "value": this.weatherValue
      }

      this.conditionsWeather.push(condition)
    }

  }
};
</script>

<style >
.bhd-tech-editor .view-table {
  margin-bottom: 30px;
}
.bhd-tech-editor .screen-name-input {
  margin-bottom: 10px;
}

.bhd-tech-editor .add-view-button {
  margin-bottom: 30px;
}
</style>