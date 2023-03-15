<template>
  <div>
    <!-- MAIN DIALOG -->
    <ConfigDetails
      v-if="dialogFormVisible"
      :allPrivileges="privilegesdata"
      :isAdd="isAdd"
      :orgConfig="orgConfig"
      :currentConfig="curConfig"
      v-on:dialogclose="dialogClosed()"
    ></ConfigDetails>
    <el-table
      size="small"
      :data="tableData.filter(data => !search || ((JSON.stringify(data._source).toLowerCase().includes(search.toLowerCase()))))"
      :default-sort="{prop: '_source.title', order: 'descending'}"
      style="width: 100%"
      highlight-current-row
      @current-change="handleCurrentChange"
      height="1000"
    >
      <el-table-column sortable prop="_source.category" label="Category"></el-table-column>
      <el-table-column sortable prop="_source.subcategory" label="Subcategory"></el-table-column>
      <el-table-column sortable prop="_source.title" label="Title"></el-table-column>
      <el-table-column sortable prop="_source.type" label="Type"></el-table-column>
      <el-table-column sortable prop="_source.order" label="Order" width="80"></el-table-column>

      <el-table-column width="60">
        <template v-slot="scope">
          <el-popover
            v-if="scope.row._source.privileges?true:false"
            placement="left-start"
            title="Privileges"
            width="200"
            trigger="hover"
            size="small"
          >
          <span :key="item" v-for="item in scope.row._source.privileges">
            &nbsp;
            <el-tag size="small">{{item}}</el-tag>
          </span>
          <template #reference>
            <el-button size="small" slot="reference">{{scope.row._source.privileges.length}}</el-button>
          </template>
          </el-popover>
        </template>
      </el-table-column>
      <el-table-column align="right" width="300">
        <!-- Removed from line below: slot-scope="scope" -->
        <template v-slot:header="scope">
          <el-row style="float:right">
            <div style="padding:10px">
              <el-tooltip
                v-if="currentRow"
                class="item"
                effect="light"
                content="Duplicate"
                placement="bottom-end"
              >
                <el-button
                  circle
                  size="small"
                  @click="duplicate()"
                  class="dupbutton"
                  type="primary"
                >
                  <el-icon><CopyDocument /></el-icon>
                </el-button>
              </el-tooltip>
              <el-tooltip class="item" effect="light" content="Add" placement="bottom">
                <el-button
                  circle
                  size="small"
                  @click="handleAddApp()"
                  class="addbutton"
                  type="primary"
                >
                  <el-icon><Plus /></el-icon>
              </el-button>
              </el-tooltip>
              <el-tooltip class="item" effect="light" content="Reload" placement="bottom-start">
                <el-button
                  circle
                  size="small"
                  @click="reloadConfig()"
                  class="regreshbutton"
                  plain
                >
                <el-icon><Refresh /></el-icon>
              </el-button>
              </el-tooltip>
            </div>
            <el-input v-model="search" size="small" placeholder="Type to search" class="searchfield" style="padding:10px" />
        </el-row>
        </template>
        <template v-slot="scope">
          <v-icon
            v-if="scope.row._source.icon"
            :icon="scope.row._source.icon"
            scale="1"
            style="margin-bottom:-3px;"
          />&nbsp;&nbsp;
          <el-button
            size="small"
            plain
            @click="handleEdit(scope.$index, scope.row)"
          >
            <el-icon><Setting /></el-icon>
          </el-button>
          <el-button
            size="small"
            type="danger"
            plain
            @click="handleDelete(scope.$index, scope.row)"
          >
            <el-icon><Delete /></el-icon>
          </el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>
<script>
import axios from "axios";

////import Vue from "vue";

import ConfigDetails from "@/components/ConfigDetails";
import {CopyDocument,Plus,Refresh,Setting,Delete} from '@element-plus/icons-vue';

export default {
  components:{ConfigDetails},
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
    privilegesdata: function() {
      var data = [];
      for (var i in this.$store.getters.privileges) {
        var priv = this.$store.getters.privileges[i];
        data.push({
          value: priv._source.value,
          desc: priv._source.name
        });
      }

      return data
    },
  },
  methods: {
    dialogClosed() {
      this.dialogFormVisible = false;
      setTimeout(() => {
        this.loadData();
      }, 1000);
    },
    reloadConfig() {
      var url =
        this.$store.getters.apiurl +
        "reloadconfig?token=" +
        this.$store.getters.creds.token;
      axios
        .get(url)
        .then(response => {
          if (response.data.error != "") console.log("Reload error...");
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
      var url =
        this.$store.getters.apiurl +
        "generic_search/nyx_app*?token=" +
        this.$store.getters.creds.token;
      axios
        .post(url, { size: 300 })
        .then(response => {
          if (response.data.error != "") console.log("User list error...");
          else {
            this.tableData = response.data.records;
          }
        })
        .catch(error => {
          console.log(error);
        });
    },
    duplicate() {
      console.log(this.currentRow);

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
      
      if(row._source.config == null) {
        row._source.config = {
          headercolumns: [], 
          tableFieldsToDownload: [], 
          tableFieldsToFilter: [], 
          writeprivileges: [], 
          queryfilters: [] 
        }
      }

      
      if(row._source.config.headercolumns == null)
        row._source.config.headercolumns = []
      
      if(row._source.config.tableFieldsToDownload == null)
        row._source.config.tableFieldsToDownload = []
      
      if(row._source.config.tableFieldsToFilter == null)
        row._source.config.tableFieldsToFilter = []
      
      if(row._source.config.queryfilters == null)
        row._source.config.queryfilters = []
      
      if(row._source.queryBarChecked == null)
        row._source.queryBarChecked = false
      
      if(row._source.queryFilterChecked == null)
        row._source.queryFilterChecked = false

      if(row._source.config.writeprivileges == null)
        row._source.config.writeprivileges = []
      else if(typeof(row._source.config.writeprivileges) == 'string')
        row._source.config.writeprivileges = [row._source.config.writeprivileges]
        
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
      this.$confirm(
        "This will permanently delete the application. Continue?",
        "Warning",
        {
          confirmButtonText: "OK",
          cancelButtonText: "Cancel",
          type: "warning"
        }
      )
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
  created: function() {

    this.loadData();
  }
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
