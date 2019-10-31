<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="cogen-editor"
  >
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
        <el-form-item label="Id" :label-width="formLabelWidth">
          <el-input :disabled="editMode!='create'" size="mini" v-model="newRec._id" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="Name" :label-width="formLabelWidth">
          <el-input :disabled="editMode!='create'" size="mini" v-model="newRec._source.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="Last Update" :label-width="formLabelWidth">
          <el-date-picker :disabled="editMode!='create'" v-model="newRec._source.LastUpdate" type="date" format="yyyy/MM/dd" value-format="timestamp" ></el-date-picker>
        </el-form-item>
        <el-form-item label="Hours" :label-width="formLabelWidth" >
          <el-input-number size="mini" v-model="newRec._source.Hours" min=0></el-input-number>
        </el-form-item>
        <el-form-item label="Starts-Stops" :label-width="formLabelWidth">
          <el-input-number size="mini" v-model="newRec._source.Starts" min=0></el-input-number>
        </el-form-item>
        <el-form-item label="Entretiens réalisés" :label-width="formLabelWidth">
          <el-checkbox-group v-model="maintenancesMade">
            <el-checkbox v-for="maintenance in maintenances" v-model="maintenance.maintenanceDone" :label="maintenance._id" :key="maintenance.maintenanceDone">{{maintenance._id}} ({{maintenance._source.maintenance_interval}} heures)</el-checkbox>
          </el-checkbox-group>
        </el-form-item>  
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
  name: "cogenEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    maintenances: null,
    maintenancesMade: [],
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    changed: false,
    dialogFormVisible: false,
    title: "Cogen configuration"
  }),
  computed: {
    recordin: function() {
      return this.record;
    },
    recordstr: function() {
      return JSON.stringify(this.record);
    },
    recchanged: function() {
      return ((JSON.stringify(this.recordin) != JSON.stringify(this.newRec)) || (this.maintenancesMade.length > 0)) ;
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
      this.maintenances = this.getMaintenances();
    },
    getMaintenances: function() {
        var url =
        this.$store.getters.apiurl + "generic_search/maintenance_parameters?token=" +this.$store.getters.creds.token;
        var query = {
          size: 1000,
          query: {
              bool: {
                must: [
                  {
                    match_phrase: {
                      Motor: this.newRec._source.Motor
                    }
                  }
                ]
              }
            }
        };
      axios
        .post(url, query)
        .then(response => {

          //console.log(JSON.stringify(response))

          this.loadMaintenance(response.data.records);

        })
        
      }, 
    
    loadMaintenance: async function(recordsdata) {

      console.log(JSON.stringify(recordsdata))

     this.maintenances = recordsdata
     this.maintenances.forEach(function(entry){
       entry.maintnenanceDone = false
     });

    },
    
    saveRecord: function() {
      if (!this.weatherActivated && this.newRec._source.weather != null) {
        delete this.newRec._source.weather;
      }

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.LastUpdate = Date.now()
      
      if (this.maintenancesMade.length > 0){
        this.newRec._source.last_maintenance = this.newRec._source.LastUpdate
        this.newRec._source.maintenancesMade = this.maintenancesMade
      }



      this.$store.commit({
        type: "updateRecord",
        data: this.newRec
      });
      this.$notify({ 
        title: "Record saved.",
        type: "success",
        message: "The cogen has been succesfuly saved.",
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