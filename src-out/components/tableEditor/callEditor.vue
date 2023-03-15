<template>
  <el-dialog
    max-width="600px"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="call-editor"
  >
    <!-- <el-card shadow="never" :body-style="{ padding: '10px' }">
        <div slot="header" class="clearfix">
          <h2>{{newRec._source.client}} ({{newRec._source.caller}})</h2>
        </div> -->

    <el-card
      shadow="never"
      style="
        text-align: left;
        margin-top: 10px;
        margin-left: 30px;
        margin-right: 30px;
        margin-bottom: 30px;
      "
    >
      <h2 style="color: #409eff">
        <b>{{ formatStrDate(newRec._source.start_time, 'DD MMM YYYY') }}</b>
      </h2>
      <p>
        Client <b>{{ newRec._source.client }}</b> called with phone number
        <b>{{ newRec._source.caller }}</b
        >. The call lasted <b>{{ formatDuration(newRec._source.duration) }}</b>
      </p>
      <p v-if="newRec._source.speak_with_sbd">
        The client waited
        <b>{{ formatDuration(newRec._source.waiting) }}</b> before speaking to
        somebody
        <span v-if="newRec._source.total_waiting"
          >(total waiting time:
          {{ formatDuration(newRec._source.total_waiting) }})</span
        >
      </p>
      <p v-else>Nobody answered the call</p>
    </el-card>
    <div style="text-align: left; margin-top: 10px; padding-right: 40px">
      <el-timeline>
        <el-timeline-item
          v-for="(event, index) in eventArray"
          :key="index"
          placement="top"
          :type="event.nodetype"
          size="normal"
          :timestamp="formatStrDate(event.start_time)"
        >
          <el-card>
            <el-row>
              <el-col :span="10">
                <h3>
                  <b
                    ><el-icon><el-icon-phone-outline /></el-icon>
                    {{ event.desk }} </b
                  ><span v-if="event.target">
                    - (target {{ event.target }})</span
                  >
                </h3>
              </el-col>
              <el-col :span="6">
                <h3 v-if="!event.rings || event.solidus">
                  <b
                    ><el-icon><el-icon-timer /></el-icon>
                    {{ formatDuration(event.duration) }}
                  </b>
                </h3>
                <h3 v-else>
                  <b
                    ><el-icon><el-icon-bell /></el-icon>
                    {{ formatDuration(event.rings) }}
                  </b>
                </h3>
              </el-col>

              <el-col :span="2">
                <h3>
                  <b>{{ event.code }}</b>
                </h3>
              </el-col>
              <el-col :span="6" style="text-align: right">
                <h3 v-if="event.welcome">
                  <span
                    style="
                      background-color: #ccc;
                      color: white;
                      padding: 0px 5px;
                    "
                    >WELCOME</span
                  >
                </h3>
                <h3 v-else-if="event.solidus">
                  <span
                    style="
                      background-color: #ccc;
                      color: white;
                      padding: 0px 5px;
                    "
                    >SOLIDUS</span
                  >
                </h3>
                <h3 v-else-if="event.rings">
                  <span
                    style="
                      background-color: #ccc;
                      color: white;
                      padding: 0px 5px;
                    "
                    >RINGS</span
                  >
                </h3>
                <h3 v-else>
                  <span
                    style="
                      background-color: #67c23a;
                      color: white;
                      padding: 0px 5px;
                    "
                    >CALL</span
                  >
                </h3>
              </el-col>
            </el-row>
          </el-card>
        </el-timeline-item>
        <el-timeline-item
          placement="top"
          :timestamp="formatStrDate(newRec._source.end_time)"
          type="danger"
        >
        </el-timeline-item>
      </el-timeline>
    </div>
    <!-- </el-card> -->

    <span slot="footer" class="dialog-footer">
      <el-button @click="$emit('dialogclose')">Ok</el-button>
      <!-- <el-button
          v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
          type="primary"
          :disabled="!recchanged"
          @click="saveRecord()"
        >{{this.$t("buttons.confirm")}}</el-button> -->
    </span>
  </el-dialog>
</template>

<script>
import {
  PhoneOutline as ElIconPhoneOutline,
  Timer as ElIconTimer,
  Bell as ElIconBell,
} from '@element-plus/icons'
import Vue from 'vue'

import YAML from 'js-yaml'
import axios from 'axios'
import moment from 'moment'
import _ from 'lodash'

export default {
  components: {
    ElIconPhoneOutline,
    ElIconTimer,
    ElIconBell,
  },
  name: 'callEditor',
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: '',
    strNewRec: '',
    orgName: '',
    newName: '',
    formLabelWidth: '120px',
    changed: false,
    dialogFormVisible: false,
    eventArray: null,
    title: 'Call detail',
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
  created: function () {
    console.log('created event')
    this.prepareData()
  },
  methods: {
    formatStrDate: function (strDate, format = 'HH:mm:ss') {
      console.log(strDate)
      console.log(moment(strDate))
      return moment(strDate).format(format)
    },
    formatDuration: function (duration) {
      var ret = ''

      var duration = moment.duration({ seconds: duration })
      if (duration.hours() > 0) ret += duration.hours() + 'h '
      if (duration.minutes() > 0) ret += duration.minutes() + 'm '
      if (duration.seconds() > 0) ret += duration.seconds() + 's'

      return ret
    },
    closeDialog: function () {
      this.$emit('dialogclose')
    },
    prepareData: function () {
      console.log('prepare data')
      this.dialogFormVisible = true
      this.newRec = JSON.parse(JSON.stringify(this.record))
      this.orgRec = JSON.parse(JSON.stringify(this.record))

      var evArray = _.sortBy(this.newRec._source.events, function (event) {
        return moment(event.start_time)
      })

      var newArray = []

      console.log(evArray)
      for (var i = 0; i < evArray.length; i++) {
        console.log(i)

        if (evArray[i].solidus == 1) {
          evArray[i].nodetype = 'default'
          newArray.push(evArray[i])
        } else if (evArray[i].rings == 0) {
          if (evArray[i].speak_with_sbd == 1) evArray[i].nodetype = 'success'
          else evArray[i].nodetype = 'default'

          newArray.push(evArray[i])
        } else {
          var firstEvent = JSON.parse(JSON.stringify(evArray[i]))
          var secondEvent = JSON.parse(JSON.stringify(evArray[i]))

          firstEvent.duration = firstEvent.rings
          secondEvent.duration -= secondEvent.rings
          secondEvent.rings = 0

          var newSplitDate = moment(firstEvent.start_time)
            .add(firstEvent.duration, 'seconds')
            .toISOString()

          firstEvent.end_time = newSplitDate
          secondEvent.start_time = newSplitDate
          firstEvent.nodetype = 'default'
          secondEvent.nodetype = 'success'

          newArray.push(firstEvent)
          newArray.push(secondEvent)
        }
      }

      console.log(newArray)

      this.eventArray = newArray
    },
    saveRecord: function () {
      if (!this.weatherActivated && this.newRec._source.weather != null) {
        delete this.newRec._source.weather
      }

      this.$store.commit({
        type: 'updateRecord',
        data: this.newRec,
      })
      this.$notify({
        title: 'Record saved.',
        type: 'success',
        message: 'The technician has been succesfuly saved.',
        position: 'bottom-right',
      })
      this.$emit('dialogcloseupdated')
    },
  },
}
</script>

<style>
.call-editor .view-table {
  margin-bottom: 30px;
}
.call-editor .screen-name-input {
  margin-bottom: 10px;
}

.call-editor .add-view-button {
  margin-bottom: 30px;
}
</style>
