<template>
    <el-dialog
    width="70%"
    top="15%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="regular-timetable-editor"
    append-to-body>

  <div>
    
    <el-form v-model="newRec._source">
       <h1 style="text-align:center;">Configuration</h1>
       <el-row>
         <el-col :span=8>
              <el-form-item label="Sélectionner Circuit: " :label-width="formLabelWidth">
                  <el-select v-model="selectedCircuit" filterable placeholder="Sélectionner">
                      <el-option
                          v-for="(item, id) in circuits"
                          :key="id"
                          :label="item"
                          :value="item">
                      </el-option>
                    </el-select>
              </el-form-item>
            </el-col>
            <el-col :span=6>
              <el-form-item label="Nom  du DB: " :label-width="formLabelWidth">
                  <el-input v-model="DB" placeholder="Veuillez enter un nom... (DBXX)"></el-input>
              </el-form-item>
            </el-col>

       </el-row>
       <el-row>
         <el-col>
           <h2>Semaine: </h2>
         </el-col>
       </el-row>
       <el-row>
         <el-col :span=6>
           <el-form-item label="ON 1: " :label-width="formLabelWidth2">
             <el-time-select v-model="weekStart1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
         <el-col :span=6>
           <el-form-item label="OFF 1: " :label-width="formLabelWidth2">
             <el-time-select v-model="weekEnd1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
         <el-col :span=6>
           <el-form-item label="ON 2: " :label-width="formLabelWidth2">
             <el-time-select v-model="weekStart2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
         <el-col :span=6>
           <el-form-item label="OFF 2: " :label-width="formLabelWidth2">
             <el-time-select v-model="weekEnd2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
       </el-row>
       <el-row>
         <el-col>
           <h2>Samedi: </h2>
         </el-col>
       </el-row>
       <el-row>
         <el-col :span=6>
           <el-form-item label="ON 1: " :label-width="formLabelWidth2">
             <el-time-select v-model="saturdayStart1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
         <el-col :span=6>
           <el-form-item label="OFF 1: " :label-width="formLabelWidth2">
             <el-time-select v-model="saturdayEnd1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
         <el-col :span=6>
           <el-form-item label="ON 2: " :label-width="formLabelWidth2">
             <el-time-select v-model="saturdayStart2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
         <el-col :span=6>
           <el-form-item label="OFF 2: " :label-width="formLabelWidth2">
             <el-time-select v-model="saturdayEnd2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
       </el-row>
       <el-row>
         <el-col>
           <h2>Dimanche: </h2>
         </el-col>
       </el-row>
       <el-row>
         <el-col :span=6>
           <el-form-item label="ON 1: " :label-width="formLabelWidth2">
             <el-time-select v-model="sundayStart1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
         <el-col :span=6>
           <el-form-item label="OFF 1: " :label-width="formLabelWidth2">
             <el-time-select v-model="sundayEnd1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
         <el-col :span=6>
           <el-form-item label="ON 2: " :label-width="formLabelWidth2">
             <el-time-select v-model="sundayStart2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
         <el-col :span=6>
           <el-form-item label="OFF 2: " :label-width="formLabelWidth2">
             <el-time-select v-model="sundayEnd2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire">
             </el-time-select>
           </el-form-item>
         </el-col>
       </el-row>
       <el-row>
         <el-col style="text-align:right;">
           <el-button type="primary" @click="applyChange()">
             Appliquer
           </el-button>
         </el-col>
       </el-row>
      <h1 style="text-align:center;">Grille Horaire</h1>
      <el-row>
        <el-col :span=4>
          <label style="text-align:center;"><br></label>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <h2>ON Horaire 1</h2>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <h2>OFF Horaire 1</h2>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <h2>ON Horaire 2</h2>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <h2>OFF Horaire 2</h2>
        </el-col>
      </el-row>


      <el-row>
        <el-col :span=4>
          <label>Lundi</label>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.mondayON1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.mondayOFF1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.mondayON2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.mondayOFF2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
      </el-row>

      <el-row>
        <el-col :span=4>
          <label>Mardi</label>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.tuesdayON1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.tuesdayOFF1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.tuesdayON2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.tuesdayOFF2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
      </el-row>

      <el-row>
        <el-col :span=4>
          <label>Mercredi</label>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.wednesdayON1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.wednesdayOFF1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.wednesdayON2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.wednesdayOFF2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
      </el-row>

      <el-row>
        <el-col :span=4>
          <label>Jeudi</label>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.thursdayON1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.thursdayOFF1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.thursdayON2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.thursdayOFF2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
      </el-row>

      <el-row>
        <el-col :span=4>
          <label>Vendredi</label>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.fridayON1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.fridayOFF1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.fridayON2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.fridayOFF2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
      </el-row>

      <el-row>
        <el-col :span=4>
          <label>Samedi</label>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.saturdayON1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.saturdayOFF1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.saturdayON2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.saturdayOFF2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
      </el-row>

      <el-row>
        <el-col :span=4>
          <label>Dimanche</label>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.sundayON1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.sundayOFF1" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.sundayON2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
        <el-col :span=5 style="text-align:center;">
          <el-time-select v-model="newRec._source.sundayOFF2" :picker-options="{start: '00:00', end:'23:45', step: '00:15'}" placeholder="Choisissez un horaire"></el-time-select>
        </el-col>
      </el-row>
    </el-form>
  </div>
  <span slot="footer" class="dialog-footer">
      <el-button
        v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
        type="primary"
        @click="saveRecord()"
      >{{this.$t("buttons.confirm")}}</el-button>
      <el-button @click="$emit('dialogclose')">{{this.$t("buttons.cancel")}}</el-button>
  </span>
  </el-dialog>
