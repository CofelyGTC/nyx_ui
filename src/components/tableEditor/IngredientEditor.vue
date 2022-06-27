<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="ingredient-editor"
  >
  
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
        <el-row style="text-align:left;">
              <el-col>
               <h2>Informations :</h2>
           </el-col>
          <el-col :span="8">
            <el-form-item label="Code Ingrédient: " :label-width="formLabelWidth2">
              <el-input :disabled="editMode!='create'" size="mini" v-model="newRec._source['Code ingrédient']" autocomplete="off"></el-input>
            </el-form-item>
          </el-col> 
          <el-col :span="8">
            <el-form-item label="Label : " :label-width="formLabelWidth">
                <el-input size="mini" v-model="newRec._source['Ingrédient']" autocomplete="off"></el-input>
            </el-form-item>
          </el-col> 
          <el-col :span="8">
            <el-form-item label="Fabricant : " :label-width="formLabelWidth">
               <el-input size="mini" v-model="newRec._source['Fabricant']" autocomplete="off"></el-input>
            </el-form-item>
          </el-col> 
         
       </el-row>

       <el-row>
            <!-- 
                Code ingrédient: I0001
                DLC: 0
                Fabricant: Panistar
                'Fournisseur ': 'Bruyerre  '
                Ingrédient: PANISTAR 158 DISQUE FEUILLETE BEURRE 18 CM 100X108GR=CARTON
                Prix kg: 9.89
                Référence Fournisseur: '15060778'
            -->
          <el-col :span="12">
            <el-form-item label="DLC: " :label-width="formLabelWidth2">
              <el-input-number size="mini" v-model="newRec._source.DLC" :min="0"></el-input-number>
            </el-form-item>
          </el-col> 
          <el-col :span="12">
            <el-form-item label="Prix kg : " :label-width="formLabelWidth">
                <el-input-number size="mini" v-model="newRec._source['Prix kg']" :min="0"></el-input-number>
            </el-form-item>
          </el-col> 
         
       </el-row>
       <el-row>
          <el-col :span="12">
            <el-form-item label="Fournisseur : " :label-width="formLabelWidth">
               <el-input size="mini" v-model="newRec._source['Fournisseur']" autocomplete="off"></el-input>
            </el-form-item>
          </el-col> 
          <el-col :span="12">
            <el-form-item label="Réf Fournisseur : " :label-width="formLabelWidth2">
               <el-input size="mini" v-model="newRec._source['Référence Fournisseur']" autocomplete="off"></el-input>
            </el-form-item>
          </el-col> 
       </el-row>

      </el-card>
      <br>
      <el-card>
          <el-row style="text-align:left;">
              <el-col>
               <h2>Allergenes :</h2>
           </el-col>
           <el-col v-for="(allergene, index) in this.newRec._source.allergenes" :key="index">
                <el-row>
                       <el-col :span=4>
                           <el-form-item label="Code" :label-width="formLabelWidth">
                              {{allergene.code}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=4>
                           <el-form-item label="Label" :label-width="formLabelWidth">
                              {{allergene.name}}
                           </el-form-item>
                        </el-col>
                        
                       
                       <el-col :span=1>
                           <el-button @click="removeAllergene(index)" type="danger" icon="el-icon-delete" circle>
                           </el-button>
                       </el-col>
                </el-row>
           </el-col>
          </el-row>
          <br>
          <el-row style="text-align:left;">
         <el-col :span="6">
           <label>Ajouter allergène : </label>
         </el-col>
         <el-col :span="6">
           <el-select v-model="newAllergene" placeholder="Choisissez un allergene" filterable size="mini">
             <el-option v-for="(_source, index) in this.allAllergenes" :key="index" :value="[_source._source['CODE'], _source._source['Label'], _source._source['def']] " :label="_source._source['CODE']+ ' ' + _source._source['Label']" ></el-option>
           </el-select>
         </el-col>
         <el-col :span="6">
           <el-button type="primary" @click="addAllergene()" icon="el-icon-plus" circle></el-button>
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
  name: "recetteEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    formLabelWidth2: "150px",
    changed: false,
    dialogFormVisible: false,
    title: "Ingrédient",
    newAllergene: null,
    allAllergenes: null   
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
  created: function() {
    console.log("created event");
    this.prepareData();
  },
  components: {},
  methods: {
    closeDialog: function() {
      this.$emit("dialogclose");
    },
    removeAllergene: function(index){
        console.log("coucou")
        console.log(this.newRec._source.allergenes[index])
        //delete this.newRec._source.ingredients[index]
        this.newRec._source.allergenes.splice(index, 1)
    },
    prepareData: function() {
      console.log("prepare data");
      this.dialogFormVisible = true;
      if(!this.record._source.allergenes)
      {
        console.log("New record")
        this.record._source.allergenes = []
        console.log(this.record)
      }

      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
      this.allAllergenes = this.getAllergenes();

    },
    addAllergene: function() {
      var allergeneToAdd = {
        "code": this.newAllergene[0],
        "name": this.newAllergene[1],
        "def": this.newAllergene[2]
        }
      this.newRec._source.allergenes.push(allergeneToAdd);
    },

    getAllergenes: function() {
      var url =
        this.$store.getters.apiurl +
        "generic_search/schamp_allergenes" +
        "?token=" +
        this.$store.getters.creds.token;
        
      var query = {
          "size": 10000
        }

        axios
        .post(url, query)
        .then(response => {
          if (response.data.error != "") {
            console.log("fail to retrieve allergenes");
          } else {
            console.log(response);

            this.allAllergenes = response.data.records


          }
        })
        .catch(error => {
          console.log(error);
        });
    },

    
    saveRecord: function() {

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.lastUpdate = Date.now()
      


      this.$store.commit({
        type: "updateRecord",
        data: this.newRec
      });
      this.$notify({ 
        title: "Record saved.",
        type: "success",
        message: "L'ingrédient a été enregistrée.",
        position: "bottom-right"
      });
      this.$emit("dialogcloseupdated");
    }
    
    },
    
  
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