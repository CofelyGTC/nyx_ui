<template>
  <div style="width: 100%">
    <el-form v-model="orders">
      <el-tabs v-model="selectedTab">
        <!--el-table>
          <el-row v-for="(index, order) in orders" :key="'TAB-'+order">
              <td>{{order}}</td><td>{{index}}</td>
          </el-row>
        </el-table-->
        <el-tab-pane
          v-for="(order, index) in orders"
          :key="'TAB-' + index"
          :label="order['_id']"
          :name="'TAB-' + index"
        >
          <el-tabs v-model="selectedUnderTab">
            <el-tab-pane
              v-for="(category, index1) in order._source.categories"
              :key="'TAB-' + index + '-' + index1"
              :label="category"
              :name="'TAB-' + index + '-' + index1"
              :lazy="true"
            >
              <el-table
                :row-key="order._source[category].code"
                :data="order._source[category]"
                :default-sort="{ prop: 'quantity', order: 'descending' }"
                style="width: 100%"
              >
                <el-table-column prop="code" label="Code"></el-table-column>

                <el-table-column prop="name" label="Name"></el-table-column>
                <el-table-column prop="confirmed" label="Confirmé">
                  <template slot-scope="scope">
                    <el-switch
                      v-model="scope.row.confirmed"
                      @change="recordConfirmed(index)"
                    ></el-switch>
                  </template>
                </el-table-column>
                <el-table-column id="quantity" prop="quantity" label="Quantité">
                  <template slot-scope="scope">
                    <el-input-number
                      :min="0"
                      size="small"
                      v-model="scope.row.quantity"
                    />
                  </template>
                </el-table-column>
              </el-table>
            </el-tab-pane>
          </el-tabs>
        </el-tab-pane>
      </el-tabs>
    </el-form>
  </div>
</template>

<script>
import Vue from 'vue'
import moment, { months } from 'moment'
import axios from 'axios'

