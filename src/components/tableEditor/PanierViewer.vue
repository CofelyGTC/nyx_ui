<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="panier-viewer"
  >

      <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <el-table :data="this.products" style="width: 100%" >
              <el-table-column prop="name" label="Name"></el-table-column>
              <el-table-column label="Quantité">
                <template slot-scope="scope">
                    {{scope.row.quantity | roundTo2}}
                </template>
              </el-table-column>
              <el-table-column prop="price_tvac" label="Prix TTC">
                <template slot-scope="scope">
                    {{scope.row.price_tvac | roundTo2}} €
                </template>
              </el-table-column>
              <el-table-column label="Prix Total TTC">
                 <template slot-scope="scope">
                    {{scope.row.quantity * scope.row.price_tvac | roundTo2}} €
                </template>
              </el-table-column>

          </el-table>
      </el-card>

    <span slot="footer" class="dialog-footer">
      <el-button @click="$emit('dialogclose')">{{this.$t("buttons.cancel")}}</el-button>
    </span>
  </el-dialog>
</template>

<script>
import Vue from "vue";

import YAML from "js-yaml";
import axios from "axios";

export default {
  name: "PanierViewer",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    products: null,
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    changed: false,
    dialogFormVisible: false,
    title: "Details"
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
      var prodList = []
      for(var index in this.newRec.products)
      {
          
          var prod = this.newRec.products[index]
          if(prod.quantity > 0)
          {
              prod['totPrice'] = prod['price_tvac'] * prod['quantity']
              prodList.push(prod)
          }
      }
      this.products = prodList

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