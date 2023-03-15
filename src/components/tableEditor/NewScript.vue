<template>
    <el-dialog
    width="70%"
    top="15%"
    :title="title"
    :visible.sync="newScriptVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="script-editor"
    append-to-body>

  <div>
    <el-form>
    <el-form-item label="Shellscript content">
        <el-input type="textarea" :autosize="{ minRows: 15, maxRows: 20}" v-model="scriptcontent"></el-input>
    </el-form-item>
    </el-form>
  </div>
  <span slot="footer" class="dialog-footer">
      <el-button
        v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
        type="primary"
        @click="sendScript()"
      >{{this.$t("buttons.confirm")}}</el-button>
      <el-button @click="$emit('newscriptclose')">{{this.$t("buttons.cancel")}}</el-button>
  </span>
  </el-dialog>
</template>

<script>

//import Vue from "vue";
export default {
  name: "newScript",
  data: () => ({
    orgRec: null,
    newRec: null,
    scriptcontent: "#!/bin/bash",
    selectedDocker: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    changed: false,
    dialogFormVisible: false,
    weatherActivated: true,
    newScriptVisible: false,
    title: "Script Editor"
  }),
  mounted: function(){
      console.log("mounted event");
      this.newScriptVisible = true;
  },
    props: {
    record: {
      type: Object
    },
    config: {
      type: Object
    }
  },
  components: {},
  methods: {
    closeDialog: function() {
    this.$emit("newscriptclose");
    },
    sendScript: function() {
        console.log('coucou')
        var command = {
        _index: "optiboard_command",
        _id: "id_" + Math.floor((1 + Math.random()) * 0x1000000),
        _source: {
          "@timestamp": Date.now(),
          cmd: "COPY",
          cmdType: "COPY",
          folder: "/etc/opt/screenshots/to_execute/autoscript.sh",
          file: btoa(this.scriptcontent),
          executed: 0,
          guid: this.record._source.guid,
          screen: this.record._source.optiboard
        },
        _type: "doc"
      };
      
      this.$store.commit({
        type: "updateRecord",
        data: command
      });
      this.$notify({
        title: "Command sent.",
        type: "success",
        message: "The commmand has been sent.",
        position: "bottom-right"
      });
      this.$emit("newscriptclose");
    }
  }
  

}
</script>

<style >
.script-editor .view-table {
  margin-bottom: 30px;
}
.script-editor .script-name-input {
  margin-bottom: 10px;
}

.script-editor .add-view-button {
  margin-bottom: 30px;
}
</style>