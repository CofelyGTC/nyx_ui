<template>
  <div>
    <el-table class="headertable" :data="$store.getters.filteredmenus" @current-change="handleCurrentHeaderChange" border
      style="width: 100%">
      <el-table-column prop="category" label="Category"></el-table-column>
      <el-table-column prop="title" label="Action">
        <template slot-scope="scope2">
          <el-button size="mini" circle type="primary" @click="handleMoveHeader(scope2.$index, scope2.row, false)"
            icon="el-icon-arrow-down" v-if="scope2.$index < $store.getters.filteredmenus.length - 1"></el-button>
          <el-button size="mini" circle type="primary" @click="handleMoveHeader(scope2.$index, scope2.row, true)"
            icon="el-icon-arrow-up" v-if="scope2.$index > 0"></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>
<script>
import axios from "axios";

import Vue from "vue";

import configdetails from "@/components/ConfigDetails";
import { Draggable } from "leaflet";
Vue.component("ConfigDetails", configdetails);

export default {
  data() {
    return {
      tableData: [],
      currentRow: null,
      search: "",
      curConfig: {},
      orgConfig: {},
      dialogFormVisible: false,
      formLabelWidth: "120px",
      formLabelWidth2: "150px",
      isAdd: false
    };
  },
  computed: {
  },
  methods: {
    handleCurrentHeaderChange(val) {
      console.log('val: ', val);
      // this.currentHeader = val;
    },
    handleMoveHeader(index, row, down) {
      console.log('row: ', row);
      this.$store.getters.filteredmenus.splice(index, 1);
      if (down) this.$store.getters.filteredmenus.splice(index - 1, 0, row);
      else this.$store.getters.filteredmenus.splice(index + 1, 0, row);
      console.log('this.$store.getters: ', this.$store.getters.filteredmenus);
      console.log('this.tableData: ', this.tableData);
      for (let index = 0; index < this.$store.getters.filteredmenus.length; index++) {
        var category = this.$store.getters.filteredmenus[index].category
        console.log('category: ', category);
        // console.log('category: ', category);
        // console.log(this.tableData.filter(data => ((JSON.stringify(data._source.category).toLowerCase().includes(category.toLowerCase())))));
        this.tableData.forEach(element2 => {
          if (element2._source.category == category) {
            element2._source.order = (index + 1) * Math.pow(10, 4) + (element2._source.order % 10000)
            console.log('element2._source: ', element2._source.order);
            // console.log('element2: ', element2);
            // console.log('element2._source.category: ', element2._source.category);
            // console.log('element2._source.subcategory: ', element2._source.subcategory);
            // (element2._source.subcategory).forEach(subcategory => {
            //   console.log('subcategory: ', subcategory);
              
            // });
          } 
        })
      }
      // this.$store.commit({
      //   type: "updateCategoryTree",
      //   data: this.$store.getters.filteredmenus
      // });
      
    },
    handleEditHeader(index, row) {
      console.log('row: ', row);
      // eslint-disable-line
      // this.currentHeader = row;
      // this.dialogHeaderVisible = true;
    },
    dialogClosed() {
      this.dialogFormVisible = false;
      setTimeout(() => {
        this.loadData();
      }, 1000);
    },
    reloadConfig() {
      var url = this.$store.getters.apiurl +
        "reloadconfig?token=" +
        this.$store.getters.creds.token;
      axios
        .get(url)
        .then(response => {
          if (response.data.error != "")
            console.log("Reload error...");
          else {
            this.$store.commit({
              type: "login",
              data: response.data
            });
            this.$notify({
              title: "Message",
              message: "Config Reloaded",
              type: "success",
              position: "bottom-right"
            });
          }
        })
        .catch(error => {
          console.log(error);
        });
    },
    loadData() {
      console.log('loadData: ');
      var url = this.$store.getters.apiurl +
        "generic_search/nyx_app*?token=" +
        this.$store.getters.creds.token;
      axios
        .post(url, { size: 300 })
        .then(response => {
          if (response.data.error != "")
            console.log("User list error...");
          else {
            this.tableData = response.data.records;
            console.log('this.$store.getters.filteredmenus: ', this.$store.getters.filteredmenus);
            console.log('this.tableData: ', this.tableData);
          }
        })
        .catch(error => {
          console.log(error);
        });
    },
    duplicate() {
      // console.log(this.currentRow);
      console.log('this.currentRow: ', this.currentRow);
      this.isAdd = true;
      var newrec = JSON.parse(JSON.stringify(this.currentRow));
      newrec._id = "id_" + Math.floor((1 + Math.random()) * 0x1000000);
      this.curConfig = JSON.parse(JSON.stringify(newrec._source));
      this.$store.commit({
        type: "setAppConfigObj",
        data: JSON.parse(JSON.stringify(newrec._source))
      });
      this.orgConfig = newrec;
      this.dialogHeaderVisible = false;
      this.currentHeader = {};
      this.dialogFormVisible = true;
    },
    handleAddApp() {
      this.isAdd = true;
      var newrec = {
        _id: "id_" + Math.floor((1 + Math.random()) * 0x1000000),
        _index: "nyx_app",
        _source: {
          title: "New App",
          type: "generic-table",
          category: "",
          order: 1000,
          privileges: [],
          queryBarChecked: false,
          queryFilterChecked: false,
          config: {
            headercolumns: [],
            tableFieldsToDownload: [],
            tableFieldsToFilter: [],
            writeprivileges: [],
            queryfilters: []
          }
        },
        _type: "doc"
      };
      this.curConfig = JSON.parse(JSON.stringify(newrec._source));
      this.orgConfig = newrec;
      this.$store.commit({
        type: "setAppConfigObj",
        date: newrec._source
      });
      this.dialogHeaderVisible = false;
      this.currentHeader = {};
      this.dialogFormVisible = true;
    },
    setCurrent(row) {
      this.$refs.singleTable.setCurrentRow(row);
    },
    handleCurrentChange(val) {
      this.currentRow = val;
    },
    handleEdit(index, row) {
      if (row._source.config == null) {
        row._source.config = {
          headercolumns: [],
          tableFieldsToDownload: [],
          tableFieldsToFilter: [],
          writeprivileges: [],
          queryfilters: []
        };
      }
      if (row._source.config.headercolumns == null)
        row._source.config.headercolumns = [];
      if (row._source.config.tableFieldsToDownload == null)
        row._source.config.tableFieldsToDownload = [];
      if (row._source.config.tableFieldsToFilter == null)
        row._source.config.tableFieldsToFilter = [];
      if (row._source.config.queryfilters == null)
        row._source.config.queryfilters = [];
      if (row._source.queryBarChecked == null)
        row._source.queryBarChecked = false;
      if (row._source.queryFilterChecked == null)
        row._source.queryFilterChecked = false;
      if (row._source.config.writeprivileges == null)
        row._source.config.writeprivileges = [];
      else if (typeof (row._source.config.writeprivileges) == 'string')
        row._source.config.writeprivileges = [row._source.config.writeprivileges];
      this.curConfig = JSON.parse(JSON.stringify(row._source));
      this.$store.commit({
        type: "setAppConfigObj",
        data: JSON.parse(JSON.stringify(row._source))
      });
      this.orgConfig = row;
      this.dialogHeaderVisible = false;
      this.currentHeader = {};
      this.isAdd = false;
      this.dialogFormVisible = true;
    },
    handleDelete(index, row) {
      this.$confirm("This will permanently delete the application. Continue?", "Warning", {
        confirmButtonText: "OK",
        cancelButtonText: "Cancel",
        type: "warning"
      })
        .then(() => {
          //this.tableData.splice(index, 1);
          this.$store.commit({
            type: "deleteRecord",
            data: row
          });
          setTimeout(() => {
            this.loadData();
          }, 1000);
          this.$notify({
            title: "Success",
            type: "success",
            message: "Delete completed",
            position: "bottom-right"
          });
        })
        .catch(() => {
          this.$notify({
            title: "Cancelled",
            type: "info",
            message: "Delete canceled",
            position: "bottom-right"
          });
        });
    }
  },
  created: function () {
    this.loadData();
  },
  components: { Draggable }
};
</script>
<style>
.el-row {
  margin-bottom: 5px;
}

.searchfield {
  width: 150px !important;
}
</style>
