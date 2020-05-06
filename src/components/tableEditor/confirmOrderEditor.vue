<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="confirm-order-editor"
  >
  
  Total TTC : {{totalPrice | roundTo2 }} €<br>
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <el-row class="ordershopnew-container" style="width: 100%" >
            {{tree}} - - - TOTO {{classement}} - {{subSubCategories}} - {{subCategories}} TOTO
            {{this.newRec._source}}

         <el-tabs v-model="selectedTab" @tab-click="tabChanged(selectedTab)">
          <el-tab-pane
          
          v-for="(category, index) in classement"
          :key="'TAB-'+index"
          :label="category"
          :name="'TAB-'+index"
          :lazy="true"
          
          
        >
        <el-tabs v-model="selectedUnderTab" @tab-click="subTabChanged()">
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
 
 </el-row>    



        <div style="bottom: 5%;">

            
        Total Sélection: {{ totalFiltered | roundTo2}}€  Total Panier TTC : {{totalPrice | roundTo2 }} €
        <!--el-table :data="records.filter(data => data.sortLvl1 == category && data.sortLvl2 == subcategory && data.sortLvl3 == filter1)" style="width: 100%"-->
        <el-table :data="records.filter(getFilter)" style="width: 100%">  
          <el-table-column prop="CODE" label="Code"></el-table-column>
          <el-table-column prop="Label" label="Nom"></el-table-column>
          <el-table-column label="Prix TTC">
            <template slot-scope="scope">
              {{scope.row.Prix_TVAC | roundTo2 }} €
            </template>
          </el-table-column>
          <el-table-column label="Quantité">
          <template slot-scope="scope">
            <el-input-number :min="0" size="mini" :disabled="!scope.row.Available" v-model="scope.row.quantity"/>
          </template>
          </el-table-column>
          <el-table-column label="Quantité en Commande">
          <template slot-scope="scope">
            <el-input-number :min="0" :max="scope.row.quantity" size="mini" :disabled="!scope.row.Available" v-model="scope.row.orderquantity"/>
          </template>
          </el-table-column>
          <el-table-column label="Total">
            <template slot-scope="scope">
              {{scope.row.quantity * scope.row.Prix_TVAC | roundTo2}} €
            </template>
          </el-table-column>
          <el-table-column label="Remarques">
            <template slot-scope="scope">
              <el-input type="textarea" v-model="scope.row.remarque"></el-input>
            </template>
          </el-table-column>
          </el-table> 
          </div>
          <br><br>
                </el-tab-pane>

      </el-tabs>
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
  name: "orderEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    tree: {},
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    changed: false,
    dialogFormVisible: false,
    title: "Commande",
    classement:[],
    filter1: '-',
    filter2: '-',
    filter3: '-',
    filter4: '-',
    filter5: '-',
    ts: 0,
    selectedTab: "TAB-0",
    selectedUnderTab: "TAB-0-0",
    subCategories: {},
    subSubCategories: {}

  }),
  computed: {
      totalPrice: function() {
      var price = 0

      if(this.records != null)
      {
        for(var itemKey in Object.keys(this.records))
        {
          var item = this.records[itemKey]
          price += (item.quantity*item.Prix_TVAC)
        }
        
      }
      return price
    },
     
    totalFiltered: function(){
      var filteredProducts = this.records
      var price = 0
      for(var itemKey in Object.keys(this.records))
      {
        var data = this.records[itemKey]
        var filter = data.sortLvl1 == this.selectedCategory && data.sortLvl2 == this.selectedSubCategory
        var filter1 = true
        var filter2 = true
        var filter3 = true
        var filter4 = true
        var filter5 = true
        

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
        
        if(filter && filter1 && filter2 && filter3 && filter4 && filter5)
        {
          price += (data.quantity*data.Prix_TVAC)
        }
        
      }
      
      return price
    },

    
    selectedCategory: function() {
      var index = this.selectedTab.split('-').pop()
      console.log(this.classement[index])
      return this.classement[index]
    },
    selectedSubCategory: function() {
      var index = this.selectedCategory
      var index1 = this.selectedUnderTab.split('-').pop()
      console.log('UnderTab Selected : ')
      console.log(this.subCategories[index][index1])
      return this.subCategories[index][index1]
    },
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
        this.getTree();;
      },
      deep: true
    }
  },
  created: function() {
    console.log("created event");
    this.getTree();
    this.prepareData();
    this.getTree();
  },
  components: {},
  methods: {
    totalCategoryQuantity: function(category) {
      var quantity = 0
      if(this.records != null)
      {
        for(var itemKey in Object.keys(this.records))
        {
          var item = this.records[itemKey]
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
      if(this.records != null)
      {
        
        for(var itemKey in Object.keys(this.records))
        {
          var item = this.records[itemKey]
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
      if(this.records != null)
      {
        for(var itemKey in Object.keys(this.records))
        {
          var item = this.records[itemKey]
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
      if(this.records != null)
      {
        
        for(var itemKey in Object.keys(this.records))
        {
          var item = this.records[itemKey]
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
        var filter = data.sortLvl1 == this.selectedCategory && data.sortLvl2 == this.selectedSubCategory
        var filter1 = true
        var filter2 = true
        var filter3 = true
        var filter4 = true
        var filter5 = true
        

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
        
        //data.sortLvl1 == category && data.sortLvl2 == subcategory
        return filter && filter1 && filter2 && filter3 && filter4 && filter5
    },
    tabChanged(index){
      this.selectedUnderTab = index+'-0'
      console.log('Selected:  TAB-'+index+'-0')
      this.filter1 = '-'
      this.filter2 = '-'
      this.filter3 = '-'
      this.filter4 = '-'
      this.filter5 = '-'
      //this.selectedUnderUnderTab = 'TAB-'+index+'-0-0'
    },
    subTabChanged(){
      this.filter1 = '-'
      this.filter2 = '-'
      this.filter3 = '-'
      this.filter4 = '-'
      this.filter5 = '-'
    },
    closeDialog: function() {
      this.$emit("dialogclose");
    },
    getTree: function() {
      var url =
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
                  
                  
                  subCategories[i] = subCat
                  console.log(subSubCategories)
                }
                console.log("Categories : "  + cats)
                this.subCategories = subCategories
                this.subSubCategories = tree
                this.classement = cats
                console.log(this.tree)
                
            }
        });    
    },
    prepareData: function() {
      console.log("prepare data");
      
      this.dialogFormVisible = true;
      console.log(this.record)
      this.getTree();
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
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