<template>
  <div style="width: 100%">
      <span v-if="dialogFormVisible">
      <PanierViewer
        :record="currentRecord"
        :config="config"    
        v-on:dialogclose="dialogFormVisible=false"
      ></PanierViewer>
    </span>
  <el-row class="ordershop-container" style="width: 100%" >
      <el-form style="widht: 100%" :disabled="this.disabled">
        <div style="bottom: 5%;">
        Total TTC : {{totalPrice | roundTo2 }} €
        <el-table :data="this.records" style="width: 100%" >
          
          <el-table-column prop="category" label="Catégorie"></el-table-column>
          <el-table-column label="Total TTC (€)">
            <template slot-scope="scope">
              {{scope.row.totPrice | roundTo2}}

            </template>
          </el-table-column>
          <el-table-column label="Détail" align="right">
             <template slot-scope="scope">
              <el-button
                size="mini"
                plain
                icon="el-icon-view"
                @click="handleView(scope.$index, scope.row)"
              ></el-button>
             </template>
          </el-table-column>
          
          
          </el-table>
          </div>   
      </el-form> 
  </el-row>
  <el-row>
      <el-button type="primary" @click="refreshData">Refresh</el-button>
  </el-row>
    </div>
</template>
<script>
import Vue from "vue";
import moment,{ months } from "moment";
import axios from "axios";
import panierviewer from "@/components/tableEditor/PanierViewer";

const req = require.context("../../components/tableEditor/", true, /\.vue$/);

Vue.component("PanierViewer", panierviewer);

export default {
  name: "ResumeOrderShop",
  data: () => ({
      records: null,
      currentRecord: { original: {} },
      editMode: null,
      oldID: null,
      disabled: false,
      loadOnEdit: true,
      totalPrice: 0,
      dialogFormVisible: false,
      category: '',
      categoryUp: '',
      search: '',
      ts: 0,

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
    this.prepareData();
  },
  computed: {

  },
  methods: {

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
      "schamps/check_resume_order?demandor="+demandor+"&token=" + this.$store.getters.creds.token; 

      console.log(url)

      axios
        .get(url, demandor)
        .then((response) => {
            if(response.data.error!="")
            console.log("Order Shops Calls list error...");
            else{
                console.log(response.data.data)
                var res = JSON.parse(response.data.data)
                console.log(res)
                
                if(res.reccords.length == 0)
                {
                    console.log("No reccord")
                    
                }
                else{

                    var callData=[]
                    this.totalPrice = 0

                    for(var key in res.reccords)
                    {
                        var newRec = res.reccords[key]['_source'];
                        newRec['_id'] = res.reccords[key]['_id'];
                        newRec['_index'] = res.reccords[key]['_index'];
                        newRec['_type'] = res.reccords[key]['_type'];
                        var subTotPrice = 0
                        var subQuantity = 0
                        var products = newRec['products']
                        for(var index in products)
                        {
                            subQuantity += products[index]['quantity']
                            
                            var subTot = products[index]['quantity'] * products[index]['price_tvac']
                            subTotPrice += subTot
                        }
                        newRec['totPrice'] = subTotPrice
                        newRec['totQuantity'] = subQuantity
                        this.totalPrice += subTotPrice
                        callData.push(newRec);
                    }

                    var tmp = JSON.parse(JSON.stringify(callData))
                    this.records = null
                    this.records = JSON.parse(JSON.stringify(tmp))
                    console.log("Records added")
                    console.log(this.records)
                }
            }
        });  
    },

    refreshData: function() {
      
      this.getData();
    },
    
    handleView(index, row) {
      this.currentRecord = {}; // required by the detail watcher
      this.editMode = "edit";
      console.log('coucou')

      if(this.loadOnEdit) {
        this.getRecordFromRow(row)
        .then(response => {
          this.currentRecord = response;
          console.log(this.currentRecord)
          this.dialogFormVisible = true;
        })
        .catch(error => {
          this.currentRecord = response;
          this.dialogFormVisible = true;
          console.log(error);
        });
      }
      else {
        this.currentRecord = row;
        this.dialogFormVisible = true;
      }
    },
    async getRecordFromRow(row) {
      console.log('getRecordFromRow')
      console.log(row)
      try {
        var url =
        this.$store.getters.apiurl +
        "generic/"+row._index+"/" +
        row._id +
        "?token=" +
        this.$store.getters.creds.token +
        "&doc_type="+row._type;
      
        const response = await axios.get(url);

        console.log(response)

        if (response.status == 200) {
          console.warn("fail to retrieve the document, returning the parameters");
          return row
          
        } else {
          let updatedRecord = JSON.parse(JSON.stringify(response.data.data));
          updatedRecord.original = JSON.parse(
            JSON.stringify(response.data.data)
          );

          return updatedRecord
        }
      } catch (e) {
        console.error(e);
        return row;
      }


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
          }, 1000)

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