export default {
  name: 'Transport',
  data: () => ({
    records: null,
    oldID: null,
    orders: null,
    disabled: false,
    category: '',
    categoryUp: '',
    ts: 0,
    changed: false,
    dialogFormVisible: false,
    title: 'Commande',
    selectedTab: 'TAB-0',
    selectedUnderTab: 'TAB-0-0',
  }),
  props: {
    config: {
      type: Object,
    },
  },
  created: function () {
    this.ts = Date.now().toString()
    bus.on('timerangechanged', (payLoad) => {
      console.log('GLOBALBUS/GENERICTABLE/TIMERANGECHANGED')
      console.log(this.config.timeSelectorType)
      console.log(payLoad.subtype)
      if (this.config.timeSelectorType == undefined)
        this.config.timeSelectorType = 'classic'
      if (payLoad.subtype == this.config.timeSelectorType) this.loadData()
      else console.log('Ignoring time change.')
    })
    this.prepareData()
  },
  methods: {
    prepareData() {
      console.log('prepare data')
      for (var i in this.$store.getters.creds.user.privileges) {
        var priv = this.$store.getters.creds.user.privileges[i]
        if (priv == 'admin' || priv == 'LIVR_FORM') {
          this.writeAccess = true
        }
      }
      //this.monthSelected = moment()
      //this.dateSelected()
      this.getData()
    },
    loadData() {
      this.records = []
      this.getData()
    },
    handleTabClick: function (tab) {
      var index = parseInt(tab.name.substring(4))

      this.$store.commit({
        type: 'setTab',
        data: this.$store.getters.currentApps.apps[index],
      })

      if (this.$store.getters.currentApps.apps[index].type == 'kibana') {
        bus.emit(
          'kibanaactivated',
          this.$store.getters.currentApps.apps[index]
        )
      }
    },
    changeApp: function () {
      this.currentApps = null

      this.selectedTab = 'TAB-0'

      this.$nextTick(() => {
        this.currentApps = JSON.parse(
          JSON.stringify(this.$store.getters.currentApps)
        )
      })
    },
    dateSelected() {
      if (this.monthSelected == null) this.monthSelected = moment()

      if (moment().format('D') >= 14) {
        this.disable = moment() > moment(this.monthSelected).endOf('Month')
      } else {
        this.disable =
          moment().subtract(1, 'months') >
          moment(this.monthSelected).endOf('Month')
      }

      this.strPeriod =
        moment(this.monthSelected).startOf('Month').format('DD MMM YYYY') +
        ' to ' +
        moment(this.monthSelected).endOf('Month').format('DD MMM YYYY')
      this.getData()
    },
    getData() {
      var demandor = this.$store.getters.creds.user.id
      var timeRange = this.$store.getters.timeRangeDay
      var url =
        this.$store.getters.apiurl +
        'schamps/getToDeliverList?start=' +
        timeRange[0].getTime() +
        '&stop=' +
        timeRange[1].getTime() +
        '&token=' +
        this.$store.getters.creds.token

      axios.get(url, demandor).then((response) => {
        if (response.data.error != '')
          console.log('Order Shops Calls list error...')
        else {
          var res = JSON.parse(response.data.data)
          console.log(res)

          if (res.reccords.length == 0) {
            console.log('No reccord')
            //this.createNewForm();
          } else {
            var orders = res.reccords
            this.orders = orders
          }
        }
      })
    },

    recordConfirmed(index) {
      var body = {}
      body.destination = '/queue/TRANSPORT_UPDATE'
      body.body = JSON.stringify(this.orders[index])

      setTimeout(() => {
        axios
          .post(
            this.$store.getters.apiurl +
              'sendmessage?token=' +
              this.$store.getters.creds.token,
            body
          )
          .then((response) => {
            if (response.data.error != '') {
              this.$notify({
                title: 'Error',
                message: 'Failed To Update Message',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Update Send !',
                type: 'success',
                position: 'bottom-right',
                duration: 2500,
              })
            }
          })
          .catch((error) => {
            console.log(error)
          })
      }, 1000)

      console.log('Sending Command')
    },

    setTableCurrent(row) {
      this.$refs.callTable.setCurrentRow(row)
    },
    updateTimeRange() {
      const start = new Date()
      console.log('coucou')
      start.setTime(this.$refs.generic.chart.series.w.globals.minX)
      bus.emit('charttimerangeupdated', [
        this.$refs.generic.chart.series.w.globals.minX,
        this.$refs.generic.chart.series.w.globals.maxX,
      ])
    },
    clickDialogCreate() {
      this.loading = true
      this.$refs['formCall'].validate((valid) => {
        if (valid) {
          for (var j in this.lotModel) {
            if (this.lotModel[j].label == this.dialogObj.lot)
              this.dialogObj.lot = this.lotModel[j].value
          }

          var newRec = {
            _id: 'id_' + Math.floor((1 + Math.random()) * 0x1000000),
            _index: 'biac_kpi101_call',
            isadd: true,
            _type: 'doc',

            _source: this.dialogObj,
          }

          console.log(newRec)

          this.$store.commit({
            type: 'updateRecord',
            data: newRec,
          })

          this.currentMonth = moment(this.monthSelected)
          this.targetMonth = moment(newRec._source.datetime)

          console.log('currentMonth: ' + this.currentMonth.format('YYYY-MM-DD'))
          console.log(' targetMonth: ' + this.targetMonth.format('YYYY-MM-DD'))

          setTimeout(
            function () {
              this.getData()
              this.dialogVisible = false
              this.loading = false
              this.$notify({
                title: 'Success',
                message: 'call ' + newRec._source.number + ' has been CREATED',
                type: 'success',
                position: 'bottom-right',
              })
              this.currentRow = null
            }.bind(this),
            500
          )

          setTimeout(() => this.getData(), 1500)

          this.targetMonth = moment(newRec._source.datetime)

          setTimeout(() => {
            console.log('******************target month********************')
            console.log(this.targetMonth.format('YYYY-MM-DD'))

            axios
              .post(
                this.$store.getters.apiurl +
                  'biac/kpi101_monthly?token=' +
                  this.$store.getters.creds.token,
                { month_to_update: this.targetMonth.format('YYYY-MM-DD') }
              )
              .then((response) => {
                if (response.data.error != '')
                  console.log('KPI104 update monthly error')
                else {
                  console.log('KPI104 update monthly success')
                  console.log(response)
                }
              })
              .catch((error) => {
                console.log(error)
              })
          }, 2500)

          if (this.targetMonth != this.currentMonth) {
            setTimeout(() => {
              console.log('***************current month***********************')
              console.log(this.currentMonth.format('YYYY-MM-DD'))

              axios
                .post(
                  this.$store.getters.apiurl +
                    'biac/kpi101_monthly?token=' +
                    this.$store.getters.creds.token,
                  { month_to_update: this.currentMonth.format('YYYY-MM-DD') }
                )
                .then((response) => {
                  if (response.data.error != '')
                    console.log('KPI104 update monthly error')
                  else {
                    console.log('KPI104 update monthly success')
                    console.log(response)
                  }
                })
                .catch((error) => {
                  console.log(error)
                })
            }, 2500)
          }
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
  },
}
</script>

<style>
.ordershop-container {
  width: 100%;
  margin: 30px 0px;
}
.box-card {
  width: 800px !important;
}

.first-row {
  margin: 10px;
}
.second-row {
  margin: 20px 10px;
}
.third-row {
  margin: 20px 10px;
}
.forth-row {
  margin: 20px 10px;
}

.table-disable {
  cursor: not-allowed;
}
</style>
