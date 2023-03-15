<template>
  <el-dialog
    width="80%"
    title="Modifier"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="table-details"
  >
    <el-form>
      <el-row>
        {{ newRec }}
      </el-row>
    </el-form>
  </el-dialog>
</template>

<script>
import YAML from 'js-yaml'
export default {
  name: 'ProductAdminEditor',
  data: () => ({
    dialogFormVisible: false,
    activeName: 'first',
    orgRec: null,
    newRec: null,
    strOrgRec: '',
    strNewRec: '',
    formLabelWidth: '180px',
    fields: [],
    changed: false,
  }),
  computed: {
    recordin: function () {
      return this.record
    },
    recordstr: function () {
      return JSON.stringify(this.record)
    },
  },
  props: {
    record: {
      type: Object,
    },
    config: {
      type: Object,
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
  mounted: function () {
    this.prepareData()
  },
  methods: {
    closeDialog: function () {
      this.$emit('dialogclose')
    },
    prepareData: function () {
      this.dialogFormVisible = true

      this.strNewRec = ''
      this.strOrgRec = ''

      console.log(this.record)

      this.newRec = JSON.parse(JSON.stringify(this.record))
      this.orgRec = JSON.parse(JSON.stringify(this.record))
    },
    saveRecord: function () {
      this.$store.commit({
        type: 'updateRecord',
        data: this.newRec,
      })
      this.$emit('dialogcloseupdated')
      this.$notify({
        title: 'Record saved.',
        type: 'success',
        message: 'Record updated.',
        position: 'bottom-right',
      })
    },
  },
}
</script>

<style>
.table-details .el-form-item__label {
  color: #464646;
  font-weight: 600;
}
.table-details .el-form-item__content {
  text-align: left;
}
</style>
