<template>
  <div>
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="700px">
      <el-form
        style="text-align: left"
        :model="dialogObj"
        :orgmodel="orgModel"
        :disable="disable"
        v-if="dialogVisible"
        ref="formCall"
      >
        <el-form-item
          label="Datum van de klacht "
          :label-width="formLabelWidth"
        >
          <el-date-picker
            :shortcuts="
              { firstDayOfWeek: 1, disabledDate: disableDate } &&
              { firstDayOfWeek: 1, disabledDate: disableDate }.shortcuts
            "
            :disabled-date="
              { firstDayOfWeek: 1, disabledDate: disableDate } &&
              { firstDayOfWeek: 1, disabledDate: disableDate }.disabledDate
            "
            :cell-class-name="
              { firstDayOfWeek: 1, disabledDate: disableDate } &&
              { firstDayOfWeek: 1, disabledDate: disableDate }.cellClassName
            "
            :disabled="disable"
            v-model="dialogObj['creationdate']"
            type="datetime"
            size="small"
            placeholder="Select date and time"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="Uitleg " :label-width="formLabelWidth">
          <el-input v-model="dialogObj['uitleg']" type="textarea" :rows="2">
          </el-input>
        </el-form-item>
      </el-form>

      <span slot="footer" class="dialog-footer">
        <el-button
          type="default"
          plain
          size="small"
          @click="dialogVisible = false"
          >Cancel</el-button
        >
        <el-button
          v-if="dialogType == 'update'"
          type="primary"
          :disabled="!hasBeenModified"
          plain
          size="small"
          :loading="loading"
          @click="clickDialogModify"
          >Modify</el-button
        >

        <el-button
          v-else
          type="primary"
          plain
          size="small"
          :disabled="formEmpty()"
          :loading="loading"
          @click="clickDialogCreate"
          >Create</el-button
        >
      </span>
    </el-dialog>

    <el-row class="kpi600-container" :span="24" type="flex" justify="center">
      <el-card class="box-card2">
        <div slot="header" class="clearfix">
          <span style="font-weight: bold"
            >KPI604 Meldingsplicht: klachten over waarheidsgetrouwe
            informatie</span
          >
        </div>
        <div class="card-body">
          <el-row class="first-row" :span="24">
            <el-col :span="12" style="text-align: left">
              <el-row>
                <el-date-picker
                  v-model="monthSelected"
                  type="month"
                  size="small"
                  placeholder="Pick a month"
                  :clearable="false"
                  @change="prepareData()"
                ></el-date-picker>
              </el-row>
              <el-row style="margin-left: 5px; font-weight: bold"></el-row>
            </el-col>
          </el-row>

          <span v-if="monthSelected">
            <el-row :span="24" class="parameters-selection" v-if="writeAccess">
              <el-col :span="12" style="text-align: left">
                <el-button
                  :disabled="!monthSelected || disable"
                  type="primary"
                  :icon="ElIconPlus"
                  @click="addRecord"
                  round
                >
                  Nieuwe Klacht</el-button
                >
              </el-col>
            </el-row>
          </span>
        </div>

        <div>
          <el-table
            :data="tableData"
            :default-sort="{ prop: '_source.kpi', order: 'descending' }"
            style="width: 100%"
          >
            <el-table-column
              prop="_source['creationdate']"
              label="Datum"
              sortable
              width="210"
              :formatter="formaterdate"
            ></el-table-column>

            <el-table-column
              prop="_source.uitleg"
              label="Uitleg"
              sortable
            ></el-table-column>

            <el-table-column label width="130">
              <template slot-scope="scope">
                <el-button
                  v-if="writeAccess"
                  size="small"
                  :icon="ElIconSetting"
                  plain
                  @click="handleEdit(scope.$index, scope.row)"
                ></el-button>
                <el-button
                  v-if="writeAccess"
                  size="small"
                  type="danger"
                  :disabled="!monthSelected || disable"
                  :icon="ElIconDelete"
                  @click="handleDelete(scope.$index, scope.row)"
                ></el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-card>
    </el-row>
  </div>
</template>

<script>
import {
  Plus as ElIconPlus,
  Setting as ElIconSetting,
  Delete as ElIconDelete,
} from '@element-plus/icons'
import Vue from 'vue'
import moment from 'moment'
import axios from 'axios'
import _ from 'lodash'
import formkpi604 from '@/components/external/FormKpi604'
import { setTimeout } from 'timers'
Vue.component('FormKpi604', formkpi604)

