<template>
  <div style="width: 100%">
  <el-row class="ordershop-container" style="width: 100%" >
      <el-form style="widht: 100%" :disabled="this.disabled">
        <el-table :data="this.records" style="width: 100%" >
          <el-table-column prop="_id" label="id"></el-table-column>
          <el-table-column prop="category" label="Categorie"></el-table-column>
          <el-table-column prop="name" label="Nom"></el-table-column>
          <el-table-column prop="old_code" label="Code"></el-table-column>
          <el-table-column prop="price_tvac" label="Prix TTC"></el-table-column>
          <el-table-column label="Quantité">
          <template slot-scope="scope">
            <el-input-number :min="0" size="mini" v-model="scope.row.quantity"/>
          </template>
          </el-table-column>
          <el-table-column label="Remarques">
            <template slot-scope="scope">
              <el-input type="textarea" v-model="scope.row.remarque"></el-input>
            </template>
          </el-table-column>
          <!--el-row v-for="item in this.records" :key="item._id" :span="24" class="row-record"-->


          <!--/el-row-->
          </el-table> 
          <el-button type="primary" @click="onSubmit">Commander</el-button>   
      </el-form>    
  </el-row>
    </div>
</template>
<script>
import Vue from "vue";
import moment,{ months } from "moment";
import axios from "axios";

export default {
  name: "FormOrderShop",
  data: () => ({
      records: null,
      oldID: null,
      disabled: false,
      category: '',
      categoryUp: '',
      ts: 0,

  }),
  props: {
    config: {
      type: Object
    }
  },
  created: function() {
    this.ts = Date.now().toString();
    var params = JSON.parse(this.config.config.controllerparameters);
    this.category = params.param1;
    this.categoryUp = params.param2
    this.prepareData();
  },
  methods: {
    onSubmit(){
      var order = {};
      var products = [];
      var entry = {};
      for(var itemKey in Object.keys(this.records)) {
        var item = this.records[itemKey]
        
        entry = {}
        entry._id = item._id
        entry.name = item.name
        entry.category = item.categoryID
        entry.code = item.old_code
        entry.quantity = item.quantity
        entry.remarque = item.remarque
        entry.price_tvac = item.price_tvac
        products.push(entry)
      }
      order.products = products
      order.dateOrder = moment()
      order.category = this.categoryUp
      order.categoryID = this.category
      order.demandor = this.$store.getters.creds.user.id
      order.oldId = this.oldID
      order.newId = order.category +'_'+this.ts

      
      
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
                duration: 2500
              });
              }
        })
        .catch((error)=> {
          console.log(error);
          
        });
      }, 3500)

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
      this.getData()
    },
    getData() {
      var demandor = this.$store.getters.creds.user.id          
      var url =
      this.$store.getters.apiurl +
      "schamps/check_order?demandor="+demandor+"&category="+this.categoryUp+"&token=" +
      this.$store.getters.creds.token;  

      
        
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
                    console.log(order)
                    for(var itemKey in order) {
                      console.log(order[itemKey])
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
      var url = this.$store.getters.apiurl + "generic_search/products_parameters?token=" + this.$store.getters.creds.token;
      var minutes = new Date().getMinutes();
      var hours = new Date().getHours();
      if(hours >= 18){
        this.disabled = true
      }
      else if(minutes >= 45 && hours==17){
        this.disabled = true
      }
      var query = {
            "size":900,
            "query": {
              "bool": {
                "must": [
                  {
                    "query_string": {
                      
                      "query": "categoryID: "+this.category
                    }
                  }
                ]
              }
            }
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
              console.log("Retrieved data : " + JSON.parse(JSON.stringify(response.data)))

              this.callData.push(response.data.records[i]._source)
            }

            
                var tmp = JSON.parse(JSON.stringify(this.callData))
                this.records = null
                this.records = JSON.parse(JSON.stringify(tmp))
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
</style>