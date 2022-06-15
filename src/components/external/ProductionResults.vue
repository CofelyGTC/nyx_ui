<template>
  <div style="width: 100%">
  <el-row class="productionresults-container" style="width: 100%" >
      <el-form style="widht: 100%" :disabled="this.disabled">
        <el-table 
          :data="records.filter(data => !search || ((JSON.stringify(data).toLowerCase().includes(search.toLowerCase()))))"
          :default-sort="{prop: 'CODE', order: 'descending'}" style="width: 100%" >
          <el-table-column prop="CODE" label="CODE" sortable></el-table-column>
          <el-table-column prop="sortLvl1" label="Catégorie" sortable></el-table-column>
          <el-table-column prop="sortLvl2" label="Sous-Catégorie" sortable></el-table-column>
          <el-table-column prop="Label" label="Nom" sortable></el-table-column>
          <el-table-column prop="confirmed" label="Confirmé">
            <template slot-scope="scope">
            <el-switch v-model="scope.row.confirmed" @change="recordConfirmed(scope.row)"></el-switch>
            </template>
          </el-table-column>
          <el-table-column prop="originalquantity" label="Quantité Demandée" sortable>
          </el-table-column>
          <el-table-column label="Quantité Produite">
          <template slot-scope="scope">
            <el-input-number :disabled="scope.row.confirmed" :min="0" size="mini" v-model="scope.row.quantity" @changed="recordModify(scope.row)"/>
          </template>
          </el-table-column>
          <el-table-column align="right" width="150">
            <template slot="header" slot-scope="scope">
              <el-input v-model="search" size="mini" placeholder="Type to search" class="searchfield" />
            </template>
          </el-table-column>
          </el-table> 
      </el-form>    
  </el-row>
    </div>
</template>
<script>
import Vue from "vue";
import moment,{ months } from "moment";
import axios from "axios";

export default {
  name: "ProductionResults",
  data: () => ({
      records: null,
      oldID: null,
      disabled: false,
      category: '',
      categoryUp: '',
      ts: 0,
      params: {},
      search: "",

  }),
  props: {
    config: {
      type: Object
    }
  },
  created: function() {
    this.ts = Date.now().toString();
    this.$globalbus.$on("timerangechanged", payLoad => {
      console.log("GLOBALBUS/GENERICTABLE/TIMERANGECHANGED");
      console.log(this.config.timeSelectorType);
      console.log(payLoad.subtype);
      if (this.config.timeSelectorType == undefined)
        this.config.timeSelectorType = "classic";
      if (payLoad.subtype == this.config.timeSelectorType) this.loadData();
      else console.log("Ignoring time change.");
    });
    this.prepareData();
  },
  methods: {
    prepareData() {
      console.log('prepare data')
      this.params = JSON.parse(this.$store.getters.activeApp.config.controllerparameters)
      console.log(this.params)
      for(var i in this.$store.getters.creds.user.privileges) {
        var priv = this.$store.getters.creds.user.privileges[i]
        if(priv =='admin' ||  priv=='SHOP_FORM') {
          this.writeAccess = true
        }
      }
      //this.monthSelected = moment()
      //this.dateSelected()
      this.getData();
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
      this.getData()
    },
    getData() {
      var demandor = this.$store.getters.creds.user.id 
      var timeRange=this.$store.getters.timeRangeDay;
      var url =
      this.$store.getters.apiurl +
      "schamps/getProductionResult?start="+timeRange[0].getTime()+"&stop="+timeRange[1].getTime()+"&filter="+this.params.production+"&token=" +
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
                    //this.createNewForm();
                }
                else{
                    var orders = res.reccords
                    var records = []
                    console.log("list order test")
                    console.log(orders)
                    for(var itemKey in orders) {
                      var obj = {}
                      obj = orders[itemKey]._source
                      obj._id = orders[itemKey]._id
                      if(obj.originalquantity > 0)
                      {
                        records.push(obj)
                      }
                    }
                    this.records = records
                     
                }
            }
        });  
    },
    
    recordConfirmed(row)
    {
        var _id = row._id;
        var products = {};
        var cats = {};

        cats.code = row.code;
        cats.category = row.category;
        cats.name = row.name;
        cats.quantity = row.quantity;
        cats.remarque = row.remarque;
        cats['@timestamp'] = row['@timestamp'];
        cats.confirmed = row.confirmed;
        cats.originalquantity = row.originalquantity;

        products._id = _id
        products._record = cats
        var body = {}
        body.destination = "/queue/PRODUCTION_RESULT_UPDATE";
        body.body = JSON.stringify(products);


        setTimeout(() => {
        axios.post(
          this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
          ).then((response) => {
            if(response.data.error!="")
              {
                this.$notify({ 
                title: "Error",
                message: "Failed To Update Message",
                type: "error",
                position: "bottom-right",
                duration: 1500});
                }
            else
              {
                this.$notify({ 
                title: "Success",
                message: "Update Send !",
                type: "success",
                position: "bottom-right",
                duration: 2500
              });
              }
        })
        .catch((error)=> {
          console.log(error);
          
        });
      }, 1000)

      console.log('Sending Command')
    },

    recordModify(row)
    {
      this.recordConfirmed(row);
    },

   setTableCurrent(row) {
      this.$refs.callTable.setCurrentRow(row);
    },
    updateTimeRange() {
      const start = new Date();
      console.log('coucou');
      start.setTime(this.$refs.generic.chart.series.w.globals.minX);
      this.$globalbus.$emit("charttimerangeupdated", [
        this.$refs.generic.chart.series.w.globals.minX,
        this.$refs.generic.chart.series.w.globals.maxX
      ]);
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
.searchfield {
  width: 140px !important;
}
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