<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="confirm-order-editor"
  >
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <el-tabs v-model="selectedTab" @tab-click="handleClick">
              <!--el-tab-pane v-for="(category) in newRec._source.categories" v-bind:category  :label="category" :name="category"></el-tab-pane-->
        
        <el-tab-pane
          v-bind:style="styleContainerComputed"
          v-for="(index, category) in newRec._source.categories"
          :key="'TAB-'+index"
          :label="index"
          :name="'TAB-'+category"
        >

        
        
        
        <el-table :data="newRec._source[index]" style="width: 100%">
          <el-table-column prop="_id" label="id"></el-table-column>
          <el-table-column prop="category" label="Categorie"></el-table-column>
          <el-table-column prop="name" label="Nom"></el-table-column>
          <el-table-column prop="code" label="Code"></el-table-column>
          <el-table-column label="Quantité">
          <template slot-scope="scope">
            <el-input-number v-model="scope.row.quantity"/>
          </template>
          </el-table-column>
          <el-table-column label="Remarques">
            <template slot-scope="scope">
              <el-input type="textarea" v-model="scope.row.remarque"></el-input>
            </template>
          </el-table-column>
          </el-table> 
          </el-tab-pane>
          </el-tabs>
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
  name: "orderEditor",
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
    title: "Commande",
    selectedTab: "TAB-0"
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
    },
    saveRecord: function() {

      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.orderDate = Date.now()

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
    },
    handleTabClick: function(tab) {
      var index = parseInt(tab.name.substring(4));
      
      this.$store.commit({
        type: "setTab",
        data: this.$store.getters.currentApps.apps[index]
      });

      if (this.$store.getters.currentApps.apps[index].type == "kibana") {
        this.$globalbus.$emit(
          "kibanaactivated",
          this.$store.getters.currentApps.apps[index]
        );
      }
    },
    changeApp: function() {
      this.currentApps = null

      this.selectedTab = "TAB-0"

      this.$nextTick(() => {
        this.currentApps = JSON.parse(JSON.stringify(this.$store.getters.currentApps))
      });
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