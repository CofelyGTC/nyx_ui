<template>
  <div style="width: 100%">
  <el-row class="stockperesvieweroffice-container" style="width: 100%" >
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
          <el-row><h1>Fêtes des Pères</h1></el-row><br>
          <el-row><h2>Schamp</h2></el-row><br>
          <el-row>
              <el-col :span=8>
                  <el-form-item  label="1 Pers." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C550" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=8>
                  <el-form-item  label="4 Pers." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C551" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=8>
                  <el-form-item  label="6 Pers." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C552" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
          </el-row><br>
           <el-row><h2>Charlotte Fruits</h2></el-row><br>
          <el-row>
              <el-col :span=12>
                  <el-form-item  label="4 Pers." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C553" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=12>
                  <el-form-item  label="6 Pers." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C554" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
          </el-row><br>
           <el-row><h2>Biscuit Mojito</h2></el-row><br>
          <el-row>
              <el-col :span=12>
                  <el-form-item  label="1 Pers." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C555" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
              <el-col :span=12>
                  <el-form-item  label="5 Pers." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C556" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
          </el-row><br>
          <el-row><h2>Biscuit Coeur </h2></el-row><br>
          <el-row>
              <el-col :span=24>
                  <el-form-item  label="5 Pers." :label-width="formLabelWidth2">
                    <el-input-number v-model="record._source.C557" :step=1 :min=0>
                    </el-input-number>
                  </el-form-item>
              </el-col>
          </el-row>  
          
          
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
  name: "StockFetesPeresOffice",
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
        var url = this.$store.getters.apiurl + "lambdas/7/update_stocks_fetes_peres?apikey=" + this.$store.getters.creds.token;
      
      
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
      var url = this.$store.getters.apiurl + "lambdas/7/get_stock_fetes_peres?apikey=" + this.$store.getters.creds.token;
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