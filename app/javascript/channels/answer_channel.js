import consumer from "./consumer"
import Answer from '../packs/entities/Answer'

consumer.subscriptions.create("AnswerChannel", {
    connected() {},

    disconnected() {},

    received(data) {
        const answer = Answer.jsonRender(data)
        $('.answers').append(answer)
    }
})