<template>
    <el-row class="danone-container" :span="24" type="flex" justify="center">  
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span style="font-weight:bold">Safety / Quality Triggers</span>
          </div>
          
          <div class="card-body">
            
            <el-row class="first-row" :span="24">
                <el-col  :span="12" style="text-align:left;">
                  <el-row>
                    <el-date-picker
                      v-model="daySelected"
                      type="date"
                      size="mini"
                      placeholder="Pick a day"
                      :clearable="false"
                      @change="dateSelected()">
                    </el-date-picker>
                  </el-row>

  
                </el-col>
                <!--<el-col  :span="12" style="text-align:right;">
                  <el-button
                    size="mini">
                    Refresh
                  </el-button>
                </el-col>-->
            </el-row>
            
            <span v-if="daySelected" >
  
              <el-row  :span="24" class="parameters-selection">
                <el-col  :span="12" style="text-align:left;">
                
                  <el-row>
                    <el-select 
                      v-model="selectedTech" 
                      size="mini"
                      @change="techChanged()"
                      placeholder="Select">
                        <el-option
                          v-for="item in techArray"
                          :key="item"
                          :label="item"
                          :value="item">
                        </el-option>
                      </el-select>
                  </el-row>
                  
                
                </el-col>
  
              </el-row>
              <el-row class="row-subtitle">
                <h3 style="text-align:center; width:100%;">{{selectedTech}} </h3>
              </el-row>
              <el-row  :span="24" class="danone-switches">
                <el-form style="text-align:left" :model="triggers"  ref="formDanone">
                  <el-form-item
                    :label="triggers.safety.label"
                    :label-width="formLabelWidth">
                    <el-switch 
                      :disabled="!writeAccess || disable"
                      v-model="triggers.safety.value" 
                      @change="kpiChanged();"></el-switch>
                    <span class="danone-switches-text">{{triggers.safety.text}}</span>
                  </el-form-item>
                  <el-form-item
                    :label="triggers.quality.label"
                    :label-width="formLabelWidth">
                    <el-switch 
                      :disabled="!writeAccess || disable"
                      v-model="triggers.quality.value" 
                      @change="kpiChanged();"></el-switch>
                    <span class="danone-switches-text">{{triggers.quality.text}}</span>
                  </el-form-item>           
                </el-form>
              </el-row>
              
            </span>
          </div>
        </el-card>
    </el-row>
  </template>
  <script>
  import Vue from "vue";
  import moment from "moment";
  import axios from "axios";
  import formDanone from "@/components/external/FormDanone";
  Vue.component("FormDanone", formDanone);
  
  export default {
    name: "FormDanone",
    data() {
      return {
        daySelected: new Date(),
        techArray: ["Water Supply", "Steam", "HVAC", "Chilled Water", "Compressed Air"],
        selectedTech: "Water Supply",
        selectedTec: null,
        disable: true,
        currentObj: null,
        strPeriod1: '',
        strPeriod2: '',
        formLabelWidth: '200px',
        writeAccess:false,
        limitDate: new Date(),
        triggers: {
          safety: {
            value: false,
            text: 'Safety',
            label: 'Safety ',
          },
          quality: {
            value: false,
            text: 'Quality',
            label: 'Quality'
          }
  
        }
        
      };
    },
    computed: {
      
    },
    
    props: {
      config: {
        type: Object
      }
    },
    created: function() {
      this.prepareData();
    },
    methods: {
      prepareData() {
        console.log('prepare data')
        //this.getEntitiesModel()
        for(var i in this.$store.getters.creds.user.privileges) {
          var priv = this.$store.getters.creds.user.privileges[i]
          if(priv =='admin' || priv=='danone-write') {
            this.writeAccess = true
        }
      }
        
        this.daySelected = new Date();
        this.daySelected.setHours(0);
        this.limitDate = new Date();
        this.limitDate.setHours(16)
        this.dateSelected();
  
      },
      
      dateSelected() {
  
  
        if(this.daySelected == null)
          this.daySelected = new Date()

        console.log("===DATE CHANGED===")
        console.log(this.limitDate)
        console.log(this.daySelected)
        console.log((this.limitDate > this.daySelected))
        var now = new Date();
        this.disable = (this.limitDate > this.daySelected)

        if (this.limitDate.toDateString() == this.daySelected.toDateString())
        {
           this.disable=(now > this.limitDate)
        }


     
        
        this.getData()
  
  
        
      },
      getData() {
        console.log('get data')
        console.log(this.selectedTech)
        console.log(this.daySelected)
  
        if(this.selectedTech == null)
          return
  
  
        if(this.daySelected == null)
          return
  
        var strDate = moment(this.daySelected).format('YYYYMMDD')
  
       
  
        console.log(strDate)
        axios.defaults.withCredentials = true;
        var url = this.$store.getters.apiurl + "lambdas/4/get_danone_data"
        var body= {
            "dt": strDate,
            "technic": this.selectedTech
        }
        console.log(url)

        axios.post(url,body,{params: {
            apikey: this.$store.getters.creds.token}}).then((response) => {
            if(response.data.error!="")
              console.log("get KPI600 monthly error");
            else {
              console.log("get KPI600 monthly success");
              console.log(response.data.data)
              console.log(typeof(response.data.data))
              
              this.currentObj = response.data.data
              this.triggers.safety.value = this.currentObj.safety_trigger
              this.triggers.quality.value = this.currentObj.quality_trigger

  
            }
        })
        .catch((error)=> {
          console.log(error);
        });
  
        
      },
      techChanged() {
        console.log('technic changed')
        console.log(this.selectedTech)
  
        //this.selectedTec = this.entityModel[this.selectedTech][0]
  
        this.getData()
      },

      kpiChanged() {
      
      this.currentObj.quality_trigger = this.triggers.safety.value
      this.currentObj.safety_trigger = this.triggers.quality.value

      this.updateData(this.selectedTech, this.dateSelected, this.currentObj)
      
    },
  
      updateData : _.debounce(function(tech, date, obj) {
        console.log('update date')

        console.log('tec '+tech)
        console.log('date '+date)
        console.log(obj)

        var year = date.getFullYear().toString()
        var month = (date.getMonth() + 1).toString()
        var day = date.getDate().toString()

        if(month.length<2)
        {
            month = '0'+month
        }
        if(day.length<2)
        {
          day = '0'+day
        }

        var strDt = year+month+day

        obj._id  = tech.toLowerCase().replace(/\s/g, '')+'_'+strDt


        
  
        var rec = {
          _id: obj._id,
          _index: "danone_data",
          isadd:false,
          _type: "_doc",
  
          _source: {
          }
        }
  
          
        rec._source = JSON.parse(JSON.stringify(obj))
        delete rec._source._id
        rec._source['@timestamp'] = moment(rec._source['@timestamp']).format()
  
        console.log(rec)
  
        this.$store.commit({
          type: "updateRecord",
          data: rec
        });
  
  
  
  
        this.$notify({
          title: "Data Saved",
          message: "",
          type: "success",
          position: "bottom-right"
        });
      }, 1500),
  
  
  
    }
  };
  </script>
  <style>
  .danone-container{
    width: 100%;
    margin: 30px 0px; 
    
  }
  .box-card {
    width: 800px !important;
  }
  
  .danone-container  .parameters-selection{
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
  
  .danone-switches-text {
    margin-left: 20px; 
    font-size: 11px;
  }
  
  .danone-container .row-subtitle {
    border-top: solid 1px #eee;
    margin-top: 15px;
    padding-top: 10px;
    padding-bottom: 10px;
    margin-bottom: 15px;
    border-bottom: solid 1px #eee;
  }
  </style>