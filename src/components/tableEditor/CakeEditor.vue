<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="cake-editor"
  >
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <el-form-item v-if="editableMagasin" label="Magasin" :label-width="formLabelWidth">
            <el-input :disabled="editableMagasin" size="mini" v-model="magasin" autocomplete="off"></el-input>
          </el-form-item>
          <el-form-item v-else label="Magasin" :label-width="formLabelWidth2">
            <el-select v-model="newRec._source.magasin" filterable placeholder="Sélectionner">
                    <el-option v-for="(item, magasin) in magasins" :key="magasin" :label="item" :value="item">
                    </el-option>
                </el-select>
            </el-form-item>
          
          <el-row>
              <el-col :span=8>
                <el-form-item label="Nom" :label-width="formLabelWidth">
                    <el-input size="mini" v-model="newRec._source.name" autocomplete="off"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span=8>  
                <el-form-item label="Prénom" :label-width="formLabelWidth">
                    <el-input size="mini" v-model="newRec._source.firstname" autocomplete="off"></el-input>
                </el-form-item>
              </el-col>  
              <el-col :span=8>  
                <el-form-item label="Téléphone" :label-width="formLabelWidth">
                    <el-input size="mini" v-model="newRec._source.phone" autocomplete="off"></el-input>
                </el-form-item>
              </el-col>  
          </el-row>
          <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <h2>Composition:</h2>
          <el-row>
              <el-form-item label="Type de Gâteaux" :label-width="formLabelWidth2">
                <el-select v-model="newRec._source.cake.type" filterable placeholder="Sélectionner">
                        <el-option v-for="(item, type) in cakeTypes" :key="type" :label="item" :value="item">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-if="newRec._source.cake.type == 'Number Cake'" label="Taille" :label-width="formLabelWidth2">
                    <el-input-number size="mini" v-model="newRec._source.cake.size" autocomplete="off" :min="10" :step="2"/>
                </el-form-item>
                <el-form-item v-else label="Taille" :label-width="formLabelWidth2">
                    <el-select v-model="newRec._source.cake.size" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, size) in sizes" :key="size" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-if="newRec._source.cake.type == 'Bavarois'" label="Goût" :label-width="formLabelWidth2">
                    <el-select v-model="newRec._source.cake.bavaroisType" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, bavaroisType) in bavaroisTypes" :key="bavaroisType" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-if="newRec._source.cake.type == 'Glace'" label="Goût" :label-width="formLabelWidth2">
                    <el-select multiple multiple-limit=2 v-model="newRec._source.cake.glaceGout" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, glaceGout) in glaceGouts" :key="glaceGout" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-if="newRec._source.cake.type == 'Number Cake'" label="Saveur" :label-width="formLabelWidth2">
                    <el-select v-model="newRec._source.cake.numberCakeType" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, numberCakeType) in numberCakeTypes" :key="numberCakeType" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>
                <div v-if="newRec._source.cake.type == 'Number Cake'">
                    <el-form-item label="Déco" :label-width="formLabelWidth2">
                        <el-select v-model="newRec._source.cake.numberCakeGender" filterable placeholder="Sélectionner">
                                <el-option v-for="(item, numberCakeGender) in numberCakeGenders" :key="numberCakeGender" :label="item" :value="item">
                                </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item v-if="newRec._source.cake.numberCakeGender == 'Fille' || newRec._source.cake.numberCakeGender == 'Garçon'" label="Âge" :label-width="formLabelWidth2">
                        <el-input-number size="mini" v-model="newRec._source.age" autocomplete="off" :min="0" :step="1"/>
                    </el-form-item>
                    <el-form-item label="Caractères :" :label-width="formLabelWidth2" >
                        <el-input maxlength="2" minlength="1" size="mini" v-model="newRec._source.cake.numberCakeChars" autocomplete="off" placeholder="Vos caractères"></el-input>
                    </el-form-item>
                </div>
                <el-form-item label="Inscription :" :label-width="formLabelWidth2" >
                    <el-input size="mini" v-model="newRec._source.cake.inscription" autocomplete="off" placeholder="Ex: Joyeux Anniversaire"></el-input>
                </el-form-item>
                <el-form-item label="Remarques :" :label-width="formLabelWidth2" >
                    <el-input size="mini" v-model="newRec._source.cake.remarques" autocomplete="off" placeholder="Vos remarque..."></el-input>
                </el-form-item>
          </el-row>
          {{totalTTC}}€
          </el-card>
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
  name: "CakeEditor",
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
    title: "Gâteaux",
    cakeTypes: ['Crème fraîche fruits', 'Spécial Patron', 'Schamp', 'Negresco', 'Chocorêve', 'Mikkado', 'Bavarois', 'Glace', 'Number Cake'],
    sizes: ['4 à 6 P', '8 à 10 P', '12 à 15 P', '20 P'],
    bavaroisTypes: ['Fruits des Bois', 'Fraise', 'Framboise', 'Bora Bora'],
    glaceGouts: ['Vanille', 'Chocolat', 'Fraise', 'Framboise', 'Pabana'],
    numberCakeTypes: ['Crème fraîche - fraise', 'Crème fraîche - framboise', 'Mousse Chocolat', 'Mousse Pabana'],
    numberCakeGenders: ['Homme', 'Femme', 'Fille', 'Garçon', 'Autre'],
    magasins: [],


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
    editableMagasin: function() {
        console.log('Active APP:')
        console.log(this.$store.getters.maintitle)
        console.log(this.$store.getters.mainsubtitle)
        console.log(this.$store.getters.currentSubCategory.fulltitle)
        if(this.$store.getters.currentSubCategory.fulltitle=='commandes/gâteaux')
        {
            return true
        }
        else{
            return false
        }
        
    },
    magasin: function()
    {
        var magasin = 'TEST'
        if(this.$store.getters.currentSubCategory.fulltitle == 'commandes/gâteaux')
        {
            console.log(this.$store.getters.activeApp.config.hiddenQuery.substring(9))
            magasin = this.$store.getters.activeApp.config.hiddenQuery.substring(9)
            
        }
        return magasin
    },
    totalTTC: function() {
        var price = 0
        if(this.newRec._source.cake.type == 'Number Cake'){
            price = this.newRec._source.cake.size * 4.5
        }
        else
        {
            switch(this.newRec._source.cake.size)
            {
                case '4 à 6 P':
                    price = 5;
                    break;
                
                case '8 à 10 P':
                    price = 10;
                    break;
                case '12 à 15 P':
                    price = 15;
                    break;
                case '20 P':
                    price = 20;
                    break;

                
            }
        }
        return price
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
    this.getMagasins();
    this.prepareData();
  },
  components: {},
  methods: {
    closeDialog: function() {
      this.$emit("dialogclose");
    },
    getMagasins() {         
      var url =
      this.$store.getters.apiurl +
      "generic_search/shop_parameters?token=" + this.$store.getters.creds.token;  

      console.log('CHECK SHOPS LIST')

      var query = {
        size: 2000,
        sort:[{"Nom magasin.keyword":{"order":"asc"}}],
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
            console.log("User Shop list error...");
            else{
                
                var res = response.data
                console.log("MAGASINS : ")
                console.log(res)
                this.magasin = res.records[0]._source['Nom magasin']
                var magasins = []
                for(var rec in res.records)
                {
                    console.log(rec)
                    magasins.push(res.records[rec]._source['Nom magasin'])
                }
                this.magasins = magasins
                console.log(this.magasins)
                this.prepareData();
               
            }
        });  

        

    },
    prepareData: function() {
      console.log("prepare data");
      this.dialogFormVisible = true;
      if(!this.record._source.cake)
      {
          this.record._source.cake = {}
      }
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
    },
    saveRecord: function() {

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.dateOrder = Date.now()
      this.newRec._source.dateDelivery = this.$store.getters.timeRangeDay[0].getTime()
      console.log(Date.now())
      console.log(this.$store.getters.timeRangeDay[0].getTime())

      if(this.$store.getters.currentSubCategory.fulltitle == 'commandes/gâteaux')
      {
          this.newRec._source.magasin = this.magasin
      }

      console.log(this.newRec)

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