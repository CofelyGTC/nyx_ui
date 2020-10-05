<template>

  <div style="width: 100%">
  <el-row class="unsalesoffice-container" style="width: 100%" >
    Sélectionnez un magasin: 
    <el-row style="width: 100%">
        <el-select @change="changeShop" filterable v-model="magasin" placeholder="Sélectionner">
              <el-option
                v-for="(item, id) in magasins"
                :key="id"
                :label="item"
                :value="item">
              </el-option>
            </el-select>
    </el-row>
            <br>
            
      <el-form style="widht: 100%" :disabled="this.disabled">
          
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
              Avec/Sans Crème Fraiche:
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
 
 </el-row>    



        <div style="bottom: 5%;">

            
        Total Sélection: {{ totalFiltered | roundTo2}}€  Total Panier TTC : {{totalPrice | roundTo2 }} €
        
        <el-table :data="records.filter(getFilter)" style="width: 100%;height: calc(100vh - 225px); overflow: auto;" :default-sort = "{prop: 'CODE', order: 'ascending'}" height="750">  
          <el-table-column prop="CODE" label="Code" sortable></el-table-column>
          <el-table-column prop="Label" label="Nom" sortable></el-table-column>
          <el-table-column label="Prix TTC" sortable>
            <template slot-scope="scope">
              {{scope.row.Prix_TVAC | roundTo2 }} €
            </template>
          </el-table-column>
          <el-table-column label="Quantité Invendus" width="150" sortable>
          <template slot-scope="scope">
            <el-input-number :min="0" size="mini" v-model="scope.row.quantity"/>
          </template>
          </el-table-column>
          <el-table-column label="Total" sortable>
            <template slot-scope="scope">
              {{scope.row.quantity * scope.row.Prix_TVAC | roundTo2}} €
            </template>
          </el-table-column>
          </el-table> 
          </div>
          <br><br>
 
          

                </el-tab-pane>

      </el-tabs>
                </el-tab-pane>
      <el-tab-pane
          :key="'TAB-Panier'"
          :label="'Total'"
          :name="'TAB-Panier'"
          :lazy="true">
          
            Sous-Total :
            <el-row 
            v-for="(category, index) in classement" :key="index">
            <h1>{{category}}: Quantité totale: {{totalCategoryQuantity(category) | roundTo2 }} Total TTC: {{totalCategoryPrice(category) | roundTo2}}€</h1>
            <el-row v-for="(subCategory, index1) in subCategories[category]" :key="index1">
                {{subCategory}}: Quantité totale: {{totalSubCategoryQuantity(category, subCategory) | roundTo2 }} Total TTC: {{totalSubCategoryPrice(category, subCategory) | roundTo2}}€
                </el-row>
            </el-row>
            <el-row>
              Total Invendus: {{totalPrice | roundTo2 }}€ TTC
              
            </el-row>
            <el-row>
              <br><br>
                   <el-button type="primary" @click="onSubmit">Enregistrer</el-button>
            </el-row>
      </el-tab-pane>


      </el-tabs>
      </el-form> 
  </el-row>
  
    </div>
    
</template>
<script>
import Vue from "vue";
import moment,{ months } from "moment";
import axios from "axios";