export default {
  data() {
    return {
      query: '',
      monthSelected: null,
      monthStart: null,
      monthEnd: null,
      disable: true,
      formLabelWidth: '200px',
      writeAccess: false,
      dialogType: 'creation',
      dialogVisible: false,
      dialogTitle: '',
      loading: false,
      dialogObj: null,
      orgModel: null,
      tableData: [],
      ElIconPlus,
      ElIconSetting,
      ElIconDelete,
    }
  },
  name: 'FormKpi604',
  computed: {
    hasBeenModified: function () {
      return (
        JSON.stringify(this.orgModel._source) != JSON.stringify(this.dialogObj)
      )
    },
  },
  created: function () {
    for (var i in this.$store.getters.creds.user.privileges) {
      var priv = this.$store.getters.creds.user.privileges[i]
      if (priv == 'admin' || priv == 'kpi604-write' || priv == 'KPI604_WRITE') {
        this.writeAccess = true
      }
    }
    this.prepareData()
  },
  methods: {
    formEmpty: function () {
      return (
        this.dialogObj != null &&
        (this.dialogObj['creationdate'] == null ||
          this.dialogObj['uitleg'] == '')
      )
    },
    disableDate(in_date) {
      return false

      if (moment().format('D') >= 16) return in_date < moment().startOf('Month')
      else return in_date < moment().subtract(1, 'months').startOf('Month')
    },
    formaterdate(row, column) {
      return moment(row._source['creationdate']).format('DD MMM YYYY - HH:mm')
    },
    clickDialogCreate() {
      var rec = {
        _id: 'id_' + Math.floor((1 + Math.random()) * 0x1000000),
        _index: 'biac_kpi604',
        _type: 'doc',

        _source: this.dialogObj,
      }

      rec._source['@timestamp'] = moment()

      this.$store.commit({
        type: 'updateRecord',
        data: rec,
      })
      setTimeout(() => this.prepareData(), 1000)
      this.dialogVisible = false
    },
    clickDialogModify() {
      var rec = this.orgModel

      this.orgModel._source = this.dialogObj

      this.$store.commit({
        type: 'updateRecord',
        data: rec,
      })
      setTimeout(() => this.prepareData(), 1000)
      this.dialogVisible = false
    },

    prepareData() {
      this.dateSelected()
      this.loadData()
    },
    loadData() {
      this.query =
        'creationdate: [' +
        this.monthStart.toISOString() +
        ' TO ' +
        this.monthEnd.toISOString() +
        ']'

      var url =
        this.$store.getters.apiurl +
        'generic_search/biac_kpi604*?token=' +
        this.$store.getters.creds.token

      var fullq = {
        size: 900,
        query: {
          bool: {
            must: [
              {
                query_string: {
                  query: this.query,
                },
              },
            ],
          },
        },
      }

      axios
        .post(url, fullq)
        .then((response) => {
          if (response.data.error != '') console.log('KPI604 list error...')
          else {
            console.log(response.data.records)
            console.log(this)
            this.tableData = response.data.records
          }
        })
        .catch((error) => {
          console.log(error)
        })
    },
    addRecord() {
      this.dialogObj = {
        creationdate: moment(),
        uitleg: '',
      }
      this.dialogType = 'creation'
      this.dialogTitle = 'Nieuw klacht'
      this.dialogVisible = true
    },
    handleEdit(index, row) {
      var newconfig = JSON.parse(JSON.stringify(row))
      this.dialogObj = newconfig._source
      this.dialogType = 'update'
      this.dialogTitle = 'Bijwerken klacht'
      this.dialogVisible = true
      this.orgModel = row
    },
    handleDelete(index, row) {
      this.$confirm(
        'Dit zal de record voor altijd verwijderen, verder gaan?',
        'Warning',
        {
          confirmButtonText: 'OK',
          cancelButtonText: 'Verwijderen',
          type: 'warning',
        }
      ).then(() => {
        this.$store.commit({
          type: 'deleteRecord',
          data: row,
        })
        setTimeout(() => this.prepareData(), 1000)
      })
    },
    dateSelected() {
      if (this.monthSelected == null) this.monthSelected = moment()

      if (moment().format('D') >= 16) {
        //console.log('report already done')
        this.disable = moment() > moment(this.monthSelected).endOf('Month')
      } else {
        this.disable =
          moment().subtract(1, 'months') >
          moment(this.monthSelected).endOf('Month')
      }
      //@this.disable=false;
      this.monthStart = moment(this.monthSelected).startOf('Month')
      this.monthEnd = moment(this.monthSelected).endOf('Month')
    },
  },
}
</script>

<style>
.kpi600-container {
  width: 100%;
  margin: 30px 0px;
}
.box-card2 {
  width: 950px !important;
}

.kpi600-container .parameters-selection {
  margin: 10px;
}

.first-row {
  /*margin: 10px;*/
}
.second-row {
  /*margin: 20px 10px;*/
}
.third-row {
  /*margin: 20px 10px;*/
}

.row-day {
  padding-top: 10px;
  padding-bottom: 10px;
  border-top: solid 1px lightgrey;
}

.kpi600-switches-text {
  margin-left: 20px;
  font-size: 11px;
}

.kpi600-container .row-subtitle {
  border-top: solid 1px #eee;
  margin-top: 15px;
  padding-top: 10px;
  padding-bottom: 10px;
  margin-bottom: 15px;
  border-bottom: solid 1px #eee;
}

.redduration {
  color: red !important;
}

.orangeduration {
  color: orange !important;
}

.greenduration {
  color: green !important;
}
</style>
