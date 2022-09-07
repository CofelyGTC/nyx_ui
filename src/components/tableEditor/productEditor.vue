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
      <el-collapse v-model="activeNames">
        <el-collapse-item title="Informations générales" name="1">
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
          <el-col :span=8>
        <el-form-item label="Label" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Label" autocomplete="off"></el-input>
        </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="Date Création" :label-width="formLabelWidth2">
               <el-date-picker
                v-model="newRec._source.creationDate"
                type="date"
                placeholder="Choississez un jour">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span=8>
          <el-form-item label="DLC" :label-width="formLabelWidth2">
          <el-input-number size="mini" v-model="newRec._source.DLC" autocomplete="off" :step="1"></el-input-number>
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
        </el-collapse-item>
        
        <el-collapse-item title="Disponibilité" name="2">
      <br>
      <el-card>
        <el-row>
          <h2>Disponibilité</h2>
        </el-row>
        <el-row>
          <el-form-item label="Type de Disponibilité" :label-width="formLabelWidth">
          <el-select v-model="availabilityType" filterable placeholder="Sélectionner" @change="changeAvailType()">
                <el-option key=0 label="Toujours Disponible" value="always"></el-option>
                <el-option key=1 label="Jours de la semaine" value="days"></el-option>
                <el-option key=2 label="Période" value="period"></el-option>
                <el-option key=3 label="Toujours Disponible Sauf" value="except"></el-option>
            </el-select>
        </el-form-item>
        <div v-if="availabilityType == 'days'">
          
          <el-row>
            <el-col :span=3>
              <el-form-item label="Lundi:" :label-width="formLabelWidth2">
                <el-switch v-model="availabilityConf.monday"></el-switch>
              </el-form-item>
            </el-col>
            <el-col :span=3>
              <el-form-item label="Mardi:" :label-width="formLabelWidth2">
                <el-switch v-model="availabilityConf.tuesday"></el-switch>
              </el-form-item>
            </el-col>
            <el-col :span=3>
              <el-form-item label="Mercredi:" :label-width="formLabelWidth2">
                <el-switch v-model="availabilityConf.wednesday"></el-switch>
              </el-form-item>
            </el-col>
            <el-col :span=3>
              <el-form-item label="Jeudi:" :label-width="formLabelWidth2">
                <el-switch v-model="availabilityConf.thursday"></el-switch>
              </el-form-item>
            </el-col>
            <el-col :span=3>
              <el-form-item label="Vendredi:" :label-width="formLabelWidth2">
                <el-switch v-model="availabilityConf.friday"></el-switch>
              </el-form-item>
            </el-col>
            <el-col :span=3>
              <el-form-item label="Samedi:" :label-width="formLabelWidth2">
                <el-switch v-model="availabilityConf.saturday"></el-switch>
              </el-form-item>
            </el-col>
            <el-col :span=3>
              <el-form-item label="Dimanche:" :label-width="formLabelWidth2">
                <el-switch v-model="availabilityConf.sunday"></el-switch>
              </el-form-item>
            </el-col>
          </el-row>
          </div>
          
          <div v-else-if="availabilityType == 'period'">
          
          <el-row>
            <el-col :span=6>
              <label>Définissez la période: </label>
            </el-col>
            <el-col :span=12>
              <el-form-item label="De:" :label-width="formLabelWidth2">
                <el-date-picker v-model="availabilityConf.period" type="daterange" range-separator="à" start-placeholder="Date de début" end-placeholder="Date de fin"></el-date-picker>
              </el-form-item>
            </el-col>
            
          </el-row>
          </div>
          <div v-else-if="availabilityType == 'except'">
          
          <el-row>
            <el-col :span=6>
              <label>Définissez la période: </label>
            </el-col>
            <el-col :span=12>
              <el-form-item label="De:" :label-width="formLabelWidth2">
                <el-date-picker v-model="availabilityConf.except" type="daterange" range-separator="à" start-placeholder="Date de début" end-placeholder="Date de fin"></el-date-picker>
              </el-form-item>
            </el-col>
            
          </el-row>
          </div>
        </el-row>
      </el-card>
        </el-collapse-item>
        <el-collapse-item title="Quotas" name="3">
      <br>
      <el-card>
        <h2>Quotas</h2>
        <el-row>
          <el-col :span=6>
            <br>
          </el-col>
          <el-col :span=6>
            <el-form-item label="Applicable ?" :label-width="formLabelWidth2">
              <el-switch v-model="newRec._source.quota_enable">
              </el-switch>
            </el-form-item>
          </el-col>
          <el-col :span=6>
            <div v-if="newRec._source.quota_enable">
            <el-form-item  label="Quantité : " :label-width="formLabelWidth2">
              <el-input-number v-model="newRec._source.quota" :step=1 :min=0>
              </el-input-number>
            </el-form-item>
            </div>
          </el-col>
          
          <el-col :span=6>
            <br>
          </el-col>
        </el-row>
      </el-card>
        </el-collapse-item>
        <el-collapse-item title="Facturation" name="4">
      <br>
      <el-card>
        <h2>Facturation</h2>
        <el-row>
          
            <el-form-item label="Catégorie" :label-width="formLabelWidth2">
              <el-select v-model="newRec._source.factCategory" filterable placeholder="Sélectionner">
                  <el-option v-for="(item, idFact) in factCategories" :key="idFact" :label="item" :value="item">
                  </el-option>
              </el-select>
        </el-form-item>
          
        </el-row>
      </el-card>
        </el-collapse-item>
        <el-collapse-item title="Informations Fournisseur" name="5">
      <br>
      <el-card>
        <h2>Infos  Fournisseurs</h2>
        <el-row>
        </el-row>
        <el-row>
          <el-form-item label="CODE Produit: " :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.fournisseur_code" autocomplete="off"></el-input>
         </el-form-item>
        </el-row>
        <el-row>
          <el-form-item label="Prix Fournisseur (HTVA): " :label-width="formLabelWidth2">
          <el-input-number size="mini" v-model="newRec._source.fournisseur_prix" :step=0.01 :min=0></el-input-number>
         </el-form-item>
        </el-row>
        <el-row>
          <el-form-item label="Fournisseur : " :label-width="formLabelWidth2">
           <el-select v-model="selectedfournisseur" filterable placeholder="Sélectionner" @change="changeFournisseur">
                <el-option v-for="(item, id) in fournisseurs" :key="id" :label="item['name']" :value="item['CODE']">
                </el-option>
            </el-select>
          
          <!--el-form-item label="Nom fournisseur : " :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.fournisseur" autocomplete="off"></el-input>
         </el-form-item>
        </el-row>
        <el-row>
          <el-form-item label="Numéro fournisseur : " :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.fournisseur_num" autocomplete="off"></el-input-->
         </el-form-item>


        </el-row>
      </el-card>
        </el-collapse-item>
        <el-collapse-item title="Conventions Produits" name="6">
          <el-card>
            <div style="width: 100%;height: calc(100vh - 225px); overflow: auto;">
            <el-row>
                <el-table
                  class="table-logs"
                  size="mini"
                  :data="conventions"
                  style="width: 100%"
                >
                  <el-table-column
                    width="180"
                    label="Convention"
                    sortable
                  >
                    <template slot-scope="scope">
                      {{scope.row.CODE }}
                    </template>
                  </el-table-column>
                  <el-table-column
                    width="180"
                    label="Description"
                    sortable
                  >
                    <template slot-scope="scope">
                      {{scope.row.description }}
                    </template>
                  </el-table-column>
                  <el-table-column
                    width="180"
                    label="Inclus ?"
                    sortable
                  >
                    <template slot-scope="scope">
                      <el-checkbox v-model="scope.row.included" @change="changeConvention(scope.row.CODE, scope.row.included)"></el-checkbox>
                      
                    </template>
                  </el-table-column>
                </el-table>
            </el-row>
            </div>
            {{conventions}}
          </el-card>
          
        </el-collapse-item>
        <el-collapse-item title="Image" name="7">
          <el-card>
            <span>
              <el-form-item label>
                <Upload :config="configUploadPicture" @on-success="uploadPictureSuccess"></Upload>
              </el-form-item>
            </span>
            <span v-if="newRec._source.picture != ''">
              <img :src="newRec._source.picture" width="350" height="350"/>
            
            </span>
          </el-card>
        </el-collapse-item>
        <el-collapse-item title="Cout Produit" name="8">
      <br>
      <el-card>
        <h2>Coût à l'achat</h2>
        <el-row>
        </el-row>
        <el-row>
          <el-col :span=9>
            <br>
          </el-col>
          <el-col :span=6>
          <el-form-item label="Coût (€): " :label-width="formLabelWidth2">
          <el-input-number size="mini" v-model="newRec._source.cout_prod" :step=0.01 :min=0></el-input-number>
         </el-form-item>
          </el-col>
          <el-col :span=9>
            <br>
          </el-col>
        </el-row>
      </el-card>
        </el-collapse-item>
      </el-collapse>

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