export default {
  name: "FormUnsalesOffice",
  data: () => ({
      records: null,
      oldID: null,
      disabled: false,
      category: '',
      categoryUp: '',
      search: '',
      classement:[],
      filter1: '-',
      filter2: '-',
      filter3: '-',
      filter4: '-',
      filter5: '-',
      filter6: '-',
      filter7: '-',
      filter8: '-',
      magasin: '',
      magasins: [],
      ts: 0,
      changed: false,
      dialogFormVisible: false,
      title: "Commande",
      selectedTab: "TAB-0",
      selectedUnderTab: "TAB-0-0",
      subCategories: {},
      subSubCategories: {},

  }),
  props: {
    config: {
      type: Object
    }
  },
  filters: {
      roundTo2: function(value){
        return value.toFixed(2);
      }
  },
  mounted: function() {
    //this.getMagasin();
    //this.getTree();
    this.ts = Date.now().toString();
    this.magasin = this.$store.getters.actualShop;
    this.selectedTab = this.$store.getters.actualLvl1;
    this.selectedUnderTab = this.$store.getters.actualLvl2;
    //this.prepareData();
  },
  created: function() {

    document.onkeydown=function(e){
      var key=window.event.keyCode;
      console.log('Key released : ' + key.toString())
      }
    document.onkeyup=function(e){
        var key=window.event.keyCode;
        console.log('Key Up: ' + key.toString())
      }

    console.log("CREATED")
    this.getMagasins();
    this.getTree();
    this.ts = Date.now().toString();

    this.$globalbus.$on("timerangechanged", payLoad => {
      console.log("GLOBALBUS/GENERICTABLE/TIMERANGECHANGED");
      console.log(this.config.timeSelectorType);
      console.log(payLoad.subtype);
      if (this.config.timeSelectorType == undefined)
        this.config.timeSelectorType = "classic";
      if (payLoad.subtype == this.config.timeSelectorType){ 
        console.log('timechanged')
        this.loadData();
        }
      else 
      {
          console.log("Ignoring time change...");
          console.log(payLoad.subtype);
          console.log(this.config.timeSelectorType);
          console.log('test');

      }
    });
    this.magasin = this.$store.getters.actualShop;
    console.log('PREPARE')
    //this.prepareData();
  },
  beforeDestroy: function(){
      console.log('BEFORE DESTROY')
      this.onSubmit();
  },
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
    }
  },
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
    refillNan(){
      for(var itemKey in Object.keys(this.records)) {
          var item = this.records[itemKey]
          if(item.quantity == null)
          {
            item.quantity = 0
          }
          if(item.orderquantity)
          {
            item.orderquantity = 0
          }
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
        return filter && filter1 && filter2 && filter3 && filter4 && filter5 && filter6 && filter7 && filter8
    },
    tabChanged(index){
      this.refillNan()
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
      this.$store.commit({
        type: "setActualLvl1",
        data: this.selectedTab
      });
      //this.selectedUnderUnderTab = 'TAB-'+index+'-0-0'
    },
    subTabChanged(){
      this.refillNan()
      this.filter1 = '-'
      this.filter2 = '-'
      this.filter3 = '-'
      this.filter4 = '-'
      this.filter5 = '-'
      this.filter6 = '-'
      this.filter7 = '-'
      this.filter8 = '-'
      this.$store.commit({
        type: "setActualLvl2",
        data: this.selectedUnderTab
      });
    },
    changeShop(){
      console.log("CHANGE SHOP")
      //this.magasin = magasin
      console.log("SHOP: " + this.magasin)
      this.$store.commit({
        type: "setActualShop",
        data: this.magasin
      });
      console.log('TESTESTEST')
      console.log(this.$store.getters.actualShop)
      this.prepareData();
    },
    onSubmit(){
      if(this.magasin != '-')
      {  
        this.refillNan()
        var order = {};
        var products = [];
        var timeRange=this.$store.getters.timeRangeDay;
        var entry = {};
        for(var itemKey in Object.keys(this.records)) {
          var item = this.records[itemKey]
          
          entry = item
          /*entry._id = item._id
          entry.name = item.name
          entry.category = item.categoryID
          entry.code = item.old_code
          entry.quantity = item.quantity
          entry.orderquantity = item.orderquantity
          entry.size = item.size
          entry.remarque = item.remarque
          entry.price_tvac = item.price_tvac
          entry.available = item.available*/
          //console.log(entry.CODE + '-'+entry.HTVA)
          if(typeof entry.HTVA == "string")
          {
            console.log(entry.CODE)
            console.log(entry.HTVA)
            entry.HTVA = parseFloat(entry.HTVA)
            console.log(entry.HTVA)
          }
          if(typeof entry.TVA == "string")
          {
            console.log(entry.CODE)
            console.log(entry.TVA)
            entry.TVA = parseFloat(entry.TVA)
            console.log(entry.TVA)
          }
          products.push(entry)
          
        }
        order.shop = this.magasin
        order.products = products
        order.dateOrder = timeRange[0].getTime();
        order.demandor = this.$store.getters.creds.user.id
        order.oldId = this.oldID
        order.newId = this.magasin +'_'+timeRange[0].getTime().toString();
        order.remise = this.remise
        order.totalBoulangerie = this.totalBoulangerie().toFixed(2)
        order.totalPatisserie = this.totalPatisserie().toFixed(2)
        order.totalOther = this.totalOther().toFixed(2)
        order.totalPrice = this.totalPrice.toFixed(2)
        //order.invendus = this.invendus
        //order.supplement = this.supplement
        //order.remisePat = this.remisePat
        //order.invendusPat = this.invendusPat
        //order.supplementPat = this.supplementPat
        
        
        
        setTimeout(() => {
          axios.post(
            this.$store.getters.apiurl + "schamps/new_unsales?token="+this.$store.getters.creds.token, order
            ).then((response) => {
              if(response.data.error!="")
                {
                  this.$notify({ 
                  title: "Error",
                  message: "Commande en " +this.categoryUp + " a echoué, veuillez recharger la page et réessayer",
                  type: "error",
                  position: "bottom-right",
                  duration: 1500});
                  }
              else
                {
                  this.$notify({ 
                  title: "Success",
                  message: "Commande en " +this.categoryUp + " envoyée !",
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

        console.log('Sending Command')
        }
        else
        {
          console.log('No data To send')
        }
    },
    prepareData() {
      console.log('prepare data')
      this.magasin = this.$store.getters.actualShop;
      for(var i in this.$store.getters.creds.user.privileges) {
        var priv = this.$store.getters.creds.user.privileges[i]
        if(priv =='admin' ||  priv=='SHOP_FORM') {
          this.writeAccess = true
        }
      }
      this.monthSelected = moment()
      this.dateSelected()
    },
    changeApp: function() {
      this.currentApps = null

      this.selectedTab = "TAB-0"

      this.$nextTick(() => {
        this.currentApps = JSON.parse(JSON.stringify(this.$store.getters.currentApps))
      });
    },
    loadData(){
        this.records = [];
        this.getData();
    },
    dateSelected() {
      
      if(this.monthSelected == null)
        this.monthSelected = moment()

      if(moment().format('D') >= 14) {
        this.disable = (moment() > moment(this.monthSelected).endOf('Month'))
      }
      else {
        this.disable = (moment().subtract(1, 'months') > moment(this.monthSelected).endOf('Month'))
      }
        
      this.strPeriod = moment(this.monthSelected).startOf('Month').format('DD MMM YYYY')+' to '+moment(this.monthSelected).endOf('Month').format('DD MMM YYYY')
      //this.getTree()
      this.getData()
      //this.createNewForm();
    },
    getTree() {
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
                    /*var subSubCat = []
                    for(var k in tree[i][j])
                    {
                      subSubCat.push(k)
                    }
                    
                    subSubCategories[i][j] = subSubCat*/
                  }
                  //var obj = {i : subCat}
                  subCategories[i] = subCat.sort();
                  console.log(subSubCategories)
                }
                console.log("Categories : "  + cats)
                this.subCategories = subCategories
                this.subSubCategories = tree
                this.classement = cats.sort();
                console.log(this.subSubCategories)
            }
        });    
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
    totalPatisserie: function(){

      var price = 0
      var products = this.records
      for(var itemKey in Object.keys(this.records))
      {
        var data = this.records[itemKey]
        if(data.sortLvl1 == 'Pâtisserie')
        {
          price += (data.quantity*data.Prix_TVAC)
        }
      }

      return price

    },

    totalBoulangerie: function(){

      var price = 0
      var products = this.records
      for(var itemKey in Object.keys(this.records))
      {
        var data = this.records[itemKey]
        if(data.sortLvl1 == 'Boulangerie')
        {
          price += (data.quantity*data.Prix_TVAC)
        }
      }

      return price

    },

    totalOther: function(){

      var price = 0
      var products = this.records
      for(var itemKey in Object.keys(this.records))
      {
        var data = this.records[itemKey]
        if(data.sortLvl1 != 'Pâtisserie' && data.sortLvl1 != 'Boulangerie')
        {
          price += (data.quantity*data.Prix_TVAC)
        }
      }

      return price

    },

    getData() {
      var demandor = this.$store.getters.creds.user.id  
      var timeRange=this.$store.getters.timeRangeDay;
      console.log(this.$store.getters.timeRangeDay)
      var magasin = this.magasin 
      console.log("MAGASIN : " + this.magasin)     
      var url =
      this.$store.getters.apiurl +
      "schamps/check_unsales?shop="+magasin+"&demandor="+demandor+"&start="+timeRange[0].getTime()+"&stop="+timeRange[1].getTime()+"&token=" + this.$store.getters.creds.token;  

      console.log('GET NEW LIST')
      //this.createNewForm();
      //this.$forceUpdate();
        
      axios
        .get(url, demandor)
        .then((response) => {
            if(response.data.error!="")
            console.log("Order Shops Calls list error...");
            else{
                var res = JSON.parse(response.data.data)
                console.log(res)
                
                if(res.reccords.length == 0)
                {
                    console.log("No reccord")
                    this.createNewForm();
                }
                else{
                    var order = res.reccords[0]['_source']['products']
                    console.log("list order")
                    
                    for(var itemKey in order) {
                      
                      order[itemKey].old_code = order[itemKey].code
                      delete order[itemKey].code
                    }
                    var oldId = res.reccords[0]['_id']
                    this.oldID = oldId
                    this.records = order
                    this.disabled = res.reccords[0]['_source']['confirmed']  
                    //this.remise = res.reccords[0]['_source']['remise']
                    //this.invendus = res.reccords[0]['_source']['invendus']
                    //this.supplement = res.reccords[0]['_source']['supplement']
                }
                this.$forceUpdate();
            }
        }); 
    },



    

      
    createNewForm(){
      console.log('Generate Empty Form')
      var url = this.$store.getters.apiurl + "generic_search/products_parameters_new?token=" + this.$store.getters.creds.token;
      var minutes = new Date().getMinutes();
      var hours = new Date().getHours();
      if(hours >= 18){
        this.disabled = true
      }
      else if(minutes >= 45 && hours==17){
        this.disabled = true
      }
      this.disabled = false
      var query = {
            "size":900
        }
       console.log(query)

      axios
        .post(url, query)
        .then((response) => {
          if(response.data.error!="")
            console.log("Order Shops Calls list error...");
          else
          {
            this.callData=[]
            console.log(response)
            for(var i in response.data.records) {
              response.data.records[i]._source._id = response.data.records[i]._id 
              response.data.records[i]._source.quantity = 0
              response.data.records[i]._source.orderquantity = 0
              console.log("Retrieved data : " + JSON.parse(JSON.stringify(response.data)))

              this.callData.push(response.data.records[i]._source)
            }

            
                var tmp = JSON.parse(JSON.stringify(this.callData))
                this.records = null
                this.records = JSON.parse(JSON.stringify(tmp))

                console.log(this.records)
                this.$forceUpdate();
          }});

          },

   
   setTableCurrent(row) {
      this.$refs.callTable.setCurrentRow(row);
    },
    handleTableSelect(val) {
      if(this.disable)
        return

      if(val == null)
        return

      this.dialogVisible = true
      this.dialogType = 'modif'
      this.currentRow = val;
      this.dialogTitle   = 'Ticket '+val.number

      this.dialogObj = JSON.parse(JSON.stringify(this.currentRow))

      for(var j in this.lotModel) {
        if(this.lotModel[j].value == this.dialogObj.lot)
          this.dialogObj.lot = this.lotModel[j].label
      }

      this.setTableCurrent()
    },
    addCall() {
      this.dialogObj = {
        datetime: moment(),
        number: '',
      }
      this.dialogType = 'creation'
      this.dialogTitle   = 'Nieuwe oproep'
      this.dialogVisible = true

    },
    clickDialogDelete() {

      this.$confirm(
        "This will permanently delete the call. Continue?",
        "Warning",
        {
          confirmButtonText: "OK",
          cancelButtonText: "Cancel",
          type: "warning"
        })
        .then(() => {
          this.deleteLoading = true
          var delRec = {
            _id: this.currentRow._id,
            _index: 'biac_kpi101_call',
            _doc: 'doc'
          }
    
          this.$store.commit({
            type: "deleteRecord",
            data: delRec
          });
    
    
          setTimeout(() => { 
            this.getData()
            this.dialogVisible = false   
            this.deleteLoading = false
            
            this.$notify({
              title: "Success",
              message: "call "+this.currentRow.number+" has been deleted",
              type: "success",
              position: "bottom-right"
            });
    
          }, 500);
    
          setTimeout(() => this.getData(), 1500)

          setTimeout(() => {
            console.log('**************************************')
            console.log(moment(this.monthSelected).format('YYYY-MM-DD'))
            
            axios.post(
              this.$store.getters.apiurl + "biac/kpi101_monthly?token="+this.$store.getters.creds.token,
                { 'month_to_update': moment(this.monthSelected).format('YYYY-MM-DD') }
              ).then((response) => {
                if(response.data.error!="")
                  console.log("KPI104 update monthly error");
                else {
                  console.log("KPI104 update monthly success");
                  console.log(response)
                }
            })
            .catch((error)=> {
              console.log(error);
            });
          }, 2500)
        })
    },
    clickDialogModify() {
      this.loading = true
      this.$refs['formCall'].validate((valid) => {
        if (valid) {
          var id = this.dialogObj._id
          delete this.dialogObj._id
          delete this.dialogObj.hour
          delete this.dialogObj.date

          try {
            delete this.dialogObj.madeBy
            delete this.dialogObj.phoneNumber
          }
          catch {
            console.log("Error")
          }
          
          for(var j in this.lotModel) {
            if(this.lotModel[j].label == this.dialogObj.lot)
              this.dialogObj.lot = this.lotModel[j].value
          }

          var newRec = {
            _id: id,
            _index: "biac_kpi101_call",
            isadd:false,
            _type: "doc",

            _source: this.dialogObj
          }

          this.$store.commit({
            type: "updateRecord",
            data: newRec
          });

          this.currentMonth = moment(this.monthSelected)
          this.targetMonth  = moment(newRec._source.datetime)

          console.log('currentMonth: ' + this.currentMonth.format('YYYY-MM-DD'))
          console.log(' targetMonth: ' + this.targetMonth.format('YYYY-MM-DD'))

          setTimeout(() => { 
            this.getData()
            this.dialogVisible = false
            this.loading = false
            this.$notify({
              title: "Success",
              message: "call "+newRec._source.number+" has been modified",
              type: "success",
              position: "bottom-right"
            });
            this.currentRow = null

          }, 500);

          setTimeout( () => this.getData(), 1500)

          
          setTimeout(() => {
            console.log('******************target month********************')
            console.log(this.targetMonth.format('YYYY-MM-DD'))
            
            axios.post(
              this.$store.getters.apiurl + "biac/kpi101_monthly?token="+this.$store.getters.creds.token,
                { 'month_to_update': this.targetMonth.format('YYYY-MM-DD') }
              ).then((response) => {
                if(response.data.error!="")
                  console.log("KPI104 update monthly error");
                else {
                  console.log("KPI104 update monthly success");
                  console.log(response)
                }
            })
            .catch((error)=> {
              console.log(error);
              
            });
          }, 2500)


          if(this.targetMonth != this.currentMonth) {
            setTimeout(() => {
              console.log('***************current month***********************')
              console.log(this.currentMonth.format('YYYY-MM-DD'))
              
              axios.post(
                this.$store.getters.apiurl + "biac/kpi101_monthly?token="+this.$store.getters.creds.token,
                  { 'month_to_update': this.currentMonth.format('YYYY-MM-DD') }
                ).then((response) => {
                  if(response.data.error!="")
                    console.log("KPI104 update monthly error");
                  else {
                    console.log("KPI104 update monthly success");
                    console.log(response)
                  }
              })
              .catch((error)=> {
                console.log(error);
                
              });
            }, 2500)
          }
        } 
        else {
          this.loading = false
          console.log('error submit!!');
          return false;
        }
      });
    },
    clickDialogCreate() {
      this.loading = true
      this.$refs['formCall'].validate((valid) => {
        if (valid) {
          
          for(var j in this.lotModel) {
            if(this.lotModel[j].label == this.dialogObj.lot)
              this.dialogObj.lot = this.lotModel[j].value
          }

          var newRec = {
            _id: "id_" + Math.floor((1 + Math.random()) * 0x1000000),
            _index: "biac_kpi101_call",
            isadd:true,
            _type: "doc",

            _source: this.dialogObj
          }

          console.log(newRec)

          this.$store.commit({
            type: "updateRecord",
            data: newRec
          });


          this.currentMonth = moment(this.monthSelected)
          this.targetMonth  = moment(newRec._source.datetime)

          console.log('currentMonth: ' + this.currentMonth.format('YYYY-MM-DD'))
          console.log(' targetMonth: ' + this.targetMonth.format('YYYY-MM-DD'))

          setTimeout(function() { 
            this.getData()
            this.dialogVisible = false
            this.loading = false
            this.$notify({
              title: "Success",
              message: "call "+newRec._source.number+" has been CREATED",
              type: "success",
              position: "bottom-right"
            });
            this.currentRow = null

          }.bind(this), 500);

          setTimeout( () => this.getData(), 1500)


          this.targetMonth = moment(newRec._source.datetime)
          
          
          setTimeout(() => {
            console.log('******************target month********************')
            console.log(this.targetMonth.format('YYYY-MM-DD'))
            
            axios.post(
              this.$store.getters.apiurl + "biac/kpi101_monthly?token="+this.$store.getters.creds.token,
                { 'month_to_update': this.targetMonth.format('YYYY-MM-DD') }
              ).then((response) => {
                if(response.data.error!="")
                  console.log("KPI104 update monthly error");
                else {
                  console.log("KPI104 update monthly success");
                  console.log(response)
                }
            })
            .catch((error)=> {
              console.log(error);
            });
          }, 2500)

          if(this.targetMonth != this.currentMonth) {
            setTimeout(() => {
              console.log('***************current month***********************')
              console.log(this.currentMonth.format('YYYY-MM-DD'))
              
              axios.post(
                this.$store.getters.apiurl + "biac/kpi101_monthly?token="+this.$store.getters.creds.token,
                  { 'month_to_update': this.currentMonth.format('YYYY-MM-DD') }
                ).then((response) => {
                  if(response.data.error!="")
                    console.log("KPI104 update monthly error");
                  else {
                    console.log("KPI104 update monthly success");
                    console.log(response)
                  }
              })
              .catch((error)=> {
                console.log(error);
              });
            }, 2500)
          }
        } 
        else {
          console.log('error submit!!');
          return false;
        }
      });
    },
    updateTimeRange() {
      const start = new Date();
      console.log('coucou');
      start.setTime(this.$refs.generic.chart.series.w.globals.minX);
      this.$globalbus.$emit("charttimerangeupdated", [
        this.$refs.generic.chart.series.w.globals.minX,
        this.$refs.generic.chart.series.w.globals.maxX
      ]);
    }

  }
};

</script>
<style>
.ordershop-container{
  width: 100%;
  margin: 30px 0px;
  
}
.box-card {
  width: 800px !important;
}

.first-row{
  margin: 10px;
}
.second-row{
  margin: 20px 10px;
}
.third-row{
  margin: 20px 10px;
}
.forth-row{
  margin: 20px 10px;
}

.table-disable {
  cursor: not-allowed;
}
.footer {
  position: fixed;
  left: 0;
  bottom: 1%;
  width: 100%;
  text-align: center;
}
</style>