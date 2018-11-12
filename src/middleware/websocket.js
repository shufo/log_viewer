export class WebSocketClient {
  constructor(endpoint, context) {
    this.endpoint = endpoint
    this.context = context
    this.handlers = []
  }

  init() {
    this.ws = new WebSocket(this.endpoint)
    this.setWebsocketHandlers()
    this.startHeartbeat()
  }

  setWebsocketHandlers() {
    this.ws.onopen = event => {
      this.clearHandlers()
    }

    this.ws.onclose = () => {
      this.ws.close()
      this.clearHandlers()
      let handle = setInterval(() => {
        this.ws = new WebSocket(this.endpoint)
        this.setWebsocketHandlers()
      }, 3000)
      this.handlers.push(handle)
    }

    this.ws.onmessage = event => {
      if (event.data != 'heartbeat') {
        this.context.store.dispatch('addLog', JSON.parse(event.data))
      }
    }
  }

  clearHandlers() {
    this.handlers.forEach(element => {
      clearInterval(element)
    })
  }

  startHeartbeat() {
    setInterval(() => {
      if (this.ws.readyState === this.ws.OPEN) {
        this.ws.send('heartbeat')
      }
    }, 10000)
  }

  startDebugLog() {
    setInterval(() => {
      const date = new Date()
      const levels = ['info', 'debug', 'warn', 'error']
      const debugData = {
        ts: {
          year: date.getFullYear(),
          month: date.getMonth(),
          day: date.getDay(),
          hour: date.getHours(),
          minute: date.getMinutes(),
          second: date.getSeconds(),
          millisecond: date.getMilliseconds()
        },
        id: this.uuid(),
        msg: 'debug',
        md: {
          level: levels[Math.floor(Math.random() * levels.length)]
        }
      }
      if (this.ws.readyState === this.ws.OPEN) {
        this.ws.send(JSON.stringify(debugData))
      }
    }, 5000)
  }

  uuid() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = (Math.random() * 16) | 0,
        v = c == 'x' ? r : (r & 0x3) | 0x8
      return v.toString(16)
    })
  }
}

export default function(context) {
  const path = window.location.pathname.endsWith('/')
    ? window.location.pathname.slice(0, -1)
    : window.location.pathname
  const transportPath = '/websocket'
  const host = context.isDev ? 'localhost:5900' : window.location.host
  const endpoint = 'ws://' + host + path + transportPath
  const client = new WebSocketClient(endpoint, context)

  client.init()

  if (context.isDev) {
    client.startDebugLog()
  }
}