import upload from "@/components/Upload";
Vue.component("Upload", upload);

function transformObject(obj) {
  return rison.encode(obj);
}

import { extractURLParts } from "../../globalfunctions";

export default {
  name: "productEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth2: "180px",
    formLabelWidth: "120px",
    changed: false,
    dialogFormVisible: false,
    title: "Produit",
    availability: ["Toujours Disponible", "Sur Commande Client", "Mercredi et Vendredi"],
    availabilityTypes:["always", "period", "days"],
    availabilityType: '',
    availabilityConf: {},
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
    lieuPrepa: ['-', 'Cave', 'Boulangerie', 'Table', 'Flexis', 'Fournitures', 'Salé', 'Fournisseur'],
    lieuProd: ['-', 'Cave', 'Boulangerie', 'Table', 'Viennoiserie', 'Fournitures', 'Salé', 'Fournisseur'],
    filters: null,
    factCategories: ['Boulangerie', 'Pâtisserie', 'Confiserie', 'Boissons', 'Sandwiches', 'Matériel', 'Salés', 'Fournisseur'],
    activeNames: ['1', '2'],
    conventions: {},
    fournisseurs: {},
    selectedfournisseur: {},
    configUploadPicture: {
      config: {
        queryfilters: [],
        queue: "/queue/PRODUCT_PICTURE_IMPORT",
        tip: "Déposez une image ici"
      }
    }

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
    getFournisseurs: function(){
        console.log("Get Fournisseurs")
        var url = this.$store.getters.apiurl + "lambdas/2/get_fournisseurs?apikey=" + this.$store.getters.creds.token;
        var body = {};
        axios
        .post(url, body)
        .then((response) => {
            console.log(response)
            this.fournisseurs = response.data
            this.$forceUpdate();
        });
    },
    prepareData: function() {
      console.log("prepare data");
      this.dialogFormVisible = true;
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
      this.selectedfournisseur['CODE'] = this.newRec._source['fournisseur_num']
      this.selectedfournisseur['name'] = this.newRec._source['fournisseur']
      this.availabilityType = this.newRec._source.avail
      
      this.availabilityConf  = JSON.parse(this.newRec._source.availabilityConf)
      console.log(this.availabilityConf)
      console.log(this.availabilityConf.period)
      this.getConventions();
      this.getFournisseurs();
    },
    lvl1Change: function(){
        this.newRec._source.sortLvl2 = '-';
    },
    changeAvailType: function()
    {
      if(this.availabilityType == 'always')
      {
        this.availabilityConf = {"always": "always"}
      }
      else if(this.availabilityType == 'days')
      {
        this.availabilityConf = {
          "monday": true,
          "tuesday": true,
          "wednesday": true,
          "thursday": true,
          "friday": true,
          "saturday": true,
          "sunday": true,
        }
        
      }
      else
      {
        this.availabilityConf = {
          "period": Date.now(),
          
        }
      }
    },
    uploadPictureSuccess: function(response, file, fileList) {
      // this.newRec._source.target = this.$store.getters.apiurl.replace('api/v1/', '')
      
      var mainurl=extractURLParts(window.location.href);
      var nurl=mainurl.protocol+"//"+mainurl.host+"";          
      this.newRec._source.picture =nurl+
        "/public/pictures/" + file.name;

      var tmp = JSON.parse(JSON.stringify(this.newRec));
      this.newRec = null;
      this.newRec = JSON.parse(JSON.stringify(tmp));
    },
    saveRecord: function() {

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.lastUpdate = Date.now()
      this.newRec._source['TVA'] = this.TVA.toFixed(2)
      this.newRec._source['HTVA'] = this.HTVA.toFixed(2)
      this.newRec._id = this.newRec._source['CODE']
      this.newRec._source.avail = this.availabilityType
      this.newRec._source.availabilityConf = JSON.stringify(this.availabilityConf)
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
      getConventions(){
          var url = this.$store.getters.apiurl +"lambdas/8/get_conventions_by_product?apikey=" + this.$store.getters.creds.token;
          var query = {"_id": this.newRec._source['CODE']}
          axios
            .post(url, query)
            .then((response) => {

              //var status = false

              console.log(response.data)
              this.conventions = response.data



      });
      },
      changeFournisseur(item)
      {
        console.log("Change Fournisseur")

        for(var four in this.fournisseurs)
        {
          console.log(four)
          if(this.fournisseurs[four]['CODE'] == item)
          {

            this.newRec._source.fournisseur = this.fournisseurs[four]['name']
          }
        }
        this.newRec._source.fournisseur_num = item

      },
      changeConvention(CODE, included)
      {
        console.log("Change Convention")
        console.log(CODE)
        console.log(included)
        var url = this.$store.getters.apiurl +"lambdas/8/set_conventions_by_product?apikey=" + this.$store.getters.creds.token;
        var query = {"_id": this.newRec._source['CODE'], "convention": CODE, "included": included}
          axios
            .post(url, query)
            .then((response) => {

              //var status = false

              console.log(response.data)



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