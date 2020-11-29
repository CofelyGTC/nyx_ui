<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="shopEditor"
  >
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <el-row>
              <el-card shadow="hover" :body-style="{ padding: '10px' }">
                <h2>Infomrations Générales:</h2>
                <el-row>
                    <el-col :span="8">
                        <el-form-item label="Nom Magasin" :label-width="formLabelWidth">
                            <el-input size="mini" v-model="magasin" autocomplete="off" placeholder="Nom magasin..."></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="8">
                        <el-form-item label="Adresse" :label-width="formLabelWidth">
                            <el-input size="mini" v-model="adresse" autocomplete="off" placeholder="Rue, N°, boite"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="8">
                        <el-form-item label="Ville" :label-width="formLabelWidth">
                            <el-input size="mini" v-model="city" autocomplete="off" placeholder="Ville"></el-input>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="8">
                        <el-form-item label="Société" :label-width="formLabelWidth">
                            <el-input size="mini" v-model="company" autocomplete="off" placeholder="Société..."></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="8">
                        <el-form-item label="Label Société" :label-width="formLabelWidth">
                            <el-input size="mini" v-model="companyLabel" autocomplete="off" placeholder="MS / RS"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="8">
                        <el-form-item label="ID Facturation" :label-width="formLabelWidth">
                            <el-input size="mini" v-model="shopID" autocomplete="off" placeholder="MSxxx / RSxxx"></el-input>
                        </el-form-item>
                    </el-col>
                </el-row>
                </el-card>
                <br>
                <el-card>
                    <el-row>
                        <h2>Commission</h2>
                    </el-row>
                    <el-row>
                        <el-form-item label="Type de Commission" :label-width="formLabelWidth2">
                            <el-select v-model="commissionType" placeholder="Sélectionner" @change="commissionChange(commissionType)"> 
                                <el-option v-for="(item, id) in commissionTypes" :key="id" :label="item" :value="item">
                                </el-option>
                            </el-select>
                        </el-form-item>
                    </el-row>
                    <div v-if="commissionType == 'Pourcentage'">
                    <el-row>
                        <el-form-item  label="Pourcentage: " :label-width="formLabelWidth2">
                            <el-input-number size="mini" v-model="commissionPercent" autocomplete="off" :min="0" :step="0.1"/>
                        </el-form-item>
                    </el-row>
                    </div>
                    <div v-else-if="commissionType == 'Intervalles'">
                    <el-row>
                        <el-form-item  label="Commission Minimum: " :label-width="formLabelWidth2">
                            <el-input-number size="mini" v-model="commissionIntervalMin" autocomplete="off" :min="0" :step="1"/>
                        </el-form-item>
                    </el-row>
                    <el-row style="text-align:left;">
                        <el-col>
                            <label>Intervalles :</label>
                        </el-col>
                        <el-col v-for="(interval, index) in commissionIntervals" :key="index">
                            <el-row>
                                <el-col :span=4>
                                    <el-form-item label="Name" :label-width="formLabelWidth">
                                        {{interval.name}}
                                    </el-form-item>
                                </el-col>
                                <el-col :span=3>
                                    <el-form-item label="Seuil" :label-width="formLabelWidth">
                                        {{interval.seuil}}
                                    </el-form-item>
                                </el-col>
                                <el-col :span=3>
                                    <el-form-item label="Fin" :label-width="formLabelWidth">
                                        {{interval.end}}
                                    </el-form-item>
                                </el-col>
                                <el-col :span=4>
                                    <el-form-item label="Pourcentage" :label-width="formLabelWidth">
                                        {{interval.percent}}
                                    </el-form-item>
                                </el-col>
                                <el-col :span=4>
                                    <el-form-item label="Forfait vendeuse" :label-width="formLabelWidth">
                                        {{interval.forfait}}
                                    </el-form-item>
                                </el-col>
                                <el-col :span=4>
                                    <el-form-item label="Forfait étudiant" :label-width="formLabelWidth">
                                        {{interval.forfaitEtudiant}}
                                    </el-form-item>
                                </el-col>
                                <el-col :span=2>
                                     <el-button @click="removeIntervalle(index)" type="danger" icon="el-icon-delete" circle></el-button>
                                </el-col>
                            </el-row>
                        </el-col>
                    </el-row>
                    <el-row>
                        <label>Ajouter Intervalle</label>
                    </el-row>
                    <el-row>
                        <el-col :span=4>
                            <label>Nom Intervalle: </label>
                        </el-col>
                        <el-col :span=4>
                            <el-input size="mini" v-model="newIntervalName" autocomplete="off" placeholder="Nom intervalle..."></el-input>
                        </el-col>
                        <el-col :span=4>
                            <label>Seuil:</label>
                        </el-col>
                        <el-col :span=4>
                            <el-input-number size="mini" v-model="newIntervalSeuil" autocomplete="off" :min="0" :step="1"/>
                        </el-col>
                        <el-col :span=4>
                            <label>Fin: </label>
                        </el-col>
                        <el-col :span=4>
                            <el-input-number size="mini" v-model="newIntervalEnd" autocomplete="off" :min="0" :step="1"/>
                        </el-col>

                    </el-row>
                    <el-row>
                        <el-col :span=4>
                            <label>Pourcentage: </label>
                        </el-col>
                        <el-col :span=4>
                            <el-input-number size="mini" v-model="newIntervalPercent" autocomplete="off" :min="0" :step="0.1"/>
                        </el-col>
                        <el-col :span=3>
                            <label>Forfait Vendeuse: </label>
                        </el-col>
                        <el-col :span=4>
                            <el-input-number size="mini" v-model="newIntervalForfait" autocomplete="off" :min="0" :step="1"/>
                        </el-col>
                         <el-col :span=3>
                            <label>Forfait étudiant: </label>
                        </el-col>
                        <el-col :span=4>
                            <el-input-number size="mini" v-model="newIntervalForfaitEtudiant" autocomplete="off" :min="0" :step="1"/>
                        </el-col>
                        <el-col :span="2">
                            <el-button type="primary" @click="addIntervalle()" icon="el-icon-plus" circle></el-button>
                        </el-col>
                    </el-row>
                    </div>

                    
                </el-card>
                <br>
                <el-card>
                    <el-row>
                        <h2>Données Facturations/Comissions</h2>
                    </el-row>
                    <el-row>
                      <el-form-item  label="Nom entête: " :label-width="formLabelWidth">
                            <el-input  size="mini" v-model="factName" autocomplete="off" placeholder="Monsieur/Madame ...."></el-input>
                        </el-form-item>
                        <el-form-item  label="Adresse: " :label-width="formLabelWidth">
                            <el-input  size="mini" v-model="factAddr" autocomplete="off" placeholder="Rue ...."></el-input>
                        </el-form-item>
                        <el-form-item  label="Numéro de TVA: " :label-width="formLabelWidth">
                            <el-input  size="mini" v-model="factTVA" autocomplete="off" placeholder="BE0 ...."></el-input>
                        </el-form-item>
                    </el-row>
                </el-card>
                

               
            
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
import CarouselEditor from './carouselEditor.vue';

