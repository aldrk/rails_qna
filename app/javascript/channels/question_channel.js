import consumer from "./consumer"
import Question from '../packs/entities/Question'

consumer.subscriptions.create("QuestionChannel", {
    connected() {},

    disconnected() {},

    received(data) {
        const question = Question.jsonRender(data)
        $('.questions').append(question)
    }
})