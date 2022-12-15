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
            <el-col :span=12>
              <el-form-item label="Sélectionner Salle: " :label-width="formLabelWidth">
                  <el-select v-model="selectedRoomID" filterable placeholder="Sélectionner" @change="roomchanged">
                      <el-option
                          v-for="(item, id) in rooms"
                          :key="id"
                          :label="item +' ('+id+')'"
                          :value="id">
                      </el-option>
                    </el-select>
              </el-form-item>
            
            </el-col>
            <el-col :span=12>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span=12>
               <el-form-item label="Sélectionner Date: " :label-width="formLabelWidth">
                 <el-date-picker
                  v-model="date"
                  type="date"
                  placeholder="Choississez un jour">
                </el-date-picker>
               </el-form-item>
            </el-col>
            <el-col :span=12>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span=12>
              <el-form-item label="Sélectionner Heure Début: " :label-width="formLabelWidth">
                <el-time-select
                  v-model="hourStart"
                  :picker-options="{
                    start: '00:00',
                    step: '00:15',
                    end: '23:45'
                  }"
                  placeholder="Choisissez un horaire">
                </el-time-select>
               </el-form-item>
            </el-col>
            <el-col :span=12>
              <el-form-item label="Sélectionner Heure Fin: " :label-width="formLabelWidth">
                <el-time-select
                  v-model="hourStop"
                  :picker-options="{
                    start: '00:00',
                    step: '00:15',
                    end: '23:45'
                  }"
                  placeholder="Choisissez un horaire">
                </el-time-select>
               </el-form-item>
            </el-col>
          </el-row>
          <el-row>
              
              

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


export default {
  name: "ulgTimetableEditor",
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
    title: "ULG-Timetable-Editor",
    selectedRoom: '',
    selectedRoomID: '',
    rooms:{},
    date: '',
    hourStart: '',
    hourStop: '',


    
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
      this.getRooms();
      
    },

    getRooms: function(){

        var url = this.$store.getters.apiurl + "lambdas/5/getrooms?apikey=" + this.$store.getters.creds.token;
        var body = {};
        axios
        .post(url, body)
        .then((response) => {
            this.rooms = response.data.rooms
            this.$forceUpdate();
        });

    },

    roomchanged: function(){
      console.log(this.rooms[this.selectedRoomID])
      this.selectedRoom = this.rooms[this.selectedRoomID]
      
    },

    formatDate: function(x, y) {
      var z = {
          M: x.getMonth() + 1,
          d: x.getDate(),
          h: x.getHours(),
          m: x.getMinutes(),
          s: x.getSeconds()
      };
      y = y.replace(/(M+|d+|h+|m+|s+)/g, function(v) {
          return ((v.length > 1 ? "0" : "") + z[v.slice(-1)]).slice(-2)
      });

      return y.replace(/(y+)/g, function(v) {
          return x.getFullYear().toString().slice(-v.length)
      });


    },

    

    saveRecord: function() {

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.lastModification = Date.now()

      this.newRec._source.id_room = this.selectedRoomID
      this.newRec._source.name_room = this.selectedRoom
      this.newRec._source.date = this.formatDate(this.date, "dd-MM-yyyy")
      this.newRec._source['@timestamp']= this.date.getTime()
      this.newRec._source.start_time = this.hourStart+':00'
      this.newRec._source.end_time = this.hourStop+':00'


      var startHours = this.hourStart.substring(0,2)
      var startMinutes =  this.hourStart.substring(3)
      var endHours = this.hourStop.substring(0,2)
      var endMinutes = this.hourStop.substring(3)

      console.log(startHours)
      console.log(startMinutes)
      console.log(endHours)
      console.log(endMinutes)


      this.newRec._source.start_datetime = parseInt(this.date.getTime()) + (parseInt(startHours) * 3600000) + (parseInt(startMinutes)*60000)
      this.newRec._source.end_datetime = parseInt(this.date.getTime()) + (parseInt(endHours) * 3600000) + (parseInt(endMinutes)*60000)





      

      

      this.$store.commit({
        type: "updateRecord",
        data: this.newRec
      });
      this.$notify({ 
        title: "Record saved.",
        type: "success",
        message: "L'horaire a été enregistré.",
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