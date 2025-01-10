<template>
  <el-dialog
  width="80%"
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
       <el-col :span=6>
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
          <el-col :span=12>
            <el-form-item label="Commentaire: " :label-width="formLabelWidth">
                <el-input v-model="newRec._source.note" placeholder="Commentaires..."></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=4>
         <el-form-item label="Automate Next Gen : " :label-width="formLabelWidth">
                <el-switch v-model="newRec._source.nextGen" ></el-switch>
            </el-form-item>
       </el-col>
       <el-col :span=4>
         <el-form-item v-if="!newRec._source.nextGen" label="Encodage Decimal : " :label-width="formLabelWidth">
                <el-switch v-model="newRec._source.oldGenDecimal" ></el-switch>
            </el-form-item>
       </el-col>
     </el-row>
     <el-row>
          <el-col :span=4>
            <el-form-item label="Dero Congés : " :label-width="formLabelWidth">
                <el-switch v-model="newRec._source.dero_holidays" ></el-switch>
            </el-form-item>
          </el-col>
          <el-col :span=4>
            <el-form-item label="Dero Congés ULG : " :label-width="formLabelWidth">
                <el-switch v-model="newRec._source.dero_holidays_ulg" ></el-switch>
            </el-form-item>
          </el-col>
          <el-col :span=5>
            <el-form-item label="Dero Congés Administration : " :label-width="formLabelWidth">
                <el-switch v-model="newRec._source.dero_holidays_office" ></el-switch>
            </el-form-item>
          </el-col>
     </el-row>
     <el-row>
       <el-col :span=4>
            <el-form-item label="Dero Covid Matin: " :label-width="formLabelWidth">
                <el-switch v-model="newRec._source.dero_covid_morning" ></el-switch>
            </el-form-item>
          </el-col>
          <el-col :span=5>
            <el-form-item label="Minutes supp. : " :label-width="formLabelWidth">
                <el-input-number v-model="newRec._source.dero_covid_morning_mins" size="small" :disabled="!newRec._source.dero_covid_morning"></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span=4>
            <el-form-item label="Dero Covid Soir: " :label-width="formLabelWidth">
                <el-switch v-model="newRec._source.dero_covid" ></el-switch>
            </el-form-item>
          </el-col>
          <el-col :span=5>
            <el-form-item label="Minutes supp. : " :label-width="formLabelWidth">
                <el-input-number v-model="newRec._source.dero_covid_mins" :disabled="!newRec._source.dero_covid" size="small" ></el-input-number>
            </el-form-item>
          </el-col>
          
     </el-row>

     <el-row>
        <el-col :span=6>
          <el-form-item label="Temps de coupure minimum (secs): " :label-width="formLabelWidth3">
                  <el-input-number v-model="newRec._source.minimal_interrupt" :min="0"></el-input-number>
              </el-form-item>

        </el-col>
        <el-col :span=6>
          <el-form-item label="Temps de coupure maximum (secs): " :label-width="formLabelWidth3">
            <el-input-number v-model="newRec._source.maximal_interrupt" :min="0"></el-input-number>
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
      >{{this.$t("buttons.save")}}</el-button>
    <el-button
      v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
      type="primary"
      @click="saveAndCloseRecord()"
    >{{this.$t("buttons.confirm")}}</el-button>
    <el-button @click="$emit('dialogclose')">{{this.$t("buttons.cancel")}}</el-button>
</span>
<div>
  <el-card>
    <el-row>
      <el-col>Recompiler ce circuit: </el-col>
      <el-col>
        <el-button type="primary"
            @click="recompile(selectedCircuit)">Recompile

        </el-button>
      </el-col>
    </el-row>
  </el-card>
</div>
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
  },
  editMode: {
    type: String
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
    
    if(this.editMode == 'create')
    {
      this.initializeHours();
    }


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
  recompile: function(circuit) {

  var body = {
        "destination": "/queue/ULG_COMPUTE_TIMESHEET",
        "body": "{'circuit': '"+circuit+"' }"
        }

      setTimeout(() => {
        axios.post(
        this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
        ).then((response) => {
            if(response.data.error!="")
            {
                this.$notify({ 
                title: "Error",
                message: "Fail to send Data",
            type: "error",
            position: "bottom-right",
            duration: 1500});
            }
            else
            {
                this.$notify({ 
                title: "Success",
                message: "Success to send Data",
                type: "success",
                position: "bottom-right",
                duration: 2000
            });
                
            }
        })
        .catch((error)=> {
        console.log(error);
        
        });
    }, 1000)

    console.log('Confirming Sync')



  },
  saveAndCloseRecord: function() {

  //this.applyChange();
  this.newRec._source.circuit = this.selectedCircuit
  this.newRec._source.DB = this.DB
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
  saveRecord: function() {

    //this.applyChange();
    this.newRec._source.circuit = this.selectedCircuit
    this.newRec._source.DB = this.DB
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

  initializeHours: function(){
    console.log('INITIALIZE')
    this.newRec._source.mondayON1 = "00:00"
    this.newRec._source.tuesdayON1= "00:00"
    this.newRec._source.wednesdayON1= "00:00"
    this.newRec._source.thursdayON1= "00:00"
    this.newRec._source.fridayON1= "00:00"
    this.newRec._source.saturdayON1= "00:00"
    this.newRec._source.sundayON1= "00:00"

    this.newRec._source.mondayON2 = "00:00"
    this.newRec._source.tuesdayON2= "00:00"
    this.newRec._source.wednesdayON2= "00:00"
    this.newRec._source.thursdayON2= "00:00"
    this.newRec._source.fridayON2= "00:00"
    this.newRec._source.saturdayON2= "00:00"
    this.newRec._source.sundayON2= "00:00"

    this.newRec._source.mondayOFF1 = "00:00"
    this.newRec._source.tuesdayOFF1= "00:00"
    this.newRec._source.wednesdayOFF1= "00:00"
    this.newRec._source.thursdayOFF1= "00:00"
    this.newRec._source.fridayOFF1= "00:00"
    this.newRec._source.saturdayOFF1= "00:00"
    this.newRec._source.sundayOFF1= "00:00"

    this.newRec._source.mondayOFF2 = "00:00"
    this.newRec._source.tuesdayOFF2= "00:00"
    this.newRec._source.wednesdayOFF2= "00:00"
    this.newRec._source.thursdayOFF2= "00:00"
    this.newRec._source.fridayOFF2= "00:00"
    this.newRec._source.saturdayOFF2= "00:00"
    this.newRec._source.sundayOFF2= "00:00"


    this.newRec._source.saturdayON1 = "00:00"
    this.newRec._source.sundayON1 = "00:00"

    this.newRec._source.saturdayON2 = "00:00"
    this.newRec._source.sundayON2 = "00:00"

    this.newRec._source.saturdayOFF1 = "00:00"
    this.newRec._source.sundayOFF1 = "00:00"

    this.newRec._source.saturdayOFF2 = "00:00"
    this.newRec._source.sundayOFF2 = "00:00"

  },

  applyChange: function(){
    console.log('APPLY')
    console.log(this.weekStart1)
    console.log(this.weekEnd1)
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

    console.log(JSON.stringify(this.newRec._source))
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