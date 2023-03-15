<template>
  <div style="width: 100%">
    <el-row class="manualactionscofely-container" style="width: 100%">
      <el-row>ACTIONS :</el-row>
      <el-row>
        <el-button type="primary" @click="sendSensor">Send Sensor</el-button>
      </el-row>
    </el-row>
  </div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'

export default {
  name: 'ManualActionsCofely',
  data: () => ({
    sensorData: '',
  }),
  props: {
    config: {
      type: Object,
    },
  },
  created: function () {
    //this.getOthersProducts();
  },
  methods: {
    sendSensor() {
      var body = {
        destination: '/queue/TESTBMSIOT',
        body: "{'message':'stop'}",
      }

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
                message: 'Fail to send Data',
                type: 'error',
                position: 'bottom-right',
                duration: 1500,
              })
            } else {
              this.$notify({
                title: 'Success',
                message: 'Success to send Data',
                type: 'success',
                position: 'bottom-right',
                duration: 2000,
              })
            }
          })
          .catch((error) => {
            console.log(error)
          })
      }, 1000)

      console.log('Confirming Commands')
    },
  },
}
</script>

<style>
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
.footer {
  position: fixed;
  left: 0;
  bottom: 1%;
  width: 100%;
  text-align: center;
}
</style>
