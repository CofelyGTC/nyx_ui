<template>
  <div style="width: 100%">
    <el-row class="productsfilterseditor-container" style="width: 100%">
      <el-row>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 1</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl1"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl1" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl1)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl1"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl1, newSortLvl1)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 2 Boulangerie</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl2Boul"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl2Boul" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl2Boul)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl2Boul"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl2Boul, newSortLvl2Boul)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 2 Pâtisserie</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl2Pat"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl2Pat" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl2Pat)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl2Pat"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl2Pat, newSortLvl2Pat)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 2 Autres</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl2Other"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl2Other" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl2Other)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl2Other"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl2Other, newSortLvl2Other)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 3</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl3"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl3" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl3)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl3"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl3, newSortLvl3)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 4</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl4"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl4" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl4)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl4"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl4, newSortLvl4)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 5</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl5"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl5" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl5)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl5"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl5, newSortLvl5)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 6</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl6"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl6" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl6)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl6"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl6, newSortLvl6)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 7</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl7"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl7" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl7)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl7"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl7, newSortLvl7)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 8</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl8"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl8" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl8)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl8"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl8, newSortLvl8)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 9</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl9"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl9" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl9)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl9"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl9, newSortLvl9)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card>
            <h2>Niveau 10</h2>
            <table>
              <thead>
                <tr>
                  <th style="text-align: left" scope="col">Filtres</th>
                </tr>
              </thead>
              <draggable
                v-bind="dragOptions"
                v-model="sortLvl10"
                tag="tbody"
                handle=".handle"
              >
                <tr v-for="(item, index) in sortLvl10" :key="index">
                  <td style="text-align: left">{{ item }}</td>
                  <td>
                    <el-icon class="handle"><el-icon-d-caret /></el-icon>
                  </td>
                  <td>
                    <el-button
                      @click="removeSortLvl(index, sortLvl10)"
                      type="danger"
                      :icon="ElIconDelete"
                      circle
                    >
                    </el-button>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-input
                      placeholder="Nouveau Filtre"
                      type="text"
                      v-model="newSortLvl10"
                    >
                    </el-input>
                  </td>
                  <td>
                    <el-button
                      type="primary"
                      @click="addSortLvl(sortLvl10, newSortLvl10)"
                      :icon="ElIconPlus"
                      circle
                    ></el-button>
                  </td>
                </tr>
              </draggable>
            </table>
          </el-card>
        </el-col>
      </el-row>
      <el-row>
        <el-button
          v-if="
            $store.getters.creds.hasPrivilege(config.config.writeprivileges)
          "
          type="primary"
          @click="saveRecord()"
          >Enregistrer
        </el-button>
      </el-row>
    </el-row>
  </div>
</template>

<script>
import {
  DCaret as ElIconDCaret,
  Delete as ElIconDelete,
  Plus as ElIconPlus,
} from '@element-plus/icons'
import Vue from 'vue'
import axios from 'axios'

export default {
  data() {
    return {
      ElIconDelete,
      ElIconPlus,
    }
  },
  components: {
    ElIconDCaret,
  },
  name: 'ProductsFiltersEditor',
  data: () => ({
    records: null,
    ts: 0,
    sortLvl1: [],
    sortLvl2Boul: [],
    sortLvl2Pat: [],
    sortLvl2Other: [],
    sortLvl3: [],
    sortLvl4: [],
    sortLvl5: [],
    sortLvl6: [],
    sortLvl7: [],
    sortLvl8: [],
    sortLvl9: [],
    sortLvl10: [],
    newSortLvl1: '',
    newSortLvl2Boul: '',
    newSortLvl2Pat: '',
    newSortLvl2Other: '',
    newSortLvl3: '',
    newSortLvl4: '',
    newSortLvl5: '',
    newSortLvl6: '',
    newSortLvl7: '',
    newSortLvl8: '',
    newSortLvl9: '',
    newSortLvl10: '',
  }),
  computed: {
    dragOptions() {
      return {
        animation: 0,
        group: 'description',
        disabled: false,
        ghostClass: 'ghost',
      }
    },
  },
  props: {
    config: {
      type: Object,
    },
  },
  mounted: function () {
    this.ts = Date.now().toString()
    this.getFilters()
  },
  created: function () {},
  methods: {
    getFilters() {
      var url =
        this.$store.getters.apiurl +
        'generic_search/products_filters?token=' +
        this.$store.getters.creds.token

      console.log('CHECK SHOPS LIST')

      var query = {
        size: 2000,
        query: {
          bool: {
            must: [
              {
                match_all: {},
              },
            ],
          },
        },
      }
      axios.post(url, query).then((response) => {
        if (response.data.error != '')
          console.log('Products Filters list error...')
        else {
          var res = response.data
          console.log(res)
          this.records = res.records[0]._source
          console.log(this.records)

          this.prepareData()
        }
      })
    },

    prepareData() {
      this.sortLvl1 = this.records['sortLvl1']
      this.sortLvl2Boul = this.records['sortLvl2Boul']
      this.sortLvl2Pat = this.records['sortLvl2Pat']
      this.sortLvl2Other = this.records['sortLvl2Other']
      this.sortLvl3 = this.records['sortLvl3']
      this.sortLvl4 = this.records['sortLvl4']
      this.sortLvl5 = this.records['sortLvl5']
      this.sortLvl6 = this.records['sortLvl6']
      this.sortLvl7 = this.records['sortLvl7']
      this.sortLvl8 = this.records['sortLvl8']
      this.sortLvl9 = this.records['sortLvl9']
      this.sortLvl10 = this.records['sortLvl10']
      console.log('Data Prepared')
    },

    addSortLvl(sortLvl, newItem) {
      sortLvl.push(newItem)
    },
    removeSortLvl: function (index, sortLvl) {
      sortLvl.splice(index, 1)
    },
    saveRecord() {
      var newRec = {}
      newRec['sortLvl1'] = this.sortLvl1
      newRec['sortLvl2Boul'] = this.sortLvl2Boul
      newRec['sortLvl2Pat'] = this.sortLvl2Pat
      newRec['sortLvl2Other'] = this.sortLvl2Other
      newRec['sortLvl3'] = this.sortLvl3
      newRec['sortLvl4'] = this.sortLvl4
      newRec['sortLvl5'] = this.sortLvl5
      newRec['sortLvl6'] = this.sortLvl6
      newRec['sortLvl7'] = this.sortLvl7
      newRec['sortLvl8'] = this.sortLvl8
      newRec['sortLvl9'] = this.sortLvl9
      newRec['sortLvl10'] = this.sortLvl10

      console.log(newRec)

      var body = {}
      body.destination = '/queue/FILTERS_UPDATE'
      body.body = JSON.stringify(newRec)

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
                message: 'Failed To Update Filters',
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
    },
  },
}
</script>

<style></style>
