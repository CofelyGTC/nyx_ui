<template>
  <div style="width: 100%">
  <el-row class="stockvieweroffice-container" style="width: 100%" >
      <el-form style="widht: 100%">
          <el-row>
            <td>
            Sélectionnez un magasin: 
            <el-select @change="changeShop" v-model="selectedShop" placeholder="Sélectionner">
                    <el-option
                        v-for="(item, id) in magasins"
                        :key="id"
                        :label="item.shop + ' ('+ item.shopid+')'"
                        :value="[item.shop, item.shopid]">
                    </el-option>
                    </el-select>
            </td>
          </el-row>  <br>
          <el-row><h2>Coeurs</h2></el-row><br>
          <el-row>
              <el-col :span=8>
                  <el-form-item  label="INDIVIDUELLE" :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C620" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=8>
                  <el-form-item  label="4 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C621" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=8>
                  <el-form-item  label="6 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C622" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
          </el-row><br>
          <el-row><h2>Schamp</h2></el-row><br>
          <el-row>
              <el-col :span=8>
                  <el-form-item  label="INDIVIDUELLE" :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C623" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=8>
                  <el-form-item  label="4 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C624" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=8>
                  <el-form-item  label="6 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C625" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
          </el-row><br>
          <el-row><h2>Fruits des Bois</h2></el-row><br>
          <el-row>
              <el-col :span=8>
                  <el-form-item  label="INDIVIDUELLE" :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C626" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=8>
                  <el-form-item  label="4 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C627" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=8>
                  <el-form-item  label="6 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C628" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
          </el-row><br>
          <el-row><h2>Glaces</h2></el-row><br>
          <el-row>
              <el-col :span=8>
                  <el-form-item  label="Igloo vanille-framboise" :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C629" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=8>
                  <el-form-item  label="Traîneau vanille-framboise " :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C630" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              
          </el-row><br>
          <el-row><h2>Galettes Nature</h2></el-row><br>
          <el-row>
              <el-col :span=12>
                  <el-form-item  label="4 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.P700" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=12>
                  <el-form-item  label="6 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.P701" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              
          </el-row><br>
          <el-row><h2>Galettes Abricot</h2></el-row><br>
          <el-row>
              <el-col :span=12>
                  <el-form-item  label="4 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.P702" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=12>
                  <el-form-item  label="6 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.P703" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              
          </el-row><br>
          <el-row><h2>Galettes Nutella</h2></el-row><br>
          <el-row>
              <el-col :span=12>
                  <el-form-item  label="4 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.P704" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=12>
                  <el-form-item  label="6 PERS." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.P705" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              
          </el-row><br>
          <div>
            <el-row>
                <el-button type="primary" @click="onSubmit">Enregistrer</el-button>
            </el-row>
          </div>
      </el-form> 
  </el-row>
  
    </div>
    
</template>
<script>
import Vue from "vue";
import moment,{ months } from "moment";
import axios from "axios";

export default {
  name: "StockViewerOffice",
  data: () => ({
      record: null,
      magasin: '',
      shopid: '',
      ts: 0,
      productsLabels: {},
      formLabelWidth2: "120px",
      selectedShop: [],
      magasins: [],

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
    this.ts = Date.now()*1000;
    this.getMagasins();
  },
  methods: {
    onSubmit(){
        this.refillNan();
        this.ts = Date.now();
        this.record._source.lastUpdate = this.ts;
        this.record._source.modifiedBy = this.$store.getters.creds.user.id 
        var url = this.$store.getters.apiurl + "lambdas/7/update_stocks_coeurs?apikey=" + this.$store.getters.creds.token;
      
      
      setTimeout(() => {
        axios.post(
          url, this.record
          ).then((response) => {

              console.log(response)
            if(response.data.errors)
              {
                this.$notify({ 
                title: "Error",
                message: "Stocks Non Enregistrés",
                type: "error",
                position: "bottom-right",
                duration: 1500});
                }
            else
              {
                this.$notify({ 
                title: "Success",
                message: "Stocks correctement enregistrés",
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
            
      this.getProductsLabels();      
      this.getData();      

    },

    getProductsLabels(){
      var demandor = this.$store.getters.creds.user.id          
      var query = {"shopid": this.shopid}
      var url = this.$store.getters.apiurl + "lambdas/7/get_products_labels?apikey=" + this.$store.getters.creds.token;
      axios
      .post(url, query)
      .then((response) => {

        //var status = false

        console.log(response.data.orderstatus)
        this.productsLabels = response.data
      });
    },

    getData(){
        
      var demandor = this.$store.getters.creds.user.id          
      var query = {"shopid": this.shopid}
      var url = this.$store.getters.apiurl + "lambdas/7/get_stock_coeurs?apikey=" + this.$store.getters.creds.token;
      axios
      .post(url, query)
      .then((response) => {

        //var status = false

        console.log(response.data.orderstatus)
        this.record = response.data
       



      });

    },

    refillNan(){
      
      
      for(var index in this.record._source)
      {
        
        if(this.record._source[index] == null)
        {
          this.record._source[index] = 0
          console.log(index.toString()+' '+this.record._source[index].toString());
        }
      }
      

    },
    changeShop(){
      console.log("CHANGE SHOP")
      console.log(this.selectedShop)
      //console.log(item)
      //this.magasin = magasin
      this.magasin = this.selectedShop[0]
      this.shopid = this.selectedShop[1]
      console.log("SHOP: " + this.magasin)
      console.log("SHOPID: " + this.shopid)
      this.$store.commit({
        type: "setActualShop",
        data: this.magasin
      });
      this.$store.commit({
        type: "setActualShopID",
        data: this.shopid
      });
      console.log('TESTESTEST')
      console.log(this.$store.getters.actualShop)
      this.prepareData();
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
                this.shopid = res.records[0]._source['shopid']
                var magasins = []
                for(var rec in res.records)
                {
                    console.log(rec)
                    var shop = {"shop": res.records[rec]._source['Nom magasin'], "shopid": res.records[rec]._source['shopid']}
                    magasins.push(shop)
                }
                this.magasins = magasins
                console.log(this.magasins)
                this.prepareData();
               
            }
        });  

        
    }
    },
}

</script>
<style>
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