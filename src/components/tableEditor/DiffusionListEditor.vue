<template>
  <el-dialog 
      width="800px" 
      title="Distribution List" 
      :visible.sync="dialogFormVisible"
      :before-close="closeDialog"
      :close-on-click-modal="false"
      class="entities-editor">    



        <el-row style="text-align:left;">
          <el-button
              @click="setFocus('author')" 
              type="text">Author</el-button>
        </el-row>

       
        <el-row style="text-align:left;">
          <el-input 
            class="entities-name-input"
            ref="author"
            placeholder="entities name" 
            v-model="newRec._source.header.auteur"
            size="mini">
          </el-input>
        </el-row>


        <el-row style="text-align:left;">
          <el-button
              @click="setFocus('recipientList')" 
              type="text">Recipient List</el-button>
        </el-row>

        <el-row style="text-align:left;">
          <el-card shadow="hover">
            <table class="table-entities">
              <thead class="thead-entities">
                <tr>
                  <th scope="col">Name</th>
                  <th style="text-align:left;" scope="col">Company</th>
                  
                  <th scope="col">Mail</th>
                  <th scope="col"></th>
                  <th scope="col"></th>
                </tr>
              </thead>
              <draggable v-bind="dragOptions" v-model="newRec._source.header.list" tag="tbody" handle=".handle">
                <tr v-for="(item, index) in newRec._source.header.list" :key="index">
                  <!-- <td scope="row">{{ item.name }}</td> -->
                  <td scope="row">
                    <el-input 
                      
                      class="entities-name-input"
                      ref="author"
                      placeholder="Name" 
                      v-model="item.name"
                      size="mini"
                      >
                    </el-input>
                  </td>
                  <!-- <td style="text-align:left;">{{ item.company }}</td> -->
                  <td style="text-align:left; width:200px;">
                    <el-select
                      style="width:100%"
                      v-model="item.company"
                      filterable
                      allow-create
                      size="mini"
                      default-first-option
                      placeholder="Company">
                      <el-option
                        v-for="comp in companyList"
                        :key="comp"
                        :label="comp"
                        :value="comp">
                      </el-option>
                    </el-select>
                  </td>
                  <td scope="row" style="width:250px;">
                    <el-input 
                      
                      class="entities-name-input"
                      ref="author"
                      placeholder="Mail" 
                      v-model="item.mail"
                      size="mini"
                      >
                    </el-input>
                  </td>
                  
                  <td style="text-align:left; ">
                    <el-button
                      size="mini"
                      circle
                      plain
                      type="danger"
                      @click="handleDeleteRecipient(index)"
                      icon="el-icon-close"
                    ></el-button>
                    
                
                  
                  </td>
                  <td><i class="el-icon-d-caret handle"></i></td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-row>





        <el-row style="text-align:center; margin-top:30px;">
          <el-button 
            size="small"
            round
            type="primary"
            @click="addRecipient"
            class="add-view-button">
            Add a recipient
          </el-button>
        </el-row>





    <span slot="footer" class="dialog-footer">
      <el-button @click="$emit('dialogclose')">{{this.$t("buttons.cancel")}}</el-button>
      <el-button v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
        type="primary"
        :disabled="!recchanged"
        @click="saveRecord()"
      >{{this.$t("buttons.confirm")}}</el-button>
    </span>
 
  </el-dialog>
</template>

<script>
import Vue from "vue";

import diffusionList from "@/components/tableEditor/DiffusionListEditor";
import axios from "axios";



Vue.component("DiffusionList", diffusionList);

export default {
  name: "entitiesEditor",
  data: () => ({
    activeName: "first",
    orgRec: null,
    newRec: null,
    strOrgRec: '',
    strNewRec: '',
    formLabelWidth: "120px",
    viewList: [],
    viewListAll: [],
    currentView: null,
    newView: null,
    dialogAddViewVisible: false,
    dialogFormVisible: false,
    dialogViewVisible: false,
    viewToModify: null,
    dragging: false,
    companyList: [
      'Cofely',
      'Brussels Airport Company',
    ]
  }),
  computed: {
    recordin: function() {
      return this.record;
    },
    recordstr:function(){
      return JSON.stringify(this.record);
    },
    newrecordstr:function(){
      return JSON.stringify(this.newRec);
    },
    viewliststr:function(){
      return JSON.stringify(this.viewList);
    },
    viewlistorgstr:function(){
      return JSON.stringify(this.viewListOrg);
    },
    newrecordstryaml:function(){
      return this.strNewRec;
    },
    recchanged:function() {
      return JSON.stringify(this.recordin)!=JSON.stringify(this.newRec);
    },
    dragOptions() {
      return {
        animation: 0,
        group: "description",
        disabled: false,
        ghostClass: "ghost"
      };
    },
  },
  props: {
    record: {
      type: Object
    }
    ,config: {
      type: Object
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
  created:function() {
    console.log('mounted event')
    this.prepareData();
  },
  methods: {
    setFocus: function(el) {
      this.$nextTick(() => this.$refs[el].focus());
    },
    closeDialog: function() {
      this.$emit("dialogclose");
    },
    refresh: function() {
      this.strNewRec = ''
      this.strOrgRec = ''

      this.$nextTick(() => {
          this.refresh2()
      })
    },
    refresh2: function() {


      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
      
    },
    prepareData: function() {
      console.log('prepare data')
      console.log(this.record._id)
      this.strNewRec = ''
      this.strOrgRec = ''
      
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
      

      console.log(this.newRec._id)
      console.log(this.orgRec._id)

      for(var i=0; i < this.orgRec._source.header.list.length; i++) {
        var company = this.orgRec._source.header.list[i].company
        if(!this.companyList.includes(company))
          this.companyList.push(company)
      }

      
      
      this.dialogFormVisible=true
    },
    handleDeleteRecipient(index) {
      this.newRec._source.header.list.splice(index, 1);
    },
    addRecipient() {
      this.newRec._source.header.list.push({
        company:'',
        name:'',
      })
    },
    saveRecord:function()
    {  
      var id_array = []
      for(var i in this.viewList) {
        var obj = {
          'id': this.viewList[i].id
        }
        id_array.push(obj)
      }


      this.newRec._source.name = this.newName
      this.newRec._source.id_array = id_array


      console.log(this.orgRec._source.id_array)
      console.log(this.newRec._source.id_array)

      this.$store.commit({
        type: "updateRecord",
        data: this.newRec
      });
      this.$emit("dialogcloseupdated")
      this.$notify({
        title: "Record saved.",
        type: "success",
        message: "Record updated.",
        position: "bottom-right"
      });
    },
  }
};
</script>

<style >
.entities-editor .view-table {
  margin-bottom:30px;
}
.entities-editor .add-view-button {
  margin-bottom:30px;
}


.entities-editor .table-entities {
  width: 100%;
  border-spacing: 0px !important;
}

.entities-editor .thead-entities th{
  padding-bottom: 10px;
}

.entities-editor .table-entities tr{
}
.entities-editor .table-entities td{
  padding:5px;
  border-top: solid 1px #ebeef5;

  
}

.entities-editor .flip-list-move {
  transition: transform 0.5s;
}
.entities-editor .no-move {
  transition: transform 0s;
}
.entities-editor .handle {
  cursor: move;
}

.entities-editor .ghost {
  opacity: 0.2;
  /* background-color: #409eff !important; */
}

.entities-editor .sortable-chosen {
  color: white;
  background-color: #409eff !important;
}
  
</style>