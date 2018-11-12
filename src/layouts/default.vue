<template>
  <v-app id="inspire">
    <v-navigation-drawer
      v-model="drawer"
      fixed
      mobile-break-point="970"
      app>
      <v-list dense>
        <v-list-tile
          v-for="(draw, i) in drawings"
          :key="i"
          :class="{'primary--text': activeFilter == draw.label}"
          @click="setLevelFilter(draw.label)">
          <v-list-tile-action>
            <v-btn
              :color="draw.color"
              small
              round
              icon
              dark
              v-text="drawCount(draw.label)" />
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title>
              <span>{{ draw.text }}</span>
            </v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
        <v-list-tile
          v-if="logCount > 0"
          class="chart-v-list-tile">
          <v-list-tile-content>
            <pie-chart
              :chart-data="pieChartData"
              :options="{
                maintainAspectRatio: false,
                legend: {
                  display: true,
                  labels: { usePointStyle: true }
                }
              }"
              :height="'250px'"
              :width="'250px'"
              :position="'relative'"
              :styles="{ position: 'relative' }"/>
          </v-list-tile-content>
        </v-list-tile>
        <v-list-tile>
          <v-list-tile-action>
            <v-icon icon>build</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-text-field
              v-model="maxLogs"
              type="number"
              value="100"
              min="1"
              max="10000"
              regular
              label="Max Logs"
              @change="changeMaxLogs"/>
          </v-list-tile-content>
        </v-list-tile>
      </v-list>
    </v-navigation-drawer>
    <v-toolbar
      color="deep-purple"
      dark
      fixed
      app>
      <v-toolbar-side-icon @click.stop="drawer = !drawer" />
      <v-text-field
        append-icon="mic"
        clearable
        class="mx-3"
        flat
        label="Search"
        prepend-inner-icon="search"
        solo-inverted
        @keyup="changeSearchText"
      />
    </v-toolbar>
    <v-content>
      <v-container
        fluid
        fill-height>
        <nuxt />
      </v-container>
    </v-content>
    <v-footer
      height="auto"
      color="deep-purple lighten-1"
      app
    >
      <v-layout
        justify-center
        row
        wrap
      >
        <v-flex
          id="bottom"
          deep-purple
          py-2
          text-xs-center
          white--text
          xs12
        >
          powered by
          <strong>
            <a
              class="white--text"
              target="_brank"
              href="https://github.com/shufo/log_viewer">Log Viewer</a>
          </strong>
        </v-flex>
      </v-layout>
    </v-footer>
  </v-app>
</template>

<script>
import { mapGetters } from 'vuex'
import PieChart from '~/components/PieChart'

export default {
  middleware: ['websocket'],
  components: { PieChart },
  props: {},
  data: () => ({
    drawer: null,
    windowSize: window.innerWidth,
    maxLogs: 100,
    activeFilter: '',
    drawings: [
      {
        text: 'All',
        label: 'all',
        color: 'primary'
      },
      {
        text: 'Info',
        label: 'info',
        color: 'info'
      },
      {
        text: 'Debug',
        label: 'debug',
        color: 'grey'
      },
      {
        text: 'Warn',
        label: 'warn',
        color: 'warning'
      },
      {
        text: 'Error',
        label: 'error',
        color: 'error'
      }
    ]
  }),
  computed: {
    ...mapGetters([
      'logCount',
      'infoLogsCount',
      'debugLogsCount',
      'warnLogsCount',
      'errorLogsCount'
    ]),
    currentWindowSize() {
      return window.innerWidth
    },
    pieChartData() {
      return {
        labels: ['info', 'debug', 'warn', 'error'],
        datasets: [
          {
            backgroundColor: ['#2196f3', '#9e9e9e', '#ffc107', '#ff5252'],
            data: [
              this.infoLogsCount,
              this.debugLogsCount,
              this.warnLogsCount,
              this.errorLogsCount
            ]
          }
        ]
      }
    }
  },
  methods: {
    changeSearchText(e) {
      this.searchInput = e.target.value
      this.$store.dispatch('changeSearchText', this.searchInput)
    },
    setLevelFilter(level) {
      this.activeFilter = level
      this.$store.dispatch('setLevelFilter', level)
    },
    changeMaxLogs(maxLogs) {
      this.$store.dispatch('changeMaxLogs', maxLogs)
    },
    drawCount(level) {
      switch (level) {
        case 'info':
          return this.infoLogsCount
          break
        case 'debug':
          return this.debugLogsCount
          break
        case 'warn':
          return this.warnLogsCount
          break
        case 'error':
          return this.errorLogsCount
          break
        default:
          return this.logCount
          break
      }
    }
  }
}
</script>
<style lang="scss">
.chart-v-list-tile {
  .v-list__tile {
    height: 300px !important;
  }
  .v-list__tile__content {
    height: 300px;
  }
}
</style>
