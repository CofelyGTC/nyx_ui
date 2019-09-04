<template>
<div>
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="80%">
        <el-form style="text-align:left" :model="dialogObj" :buildings="buildings" :floors="floors" :orgmodel="orgModel"  :disable="disable" v-if="dialogVisible" ref="formCall">
 
            

              <el-form-item
                  label="Datum van spotcheck"
                  :label-width="formLabelWidth">
                <el-date-picker
                  :disabled="disable"
                  v-model="dialogObj.datetimestart"
                  :picker-options={firstDayOfWeek:1}
                  type="datetime"
                  size="mini"
                  placeholder="Select date and time">
                </el-date-picker>
              </el-form-item>


               <el-form-item
                  label="Gebouw"
                  :label-width="formLabelWidth">
                <el-select size="mini" v-model="dialogObj.building" 
                  :disabled="disable"
                  placeholder="Select"
                  @change="building_changed">
                    <el-option
                      v-for="item in buildings"
                      :key="item.building"
                      :label="item.building"
                      :value="item.building">
                    </el-option>
                  </el-select>
              </el-form-item>

              <el-form-item
                  label="Verdieping"
                  :label-width="formLabelWidth">
                <el-select size="mini" v-model="dialogObj.floor" 
                  :disabled="disable"
                  placeholder="Select"
                  >
                    <el-option
                      v-for="item in floors"
                      :key="item"
                      :label="item"
                      :value="item">
                    </el-option>
                  </el-select>
              </el-form-item>


            <el-form-item
                  label="Uitleg "
                  :label-width="formLabelWidth">
                <el-input 
                
                  style="max-width:620px;"
                  v-model="dialogObj.desc" 
                  :controls="false"
                  size="mini"></el-input>
              </el-form-item>


              <el-form-item
                  label="Resultaat "
                  :label-width="formLabelWidth">
                                    
                   <el-select size="mini" v-model="dialogObj.conform" 
                    :disabled="disable"
                    placeholder="Select">
                      <el-option key="1"
                        label="Conform"
                        :value="true" >                       
                      </el-option>
                      <el-option key="0"
                        label="Niet Conform"
                        :value="false" >                       
                      </el-option>
                    </el-select>
              </el-form-item> 
                      
             <el-form-item v-if="!dialogObj.conform"
                  label="Datum van resolutie"
                  :label-width="formLabelWidth">
                <el-date-picker
                  :disabled="disable"
                  v-model="dialogObj.datetimeend"
                  :picker-options={firstDayOfWeek:1}
                  type="datetime"
                  size="mini"
                  placeholder="Select date and time">
                </el-date-picker>
              </el-form-item>

        </el-form>
        
        <span slot="footer" class="dialog-footer">
          
          <el-button 
            type="default" 
            plain 
            size="small" 
            @click="dialogVisible = false">Cancel</el-button>
          <el-button 
            v-if="dialogType=='update'"
            type="primary"
            :disabled="!hasBeenModified" 
            plain 
            size="small" 
            :loading="loading"
            @click="clickDialogModify">Modify</el-button>
            
          <el-button 
            v-else
            type="primary"
            plain 
            size="small" 
            :disabled="dialogObj==null" 
            :loading="loading"
            @click="clickDialogCreate">Create</el-button>
        </span>
      </el-dialog>

  <el-row class="kpi600-container" :span="24" type="flex" justify="center">  
      <el-card class="box-card2">
        <div slot="header" class="clearfix">
          <span style="font-weight:bold">KPI 302 Manier van uitvoeren</span>
        </div>
        <div class="card-body">
          <el-row class="first-row" :span="24">
              <el-col  :span="12" style="text-align:left;">
                <el-row>
                  <el-date-picker
                    v-model="monthSelected"
                    type="month"
                    size="mini"
                    placeholder="Pick a month"
                    :clearable="false"
                    @change="dateSelected()">
                  </el-date-picker>
                </el-row>
                <el-row style="margin-left:5px; font-weight:bold;">
                  
                </el-row>

              </el-col>

          </el-row>
          
          <span v-if="monthSelected" >

            <el-row  :span="24" class="parameters-selection" v-if="writeAccess">
              <el-col  :span="12" style="text-align:left;">
                <el-button
                  :disabled="!monthSelected || disable"
                  type="primary"
                  icon="el-icon-plus"
                  @click="addRecord"
                  round
                ></el-button>

                
              </el-col>

            </el-row>            
            
          </span>
        </div>

        <div>
          
            <el-table
              :data="tableData"
              :default-sort = "{prop: '_source.datetimestart', order: 'ascending'}"
              style="width: 100%">

              <el-table-column
                prop="_source.datetimestart"
                label="Datum van spotcheck"
                sortable
                width="190"
                :formatter="formaterstart">
              </el-table-column>

              <el-table-column
                prop="_source.datetimeend"
                label="Datum van resolutie"
                sortable
                width="180"
                size="small"
                :formatter="formaterend">
                
                <template slot-scope="scope" v-if="!scope.row._source.conform">                                    
                  <el-popover
                  placement="top-start"
                  title="Tijd Interval"
                  width="180"
                  trigger="hover"
                  :content="hintduration(scope.row)"                  
                  >

                  <el-button type="text"  v-bind:class="{redduration:formatend(scope.row),greenduration:!formatend(scope.row)}"  slot="reference">{{formaterend(scope.row)}}</el-button>
                </el-popover>
                </template>
              </el-table-column>

              <el-table-column
                prop="_source.conform"
                label="Conform"
                sortable
                width="110"
                align="center"
                >
                
                <template slot-scope="scope" >
                
                  <v-icon name="times" scale="1.0" v-if="!scope.row._source.conform"/>
                  <v-icon name="check" scale="1.0" v-if="scope.row._source.conform"/>
                  <!-- <div style="text-align:center;" >
                    <v-icon name="bug" scale="1.5"/>
                  </div> -->
                </template>
              </el-table-column>
              
                              
              <el-table-column
                
                label="Gebouw"
                width="120"
                sortable
                >
                <template slot-scope="scope" >                  
                  {{scope.row._source.building}} / {{scope.row._source.floor}}                  
                </template>
                
              </el-table-column>
              

            
            <el-table-column
                prop="_source.desc"
                label="Uitleg"
                sortable
                width="290">
              </el-table-column>

              <el-table-column
                
                label=""
                
                width="130">
              <template slot-scope="scope">
                
                <el-button v-if="writeAccess"
                  size="mini"
                  
                  icon="el-icon-setting"
                  plain
                  @click="handleEdit(scope.$index, scope.row)"
                ></el-button>
                <el-button v-if="writeAccess"
                  size="mini"
                  type="danger"
                  :disabled="!monthSelected || disable"
                  icon="el-icon-delete"
                  plain
                  @click="handleDelete(scope.$index, scope.row)"
                ></el-button>
              </template>
              </el-table-column>
            </el-table>

        </div>
      </el-card>
  </el-row>
  </div>
