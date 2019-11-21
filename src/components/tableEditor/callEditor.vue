
<template>
  <el-dialog
    max-width="600px"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="call-editor"
  >
    <el-card shadow="never" :body-style="{ padding: '10px' }">
      <div slot="header" class="clearfix">
        <h2>{{newRec._source.client}} ({{newRec._source.caller}})</h2>
      </div>

      <div style="text-align:left; margin-top:10px;">
        <el-timeline :reverse="reverse">
          <el-timeline-item
            v-for="(event, index) in newRec._source.events"
            :key="index"
            placement="top"
            :timestamp="formatStrDate(event.start_time)"
          >
            <el-card>
              <h4>{{event.caller}} <i class="el-icon-right"></i> {{event.target}}</h4>
              <p>{{event}}</p>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </div>
    </el-card>

    <span slot="footer" class="dialog-footer">
      <el-button @click="$emit('dialogclose')">{{this.$t("buttons.cancel")}}</el-button>
      <el-button
        v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
        type="primary"
        :disabled="!recchanged"
        @click="saveRecord()"
      >{{this.$t("buttons.confirm")}}</el-button>
    </span>
  </el-dialog>
</template>

<script>
import Vue from "vue";

import YAML from "js-yaml";
import axios from "axios";
import moment from "moment";

export default {
  name: "callEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    changed: false,
    dialogFormVisible: false,
    title: "Call detail"
  }),
  computed: {
    recordin: function() {
      return this.record;
    },
    recordstr: function() {
      return JSON.stringify(this.record);
    },
    recchanged: function() {
      return JSON.stringify(this.recordin) != JSON.stringify(this.newRec);
    }
  },
  props: {
    record: {
      type: Object
    },
    config: {
      type: Object
    },
    editMode: {
      type: String
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
  created: function() {
    console.log("created event");
    this.prepareData();
  },
  components: {},
  methods: {
    formatStrDate: function(strDate) {
      console.log(strDate)
      console.log(moment(strDate))
      return moment(strDate).format('HH:mm:ss')
    },
    closeDialog: function() {
      this.$emit("dialogclose");
    },
    prepareData: function() {
      console.log("prepare data");
      this.dialogFormVisible = true;
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));

    },
    saveRecord: function() {
      if (!this.weatherActivated && this.newRec._source.weather != null) {
        delete this.newRec._source.weather;
      }

      this.$store.commit({
        type: "updateRecord",
        data: this.newRec
      });
      this.$notify({
        title: "Record saved.",
        type: "success",
        message: "The technician has been succesfuly saved.",
        position: "bottom-right"
      });
      this.$emit("dialogcloseupdated");
    }
  }
};
</script>

<style >
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