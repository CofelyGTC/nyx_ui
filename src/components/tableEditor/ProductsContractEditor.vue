<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="product-contract-editor"
  >
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <el-row>
              <el-col :span="12">
                <el-form-item label="ID : " :label-width="formLabelWidth">
                    <el-input placeholder="PC...." v-model="newRec._id"></el-input>
                </el-form-item>


              </el-col>
              <el-col :span="12">
                <el-form-item placeholder="Décrivez ce contrat..." label="Description : " :label-width="formLabelWidth">
                    <el-input v-model="newRec._source.description"></el-input>
                </el-form-item>


              </el-col>
          </el-row>
          <el-row>
                 
              <ul class="infinite-list" v-infinite-scroll="load" style="overflow:auto">
                  <li v-for="prod in productsList" :key="prod.CODE" class="infinite-list-item">
                      
                          
                              {{prod.CODE}} - {{prod.Label}} <el-checkbox v-model="prod.checked" @change="checkChange(prod)"></el-checkbox>

                  </li>
              </ul>
          </el-row>
          <el-row>
            {{newRec._source.products}}
          </el-row>

      
          
      </el-card>
    </el-form>

    <span slot="footer" class="dialog-footer">
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
  name: "ProductsContractEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "240px",
    changed: false,
    dialogFormVisible: false,
    title: "Convention-Editor",
    disabled: false,
    strDt: '',
    productsList: []
  }),
  computed: {
    recordin: function() {
      return this.record;
    },
    recordstr: function() {
      return JSON.stringify(this.record);
    },
    recchanged: function() {
      return JSON.stringify(this.recordin) != JSON.stringify(this.newRec);
    },
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
      },
      deep: true
    }
  },
  filters: {
      roundTo2: function(value){
        return value.toFixed(2);
      }
  },
  created: function() {
    console.log("created event");
    this.prepareData();
  },
  components: {},
  methods: {
    closeDialog: function() {
      this.$emit("dialogclose");
    },
    prepareData: function() {
      console.log("prepare data");
      this.dialogFormVisible = true;
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
      if(!this.newRec._source.products)
      {
          this.newRec._source.products=[]
      }
      this.getProductsList();
      
    },

    getProductsList: function() {
                
        var url = this.$store.getters.apiurl + "lambdas/8/get_products_list?apikey=" + this.$store.getters.creds.token;
        var body = {};
        axios
        .post(url, body)
        .then((response) => {
            //console.log(response)
            this.productsList = response.data.products
            console.log( this.newRec._source.products)
            for(var key in this.productsList)
            {
                
                if(this.newRec._source.products.includes(this.productsList[key]['CODE']))
                {
                    console.log(this.productsList[key]['CODE'])
                    this.productsList[key]['checked'] = true
                }
            }
            this.$forceUpdate();
        });

    },

    load () {
        this.count += 2
      },
      

    checkChange(prod) {

        

        if(prod.checked)
        {
            this.newRec._source.products.push(prod.CODE)

        }
        else
        {
            var index = this.newRec._source.products.indexOf(prod.CODE);
            this.newRec._source.products.splice(index, 1)
        }

    },

    

    saveRecord: function() {

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.lastUpdate = Date.now()

      

      

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
.infinite-list {
  columns: 3;
  -webkit-columns: 3;
  -moz-columns: 3;
  text-align: left;
  overflow: auto;
}
</style>