<template>

  <div style="width: 100%">
  <el-row class="ordershopnew-container" style="width: 100%" >
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
          <!--div class="footer">
          Total TTC : {{totalPrice | roundTo2}} €
          <br><br>
          </div-->   
          
          <!--/el-tab-pane>

         </el-tabs-->
                </el-tab-pane>

      </el-tabs>
                </el-tab-pane>
      <el-tab-pane
          :key="'TAB-Panier'"
          :label="'Panier'"
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
              Total Panier: {{totalPrice | roundTo2 }}€ TTC
              
            </el-row>
            <el-row>
              <br><br>
                   <el-button type="primary" @click="onSubmit">Commander</el-button>
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
  name: "FormOrderShopNew",
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
      ts: 0,
      changed: false,
      dialogFormVisible: false,
      title: "Commande",
      selectedTab: "TAB-0",
      selectedUnderTab: "TAB-0-0",
      subCategories: {},
      subSubCategories: {}

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
  created: function() {
    this.ts = Date.now().toString();
    console.log('PREPARE')
    this.prepareData();
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
    onSubmit(){
      var order = {};
      var products = [];
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
        products.push(entry)
      }
      order.products = products
      order.dateOrder = moment()
      order.demandor = this.$store.getters.creds.user.id
      order.oldId = this.oldID
      order.newId = order.demandor +'_'+this.ts

      
      
      setTimeout(() => {
        axios.post(
          this.$store.getters.apiurl + "schamps/new_order?token="+this.$store.getters.creds.token, order
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
    },
    prepareData() {
      console.log('prepare data')
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
      this.getTree()
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
                  subCategories[i] = subCat
                  console.log(subSubCategories)
                }
                console.log("Categories : "  + cats)
                this.subCategories = subCategories
                this.subSubCategories = tree
                this.classement = cats
                console.log(this.subSubCategories)
            }
        });    
    },

    getData() {
      var demandor = this.$store.getters.creds.user.id          
      var url =
      this.$store.getters.apiurl +
      "schamps/check_order_new?demandor="+demandor+"&token=" + this.$store.getters.creds.token;  

      console.log('GET NEW LIST')

      
        
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
                }
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