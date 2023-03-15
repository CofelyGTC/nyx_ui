<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="cakedeco-editor"
  >
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
        <el-row>
          <el-col :span="8">
            <el-form-item label="Référence" :label-width="formLabelWidth">
              <el-input placeholder="..." v-model="newRec._source.reference">
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Catégorie" :label-width="formLabelWidth">
              <el-input placeholder="..." v-model="newRec._source.category">
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Nom" :label-width="formLabelWidth">
              <el-input placeholder="..." v-model="newRec._source.name">
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item
              label="Nbre de Personnes"
              :label-width="formLabelWidth"
            >
              <el-input-number
                v-model="newRec._source.nbre_pers"
                :step="1"
                :min="1"
              >
              </el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Prix de reviens" :label-width="formLabelWidth">
              <el-input-number
                v-model="newRec._source.prix_reviens"
                :step="0.01"
                :min="0"
              >
              </el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Prix final" :label-width="formLabelWidth">
              <el-input-number
                v-model="newRec._source.prix"
                :step="0.01"
                :min="0"
              >
              </el-input-number>
            </el-form-item>
          </el-col>
        </el-row>
      </el-card>
    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button @click="$emit('dialogclose')">{{
        this.$t('buttons.cancel')
      }}</el-button>
      <el-button
        v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
        type="primary"
        :disabled="!recchanged"
        @click="saveRecord()"
        >{{ this.$t('buttons.confirm') }}</el-button
      >
    </span>
  </el-dialog>
</template>

<script>
import Vue from 'vue'

import YAML from 'js-yaml'
import axios from 'axios'

export default {
  name: 'cakeDecoEditor',
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: '',
    strNewRec: '',
    orgName: '',
    newName: '',
    formLabelWidth: '240px',
    changed: false,
    dialogFormVisible: false,
    title: 'Décorations Gâteaux',
    disabled: false,
    strDt: '',
  }),
  computed: {
    recordin: function () {
      return this.record
    },
    recordstr: function () {
      return JSON.stringify(this.record)
    },
    recchanged: function () {
      return JSON.stringify(this.recordin) != JSON.stringify(this.newRec)
    },
    totalBC: function () {
      return this.newRec._source.bancontact + this.newRec._source.bancontact2
    },
  },
  props: {
    record: {
      type: Object,
    },
    config: {
      type: Object,
    },
    editMode: {
      type: String,
    },
  },
  watch: {
    recordin: {
      handler: function () {
        this.prepareData()
      },
      deep: true,
    },
  },
  filters: {
    roundTo2: function (value) {
      return value.toFixed(2)
    },
  },
  created: function () {
    console.log('created event')
    this.prepareData()
  },
  components: {},
  methods: {
    closeDialog: function () {
      this.$emit('dialogclose')
    },
    prepareData: function () {
      console.log('prepare data')
      this.dialogFormVisible = true
      this.newRec = JSON.parse(JSON.stringify(this.record))
      this.orgRec = JSON.parse(JSON.stringify(this.record))
      this.disabled = this.newRec._source.confirmed
      var ts = this.newRec._source['@timestamp']
      var dt = new Date(ts)
      var year = dt.getFullYear().toString()
      var month = (dt.getMonth() + 101).toString().substring(1)
      var day = (dt.getDate() + 100).toString().substring(1)
      this.strDt = year + '-' + month + '-' + day
    },

    saveRecord: function () {
      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.lastModification = Date.now()

      if (this.newRec._source.bancontact == null) {
        this.newRec._source.bancontact = 0
      }
      if (this.newRec._source.bancontact2 == null) {
        this.newRec._source.bancontact2 = 0
      }
      if (this.newRec._source.sandwichs == null) {
        this.newRec._source.sandwichs = 0
      }
      if (this.newRec._source.confiserie == null) {
        this.newRec._source.confiserie = 0
      }

      this.$store.commit({
        type: 'updateRecord',
        data: this.newRec,
      })
      this.$notify({
        title: 'Record saved.',
        type: 'success',
        message: 'La commande a été enregistrée.',
        position: 'bottom-right',
      })
      this.$emit('dialogcloseupdated')
    },
  },
}
</script>

<style>
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
