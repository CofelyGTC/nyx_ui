<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="product-editor"
  >
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
        <el-row>
            <el-col :span=8>  
        <el-form-item label="Disponibilité" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Availbility" autocomplete="off"></el-input>
        </el-form-item>
            </el-col>
            <el-col :span=8>
        <el-form-item label="CODE" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.CODE" autocomplete="off"></el-input>
        </el-form-item>
            </el-col>
        <el-col :span=8>
        <el-form-item label="Céréal" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Cereal" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
        </el-row>
        <el-row>
            <el-col :span=8>
        <el-form-item label="Conditionnement" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Conditionnement" autocomplete="off"></el-input>
        </el-form-item>
            </el-col>
        <el-col :span=8>
        <el-form-item label="Filtre invendu" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Filter_unsale" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
        <el-col :span=8>
        <el-form-item label="Format" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Format" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
        <el-form-item label="Label" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Label" autocomplete="off"></el-input>
        </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="Date Création" :label-width="formLabelWidth2">
               <el-date-picker
                v-model="newRec._source.creationDate"
                type="date"
                placeholder="Choississez un jour">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
          <el-form-item label="Lieu de Préparation" :label-width="formLabelWidth2">
            <el-select v-model="newRec._source.lieuPreparation" filterable placeholder="Sélectionner">
                <el-option v-for="(item, idPrepa) in lieuPrepa" :key="idPrepa" :label="item" :value="item">
                </el-option>
            </el-select>
           </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="Lieu de Production" :label-width="formLabelWidth2">
            <el-select v-model="newRec._source.lieuProduction" filterable placeholder="Sélectionner">
                <el-option v-for="(item, idProd) in lieuProd" :key="idProd" :label="item" :value="item">
                </el-option>
            </el-select>
           </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="Conditionnement" :label-width="formLabelWidth2">
              <el-input-number size="mini" v-model="newRec._source.conditionnement" autocomplete="off" :step="1"></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="Unité de vente" :label-width="formLabelWidth2">
              <el-input placeholder="ex: vente à l'unité" size="mini" v-model="newRec._source.unite_vente" autocomplete="off"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
            <el-col :span=4>
        <el-form-item label="Prix TVAC" :label-width="formLabelWidth2">
          <el-input-number size="mini" v-model="newRec._source.Prix_TVAC" autocomplete="off" :step="0.01"></el-input-number>
        </el-form-item>
            </el-col>
            <el-col :span=4>
        <el-form-item label="TVA" :label-width="formLabelWidth2">
          {{TVA | roundTo2 }}€
        </el-form-item>
            </el-col>
            <el-col :span=4>
        <el-form-item label="HTVA" :label-width="formLabelWidth2">
          {{HTVA | roundTo2 }}€
        </el-form-item>
            </el-col>
            <el-col :span=4>
        <el-form-item label="Taux TVA" :label-width="formLabelWidth2">
          <el-input-number size="mini" v-model="newRec._source.Taux_TVA" autocomplete="off" :step="0.01"></el-input-number>
        </el-form-item>
            </el-col>
            <el-col :span=4>
        <el-form-item label="Poids" :label-width="formLabelWidth2">
          <el-input-number size="mini" v-model="newRec._source.Weight" autocomplete="off"></el-input-number>
        </el-form-item>
            </el-col>
        </el-row>
        <el-row>
            <el-col :span=8>
        <el-form-item label="Type" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Type" autocomplete="off"></el-input>
        </el-form-item>
            </el-col>
            <el-col :span=8>
        <el-form-item label="Niveau 1"  :label-width="formLabelWidth2">
         
          <el-select v-model="newRec._source.sortLvl1" filterable placeholder="Sélectionner" @change="lvl1Change()">
                <el-option v-for="(item, id1) in lvl1" :key="id1" :label="item" :value="item">
                </el-option>
            </el-select>
        </el-form-item>
            </el-col>
            <el-col :span=8>
        <el-form-item label="Niveau 2" :label-width="formLabelWidth2">
          
          <el-select v-if="newRec._source.sortLvl1 == 'Boulangerie'" filterable v-model="newRec._source.sortLvl2" placeholder="Sélectionner">
                <el-option v-for="(item, id2) in lvl2" :key="id2" :label="item" :value="item">
                  
                </el-option>
            </el-select>
            <el-select v-else-if="newRec._source.sortLvl1 == 'Pâtisserie'" filterable v-model="newRec._source.sortLvl2" placeholder="Sélectionner">
                <el-option v-for="(item, id2) in lvl2_pat" :key="id2" :label="item" :value="item">
                  
                </el-option>
            </el-select>
            <el-select v-else v-model="newRec._source.sortLvl2" filterable placeholder="Sélectionner">
                <el-option v-for="(item, id2) in lvl2_others" :key="id2" :label="item" :value="item">
                  
                </el-option>
            </el-select>
        </el-form-item>
            </el-col>
        </el-row>
        <el-row>
            <el-col :span=12>
        <el-form-item label="Type de Pâte" :label-width="formLabelWidth2">
          <el-select v-model="newRec._source.sortLvl3" filterable placeholder="Sélectionner">
                <el-option v-for="(item, id3) in lvl3" :key="id3" :label="item" :value="item">
                </el-option>
            </el-select>
        </el-form-item>
            </el-col>
            <el-col :span=12>
        <el-form-item label="Fruits Cuits / Pas Cuits" :label-width="formLabelWidth2">
          <el-select v-model="newRec._source.sortLvl4" filterable placeholder="Sélectionner">
                <el-option v-for="(item, id4) in lvl4" :key="id4" :label="item" :value="item">
                </el-option>
            </el-select>
        </el-form-item>
        </el-col>
        </el-row>
        <el-row>
            <el-col :span=12>
        <el-form-item label="Avec/Sans Fruits" :label-width="formLabelWidth2">
          <el-select v-model="newRec._source.sortLvl5" filterable placeholder="Sélectionner">
                <el-option v-for="(item, id5) in lvl5" :key="id5" :label="item" :value="item">
                </el-option>
            </el-select>
        </el-form-item>
        </el-col>
            <el-col :span=12>
        <el-form-item label="Taille" :label-width="formLabelWidth2">
          <el-select v-model="newRec._source.sortLvl6" filterable placeholder="Sélectionner">
                <el-option v-for="(item, id6) in lvl6" :key="id6" :label="item" :value="item">
                </el-option>
            </el-select>
        </el-form-item>
        </el-col>
        </el-row>
        <el-row>
            <el-col :span=12>
        <el-form-item label="Avec/Sans Crème Fraîche" :label-width="formLabelWidth2">
          <el-select v-model="newRec._source.sortLvl7" filterable placeholder="Sélectionner">
                <el-option v-for="(item, id7) in lvl7" :key="id7" :label="item" :value="item">
                </el-option>
            </el-select>
        </el-form-item>
        </el-col>
            <el-col :span=12>
        <el-form-item label="Type de Fruits" :label-width="formLabelWidth2">
          <el-select v-model="newRec._source.sortLvl8" filterable placeholder="Sélectionner">
                <el-option v-for="(item, id8) in lvl8" :key="id8" :label="item" :value="item">
                </el-option>
            </el-select>
        </el-form-item>
        </el-col>
        </el-row>
        <el-row>
            <el-col :span=12>
        <el-form-item label="Type de Crème" :label-width="formLabelWidth2">
          <el-select v-model="newRec._source.sortLvl9" filterable placeholder="Sélectionner">
                <el-option v-for="(item, id9) in lvl9" :key="id9" :label="item" :value="item">
                </el-option>
            </el-select>
        </el-form-item>
        </el-col>
            <el-col :span=12>
        <el-form-item label="Autre" :label-width="formLabelWidth2">
          <el-select v-model="newRec._source.sortLvl10" filterable placeholder="Sélectionner">
                <el-option v-for="(item, id10) in lvl10" :key="id10" :label="item" :value="item">
                </el-option>
            </el-select>
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
  name: "productEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth2: "120px",
    changed: false,
    dialogFormVisible: false,
    title: "Produit",
    availability: ["Toujours Disponible", "Sur Commande Client", "Mercredi et Vendredi"],
    lvl1: ['Boulangerie', 'Pâtisserie', 'Confiserie', 'Salés', 'Boissons', 'Divers'],
    lvl2: ['Gris', 'Demi gris', 'Blanc', 'Spéciaux', 'Baguette et Pistolet'],
    lvl2_pat: ['Petit déjeuner', 'Petite Pâtisserie', 'Tarte', 'Gâteaux', 'Divers', 'Tropézienne', 'Verrine'],
    lvl2_others:['Bonbons', 'Pralines', 'Chocolat', 'Biscuits', 'Sandwichs', 'Quiches','Oeufs', 'Canettes', 'Bouteilles', 'Matériel Nettoyage', 'Matériel Vente'],
    lvl3: ['-', 'Pâte biscuit', 'Pâte levée', 'Pâte feuilletée'],
    lvl4: ['-', 'Cuit', 'Pas cuit'],
    lvl5: ['-', 'Avec fruit', 'Sans fruit'],
    lvl6: ['-', 'Petite', 'Moyenne', 'Grande'],
    lvl7: ['-', 'Crème fraîche', 'Nature'],
    lvl8: ['-',  'Abricot','Citron', 'Fraise', 'Framboise', 'Multi'],
    lvl9: ['-', 'Crème Pâtissière', 'Crème au beurre', 'Crème fraîche'],
    lvl10: ['-'],
    lieuPrepa: ['-', 'Cave', 'Boulangerie', 'Table'],
    lieuProd: ['-', 'Cave', 'Boulangerie', 'Table', 'Viennoiserie'],
    filters: null,

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
    TVA: function() {
      return this.newRec._source.Prix_TVAC - this.HTVA
    },
    HTVA: function() {
      return this.newRec._source.Prix_TVAC / (1+this.newRec._source.Taux_TVA)
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
  filters: {
      roundTo2: function(value){
        return value.toFixed(2);
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
    this.getFilters();
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
    lvl1Change: function(){
        this.newRec._source.sortLvl2 = '-';
    },
    saveRecord: function() {

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.lastUpdate = Date.now()
      this.newRec._source['TVA'] = this.TVA.toFixed(2)
      this.newRec._source['HTVA'] = this.HTVA.toFixed(2)
      this.newRec._id = this.newRec._source['CODE']
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
    getFilters(){
        var url =
        this.$store.getters.apiurl +
        "generic_search/products_filters?token=" + this.$store.getters.creds.token;  

        console.log('CHECK SHOPS LIST')

        var query = {
            size: 2000,
            query: {
            bool: {
                must: [
                {
                    match_all: {}
                }
                ]
            }
            }
        };
        axios
        .post(url, query)
        .then((response) => {
            if(response.data.error!="")
            console.log("Products Filters list error...");
            else{
                
                var res = response.data
                console.log(res)
                this.filters = res.records[0]._source
                console.log(this.filters)

                this.prepareFilters();
               
            }
        });  

      },
      prepareFilters(){
          this.lvl1 = this.filters['sortLvl1']
          this.lvl2 = this.filters['sortLvl2Boul']
          this.lvl2_pat = this.filters['sortLvl2Pat']
          this.lvl2_others = this.filters['sortLvl2Other']
          this.lvl3 = this.filters['sortLvl3']
          this.lvl4 = this.filters['sortLvl4']
          this.lvl5 = this.filters['sortLvl5']
          this.lvl6 = this.filters['sortLvl6']
          this.lvl7 = this.filters['sortLvl7']
          this.lvl8 = this.filters['sortLvl8']
          this.lvl9 = this.filters['sortLvl9']
          this.lvl10 = this.filters['sortLvl10']
          console.log("Data Prepared")

      },
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