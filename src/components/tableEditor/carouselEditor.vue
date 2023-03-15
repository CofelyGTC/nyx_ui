<template>
  <el-dialog
    width="80%"
    title="Carousel editor"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="carousel-editor"
    v-if="newRec"
  >
    <el-dialog
      width="30%"
      title="Select a view"
      :visible.sync="dialogAddViewVisible"
      append-to-body
    >

      <el-select
        size="small"
        v-model="newView"
        filterable
        placeholder="Select"
        @change="viewSelected()"
      >
        <el-option
          v-for="item in viewListAll"
          :key="item.id"
          :label="item.type + ' - ' + item.description + ' ('+item.duration/1000+'s)'"
          :value="item"
        ></el-option>
      </el-select>
    </el-dialog>
    <ViewEditor
      v-if="dialogViewVisible"
      :record="viewToModify"
      :config="config"
      v-on:dialogcloseupdated="viewUpdated()"
      v-on:dialogclose="dialogViewVisible=false;"
    ></ViewEditor>
      <span slot="title" class="dialog-header">
        <el-row type="flex" class="row-bg" justify="space-between">
          <el-col :span="12" style="text-align:left;">
            <h1 style=" color:white;">{{orgRec._source.name}}</h1>
          </el-col>
          <el-col :span="12" style="text-align:right;">
            <el-button
              :disabled="loading || !recchanged || newRec._source.name==''"
              type="primary"
              size="small"
              @click="submitForm('newRec')"
            >{{this.$t("buttons.save")}}</el-button>
            <el-button plain size="small" @click="closeDialog">{{this.$t("buttons.quit")}}</el-button>
          </el-col>
        </el-row>
      </span>

    <el-form :model="newRec" :rules="rules" ref="newRec">
    <el-row style="text-align:left;">
      <el-col :span="12">
        <el-button @click="setFocus('carName')" type="text">Carousel Name</el-button>
      </el-col>
      <el-col :span="12" v-if="newRec._source.client || $store.getters.creds.hasPrivilege('admin')">
        <el-button @click="setFocus('client')" type="text">Client</el-button>
      </el-col>
    </el-row>

    <el-row>
      <el-col :span="12" class="padding-right">
        <el-form-item label="" prop="_source.name">
          <el-input
            placeholder="carousel name"
            :disabled="!$store.getters.creds.hasPrivilege('admin')"
            ref="carName"
            v-model="newRec._source.name"
            size="small"
          ></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="12"  v-if="newRec._source.client || $store.getters.creds.hasPrivilege('admin')">
        <el-input
          placeholder="clients to filter"
          :disabled="!$store.getters.creds.hasPrivilege('admin')"
          ref="client"
          v-model="newRec._source.client"
          size="small"
        ></el-input>
      </el-col>
    </el-row>
    <el-row style="text-align:left;" v-if="viewList && viewList.length>0">
      <el-col :span="8">
        <el-button type="text">Views</el-button>
      </el-col>
    </el-row>

    <el-row>
      <el-card 
        
        :body-style="{ padding: '0px' }" style="margin-bottom:20px;" shadow="never" v-if="viewList && viewList.length>0">
        <table class="table-carousel" v-loading="loadingViewList">
          <thead class="thead-carousel">
            <tr>
              <th scope="col"></th>
              <th style="text-align:left;" scope="col">Type</th>
              <th style="text-align:left;" scope="col">Description</th>
              <th style="text-align:left;" scope="col">Duration</th>
              <th style="text-align:left;" scope="col">Actions</th>
              <th scope="col"></th>
            </tr>
          </thead>
          <draggable v-bind="dragOptions" v-model="viewList" tag="tbody" handle=".handle">
            <tr v-for="(item, index) in viewList" :key="index" >
              <td scope="row"><el-button
                  size="small"
                  circle=""
                  plain
                  type="danger"
                  @click="handleDeleteView(index)"
                  icon="el-icon-close"
                ></el-button></td>
              <td style="text-align:left;" scope="row">{{ item.type }}</td>
              <td style="text-align:left;">{{ item.description }}</td>
              <td style="text-align:left;">{{ item.duration }}</td>
              <td style="text-align:left; width:400px;">
                

                <el-button
                  size="small"
                  v-if="!(item.type=='kibana' && $store.getters.creds.hasPrivilege('optiboard-nokibana') && !$store.getters.creds.hasPrivilege('admin'))"
                  round
                  @click="clickModifyView(item)"
                  icon="el-icon-setting"
                >Modify</el-button>
                <el-button
                  v-show="item.type!='optiboard'"
                  size="small"
                  round
                  @click="handlePreviewView(index)"
                  icon="el-icon-view"
                >Preview</el-button>
                <el-button
                  v-if="item.type=='kibana' && (!$store.getters.creds.hasPrivilege('optiboard-nokibana') || $store.getters.creds.hasPrivilege('admin'))"
                  size="small"
                  round
                  type="danger"
                  plain
                  @click="handleOpenInKibana(index)"
                  icon="el-icon-news"
                >Open in Kibana</el-button>
              </td>
              <td>
                <i class="el-icon-d-caret handle"></i>
              </td>
            </tr>
          </draggable>
        </table>
      </el-card>
    </el-row>

    <el-row style="height:40px;">
      <el-button size="small" type="primary" @click="addExistingView" class="add-view-button" icon="el-icon-plus">Add Exsting view</el-button>
      <el-button size="small" type="" @click="addNewView" class="add-view-button" icon="el-icon-edit">Create New view</el-button>
    </el-row>

    </el-form>
  </el-dialog>
