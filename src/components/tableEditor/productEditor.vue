<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="product-editor"
  >
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
        <el-row>
            <el-col :span=8>  
        <el-form-item label="Disponibilité" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Availbility" autocomplete="off"></el-input>
        </el-form-item>
            </el-col>
            <el-col :span=8>
        <el-form-item label="CODE" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.CODE" autocomplete="off"></el-input>
        </el-form-item>
            </el-col>
        <el-col :span=8>
        <el-form-item label="Céréal" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Cereal" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
        </el-row>
        <el-row>
            <el-col :span=8>
        <el-form-item label="Conditionnement" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Conditionnement" autocomplete="off"></el-input>
        </el-form-item>
            </el-col>
        <el-col :span=8>
        <el-form-item label="Filtre invendu" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Filter_unsale" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
        <el-col :span=8>
        <el-form-item label="Format" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Format" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
        </el-row>
        <el-row>
        <el-form-item label="Label" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Label" autocomplete="off"></el-input>
        </el-form-item>
        </el-row>
        <el-row>
            <el-col :span=4>
        <el-form-item label="Prix TVAC" :label-width="formLabelWidth2">
          <el-input-number size="mini" v-model="newRec._source.Prix_TVAC" autocomplete="off"></el-input-number>
        </el-form-item>
            </el-col>
            <el-col :span=4>
        <el-form-item label="TVA" :label-width="formLabelWidth2">
          <el-input-number size="mini" v-model="newRec._source.TVA" autocomplete="off"></el-input-number>
        </el-form-item>
            </el-col>
            <el-col :span=4>
        <el-form-item label="HTVA" :label-width="formLabelWidth2">
          <el-input-number size="mini" v-model="newRec._source.HTVA" autocomplete="off"></el-input-number>
        </el-form-item>
            </el-col>
            <el-col :span=4>
        <el-form-item label="Taux TVA" :label-width="formLabelWidth2">
          <el-input-number size="mini" v-model="newRec._source.Taux_TVA" autocomplete="off"></el-input-number>
        </el-form-item>
            </el-col>
            <el-col :span=4>
        <el-form-item label="Poids" :label-width="formLabelWidth2">
          <el-input-number size="mini" v-model="newRec._source.Weight" autocomplete="off"></el-input-number>
        </el-form-item>
            </el-col>
        </el-row>
        <el-row>
            <el-col :span=8>
        <el-form-item label="Type" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.Type" autocomplete="off"></el-input>
        </el-form-item>
            </el-col>
            <el-col :span=8>
        <el-form-item label="Niveau 1" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.sortLvl1" autocomplete="off"></el-input>
        </el-form-item>
            </el-col>
            <el-col :span=8>
        <el-form-item label="Niveau 2" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.sortLvl2" autocomplete="off"></el-input>
        </el-form-item>
            </el-col>
        </el-row>
        <el-row>
            <el-col :span=12>
        <el-form-item label="Type de Pâte" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.sortLvl3" autocomplete="off"></el-input>
        </el-form-item>
            </el-col>
            <el-col :span=12>
        <el-form-item label="Fruits Cuits / Pas Cuits" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.sortLvl4" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
        </el-row>
        <el-row>
            <el-col :span=12>
        <el-form-item label="Avec/Sans Fruits" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.sortLvl5" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
            <el-col :span=12>
        <el-form-item label="Taille" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.sortLvl6" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
        </el-row>
        <el-row>
            <el-col :span=12>
        <el-form-item label="Avec/Sans Crème Fraîche" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.sortLvl7" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
            <el-col :span=12>
        <el-form-item label="Type de Fruits" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.sortLvl8" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
        </el-row>
        <el-row>
            <el-col :span=12>
        <el-form-item label="Type de Crème" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.sortLvl9" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
            <el-col :span=12>
        <el-form-item label="Autre" :label-width="formLabelWidth2">
          <el-input size="mini" v-model="newRec._source.sortLvl10" autocomplete="off"></el-input>
        </el-form-item>
        </el-col>
        </el-row>
      </el-card>
    </el-form>

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

export default {
  name: "productEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth2: "120px",
    changed: false,
    dialogFormVisible: false,
    title: "Produit"
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


      this.$store.commit({
        type: "updateRecord",
        data: this.newRec
      });
      this.$notify({ 
        title: "Record saved.",
        type: "success",
        message: "Le produit a été enregistrée.",
        position: "bottom-right"
      });
      this.$emit("dialogcloseupdated");
    }
  }
};
</script>

<style >
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