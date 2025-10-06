import consumer from "channels/consumer"

const channelParams = {
  channel: "CustomSubscriber",
  custom_param: "Something from JS"
};

consumer.subscriptions.create(
  channelParams,
  {
    connected() {
      console.log('MAKSIM custom_consumer.js - CONNECTED to CustomSubscriber')
    },

    disconnected() {
      console.log('MAKSIM custom_consumer.js - DISCONNECTED from CustomSubscriber')
    },

    received(data) {
      console.log('MAKSIM custom_consumer.js - RECEIVED data:', data)
      this.appendLine(data)
    },

    appendLine(data) {
      console.log('MAKSIM custom_consumer.js - appendLine called')
      const html = this.createLine(data)
      const element = document.querySelector("[custom-channel-id='custom-messages']")
      if (element) {
        element.insertAdjacentHTML("beforeend", html)
      } else {
        console.error('MAKSIM custom_consumer.js - Element with custom-channel-id="custom-messages" not found!')
      }
    },

    createLine(data) {
      console.log('MAKSIM custom_consumer.js - createLine called')
      console.log('MAKSIM custom_consumer.js - data:', data)
      return `
        <p>
          ${data["custom_param"]} | ${data["from_user"]}
        </p>
      `
    }
  }
)