</template>

<script>
//import Vue from "vue";
import axios from "axios";
import _ from "lodash";

import vieweditor from "@/components/tableEditor/ViewEditor";

//Vue.component("ViewEditor", vieweditor);

export default {
  name: "carouselEditor",
  data: () => ({
    activeName: "first",
    orgRec: null,
    newRec: null,
    loading: false,
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    changed: false,
    viewList: [],
    viewListAll: [],
    currentView: null,
    newView: null,
    dialogAddViewVisible: false,
    dialogFormVisible: false,
    dialogViewVisible: false,
    viewToModify: null,
    viewModifyMode: 'add',
    dragging: false,
    loadingViewList: false,
    rules: {
      _source: {
        name : [
          { required: true, message: "Carousel name cannot be empty", trigger: "change" }
        ],
      }
    },
  }),
  computed: {
    recordin: function() {
      return this.record;
    },
    recchanged: function() {
      return JSON.stringify(this.recordin) != JSON.stringify(this.newRec);
    },
    dragOptions() {
      return {
        animation: 0,
        group: "description",
        disabled: false,
        ghostClass: "ghost"
      };
    }
  },
  props: {
    record: {
      type: Object
    },
    config: {
      type: Object
    }
  },
  watch: {
    viewList: {
      handler: function() {
        this.viewListToRecord()
      },
      deep: true
    },
    // viewListAll: {
    //   handler: function() {
    //     this.viewListAllToViewList()
    //   },
    //   deep: true
    // },
  },
  mounted: function() {
    console.log("mounted event");
    console.log(this.record)
    this.prepareData();
  },
  components: {
    vieweditor:"ViewEditor"
  },
  methods: {
    closeDialog: function() {
      if (!(this.loading || !this.recchanged || this.newRec._source.name==''))
      {
        this.$confirm('There are unsaved changes. Continue?', 'Warning', {
          confirmButtonText: 'OK',
          cancelButtonText: 'Cancel',
          type: 'warning'
        }).then(() => {
          this.$emit("dialogclose");
        })      
      }
      else
        this.$emit("dialogclose");
    },
    viewListToRecord: _.debounce(function() {
      this.newRec._source.id_array = this.viewList.map(function (obj) {
                                                        return {'id': obj.id};
                                                      });
    }, 500),
    viewListAllToViewList: _.debounce(function() {
      console.log('viewListAllToViewList')
      console.log(this.newRec._source.id_array)
      
      this.viewList = []

      for (var i in this.newRec._source.id_array) {
        for (var j in this.viewListAll) {
          var viewRec = this.viewListAll[j];
          if (this.newRec._source.id_array[i].id == viewRec.id) {
            this.viewList.push(JSON.parse(JSON.stringify(viewRec)));
          }
        }
      }

      var tmp = JSON.parse(JSON.stringify(this.viewList));
      this.viewList = null;
      this.viewList = JSON.parse(JSON.stringify(tmp));
    }, 500),
    prepareData: function() {
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));

      // if (this.orgRec._source.id_array == null) {
      //   this.orgRec._source.id_array = [];
      // }

      this.getViews();

      this.dialogFormVisible = true;
      this.changed = false;
    },
    handleCurrentViewChange(val) {
      this.currentView = val;
    },
    handleEditView(index, row) {
      // eslint-disable-line
      //this.dialogHeaderVisible = true; -> coming soon
    },
    handleDeleteView(index) {
      this.currentView = null;
      this.viewList.splice(index, 1);
    },
    handleMoveView(index, row, down) {
      this.viewList.splice(index, 1);
      if (down) this.viewList.splice(index - 1, 0, row);
      else this.viewList.splice(index + 1, 0, row);
    },
    handleOpenInKibana(index) {
      window.open(
        this.viewList[index].target
          .replace("kibananyx", "kibana")
          .replace("embed=true", "")
          .replace(",title:Test", "")
          .replace("title:Test,", "")
      );
    },
    handlePreviewView(index) {
      window.open(this.viewList[index].target);
    },
    addExistingView() {
      this.newView = null;
      this.dialogAddViewVisible = true;
    },
    viewSelected() {
      this.viewList.push(JSON.parse(JSON.stringify(this.newView)));
      this.dialogAddViewVisible = false;
    },
    viewUpdated() {

      if(this.viewModifyMode == 'add') {
        this.newRec._source.id_array.push({'id':this.viewToModify._id});
      }

      this.loadingViewList = true;
      setTimeout(() => {
        this.getViews();
      }, 1500);


      this.viewToModify = null;
      this.dialogViewVisible = false;

    },
    addNewView() {
      this.viewModifyMode = 'add'
      this.viewToModify = {
        _id: "id_" + Math.floor((1 + Math.random()) * 0x1000000),
        _index: 'nyx_view_carousel',
        _source: {
          duration: 30000
        }
      };

      if(this.newRec._source.client)
        this.viewToModify._source.client = this.newRec._source.client

      this.dialogViewVisible = true;
    },
    clickModifyView(view) {
      this.viewModifyMode = 'modify'
      var url =
        this.$store.getters.apiurl +
        "generic/nyx_view_carousel/" +
        view.id +
        "?token=" +
        this.$store.getters.creds.token;
      axios
        .get(url)
        .then(response => {
          if (response.data.error != "") console.log("GET VIEW ERROR...");
          else {
            this.viewToModify = response.data.data;
            this.dialogViewVisible = true;
          }
        })
        .catch(error => {
          console.log(error);
        });
    },
    submitForm(formName) {

      this.$refs[formName].validate((valid) => {
          if (valid) {
            this.saveRecord();
          } else {
            console.log('error submit!!');
            return false;
          }
        });
    },
    saveRecord: function() {
      this.$store.commit({
        type: "updateRecord",
        data: this.newRec
      });
      this.$emit("dialogcloseupdated");
      this.$notify({
        title: "Record saved.",
        type: "success",
        message: "Record updated.",
        position: "bottom-right"
      });
    },
    getViews() {
      // this.viewList = [];
      this.loadingViewList = true
      this.viewListAll = [];
      var url =
        this.$store.getters.apiurl +
        "generic_search/nyx_view_carousel*?token=" +
        this.$store.getters.creds.token;

      var query = {
        size: 2000,
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
        .then(response => {
          if (response.data.error != "")
            console.log("generic search view carousel error...");
          else {
            for (var i in response.data.records) {
              var viewRec = response.data.records[i];

              var viewObj = {
                id: viewRec._id,
                type: viewRec._source.type,
                description: viewRec._source.description,
                duration: viewRec._source.duration,
                target: viewRec._source.target
              };

              this.viewListAll.push(viewObj);
            }

            this.viewListAllToViewList()

            this.loadingViewList = false
          }
        })
        .catch(error => {
          this.loadingViewList = false
          console.log(error);
        });
    },

    setFocus: function(el) {
      this.$nextTick(() => this.$refs[el].focus());
    },
    setFocusInput: function() {
      let input = this.$refs.indexPattern;
      this.$nextTick(() => input.focus());
    },
    setFocusSelect: function() {
      let select = this.$refs.timeField;
      this.$nextTick(() => select.focus());
    }
  }
};
</script>

<style >
.carousel-editor .view-table {
  margin-bottom: 30px;
}

.carousel-editor .add-view-button {
  margin-bottom: 30px;
}

.carousel-editor .table-carousel {
  width: 100%;
  border-spacing: 0px !important;
}

.carousel-editor .thead-carousel th {
  padding-bottom: 10px;
}

.carousel-editor .table-carousel td {
  padding: 5px;
  border-top: solid 1px #ebeef5;
}

.carousel-editor .flip-list-move {
  transition: transform 0.5s;
}
.carousel-editor .no-move {
  transition: transform 0s;
}
.carousel-editor .handle {
  cursor: move;
}

.carousel-editor .ghost {
  opacity: 0.2;
  /* background-color: #409eff !important; */
}

.carousel-editor .sortable-chosen {
  color: white;
  background-color: #409eff !important;
}


.carousel-editor .padding-right {
  padding-right: 10px;
}
.carousel-editor .el-form-item__content {
  padding-bottom: 5px;
  line-height: normal;
}
</style>