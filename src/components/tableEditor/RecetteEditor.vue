<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="recette-editor"
  >
  
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">

       <el-row>
           <el-col :span="6">
            <el-form-item label="Code" :label-width="formLabelWidth">
                <el-input :disabled="editMode!='create'" size="mini" v-model="newRec._source.code" autocomplete="off"></el-input>
            </el-form-item>
        </el-col>    
        <el-col :span="6">
            <el-form-item label="Poids" :label-width="formLabelWidth">
                <el-input-number size="mini" v-model="newRec._source.weight" :min="0"></el-input-number>
            </el-form-item>
        </el-col>    
        <el-col :span="6">
            <el-form-item label="Unité" :label-width="formLabelWidth">
                <el-input size="mini" v-model="newRec._source.unity" autocomplete="off"></el-input>
            </el-form-item>
       </el-col>     
       </el-row> 
       <el-row style="text-align:left;">
           <el-col>
               <label>Ingrédients :</label>
           </el-col>
           <el-col v-for="(ingredient, index) in this.newRec._source.ingredients" :key="index">
                <el-row>
                       <el-col :span=6>
                           <el-form-item label="Code Ingr." :label-width="formLabelWidth">
                              {{ingredient.code}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=6>
                           <el-form-item label="Ingr." :label-width="formLabelWidth">
                              {{ingredient.name}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=6>    
                           <el-form-item label="Quantity" :label-width="formLabelWidth">
                               <el-input-number size="mini" v-model="ingredient.quantity" :min="0"></el-input-number>
                           </el-form-item>
                       </el-col>
                       <el-col :span=3>
                           <el-button @click="removeIngredient(index)" type="danger" icon="el-icon-delete" circle>
                           </el-button>
                       </el-col>
                </el-row>
           </el-col>
       </el-row>
       <el-row style="text-align:left;">
         <el-col :span="4">
           <label>Ajouter ingrédient : </label>
         </el-col>
         <el-col :span="4">
           <el-select v-model="newIngredient" placeholder="Choisissez un ingrédient" filterable size="mini">
             <el-option v-for="(_source, index) in this.allIngredients" :key="index" :value="[_source._source['Code ingrédient'], _source._source['Ingrédient']]" :label="_source._source['Code ingrédient']+ ' ' + _source._source['Ingrédient']" ></el-option>
           </el-select>
         </el-col>
          <el-col :span="3">
           <label>Quantité : </label>
         </el-col>
         <el-col :span=3>    
           <el-input-number size="mini" v-model="newIngredientQuantity" :min="0" :value="1"></el-input-number>
         </el-col>
         <el-col :span="4">
           <el-button type="primary" @click="addIngredient()" icon="el-icon-plus" circle></el-button>
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
    changed: false,
    dialogFormVisible: false,
    title: "Recette",
    allIngredients: null,
    newIngredient: null,
    newIngredientQuantity: 1
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
  components: {},
  methods: {
    closeDialog: function() {
      this.$emit("dialogclose");
    },
    removeIngredient: function(index){
        console.log("coucou")
        console.log(this.newRec._source.ingredients[index])
        //delete this.newRec._source.ingredients[index]
        this.newRec._source.ingredients.splice(index, 1)
    },
    prepareData: function() {
      console.log("prepare data");
      this.dialogFormVisible = true;
      if(!this.record._source.ingredients)
      {
        console.log("New record")
        this.record._source.ingredients = []
        console.log(this.record)
      }
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
      this.allIngredients = this.getIngredients();
    },
    addIngredient: function() {
      var ingredientToAdd = {
        "code": this.newIngredient[0],
        "name": this.newIngredient[1],
        "quantity": this.newIngredientQuantity
      }
      this.newRec._source.ingredients.push(ingredientToAdd);
    },
    getIngredients: function() {
      var url =
        this.$store.getters.apiurl +
        "generic_search/schamp_ingredients" +
        "?token=" +
        this.$store.getters.creds.token;
        
      var query = {
          "size": 10000
        }

        axios
        .post(url, query)
        .then(response => {
          if (response.data.error != "") {
            console.log("fail to retrieve ingredients");
          } else {
            console.log(response);

            this.allIngredients = response.data.records


          }
        })
        .catch(error => {
          console.log(error);
        });
    },
    saveRecord: function() {

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.orderDate = Date.now()

      this.$store.commit({
        type: "updateRecord",
        data: this.newRec
      });
      this.$notify({ 
        title: "Record saved.",
        type: "success",
        message: "La recette a été enregistrée.",
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