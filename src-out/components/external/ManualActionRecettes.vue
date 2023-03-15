<template>
  <div style="width: 100%">
    <el-row class="manualactionrecettes-container" style="width: 100%">
      <el-row>ACTIONS :</el-row>
      <el-row>
        <el-col :span="12" style="text-align: right"
          ><el-button type="primary" @click="sendSensor"
            >Recompilation</el-button
          ></el-col
        >
        <el-col :span="12" style="text-align: left">
          <v-icon
            v-if="computeIcon(this.recetteComputedState) != ''"
            :color="computeIconColor(this.recetteComputedState)"
            :name="computeIcon(this.recetteComputedState)"
            :scale="2"
          />
          <v-icon
            v-if="computeIcon(this.recetteComputedLastRun) != ''"
            :color="computeIconColor(this.recetteComputedLastRun)"
            :name="computeIcon(this.recetteComputedLastRun)"
            :scale="2"
          />
        </el-col>
      </el-row>
    </el-row>
  </div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'

export default {
  name: 'ManualActionRecettes',
  data: () => ({
    sensorData: '',
    recetteComputedState: 'regular/check-circle',
    recetteComputedLastRun: 'check>green',
    refAutoRefresh: null,
  }),
  props: {
    config: {
      type: Object,
    },
  },
  created: function () {
    this.setAutoRefresh()
  },
  beforeDestroy: function () {
    console.log('BEFORE DESTROY')
    clearInterval(this.refAutoRefresh)
  },
  methods: {
    computeIcon: function (field) {
      /*var rec = row;
      if (field.indexOf("_source") == 0) {
        rec = row["_source"];
        var res = "";
        if (field.indexOf("@") == -1)
          res = _.get(rec, field.replace("_source.", ""));
        else res = rec[field.replace("_source.", "")];

        if (res == undefined) return "";
        else return this.cutRec("" + res).split(">")[0];
      }
      if (field.indexOf("@") == -1)
        return this.cutRec(_.get(rec, field)).split(">")[0];
      else res = rec[field].split(">")[0];

      return res;*/
      console.log(field)

      if (field.indexOf('>') == -1) {
        return field
      } else {
        return field.split('>')[0]
      }
    },
    computeIconColor: function (field) {
      /*var rec = row;
      if (field.indexOf("_source") == 0) {
        rec = row["_source"];
        var res = "";
        if (field.indexOf("@") == -1)
          res = _.get(rec, field.replace("_source.", ""));
        else res = rec[field.replace("_source.", "")];
        if (res == undefined) return "grey";
        else if (field.indexOf(">") == -1)
          return this.cutRec("" + res).split(">")[1];
      }*/
      console.log(field)
      if (field.indexOf('>') == -1) {
        return 'grey'
      } else {
        return field.split('>')[1]
      }
    },
    sendSensor() {
      var body = {
        destination: '/queue/RECALCUL_RECETTE',
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
              this.getLambdaState()
              this.getLambdaLastrun()
            }
          })
          .catch((error) => {
            console.log(error)
          })
      }, 1000)

      console.log('Confirming Sync')
    },
    getLambdaState() {
      var query = { _id: 'r8_notebookslambdasipynb_recalcul_recette' }
      var url =
        this.$store.getters.apiurl +
        'lambdas/8/get_lambda_state?apikey=' +
        this.$store.getters.creds.token
      axios.post(url, query).then((response) => {
        this.recetteComputedState = response.data.data
      })
    },
    getLambdaLastrun() {
      var query = { _id: 'r8_notebookslambdasipynb_recalcul_recette' }
      var url =
        this.$store.getters.apiurl +
        'lambdas/8/get_lambda_lastrun?apikey=' +
        this.$store.getters.creds.token
      axios.post(url, query).then((response) => {
        this.recetteComputedLastRun = response.data.data
      })
    },
    setAutoRefresh: function () {
      console.log('Setting Interval')

      if (this.refAutoRefresh != null) clearInterval(this.refAutoRefresh)

      this.refAutoRefresh = setInterval(() => {
        //this.refreshData()
        this.getLambdaState()
        this.getLambdaLastrun()
      }, 2000)
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
