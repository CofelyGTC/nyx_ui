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
    name: "modelEditor",
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
      title: "Editor",
      
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
        
      },
  
  
      saveRecord: function() {
  
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