</template>
<script>
import Vue from "vue";
import moment from "moment";
import axios from "axios";
import _ from "lodash";
import formkpi302 from "@/components/external/FormKpi302";
import { setTimeout } from 'timers';
Vue.component("FormKpi302", formkpi302);

export default {
  name: "FormKpi302",
  data() {
    return {
      query:"",
      monthSelected: null, 
      monthStart: null,      
      monthEnd: null,      
      disable: true,      
      formLabelWidth: '250px',
      writeAccess:false,
      dialogType: 'creation',
      dialogVisible:false,
      dialogTitle:"",
      loading:false,
      dialogObj:null,
      orgModel:null,
      tableData:[],
      buildings:[{"building":"001 A","floors":["Floor K (0) Kelder","Floor E (1) Tussenkelder","Floor P (2) Platform","Floor A (3) Aankomst/Vertrek","Floor M (4) Mezzanine","Floor T (5) Techniek","Floor L (6) Koeltorens","Floor D (7) Dak"]},{"building":"001 B","floors":["Floor K (0) Kelder","Floor P (1) Platform","Floor A (2) Aankomst","Floor V (3) Vertrek","Floor S (4) Salondiensten","Floor D (5) Dak"]},{"building":"001 C","floors":["Floor K (-2) Kelder","Floor P (0) Inschepingsvloer"]},{"building":"001 G","floors":["Floor 0 (0) Platform","Floor 1 (1) Aankomst/Vertrek","Floor 2 (2) Aankomst","Floor 4 (3) Mezzanine + Vertrek","Floor T (4) Tussentechniek","Floor 5 (5) Techniek","Floor 6 (6) Dak"]},{"building":"001 New","floors":["Floor U (-3) Kruipkelder","Floor K (-2) Kelder","Floor E (-1) Technisch plafond","Floor P (0) Platform","Floor I (1) Tussenverdieping","Floor A (2) Aankomst","Floor V ( 3) Vertrek","Floor M (4) Mezzanine","Floor B (5) Burelen","Floor T (6) Techniek + parking","Floor S (7) Stand & gate","Floor D (8) Dak"]},{"building":"001 Old","floors":["Floor K (-3) 2&3 ondervloer","Floor 0 (-2) Level 00","Floor M (-1) Motorfiets Parking","Floor 1 (0) Level 01 Platform","Floor I (1) Tussenv. Sanitair","Floor 2 (2) Level 02 Aankomst","Floor 3 (3) Level 03 Vertrek","Floor 4 (4) Level 04","Floor 5 (5) Level 05","Floor 6 (6) Level 06","Floor 7 (7) Level 07","Floor 8 (8) Level 08","Floor 9 (9) Level 09","Floor A (10) Level 10","Floor B (11) Controletoren11","Floor C (12) Controletoren12","Floor D (13) Dak"]},{"building":"001 Tun","floors":["Floor K (0) Tunnel"]},{"building":"001 W","floors":["Floor K (-1) Kelder","Floor E (0) Tussenkelder"]},{"building":"056","floors":["Floor G (0) Gelijkvloers","Floor V (1) Verdieping","Floor D (2) Dak"]},{"building":"034","floors":["Floor G (0) Gelijkvloers"]},{"building":"026","floors":["Floor K (-1) Kelder","Floor G (0) Gelijkvloers"]},{"building":"016","floors":["Floor G (0) Gelijkvloers"]},{"building":"001 M","floors":["Floor K (-1) Kelder","Floor P (0) Platform","Floor I (1) Tussenverdieping","Floor A (2) Aankomst","Floor V ( 3) Vertrek","Floor 4 (4) Level 04","Floor 5 (5) Level 05","Floor 6 (6) Level 06","Floor 7 (7) Level 07","Floor 8 (8) Level 08","Floor 9 (9) Level 09","Floor 10 (10) Level 10","Floor D (11) Dak"]}],
      floors:[]
    };
  },
  computed: {
    hasBeenModified: function() {
      
      return JSON.stringify(this.orgModel._source) != JSON.stringify(this.dialogObj)
    }
  },
  created: function() {
    for(var i in this.$store.getters.creds.user.privileges) {
        var priv = this.$store.getters.creds.user.privileges[i]
        if(priv =='admin' || priv=='kpi302-write' || priv=='KPI302_WRITE') {
          this.writeAccess = true
        }
      }
    this.prepareData();
  },
  methods: {
    building_changed(val)
    {
      for(var i=0;i<this.buildings.length;i++)
      {
        if(this.buildings[i].building==val)
        {          
          this.floors=this.buildings[i].floors;
          this.dialogObj.floor=this.buildings[i].floors[0];

          return
        }  
      }
      
    },
    formaterend(row, column)
    {
      if (row._source.datetimeend !=null)
        return moment(row._source.datetimeend).format("DD/MMM/YYYY HH:mm");
      else
        return "";
      //return JSON.stringify(column);
      }
      ,
      formatend(row, column)
    {
      if (row._source.datetimeend !=null)
        if ((moment(row._source.datetimeend).diff(row._source.datetimestart,'hours')/24)<=15)
          return false;
        else
          return true;
      else
        return "";
      //return JSON.stringify(column);
      }
    ,
    hintduration(row, column)
    {
      return  " "+(moment(row._source.datetimeend).diff(row._source.datetimestart,'hours')/24).toFixed(2)+" dag(en)"

      //return JSON.stringify(column);
      }
    ,
    formaterstart(row, column)
    {
      return moment(row._source.datetimestart).format("DD/MMM/YYYY HH:mm")
      //return JSON.stringify(column);
      }
    ,    
    
    clickDialogCreate(){
      var rec = {
        _id: "id_" + Math.floor((1 + Math.random()) * 0x1000000),
        _index: "biac_kpi302_monthly",
        _type: "doc",

        _source: this.dialogObj
      }

      rec._source['@timestamp'] = moment()            

      this.$store.commit({
        type: "updateRecord",
        data: rec
      });
      setTimeout(()=>this.prepareData(),1000);
      this.dialogVisible = false
    },
    clickDialogModify(){
      var rec = this.orgModel;

      this.orgModel._source=this.dialogObj;
      
      this.$store.commit({
        type: "updateRecord",
        data: rec
      });
      setTimeout(()=>this.prepareData(),1000);
      this.dialogVisible = false
    },
    
    prepareData() {
      console.log('prepare data')            
      
      this.monthSelected = moment()
      this.dateSelected()

      

    },
    addRecord() {
      this.dialogObj = {
        datetimestart: moment(),        
        datetimeend: null,        
        conform: true  ,
        building:this.buildings[0].building  ,
        floor:this.buildings[0].floors[0]        
      }
      this.floors=this.buildings[0].floors  
      this.dialogType = 'creation'
      this.dialogTitle   = 'Nieuw spotcheck'
      this.dialogVisible = true

    },
    handleEdit(index, row){
      var newconfig=JSON.parse(JSON.stringify(row));
      this.dialogObj = newconfig._source;
      this.dialogType = 'update'
      this.dialogTitle   = 'Bijwerken spotcheck'
      this.dialogVisible = true
      this.orgModel=row;

      for(var i=0;i<this.buildings.length;i++)
      {
        if(this.buildings[i].building==this.dialogObj.building)
        {          
          this.floors=this.buildings[i].floors;

          break
        }  
      }
    },
    handleDelete(index,row)
    {
      this.$confirm(
        "Dit zal de record voor altijd verwijderen, verder gaan?",
        "Warning",
        {
          confirmButtonText: "OK",
          cancelButtonText: "Verwijderen",
          type: "warning"
        }
      ).then(() => {
          this.$store.commit({
            type: "deleteRecord",
            data: row
          });
          setTimeout(()=>this.prepareData(),1000);
      });
    },     
    dateSelected() {


      if(this.monthSelected == null)
        this.monthSelected = moment()


      if(moment().format('D') > 14) {
        //console.log('report already done')
        this.disable = (moment() > moment(this.monthSelected).endOf('Month'))
      }
      else {
        this.disable = (moment().subtract(1, 'months') > moment(this.monthSelected).endOf('Month'))
      }
      //@this.disable=false;
      this.monthStart=moment(this.monthSelected).startOf('Month')
      this.monthEnd=moment(this.monthSelected).endOf('Month')

      this.query="datetimestart: ["+this.monthStart.toISOString()+" TO "+this.monthEnd.toISOString()+"]"

      var url =
      this.$store.getters.apiurl +
      "generic_search/biac_kpi302_monthly*?token=" +
      this.$store.getters.creds.token;

    var fullq={
          "size":900,
          "query": {
            "bool": {
              "must": [
                {
                  "query_string": {
                    
                    "query": this.query
                  }
                }
              ]
            }
          }
      }

    axios
      .post(url, fullq)
      .then((response) => {
        if(response.data.error!="")
          console.log("KPI302 list error...");
        else
        {
          console.log(response.data.records);
          console.log(this);
          this.tableData=response.data.records;

        }
      })
      .catch((error)=> {
        console.log(error);
      });
    }

  }
};
</script>
<style>
.kpi600-container{
  width: 100%;
  margin: 30px 0px; 
  
}
.box-card2 {
  width: 1050px !important;
}

.kpi600-container  .parameters-selection{
  margin: 10px;

}

.first-row{
  /*margin: 10px;*/
}
.second-row{
  /*margin: 20px 10px;*/
}
.third-row{
  /*margin: 20px 10px;*/
}

.row-day {
  padding-top:10px;
  padding-bottom:10px;
  border-top: solid 1px lightgrey;
}

.kpi600-switches-text {
  margin-left: 20px; 
  font-size: 11px;
}

.redduration
{
  color:red !important;
}

.greenduration
{
  color:green !important;
}

.kpi600-container .row-subtitle {
  border-top: solid 1px #eee;
  margin-top: 15px;
  padding-top: 10px;
  padding-bottom: 10px;
  margin-bottom: 15px;
  border-bottom: solid 1px #eee;
}
</style>