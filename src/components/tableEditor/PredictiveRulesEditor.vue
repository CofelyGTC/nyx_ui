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
              <el-col :span=4>
                    <el-form-item label="Symbol" :label-width="formLabelWidth">
                        <el-select v-model="conditionPLCSymbol">
                            <el-option v-for="(item, id) in symbols" :key="id" :label="item" :value="item"></el-option>
                        </el-select>
                    </el-form-item>
              </el-col>
              <el-col :span=6>    
                <el-form-item label="Value: " :label-width="formLabelWidth2">
                    <el-input-number size="mini" v-model="conditionPLCValue" :min="0"></el-input-number>
                </el-form-item>
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

    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button @click="$emit('dialogclose')">{{this.$t("buttons.cancel")}}</el-button>
      <el-button
        v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
        type="primary"
        :disabled="!recchanged"
        @click="saveRecord()"
      >{{this.$t("buttons.confirm")}}</el-button>
    </span>
  </el-dialog>
</template>

<script>
import Vue from "vue";

import YAML from "js-yaml";
import axios from "axios";

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
    building: '-',
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
    symbols: ['>', '<', '<=', '>=', '==', '!='],
    conditionPLC: '',
    conditionPLCTag: '',
    conditionPLCSymbol: '>',
    conditionPLCValue: 0,
    tagsPLCCondition: [],

    
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

    this.getBuildingsList();
    this.prepareData();

    
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