<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="user-shop"
  >
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <el-row>
              <el-col :span="8">
            <el-form-item label="User" :label-width="formLabelWidth">
            <el-select v-model="user" placeholder="Sélectionner" @change="userChange(user)">
                <el-option v-for="(item, id1) in users" :key="id1" :label="item" :value="item">
                </el-option>
            </el-select>
            </el-form-item>
              </el-col>
              
          </el-row>
          </el-card>
          <br>
          <el-card>
              <h2>Magasins Atribués</h2>
              <br>
              <el-row style="text-align:left;">
                  <el-col v-for="(shop, index) in this.allowedshops" :key=index>
                      <el-row>
                          <el-col :span=8>
                           <el-form-item label="Magasin" :label-width="formLabelWidth">
                              {{shop.shop}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=8>
                           <el-form-item label="ID Magasin" :label-width="formLabelWidth">
                              {{shop.shopid}}
                           </el-form-item>
                        </el-col>
                        <el-col :span=4>
                           <center>
                           <el-button @click="removeAllowedShop(index)" type="danger" icon="el-icon-delete" circle>
                           </el-button>
                           </center>
                        </el-col>
                      </el-row>
                  </el-col>
              </el-row>
            <el-row>
              <el-col :span="8">
            <el-form-item label="Magasin" :label-width="formLabelWidth">
            <el-select v-model="shop" placeholder="Sélectionner" @change="shopChange(shop)"> 
                <el-option v-for="(item, id2) in shops" :key="id2" :label="item" :value="item">
                </el-option>
            </el-select>
            </el-form-item>
              </el-col>
              <el-col :span="8">
            <el-form-item label="Magasin ID" :label-width="formLabelWidth">
            <el-select v-model="shopid" placeholder="Sélectionner" @change="idChange(shopid)"> 
                <el-option v-for="(item, id3) in ids" :key="id3" :label="item" :value="item">
                </el-option>
            </el-select>
            </el-form-item>
              </el-col>
              <el-col :span=4 style="text-align:right;">
                <el-button type="primary" @click="addAllowedShop()" icon="el-icon-plus" circle></el-button>
            </el-col>
          </el-row>
      </el-card>
    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button @click="$emit('dialogclose')">{{this.$t("buttons.cancel")}}</el-button>
      <el-button
        v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
        type="primary"
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
  name: "SalesShops",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    changed: false,
    dialogFormVisible: false,
    title: "Attributions des Magasins",
    user:'',
    shop:'',
    shopid: '',
    users: [],
    shops: [],
    shopsids: {},
    ids:[],
    allowedshops: [],
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
    }
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
      this.user = this.newRec._source.userId
      if(this.newRec._source.shops)
      {
        this.allowedshops = this.newRec._source.shops
      }
      this.getUsers();
      this.getShops();
    },

    getUsers: function(){
        console.log("Get users List")
        var url = this.$store.getters.apiurl + "lambdas/2/get_users?apikey=" + this.$store.getters.creds.token;
        var body = {};
        axios
        .post(url, body)
        .then((response) => {
            console.log(response)
            this.users = response.data
            this.$forceUpdate();
        });

    },

    getShops: function(){
        console.log("Get shops List")
        var url = this.$store.getters.apiurl + "lambdas/2/get_shopsids?apikey=" + this.$store.getters.creds.token;
        var body = {};
        axios
        .post(url, body)
        .then((response) => {
            console.log(response)
            this.shops = response.data.shops
            this.shopsids = response.data.shopsids
            this.ids = this.shopsids[this.shop]
            console.log(this.shops)
            this.$forceUpdate();
        });

    },

    userChange: function(user){
        this.newRec._source.userId = user;
    },
    shopChange: function(shop){
        this.newRec._source.magasin = shop;
        this.ids = this.shopsids[shop];
        this.shopid = ''
    },

    idChange: function(id){
        this.newRec._source.shopid = id;
    },

    removeAllowedShop: function(index){
        this.allowedshops.splice(index, 1);
    },

    addAllowedShop(shop){

        var allowedShop = {
            "shop": this.shop,
            "shopid": this.shopid
        }

        this.allowedshops.push(allowedShop)
    },

    saveRecord: function() {

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.lastUpdate = Date.now()
      this.newRec._source.user = this.user
      this.newRec._source.shops = this.allowedshops

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
</style>