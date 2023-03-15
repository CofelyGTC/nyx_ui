<template>
  <el-dialog
    width="70%"
    top="15%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="circuit-room"
    append-to-body
  >
    <div>
      <el-form v-model="newRec._source">
        <el-row>
          <el-col>
            <el-form-item
              label="Nom du circuit:"
              size="small"
              :label-width="formLabelWidth"
            >
              <el-input
                v-model="circuitName"
                placeholder="Veuillez enter un nom..."
              ></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="6">
            <el-form-item label="Ajouter Local: " :label-width="formLabelWidth">
              <el-select
                v-model="selectedRoom"
                filterable
                placeholder="Sélectionner"
              >
                <el-option
                  v-for="(item, id) in rooms"
                  :key="id"
                  :label="item"
                  :value="item"
                >
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-button type="primary" @click="addRoom()"> Appliquer </el-button>
          </el-col>
        </el-row>

        <h1 style="text-align: center">Locaux</h1>
        <el-row style="text-align: left">
          <el-col v-for="(item, index) in newRec._source.rooms" :key="index">
            <el-row style="text-align: left">
              <el-col :span="6">
                {{ item }}
              </el-col>
              <el-col :span="6">
                <el-button
                  @click="removeRoom(index)"
                  type="danger"
                  :icon="ElIconDelete"
                  circle
                >
                </el-button>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
      </el-form>
    </div>
    <span slot="footer" class="dialog-footer">
      <el-button
        v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
        type="primary"
        @click="saveRecord()"
        >{{ this.$t('buttons.confirm') }}</el-button
      >
      <el-button @click="$emit('dialogclose')">{{
        this.$t('buttons.cancel')
      }}</el-button>
    </span>
  </el-dialog>
</template>

<script>
import { Delete as ElIconDelete } from '@element-plus/icons'

import Vue from 'vue'
import axios from 'axios'
export default {
  data() {
    return {
      ElIconDelete,
    }
  },
  name: 'circuitRoom',
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: '',
    strNewRec: '',
    orgName: '',
    newName: '',
    formLabelWidth: '120px',
    formLabelWidth2: '100px',
    changed: false,
    dialogFormVisible: false,
    title: 'Configuration Circuits',
    rooms: [],
    circuitName: null,
    selectedRoom: '',
  }),
  mounted: function () {
    console.log('mounted event')
  },
  created: function () {
    this.prepareData()
  },
  props: {
    record: {
      type: Object,
    },
    config: {
      type: Object,
    },
  },
  components: {},
  methods: {
    closeDialog: function () {
      this.$emit('dialogclose')
    },
    prepareData: function () {
      console.log('prepare data')
      this.dialogFormVisible = true
      this.getRooms()
      this.newRec = JSON.parse(JSON.stringify(this.record))
      this.orgRec = JSON.parse(JSON.stringify(this.record))
      this.circuitName = this.newRec._source.name
    },
    saveRecord: function () {
      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.lastUpdate = Date.now()
      this.newRec._source.name = this.circuitName
      console.log(this.newRec)
      this.$store.commit({
        type: 'updateRecord',
        data: this.newRec,
      })
      this.$notify({
        title: 'Record saved.',
        type: 'success',
        message: 'Le produit a été enregistrée.',
        position: 'bottom-right',
      })
      this.$emit('dialogcloseupdated')
    },

    getRooms: function () {
      var url =
        this.$store.getters.apiurl +
        'lambdas/5/getrooms?apikey=' +
        this.$store.getters.creds.token
      var body = {}
      axios.post(url, body).then((response) => {
        this.rooms = response.data.rooms
        this.$forceUpdate()
      })
    },

    addRoom: function () {
      this.newRec._source.rooms.push(this.selectedRoom)
    },

    removeRoom: function (index) {
      this.newRec._source.rooms.splice(index, 1)
    },
  },
}
</script>

<style>
.script-editor .view-table {
  margin-bottom: 30px;
}
.script-editor .script-name-input {
  margin-bottom: 10px;
}

.script-editor .add-view-button {
  margin-bottom: 30px;
}
.label-form {
  text-align: center;
}
</style>
