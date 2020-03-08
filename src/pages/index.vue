<template>
  <v-layout
    column
    justify-space-between>
    <v-flex
      xs12
      sm12
      md12
      lg12>
      <v-expansion-panel>
        <v-divider/>
        <v-slide-y-transition
          class="py-0"
          group
          tag="v-expansion-panel">
          <v-expansion-panel-content
            v-for="message in filteredLogs"
            :key="message.id"
            lazy
          >
            <v-layout
              v-scroll="onScroll"
              slot="header"
              align-center
              justify-space-between
              row
              spacer
            >
              <v-flex
                xs4
                sm2
                md1>
                <v-avatar
                  slot="activator"
                  size="36px"
                >
                  <v-icon
                    :color="logColor(message.md.level)"
                    v-text="logIcon(message.md.level)"
                  />
                </v-avatar>
              </v-flex>

              <v-flex
                no-wrap
                xs5
                sm8
                ellipsis>
                <strong 
                  id="app_message_key" 
                  v-html="message.msg"/>
              </v-flex>
              <v-spacer/>
              <v-flex
                xs3
                sm2
                v-text="logTimestamp(message.ts)"/>

            </v-layout>
            <log-detail :message="message"/>
          </v-expansion-panel-content>
        </v-slide-y-transition>
      </v-expansion-panel>
      <v-card>
        <v-fab-transition>
          <v-btn
            v-if="offsetTop < 100"
            relative
            dark
            fab
            bottom
            right
            fixed
            color="pink"
            @click="goToBottom"
          >
            <v-icon>arrow_downward</v-icon>
          </v-btn>
        </v-fab-transition>
        <v-fab-transition>
          <v-btn
            v-if="offsetTop > 100"
            relative
            dark
            fab
            bottom
            right
            fixed
            color="pink"
            @click="goToTop"
          >
            <v-icon>arrow_upward</v-icon>
          </v-btn>
        </v-fab-transition>
        <v-card-text
          v-if="filteredLogs.length == 0">
          <p id="waiting_text">Waiting for logs matching the conditions to coming in...</p>
          <v-progress-circular
            indeterminate
            color="purple"/>
        </v-card-text>
      </v-card>
    </v-flex>
  </v-layout>
</template>

<script>
import { mapGetters } from 'vuex'
import LogDetail from '~/components/LogDetail.vue'

export default {
  components: { LogDetail },
  data: () => ({
    offsetTop: 0
  }),
  computed: {
    ...mapGetters([
      'searchText',
      'logs',
      'logsWithId',
      'filteredLogs',
      'filterLevel'
    ]),
    results() {
      return this.resultIds.map(id => this.logsWithId[id])
    }
  },
  methods: {
    logColor(level) {
      switch (level) {
        case 'info':
          return 'indigo'
          break
        case 'debug':
          return 'grey'
          break
        case 'warn':
          return 'yellow'
          break
        case 'error':
          return 'red'
          break
        default:
          return 'indigo'
          break
      }
    },
    logIcon(level) {
      switch (level) {
        case 'info':
          return 'info'
          break
        case 'debug':
          return 'bug_report'
          break
        case 'warn':
          return 'warning'
          break
        case 'error':
          return 'error'
          break
        default:
          return 'info'
          break
      }
    },
    logTimestamp({ hour, minute, second, millisecond }) {
      return (
        hour.toString().padStart(2, '0') +
        ':' +
        minute.toString().padStart(2, '0') +
        ':' +
        second.toString().padStart(2, '0') +
        '.' +
        millisecond.toString().padStart(3, '0')
      )
    },
    goToBottom() {
      this.$vuetify.goTo(999999, { duration: 300, easing: 'easeInOutCubic' })
    },
    goToTop() {
      this.$vuetify.goTo(0, { duration: 300, easing: 'easeInOutCubic' })
    },
    onScroll() {
      this.offsetTop = window.pageYOffset || document.documentElement.scrollTop
    }
  }
}
</script>
