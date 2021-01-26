<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="unsales-editor"
  >
    <el-row><h1>{{newRec._source.shop}}</h1></el-row>

  <el-row>Total Boulangerie TTC: {{ totalBoulangerie  | roundTo2 }}€  Total Pâtisserie TTC : {{totalPatisserie | roundTo2 }} € Total Autres TTC : {{totalOther  | roundTo2 }} €</el-row>
 
  <el-row>Total TTC : {{totalPrice | roundTo2 }} €<br></el-row>
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <el-row class="unsaleseditor-container" style="width: 100%" >
            

         <el-tabs v-model="selectedTab" @tab-click="tabChanged(selectedTab)">
          <el-tab-pane
          
          v-for="(category, index) in classement"
          :key="'TAB-'+index"
          :label="category"
          :name="'TAB-'+index"
          :lazy="true"
          
          
        >
        <!--el-tabs v-model="selectedUnderTab" @tab-click="subTabChanged()">
          <el-tab-pane
          
          v-for="(subcategory, index1) in subCategories[category]"
          :key="'TAB-'+index+'-'+index1"
          :label="subcategory"
          :name="'TAB-'+index+'-'+index1"
          :lazy="true"
          
          
        >


 <el-row>
          <el-col v-if="subSubCategories[category][subcategory]['sortLvl3'].length> 1" :span="4">
                          Type de pâte: 
            <el-select v-model="filter1" placeholder="Sélectionner">
              <el-option
                v-for="(item, id1) in subSubCategories[category][subcategory]['sortLvl3']"
                :key="id1"
                :label="item"
                :value="item">
              </el-option>
            </el-select>
            </el-col>
            <el-col v-if="subSubCategories[category][subcategory]['sortLvl4'].length> 1" :span="4">
               Fruits cuits/pas cuits:
            <el-select v-model="filter2" placeholder="Sélectionner">
              <el-option
                v-for="(item, id2) in subSubCategories[category][subcategory]['sortLvl4']"
                :key="id2"
                :label="item"
                :value="item">
              </el-option>
            </el-select>
            </el-col>
            <el-col v-if="subSubCategories[category][subcategory]['sortLvl5'].length> 1" :span="4">
             Avec/Sans Fruits
            <el-select v-model="filter3" placeholder="Sélectionner">
              <el-option
                v-for="(item, id3) in subSubCategories[category][subcategory]['sortLvl5']"
                :key="id3"
                :label="item"
                :value="item">
              </el-option>
            </el-select>
            </el-col>
            <el-col v-if="subSubCategories[category][subcategory]['sortLvl6'].length> 1" :span="4">
              Taille:
            <el-select v-model="filter4" placeholder="Sélectionner">
              <el-option
                v-for="(item, id4) in subSubCategories[category][subcategory]['sortLvl6']"
                :key="id4"
                :label="item"
                :value="item">
              </el-option>
            </el-select>
            </el-col>
            <el-col v-if="subSubCategories[category][subcategory]['sortLvl7'].length> 1" :span="4">
              Crème Fraiche:
            <el-select v-model="filter5" placeholder="Sélectionner">
              <el-option
                v-for="(item, id5) in subSubCategories[category][subcategory]['sortLvl7']"
                :key="id5"
                :label="item"
                :value="item">
              </el-option>
            </el-select>
            </el-col>
            <el-col v-if="subSubCategories[category][subcategory]['sortLvl8'].length> 1" :span="4">
              Type de fruits:
            <el-select v-model="filter6" placeholder="Sélectionner">
              <el-option
                v-for="(item, id6) in subSubCategories[category][subcategory]['sortLvl8']"
                :key="id6"
                :label="item"
                :value="item">
              </el-option>
            </el-select>
            </el-col>
            <el-col v-if="subSubCategories[category][subcategory]['sortLvl9'].length> 1" :span="4">
              Crème:
            <el-select v-model="filter7" placeholder="Sélectionner">
              <el-option
                v-for="(item, id7) in subSubCategories[category][subcategory]['sortLvl9']"
                :key="id7"
                :label="item"
                :value="item">
              </el-option>
            </el-select>
            </el-col>
            <el-col v-if="subSubCategories[category][subcategory]['sortLvl10'].length> 1" :span="4">
              Autres:
            <el-select v-model="filter8" placeholder="Sélectionner">
              <el-option
                v-for="(item, id8) in subSubCategories[category][subcategory]['sortLvl10']"
                :key="id8"
                :label="item"
                :value="item">
              </el-option>
            </el-select>
            </el-col>
 
 </el-row-->    



        <div style="bottom: 5%;">

            
        Total Panier TTC : {{totalPrice | roundTo2 }} €

        <br>
        <el-row>
            <el-col :span="4">
                <el-form-item label="Clôturé ? : ">
                    <el-switch v-model="newRec._source.confirmed"></el-switch>
                </el-form-item>
            </el-col>
        </el-row>
        
        
        <el-table :data="newRec._source.products.filter(getFilter)" style="width: 100%;height: calc(100vh - 225px); overflow: auto;" :default-sort = "{prop: 'CODE', order: 'ascending'}" height="750">    
            <el-table-column prop="CODE" label="Code" sortable></el-table-column>
          <el-table-column prop="Label" label="Nom" sortable></el-table-column>
          <el-table-column label="Prix TTC" sortable>
            <template slot-scope="scope">
              {{scope.row.Prix_TVAC | roundTo2 }} €
            </template>
          </el-table-column>
          <el-table-column label="Quantité" sortable>
          <template slot-scope="scope">
            <el-input-number :min="0" size="mini" v-model="scope.row.quantity" :disabled="scope.row.checked || newRec._source.confirmed"/>
          </template>
          </el-table-column>
          <el-table-column label="Total TTC" sortable>
            <template slot-scope="scope">
              {{scope.row.quantity * scope.row.Prix_TVAC | roundTo2}} €
            </template>
          </el-table-column>
          <el-table-column :span=2 label="Check">
              <template slot-scope="scope">
              <el-switch v-model="scope.row.checked"></el-switch>
              </template>
          </el-table-column>
          
          </el-table> 
          </div>
          <br><br>
                <!--/el-tab-pane>

      </el-tabs-->
                </el-tab-pane>
                <el-tab-pane
        :key="'TAB_AddProduct'"
        :label="'Ajouter Produit'"
        :name="'TAB_AddProduct'"
        :lazy="true">
        <div style="width: 100%;height: calc(100vh - 225px); overflow: auto;" height=750>
          <el-row>Ajouter: 
            <el-select v-model="productToAdd" placeholder="Sélectionner">
              <el-option
                v-for="(prod, idProd) in othersProducts"
                :key="idProd"
                :label="prod.CODE+ ' ('+prod.label+')'"
                :value="prod['_id']">
              </el-option>
            </el-select>
            <el-button type="primary" @click="addProduct">Ajouter</el-button>


          </el-row>
          <el-row>{{productToAdd}}</el-row>
        </div>
      </el-tab-pane>
          </el-tabs>
          </el-row>
      </el-card>
    </el-form>

    <span slot="footer" class="dialog-footer">
      Total TTC : {{totalPrice | roundTo2 }} €
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
  name: "unsalesEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    tree: {'hello': 'test'},
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    changed: false,
    dialogFormVisible: false,
    title: "Commande",
    classement:['toto'],
    filter1: '-',
    filter2: '-',
    filter3: '-',
    filter4: '-',
    filter5: '-',
    filter6: '-',
    filter7: '-',
    filter8: '-',
    ts: 0,
    selectedTab: "TAB-0",
    selectedUnderTab: "TAB-0-0",
    subCategories: {},
    subSubCategories: {},
    othersProducts: [],
    productToAdd: '',

  }),
  computed: {

      productsList: function(){
        var list = []

        console.log('ProductList')
        console.log(this.newRec._source.products)

        for(var product in Object.keys(this.newRec._source.products))
        {
          list.push(this.newRec._source.products[product]['CODE'])
        }
        return list;
    },

      totalPrice: function() {
      var price = 0

      if(this.newRec._source.products != null)
      {
        for(var itemKey in Object.keys(this.newRec._source.products))
        {
          var item = this.newRec._source.products[itemKey]
          price += (item.conditionnement*item.quantity*item.Prix_TVAC)
        }
        
      }
      return price
    },
     
     testClass: function() {

        return 'this.classement'
     },
     
    /*totalFiltered: function(){
      var filteredProducts = this.newRec._source.products
      var price = 0
      for(var itemKey in Object.keys(this.newRec._source.products))
      {
        var data = this.newRec._source.products[itemKey]
        var filter = data.sortLvl1 == this.selectedCategory && data.sortLvl2 == this.selectedSubCategory
        var filter1 = true
        var filter2 = true
        var filter3 = true
        var filter4 = true
        var filter5 = true
        var filter6 = true
        var filter7 = true
        var filter8 = true
        

        if(this.filter1 != '-')
        {
            filter1 = data.sortLvl3 == this.filter1
        }
        if(this.filter2 != '-')
        {
            filter2 = data.sortLvl4 == this.filter2
        }
        if(this.filter3 != '-')
        {
            filter3 = data.sortLvl5 == this.filter3
        }
        if(this.filter4 != '-')
        {
            filter4 = data.sortLvl6 == this.filter4
        }
        if(this.filter5 != '-')
        {
            filter5 = data.sortLvl7 == this.filter5
        }
        if(this.filter6 != '-')
        {
            filter6 = data.sortLvl8 == this.filter6
        }
        if(this.filter7 != '-')
        {
            filter7 = data.sortLvl9 == this.filter7
        }
        if(this.filter8 != '-')
        {
            filter8 = data.sortLvl10 == this.filter8
        }
        
        if(filter && filter1 && filter2 && filter3 && filter4 && filter5 && filter6 && filter7 && filter8)
        {
          price += (data.conditionnement*data.quantity*data.Prix_TVAC)
        }
        
      }
      
      return price
    },*/

    totalPatisserie: function(){

      var price = 0
      //var products = this.newRec._source.products
      for(var itemKey in Object.keys(this.newRec._source.products))
      {
        var data = this.newRec._source.products[itemKey]
        if(data.sortLvl1 == 'Pâtisserie')
        {
          price += (data.conditionnement*data.quantity*data.Prix_TVAC)
        }
      }

      return price

    },

    totalBoulangerie: function(){

      var price = 0
      //var products = this.newRec._source.products
      for(var itemKey in Object.keys(this.newRec._source.products))
      {
        var data = this.newRec._source.products[itemKey]
        if(data.sortLvl1 == 'Boulangerie')
        {
          price += (data.conditionnement*data.quantity*data.Prix_TVAC)
        }
      }

      return price

    },

    totalOther: function(){

      var price = 0
      //var products = this.newRec._source.products
      for(var itemKey in Object.keys(this.newRec._source.products))
      {
        var data = this.newRec._source.products[itemKey]
        if(data.sortLvl1 != 'Pâtisserie' && data.sortLvl1 != 'Boulangerie')
        {
          price += (data.conditionnement*data.quantity*data.Prix_TVAC)
        }
      }

      return price

    },

    
    selectedCategory: function() {
      var index = this.selectedTab.split('-').pop()
      console.log(this.classement[index])
      return this.classement[index]
    },
    /*selectedSubCategory: function() {
      var index = this.selectedCategory
      var index1 = this.selectedUnderTab.split('-').pop()
      console.log('UnderTab Selected : ')
      console.log(this.subCategories[index][index1])
      return this.subCategories[index][index1]
    },*/
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
  filters: {
      roundTo2: function(value){
        return value.toFixed(2);
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
        //this.getTree();
      },
      deep: true
    }
  },
  created: function() {
    console.log("created event");
    
    this.prepareData();
  },
  mounted: function () {
      this.getTree();
      console.log("Mounted")
  },
  components: {},
  methods: {
    totalCategoryQuantity: function(category) {
      var quantity = 0
      if(this.newRec._source.products != null)
      {
        for(var itemKey in Object.keys(this.newRec._source.products))
        {
          var item = this.newRec._source.products[itemKey]
          if(item.sortLvl1 ==category){
              quantity += (item.quantity)
          }    
        }
        return quantity
      }
      else{
        return 0
      }
      
    },
    totalCategoryPrice: function(category) {
      
      var price = 0
      if(this.newRec._source.products != null)
      {
        
        for(var itemKey in Object.keys(this.newRec._source.products))
        {
          var item = this.newRec._source.products[itemKey]
          if(item.sortLvl1 ==category){
              price += (item.quantity*item.Prix_TVAC)
          }
         
        }
        return price
      }
      else{
        return 0
      }
      
    },
    totalSubCategoryQuantity: function(category, subCategory) {
      var quantity = 0
      if(this.newRec._source.products != null)
      {
        for(var itemKey in Object.keys(this.newRec._source.products))
        {
          var item = this.newRec._source.products[itemKey]
          if(item.sortLvl1 ==category && item.sortLvl2 == subCategory){
              quantity += (item.quantity)
          }    
        }
        return quantity
      }
      else{
        return 0
      }
      
    },
    totalSubCategoryPrice: function(category, subCategory) {
      
      var price = 0
      if(this.newRec._source.products != null)
      {
        
        for(var itemKey in Object.keys(this.newRec._source.products))
        {
          var item = this.newRec._source.products[itemKey]
          if(item.sortLvl1 ==category && item.sortLvl2 == subCategory){
              price += (item.quantity*item.Prix_TVAC)
          }
         
        }
        return price
      }
      else{
        return 0
      }
      
    },
    getFilter(data){

        //console.log(data)
        //console.log(this.category)
        var filter = data.sortLvl1 == this.selectedCategory 
        //&& data.sortLvl2 == this.selectedSubCategory
        var filter1 = true
        var filter2 = true
        var filter3 = true
        var filter4 = true
        var filter5 = true
        var filter6 = true
        var filter7 = true
        var filter8 = true
        

        if(this.filter1 != '-')
        {
            filter1 = data.sortLvl3 == this.filter1
        }
        if(this.filter2 != '-')
        {
            filter2 = data.sortLvl4 == this.filter2
        }
        if(this.filter3 != '-')
        {
            filter3 = data.sortLvl5 == this.filter3
        }
        if(this.filter4 != '-')
        {
            filter4 = data.sortLvl6 == this.filter4
        }
        if(this.filter5 != '-')
        {
            filter5 = data.sortLvl7 == this.filter5
        }
        if(this.filter6 != '-')
        {
            filter6 = data.sortLvl8 == this.filter6
        }
        if(this.filter7 != '-')
        {
            filter7 = data.sortLvl9 == this.filter7
        }
        if(this.filter8 != '-')
        {
            filter8 = data.sortLvl10 == this.filter8
        }
        
        //data.sortLvl1 == category && data.sortLvl2 == subcategory
        //&& filter1 && filter2 && filter3 && filter4 && filter5 && filter6 && filter7 && filter8
        return filter 
    },
    tabChanged(index){
      this.selectedUnderTab = index+'-0'
      console.log('Selected:  TAB-'+index+'-0')
      this.filter1 = '-'
      this.filter2 = '-'
      this.filter3 = '-'
      this.filter4 = '-'
      this.filter5 = '-'
      this.filter6 = '-'
      this.filter7 = '-'
      this.filter8 = '-'
      //this.selectedUnderUnderTab = 'TAB-'+index+'-0-0'
    },
    subTabChanged(){
      this.filter1 = '-'
      this.filter2 = '-'
      this.filter3 = '-'
      this.filter4 = '-'
      this.filter5 = '-'
      this.filter6 = '-'
      this.filter7 = '-'
      this.filter8 = '-'
    },
    closeDialog: function() {
      this.$emit("dialogclose");
    },
    getOthersProducts: function(){
      var query = {"codes": this.productsList}
      var url = this.$store.getters.apiurl + "lambdas/2/getOthersProducts?apikey=" + this.$store.getters.creds.token;
      axios
      .post(url, query)
      .then((response) => {

        //var status = false

        console.log(response.data.orderstatus)
        this.othersProducts = response.data



      });

    },
    addProduct: function(){
        var _id = this.productToAdd

        var query = {"code": _id}

        var url = this.$store.getters.apiurl + "lambdas/2/getProductByCode?apikey=" + this.$store.getters.creds.token;
        axios
        .post(url, query)
        .then((response) => {

          //var status = false

          console.log(response.data.orderstatus)
          this.newRec._source.products.push(response.data)
          this.getOthersProducts();



      });


    },

    removeProduct: function(index, scope){
        console.log(scope)
        console.log(index)
        //console.log(rows)
        //rows.splice(index, 1)
        console.log('delete')
        var code = scope.row['CODE']
        var toDelete = 0

        for(var itemKey in Object.keys(this.newRec._source.products)) {
          var item = this.newRec._source.products[itemKey]
          if(item['CODE'] == code)
          {
            toDelete = itemKey
          }
        }

        this.newRec._source.products.splice(toDelete, 1)
        this.getOthersProducts();

    },
    
    getTree: function() {
      /*var url =
      this.$store.getters.apiurl +
      "schamps/get_products_tree?token=" + this.$store.getters.creds.token;  

      console.log('GET PRODUCTS TREE')
      axios
        .get(url)
        .then((response) => {
            if(response.data.error!="")
            console.log("Order Shops Calls list error...");
            else{
                var res = JSON.parse(response.data.data)
                this.tree = res.reccords
                console.log("TREE : ")
                
                var tree = res.reccords
                console.log(JSON.stringify(tree))
                var cats = []
                var subCategories = {}
                var subSubCategories = {}
                for(var i in tree)
                {
                  console.log(i)
                  cats.push(i)
                  var subCat = []
                  subSubCategories[i] = {}
                  for(var j in tree[i])
                  {
                    console.log(j)
                    subCat.push(j)
                  }
                  
                  
                  subCategories[i] = subCat.sort()
                  console.log(subSubCategories)
                }
                console.log("Categories : "  + cats)
                this.subCategories = subCategories
                this.subSubCategories = tree
                //this.classement = 'TOTO'
                //alert(JSON.stringify(cats))
                this.classement = cats.sort()
                //alert(JSON.stringify(cats))
                console.log(cats)
                console.log(this.classement)
                console.log(['tata', 'titi'])
                this.tree = tree
                
            }
        });    */
        var cats = []
        for( var index in this.newRec._source.products)
        {
            //console.log(prod)
            if(this.newRec._source.products[index]['display'] == true)
            {
                cats.push(this.newRec._source.products[index]['sortLvl1'])
            }
            
        }
        var classement = cats.filter(this.onlyUnique)

        this.classement = classement.sort()
    },

    onlyUnique: function(value, index, self) {
    return self.indexOf(value) === index;
    },

    prepareData: function() {
      console.log("prepare data");
      //this.tree = {'coucou': 1}
      this.dialogFormVisible = true;
      console.log(this.record)
      
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
      this.tree = {'coucou': 1}
      this.getOthersProducts();
      //this.getTree()
    },

    
    
    saveRecord: function() {

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.orderDate = Date.now()

      this.newRec._source.totalPrice = this.totalPrice.toFixed(2);
      this.newRec._source.totalBoulangerie = this.totalBoulangerie.toFixed(2)
      this.newRec._source.totalPatisserie = this.totalPatisserie.toFixed(2)
      this.newRec._source.totalOther = this.totalOther.toFixed(2)

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
    },
    handleTabClick: function(tab) {
      var index = parseInt(tab.name.substring(4));
      
      this.$store.commit({
        type: "setTab",
        data: this.$store.getters.currentApps.apps[index]
      });

      if (this.$store.getters.currentApps.apps[index].type == "kibana") {
        this.$globalbus.$emit(
          "kibanaactivated",
          this.$store.getters.currentApps.apps[index]
        );
      }
    },
    changeApp: function() {
      this.currentApps = null

      this.selectedTab = "TAB-0"

      this.$nextTick(() => {
        this.currentApps = JSON.parse(JSON.stringify(this.$store.getters.currentApps))
      });
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