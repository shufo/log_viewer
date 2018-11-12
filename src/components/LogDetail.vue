<template>
  <v-card>
    <v-divider/>
    <v-card-text>
      <highlight-code lang="elixir">
        {{ message.msg }}
      </highlight-code>
    </v-card-text>
    <v-card-actions>
      <v-btn
        flat
        @click="show = !show">
        <v-icon left>{{ show ? 'keyboard_arrow_up' : 'keyboard_arrow_down' }}</v-icon>
        metadata
      </v-btn>
    </v-card-actions>
    <v-slide-y-transition>
      <v-card-text v-show="show">
        <v-divider/>
        <v-data-table
          :items="tableItems"
          class="elevation-1"
          hide-actions
          hide-headers
          text-xs-left>
          <template
            slot="items"
            slot-scope="props">
            <td>
              <strong>{{ props.item.key }}</strong>
            </td>
            <td class="text-xs-left">
              <highlight-code lang="elixir">
                {{ props.item.value }}
              </highlight-code>
            </td>
          </template>
        </v-data-table>
      </v-card-text>
    </v-slide-y-transition>
  </v-card>
</template>

<script>
export default {
  name: 'LogDetail',
  props: {
    message: { type: Object, required: true }
  },
  data: () => ({
    show: false
  }),
  computed: {
    tableItems() {
      return Object.keys(this.message.md).map(item => {
        return { key: item, value: this.message.md[item] }
      })
    }
  }
}
</script>
