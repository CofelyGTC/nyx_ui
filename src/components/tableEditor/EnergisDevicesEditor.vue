<template>
    <el-dialog
      width="80%"
      :title="title"
      :visible.sync="dialogFormVisible"
      :before-close="closeDialog"
      :close-on-click-modal="false"
      class=""
    >
      <el-form v-model="newRec._source">
        <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <el-row>
            <el-col :span="12">
              <el-form-item label="Metric ID" :label-width="formLabelWidth" >
                <el-input-number v-if="editMode=='create'" v-model="newRec._source.metric_id" step="1" :disabled="editMode!='create'"></el-input-number>
                <label v-else>{{ newRec._source.metric_id }}</label>
                </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="Rule Type" :label-width="formLabelWidth">
                   <el-select v-model="newRec._source.granularity" filterable placeholder="Select">
                       <el-option v-for="(item, type) in granularityList" :key="type" :label="item" :value="item">
                       </el-option>
                   </el-select>
                </el-form-item>
            </el-col>

          </el-row>
          <el-row>
            {{ this.newRec._source }}
          </el-row>
            <!-- 
              metric_id
              granularity
            -->
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
    name: "energisDevicesEditor",
    data: () => ({
      orgRec: null,
      newRec: null,
      strOrgRec: "",
      strNewRec: "",
      orgName: "",
      newName: "",
      formLabelWidth: "240px",
      changed: false,
      dialogFormVisible: false,
      last_value: '2018-01-01T00:00:00.000Z',
      title: "Energis Devices Editor",
      granularityList: ["FIVE_MINUTE", "TEN_MINUTE", "FIFTEEN_MINUTE", "THIRTY_MINUTE", "HOUR", "DAY", "MONTH", "YEAR", "MAX"]
      
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
    filters: {
        roundTo2: function(value){
          return value.toFixed(2);
        }
    },
    created: function() {
      console.log("created event");
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
        if(this.editMode!='create')
        {
          this.last_value = this.newRec._source.last_value;
        }
        
      },
  
  
      saveRecord: function() {
        
        this.newRec._source.last_value = this.last_value;
        this.newRec._source.modifyBy = this.$store.getters.creds.user.login
        this.newRec._source.lastModification = Date.now()
  
        
  
        
  
        this.$store.commit({
          type: "updateRecord",
          data: this.newRec
        });
        this.$notify({ 
          title: "Record saved.",
          type: "success",
          message: "Success Message.",
          position: "bottom-right"
        });
        this.$emit("dialogcloseupdated");
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