export default {
  name: "shopEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    changed: false,
    dialogFormVisible: false,
    title: "Shop Editor",
    magasin: '',
    adresse: '',
    city: '',
    company: '',
    companyLabel: '',
    shopID: '',
    commissionTypes: ['Pourcentage', 'Intervalles', 'Facturation', 'Néant'],
    commissionType: '',
    commissionIntervals: [],
    commissionPercent: 0,
    commissionIntervalMin: 2500,
    newIntervalName: '',
    newIntervalSeuil: 0,
    newIntervalEnd: 0,
    newIntervalPercent: 0,
    newIntervalForfait: 0,
    newIntervalForfaitEtudiant: 0,
    factAddr: '',
    factName: '',
    factTVA: ''
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
    this.prepareData();
  },
  components: {CarouselEditor},
  methods: {
    closeDialog: function() {
      this.$emit("dialogclose");
    },
    prepareData: function() {
      console.log("prepare data");
      this.dialogFormVisible = true;
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
      this.magasin = this.newRec._source['Nom magasin']
      this.adresse = this.newRec._source.address
      this.city = this.newRec._source.city
      this.company = this.newRec._source.company
      this.companyLabel = this.newRec._source.owner
      this.shopID = this.newRec._source.shopid
      if(this.newRec._source.commissionType ){
        this.commissionType=this.newRec._source.commissionType 
      }
      if(this.newRec._source.commissionIntervals ){
      this.commissionIntervals=this.newRec._source.commissionIntervals
      }
      if(this.newRec._source.commissionPercent ){
      this.commissionPercent=this.newRec._source.commissionPercent
      }
      if(this.newRec._source.commissionIntervalMin ){
      this.commissionIntervalMin=this.newRec._source.commissionIntervalMin
      }


      if(this.newRec._source.factAddr){
        this.factAddr = this.newRec._source.factAddr
      }

      if(this.newRec._source.factName){
        this.factName = this.newRec._source.factName
      }

      if(this.newRec._source.factTVA){
        this.factTVA = this.newRec._source.factTVA
      }

    },

    addIntervalle: function(){

        var newInterval = {
            "name": this.newIntervalName,
            "seuil": this.newIntervalSeuil,
            "end": this.newIntervalEnd,
            "percent": this.newIntervalPercent,
            "forfait": this.newIntervalForfait,
            "forfaitEtudiant": this.newIntervalForfaitEtudiant
        }

        this.commissionIntervals.push(newInterval)

    },

    removeIntervalle: function(index){

        this.commissionIntervals.splice(index, 1)
    },

    saveRecord: function() {

        
      this.newRec._source['Nom magasin'] = this.magasin
      this.newRec._source.address = this.adresse
      this.newRec._source.city = this.city
      this.newRec._source.company = this.company
      this.newRec._source.owner = this.companyLabel
      this.newRec._source.shopid = this.shopID
      this.newRec._source.commissionType = this.commissionType
      this.newRec._source.commissionIntervals = this.commissionIntervals
      this.newRec._source.commissionPercent = this.commissionPercent
      this.newRec._source.commissionIntervalMin = this.commissionIntervalMin
      this.newRec._source.modifyBy = this.$store.getters.creds.user.login

      this.newRec._source.factAddr = this.factAddr
      this.newRec._source.factName = this.factName
      this.newRec._source.factTVA = this.factTVA

      this.newRec._source['@timestamp'] = Date.now()

      this.$store.commit({
        type: "updateRecord",
        data: this.newRec
      });
      this.$notify({ 
        title: "Record saved.",
        type: "success",
        message: "La commande a été enregistrée.",
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