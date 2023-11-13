<template>
  <div>
    <el-table class="headertable" :data="$store.getters.filteredmenus" @current-change="handleCurrentHeaderChange" border
      style="width: 100%">
      <!-- Submenus -->
      <el-table-column type="expand">
        <template slot-scope="data">
          <el-table :data="data.row.submenus" @current-change="handleCurrentHeaderChange" :show-header="false">
            <!-- Apps -->
            <el-table-column type="expand" :show-header="false">
              <template slot-scope="scopesubmenus">
                <el-table :data="scopesubmenus.row.apps" @current-change="handleCurrentHeaderChange" :show-header="false">
                  <el-table-column prop="title"></el-table-column>
                  <el-table-column width="100" style="border-color: #70bd95;" border-color="#70bd95">
                    <template slot-scope="scopesubapps" style="border-color: #70bd95;" border-color="#70bd95">
                      <el-button size="mini" circle type="primary" style="background-color: #70BD95;"
                        @click="handleSubappsMoveHeader(data.$index, data.row, scopesubmenus.$index, scopesubmenus.row, scopesubapps.$index, scopesubapps.row, false)"
                        icon="el-icon-arrow-down"
                        v-if="scopesubapps.$index < scopesubmenus.row.apps.length - 1"></el-button>
                      <el-button size="mini" circle type="primary" style="background-color: #70BD95;"
                        @click="handleSubappsMoveHeader(data.$index, data.row, scopesubmenus.$index, scopesubmenus.row, scopesubapps.$index, scopesubapps.row, true)"
                        icon="el-icon-arrow-up" v-if="scopesubapps.$index > 0"></el-button>
                    </template>
                  </el-table-column>
                </el-table>
              </template>
            </el-table-column>
            <el-table-column prop="title"></el-table-column>
            <el-table-column prop="title" width="100">
              <template slot-scope="scopesubmenus">
                <el-button size="mini" circle type="primary" style="background-color: #004e7a;"
                  @click="handleSubmenusMoveHeader(data.$index, data.row, scopesubmenus.$index, scopesubmenus.row, false)"
                  icon="el-icon-arrow-down" v-if="scopesubmenus.$index < data.row.submenus.length - 1"></el-button>
                <el-button size="mini" circle type="primary" style="background-color: #004e7a;"
                  @click="handleSubmenusMoveHeader(data.$index, data.row, scopesubmenus.$index, scopesubmenus.row, true)"
                  icon="el-icon-arrow-up" v-if="scopesubmenus.$index > 0"></el-button>
              </template>
            </el-table-column>
          </el-table>
        </template>
      </el-table-column>
      <el-table-column prop="category" label="Category"></el-table-column>
      <el-table-column prop="title" label="Action" width="100">
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
    },
    handleMoveHeader(index, row, down) {
      var storeData = this.$store.getters.filteredmenus
      storeData.splice(index, 1);
      if (down) storeData.splice(index - 1, 0, row);
      else storeData.splice(index + 1, 0, row);
      var targetIndex = down ? index - 1 : index
      for (let index = 0; index < storeData.length; index++) {
        if (index == targetIndex || index == targetIndex + 1) {
          const targetCategory = storeData[index].category.toLowerCase();
          const filteredItems = this.tableData.filter(item =>
            item._source && item._source.category &&
            item._source.category.toLowerCase() === targetCategory
          );
          filteredItems.forEach(element => {
            element._source.order = (index + 1) * Math.pow(10, 4) + (element._source.order % 10000)
            this.$store.commit({
              type: "updateRecord",
              data: element
            });
            // console.log(`element: ${this.tableData.indexOf(element)}"${element._source.category.toLowerCase()}/${element._source.subcategory.toLowerCase()}/${element._source.title.toLowerCase()}"  ${element._source.order}`);
          })
          
        }
      }
    },
    handleSubmenusMoveHeader(parentindex, parentrow, index, row, down) {
      var storeData = this.$store.getters.filteredmenus
      var category = storeData[parentindex].category.toLowerCase()
      var submenus = storeData[parentindex].submenus
      submenus.splice(index, 1);
      if (down) submenus.splice(index - 1, 0, row);
      else submenus.splice(index + 1, 0, row);
      var targetIndex = down ? index - 1 : index
      for (let index = 0; index < submenus.length; index++) {
        if (index == targetIndex || index == targetIndex + 1) {
          const targetSubmenus = submenus[index].title.toLowerCase();
          const filteredItems = this.tableData.filter(item =>
            item._source && item._source.category &&
            item._source.category.toLowerCase() === category &&
            item._source.subcategory.toLowerCase() === targetSubmenus
          );
          filteredItems.forEach(element => {
            element._source.order = Math.floor(element._source.order / 10000) * Math.pow(10, 4) + index * Math.pow(10, 2) + element._source.order % 100;
            // console.log(`element: ${this.tableData.indexOf(element)}"${element._source.category.toLowerCase()}/${element._source.subcategory.toLowerCase()}/${element._source.title.toLowerCase()}"  ${element._source.order}`);
            if (element) {
              this.$store.commit({
                type: "updateRecord",
                data: element
              });
            }
          });
        }
      }
    },
    handleSubappsMoveHeader(parentindex, parentrow, subindex, subrow, index, row, down) {
      var storeData = this.$store.getters.filteredmenus
      var category = storeData[parentindex]
      var submenus = category.submenus[subindex]
      var apps = submenus.apps
      apps.splice(index, 1);
      if (down) apps.splice(index - 1, 0, row);
      else apps.splice(index + 1, 0, row);
      var targetIndex = down ? index - 1 : index
      for (let index = 0; index < apps.length; index++) {
        if (index == targetIndex || index == targetIndex + 1) {
          const targetApps = apps[index].title.toLowerCase();
          const filteredItems = this.tableData.find(item =>
            item._source.category.toLowerCase() === category.category.toLowerCase() &&
            item._source.subcategory.toLowerCase() === submenus.title.toLowerCase() &&
            item._source.title.toLowerCase() === targetApps
          );
          filteredItems._source.order = Math.floor(filteredItems._source.order / 100) * 100 + index;
          console.log('filteredItems: ', filteredItems);
          if (filteredItems) {
            this.$store.commit({
              type: "updateRecord",
              data: filteredItems
            });
          }
        }
      }
    },
    loadData() {
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
            // this.tableData.forEach(element => {
            //   if (!element._source.subcategory) console.log(`element: ${this.tableData.indexOf(element)}"${element._source.category.toLowerCase()}/${element._source.title.toLowerCase()}" `);
            //   else console.log(`element: ${this.tableData.indexOf(element)}"${element._source.category.toLowerCase()}/${element._source.subcategory.toLowerCase()}/${element._source.title.toLowerCase()}" `);
            // });
          }
        })
        .catch(error => {
          console.log(error);
        });
    },
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

.el-table__expanded-cell[class*=cell] {
  /* padding-left: 44px !important; */
  padding-top: 0px !important;
  padding-bottom: 0px !important;
  border-style: inset;
  border-right: 0px !important;
  border-width: 3px;
  /* border-left: 5px !important; */
}
</style>