</template>

<script>

import Vue from "vue";
import axios from "axios";
export default {
  name: "regularTimetableEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "150px",
    formLabelWidth2: "100px",
    changed: false,
    dialogFormVisible: false,
    title: "Editeur d'horaires standards",
    weekStart1: '00:00',
    weekStart2: '00:00',
    weekEnd1: '00:00',
    weekEnd2: '00:00',
    saturdayStart1: '00:00',
    saturdayEnd1: '00:00',
    saturdayStart2: '00:00',
    saturdayEnd2: '00:00', 
    sundayStart1: '00:00',
    sundayEnd1: '00:00',
    sundayStart2: '00:00',
    sundayEnd2: '00:00', 
    holidays: '',
    circuits: [],
    selectedCircuit: '',
    DB: '',


  }),
  mounted: function(){
      console.log("mounted event");
  },
  created: function (){
    this.prepareData();

  },
    props: {
    record: {
      type: Object
    },
    config: {
      type: Object
    }
  },
  components: {},
  methods: {
    closeDialog: function() {
      this.$emit("dialogclose");
    },
    prepareData: function() {
      console.log("prepare data");
      this.dialogFormVisible = true;
      this.getCircuits();
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
     
      this.DB = this.newRec._source.DB 
      this.selectedCircuit = this.newRec._source['circuit']
      this.weekStart1 = this.newRec._source.mondayON1 
      this.weekStart1 = this.newRec._source.tuesdayON1
      this.weekStart1 = this.newRec._source.wednesdayON1
      this.weekStart1 = this.newRec._source.thursdayON1
      this.weekStart1 = this.newRec._source.fridayON1
      this.weekStart1 = this.newRec._source.saturdayON1 
      this.weekStart1 = this.newRec._source.sundayON1
       
      this.weekStart2 = this.newRec._source.mondayON2
      this.weekStart2 = this.newRec._source.tuesdayON2
      this.weekStart2 = this.newRec._source.wednesdayON2 
      this.weekStart2 = this.newRec._source.thursdayON2
      this.weekStart2 = this.newRec._source.fridayON2
      this.weekStart2 = this.newRec._source.saturdayON2
      this.weekStart2 = this.newRec._source.sundayON2

      this.weekEnd1 = this.newRec._source.mondayOFF1
      this.weekEnd1 = this.newRec._source.tuesdayOFF1
      this.weekEnd1 = this.newRec._source.wednesdayOFF1
      this.weekEnd1 = this.newRec._source.thursdayOFF1
      this.weekEnd1 = this.newRec._source.fridayOFF1
      this.weekEnd1 = this.newRec._source.saturdayOFF1
      this.weekEnd1 = this.newRec._source.sundayOFF1

      this.weekEnd2 = this.newRec._source.mondayOFF2
      this.weekEnd2 = this.newRec._source.tuesdayOFF2
      this.weekEnd2 = this.newRec._source.wednesdayOFF2
      this.weekEnd2 = this.newRec._source.thursdayOFF2
      this.weekEnd2 = this.newRec._source.fridayOFF2
      this.weekEnd2 = this.newRec._source.saturdayOFF2
      this.weekEnd2 = this.newRec._source.sundayOFF2


      this.saturdayStart1 = this.newRec._source.saturdayON1
      this.sundayStart1 = this.newRec._source.sundayON1

      this.saturdayStart2 = this.newRec._source.saturdayON2
      this.sundayStart2 = this.newRec._source.sundayON2

      this.saturdayEnd1 = this.newRec._source.saturdayOFF1
      this.sundayEnd1 = this.newRec._source.sundayOFF1

      this.saturdayEnd2 = this.newRec._source.saturdayOFF2
      this.sundayEnd2 = this.newRec._source.sundayOFF2
      
    },
    saveRecord: function() {

      this.applyChange();
      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.lastUpdate = Date.now()
      console.log(this.newRec)
      this.$store.commit({
        type: "updateRecord",
        data: this.newRec
      });
      this.$notify({ 
        title: "Record saved.",
        type: "success",
        message: "Le produit a été enregistrée.",
        position: "bottom-right"
      });
      this.$emit("dialogcloseupdated");
    },

    getCircuits: function(){

        var url = this.$store.getters.apiurl + "lambdas/5/getcircuits?apikey=" + this.$store.getters.creds.token;
        var body = {};
        axios
        .post(url, body)
        .then((response) => {
            this.circuits = response.data.circuits
            this.$forceUpdate();
        });

    },

    applyChange: function(){
      this.newRec._source.mondayON1 = this.weekStart1
      this.newRec._source.tuesdayON1= this.weekStart1
      this.newRec._source.wednesdayON1= this.weekStart1
      this.newRec._source.thursdayON1= this.weekStart1
      this.newRec._source.fridayON1= this.weekStart1
      this.newRec._source.saturdayON1= this.weekStart1
      this.newRec._source.sundayON1= this.weekStart1

      this.newRec._source.mondayON2 = this.weekStart2
      this.newRec._source.tuesdayON2= this.weekStart2
      this.newRec._source.wednesdayON2= this.weekStart2
      this.newRec._source.thursdayON2= this.weekStart2
      this.newRec._source.fridayON2= this.weekStart2
      this.newRec._source.saturdayON2= this.weekStart2
      this.newRec._source.sundayON2= this.weekStart2

      this.newRec._source.mondayOFF1 = this.weekEnd1
      this.newRec._source.tuesdayOFF1= this.weekEnd1
      this.newRec._source.wednesdayOFF1= this.weekEnd1
      this.newRec._source.thursdayOFF1= this.weekEnd1
      this.newRec._source.fridayOFF1= this.weekEnd1
      this.newRec._source.saturdayOFF1= this.weekEnd1
      this.newRec._source.sundayOFF1= this.weekEnd1

      this.newRec._source.mondayOFF2 = this.weekEnd2
      this.newRec._source.tuesdayOFF2= this.weekEnd2
      this.newRec._source.wednesdayOFF2= this.weekEnd2
      this.newRec._source.thursdayOFF2= this.weekEnd2
      this.newRec._source.fridayOFF2= this.weekEnd2
      this.newRec._source.saturdayOFF2= this.weekEnd2
      this.newRec._source.sundayOFF2= this.weekEnd2


      this.newRec._source.saturdayON1 = this.saturdayStart1
      this.newRec._source.sundayON1 = this.sundayStart1

      this.newRec._source.saturdayON2 = this.saturdayStart2
      this.newRec._source.sundayON2 = this.sundayStart2

      this.newRec._source.saturdayOFF1 = this.saturdayEnd1
      this.newRec._source.sundayOFF1 = this.sundayEnd1

      this.newRec._source.saturdayOFF2 = this.saturdayEnd2
      this.newRec._source.sundayOFF2 = this.sundayEnd2

      this.newRec._source.circuit = this.selectedCircuit
      this.newRec._source.DB = this.DB
    }
      
    
  }
  

}
</script>

<style >
.script-editor .view-table {
  margin-bottom: 30px;
}
.script-editor .script-name-input {
  margin-bottom: 10px;
}

.script-editor .add-view-button {
  margin-bottom: 30px;
}
.label-form{
  text-align: center;
}
</style>